#!/usr/bin/env python3
"""
Convert a MATLAB live script (.mlx) to the plain-text live code format (.m).

The plain-text format uses %[text] markers for prose and bare MATLAB for code,
as described at:
https://www.mathworks.com/help/matlab/matlab_prog/plain-text-file-format-for-live-scripts.html

Usage:
    python mlx2m.py lesson_foo.mlx              # writes lesson_foo.m
    python mlx2m.py lesson_foo.mlx -o out.m     # explicit output path
"""

import base64
import hashlib
import json
import os
import zipfile
import argparse
from lxml import etree

W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
MC = 'http://schemas.openxmlformats.org/markup-compatibility/2006'
PKG = 'http://schemas.openxmlformats.org/package/2006/relationships'
NS = {'w': W, 'mc': MC}


def _w(tag): return f'{{{W}}}{tag}'


def _mc(tag): return f'{{{MC}}}{tag}'


def _pkg(tag): return f'{{{PKG}}}{tag}'


# ---------------------------------------------------------------------------
# Paragraph-level helpers
# ---------------------------------------------------------------------------

def get_style(p):
    """Return the pStyle value for a <w:p>, resolving mc:AlternateContent."""
    pPr = p.find(_w('pPr'))
    if pPr is not None:
        ps = pPr.find(_w('pStyle'))
        if ps is not None:
            return ps.get(_w('val'))
    for ac in p:
        if ac.tag != _mc('AlternateContent'):
            continue
        for candidate_tag in (_mc('Choice'), _mc('Fallback')):
            candidate = ac.find(candidate_tag)
            if candidate is None:
                continue
            pPr = candidate.find(_w('pPr'))
            if pPr is not None:
                ps = pPr.find(_w('pStyle'))
                if ps is not None:
                    return ps.get(_w('val'))
    return None


def is_section_break(p):
    pPr = p.find(_w('pPr'))
    return pPr is not None and pPr.find(_w('sectPr')) is not None


# ---------------------------------------------------------------------------
# Run / inline-text helpers
# ---------------------------------------------------------------------------

def _run_text(r):
    t = r.find(_w('t'))
    return t.text or '' if t is not None else ''


def _format_run(r):
    """Return markdown-formatted text from a <w:r>."""
    text = _run_text(r)
    if not text:
        return ''

    rPr = r.find(_w('rPr'))
    if rPr is None:
        return text

    bold = rPr.find(_w('b')) is not None
    italic = rPr.find(_w('i')) is not None
    fonts = rPr.find(_w('rFonts'))
    mono = fonts is not None and fonts.get(_w('cs')) == 'monospace'

    if not (mono or bold or italic):
        return text

    # Move surrounding whitespace outside markers to keep markdown valid
    inner = text.strip()
    leading = text[:len(text) - len(text.lstrip())]
    trailing = text[len(text.rstrip()):]

    if not inner:
        return text

    if mono:
        return f'{leading}`{inner}`{trailing}'
    if bold and italic:
        return f'{leading}***{inner}***{trailing}'
    if bold:
        return f'{leading}**{inner}**{trailing}'
    if italic:
        return f'{leading}*{inner}*{trailing}'
    return text


# ---------------------------------------------------------------------------
# Equation helpers
# ---------------------------------------------------------------------------

def _escape_latex(latex):
    """
    Escape LaTeX for the .m plain-text format.

    In the .m format, backslashes are doubled (\\) and underscores are escaped
    (backslash-underscore) so they are not interpreted as markdown formatting.
    """
    latex = latex.replace('\\', '\\\\')
    latex = latex.replace('_', r'\_')
    return latex


def _get_custom_xml_attrs(customXml):
    """Return {name: val} dict from <w:customXmlPr><w:attr> children."""
    attrs = {}
    for attr in customXml.findall(f'{_w("customXmlPr")}/{_w("attr")}'):
        name = attr.get(_w('name'))
        val = attr.get(_w('val'))
        if name:
            attrs[name] = val
    return attrs


def _get_latex(customXml):
    """Extract the LaTeX string from an equation customXml element."""
    parts = []
    for r in customXml.findall(_w('r')):
        parts.append(_run_text(r))
    return ''.join(parts)


# ---------------------------------------------------------------------------
# Converter class  (holds per-file state: images, rels)
# ---------------------------------------------------------------------------

class Converter:

    def __init__(self):
        self.rels = {}          # rId -> zip-relative media path
        self.images = []        # ordered list of image dicts for appendix
        self._seen_rids = {}    # rId -> hash (avoid duplicates)

    # -- Relationship file --------------------------------------------------

    def _load_rels(self, z):
        try:
            xml = z.read('matlab/_rels/document.xml.rels')
        except KeyError:
            return
        root = etree.fromstring(xml)
        for rel in root:
            rid = rel.get('Id')
            target = rel.get('Target', '')
            # targets are relative to matlab/ so ../media/x.png → media/x.png
            if target.startswith('../'):
                target = target[3:]
            if rid:
                self.rels[rid] = target

    # -- Image processing ---------------------------------------------------

    def _process_image(self, customXml, z):
        """
        Extract image bytes from zip, base64-encode, record for appendix.
        Returns the 4-char hex hash used as the image identifier.
        """
        attrs = _get_custom_xml_attrs(customXml)
        rid = attrs.get('relationshipId')
        if not rid:
            return None

        if rid in self._seen_rids:
            return self._seen_rids[rid]

        media_path = self.rels.get(rid)
        if not media_path:
            return None

        try:
            img_bytes = z.read(media_path)
        except KeyError:
            return None

        # 4-char hex hash (MD5 prefix)
        img_hash = hashlib.md5(img_bytes).hexdigest()[:4]

        ext = os.path.splitext(media_path)[1].lower().lstrip('.')
        mime = {'png': 'image/png', 'jpg': 'image/jpeg',
                'jpeg': 'image/jpeg', 'gif': 'image/gif'}.get(ext, 'image/png')

        b64 = base64.b64encode(img_bytes).decode('ascii')
        src = f'data:{mime};base64,{b64}'

        self.images.append({
            'hash': img_hash,
            'height': int(attrs.get('height', 0)),
            'width': int(attrs.get('width', 0)),
            'align': attrs.get('verticalAlign', 'baseline'),
            'src': src,
        })
        self._seen_rids[rid] = img_hash
        return img_hash

    # -- Text extraction ----------------------------------------------------

    def extract_text(self, p, z):
        """
        Walk children of <w:p> and return a markdown string.
        Handles w:r, w:hyperlink, w:customXml (equations + images),
        and mc:AlternateContent pPr wrappers (skipped for text).
        """
        parts = []

        for child in p:
            tag = child.tag

            if tag == _w('r'):
                parts.append(_format_run(child))

            elif tag == _w('hyperlink'):
                url = child.get(_w('docLocation'), '')
                text = ''.join(_run_text(r) for r in child.iter(_w('r')))
                parts.append(f'[{text}]({url})' if url else text)

            elif tag == _w('customXml'):
                element = child.get(_w('element'))

                if element == 'equation':
                    attrs = _get_custom_xml_attrs(child)
                    display = attrs.get('displayStyle') == 'true'
                    latex = _escape_latex(_get_latex(child))
                    # Both inline and display use $...$; display equations
                    # typically occupy the whole paragraph so they end up on
                    # their own %[text] line naturally.
                    parts.append(f'$${latex}$$' if display else f'${latex}$')

                elif element == 'image':
                    img_hash = self._process_image(child, z)
                    if img_hash:
                        parts.append(f'![](text:image:{img_hash})')

            # mc:AlternateContent here wraps pPr for heading styles — no text
            # w:pPr, w:bookmarkStart, etc. — skip silently

        return ''.join(parts)

    # -- Paragraph → output lines -------------------------------------------

    HEADING_LEVEL = {
        'title':    '#',
        'heading':  '##',
        'heading2': '##',
        'heading3': '###',
    }

    def paragraph_to_lines(self, p, style, z):
        if style in self.HEADING_LEVEL:
            text = self.extract_text(p, z)
            if text.strip():
                return [f'%[text] {self.HEADING_LEVEL[style]} {text}']

        elif style == 'text':
            text = self.extract_text(p, z)
            if text.strip():
                return [f'%[text] {text}']

        elif style == 'ListParagraph':
            text = self.extract_text(p, z)
            if text.strip():
                return [f'%[text] - {text}']

        elif style == 'code':
            t = p.find('.//' + _w('t'))
            if t is not None and t.text and t.text.strip():
                return t.text.splitlines()

        return []

    # -- Body iteration (resolves body-level mc:AlternateContent) -----------

    @staticmethod
    def iter_body(body):
        for child in body:
            tag = child.tag
            if tag == _w('p'):
                yield ('paragraph', child)
            elif tag == _mc('AlternateContent'):
                choice = child.find(_mc('Choice'))
                if choice is not None:
                    for p in choice.iter(_w('p')):
                        style = get_style(p)
                        if style == 'CodeExampleLine':
                            yield ('code_example', p)
                            break
                else:
                    fallback = child.find(_mc('Fallback'))
                    if fallback is not None:
                        for p in fallback.iter(_w('p')):
                            yield ('paragraph', p)

    # -- Appendix -----------------------------------------------------------

    def build_appendix(self):
        lines = ['', '%[appendix]{"version":"1.0"}']
        for img in self.images:
            data = {
                'align': img['align'],
                'height': img['height'],
                'src': img['src'],
                'width':  img['width'],
            }
            # Compact JSON; escape forward slashes to match MATLAB's format
            data_str = json.dumps(
                data, separators=(',', ':')
            ).replace('/', r'\/')
            lines += [
                '%---',
                f'%[text:image:{img["hash"]}]',
                f'%   data: {data_str}',
            ]
        lines.append('')
        return lines

    # -- Main entry point ---------------------------------------------------

    def convert(self, input_path, output_path):
        with zipfile.ZipFile(input_path, 'r') as z:
            self._load_rels(z)
            xml_bytes = z.read('matlab/document.xml')
            root = etree.fromstring(xml_bytes)
            body = root.find(_w('body'))

            out_lines = []

            for kind, p in self.iter_body(body):

                if kind == 'code_example':
                    t = p.find('.//' + _w('t'))
                    if t is not None and t.text and t.text.strip():
                        out_lines.append(f'%[text]     {t.text}')
                    continue

                if is_section_break(p):
                    out_lines.append('%%')
                    continue

                style = get_style(p)

                if style is None:
                    text = self.extract_text(p, z)
                    if text.strip():
                        out_lines.append(f'%[text] {text}')
                    continue

                lines = self.paragraph_to_lines(p, style, z)
                out_lines.extend(lines)

        # Trim trailing blank lines / %% before appending appendix
        while out_lines and out_lines[-1] in ('', '%%'):
            out_lines.pop()

        out_lines += self.build_appendix()

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(out_lines))

        print(f'Wrote {output_path}')
        if self.images:
            print(f'  Embedded {len(self.images)} image(s)')


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description='Convert a .mlx live script to plain-text live code (.m).',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument('input', help='Input .mlx file')
    parser.add_argument('-o', '--output',
                        help='Output .m file (default: input + .m)')
    args = parser.parse_args()

    output = args.output or os.path.splitext(args.input)[0] + '.m'
    Converter().convert(args.input, output)


if __name__ == '__main__':
    main()
