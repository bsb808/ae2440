#!/usr/bin/env python3
"""
Check the rendered site for broken relative links.

Walks site/_site/**/*.html and reports every href/src that points at a file which does not
exist in the rendered output (missing PDF, moved page, typo). External URLs, anchors, and
mailto links are ignored. Run after `quarto render site`.

Usage: python3 utils/check_site_links.py [site/_site]
Exit status 1 if any link is broken.
"""
import re
import sys
from pathlib import Path
from urllib.parse import unquote

REPO = Path(__file__).resolve().parents[1]


def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else REPO / 'site' / '_site'
    if not root.is_dir():
        sys.exit(f'{root} not found; run `quarto render site` first')
    broken, checked = 0, 0
    for html in sorted(root.rglob('*.html')):
        text = html.read_text(errors='replace')
        for href in re.findall(r'(?:href|src)="([^"#?]+)', text):
            if href.startswith(('http://', 'https://', 'mailto:', 'data:', '//')):
                continue
            checked += 1
            target = (root / href.lstrip('/')) if href.startswith('/') else (html.parent / unquote(href))
            if not target.resolve().exists():
                broken += 1
                print(f'BROKEN  {html.relative_to(root)}  ->  {href}')
    print(f'{root.relative_to(REPO)}: {checked} relative links checked, {broken} broken')
    sys.exit(1 if broken else 0)


if __name__ == '__main__':
    main()
