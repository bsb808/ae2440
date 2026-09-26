"""
grading_utils.py — Utility functions for AE2440 Sakai assignment grading.

Typical workflow:
    1. Extract the Sakai zip:
           unzip "grading/AssignmentN_*.zip" -d /tmp/submissions/
    2. Call check_required_files() to audit submissions.
    3. Use the results to update grades.csv and comments.txt.
"""

import os
import re
import csv
import io


# ---------------------------------------------------------------------------
# Sakai directory helpers
# ---------------------------------------------------------------------------

def get_student_dirs(assignment_dir):
    """Return sorted list of per-student subdirectory paths.

    Skips non-directory entries (e.g. grades.csv).
    """
    return sorted(
        os.path.join(assignment_dir, d)
        for d in os.listdir(assignment_dir)
        if os.path.isdir(os.path.join(assignment_dir, d))
    )


def submission_dir(student_dir):
    """Return the 'Submission attachment(s)' path for a student directory."""
    return os.path.join(student_dir, "Submission attachment(s)")


def student_name(student_dir):
    """Extract 'Last, First' display name from a Sakai student directory name.

    Directory names have the form: 'Last, First(username)'
    """
    base = os.path.basename(student_dir)
    return base[:base.rfind("(")].strip()


def student_id(student_dir):
    """Extract the Sakai username from a student directory name."""
    base = os.path.basename(student_dir)
    return base[base.rfind("(") + 1: base.rfind(")")]


# ---------------------------------------------------------------------------
# File presence check
# ---------------------------------------------------------------------------

def check_required_files(assignment_dir, required_files):
    """Check each student's submission for required files (case-sensitive).

    Assigns a grade of 100 if all required files are present, 90 if any are
    missing, and generates feedback text suitable for appending to comments.txt.

    Parameters
    ----------
    assignment_dir : str
        Path to the extracted top-level assignment directory, e.g.
        '/tmp/submissions/Assignment3_FunctionsAndConditionals/'.
    required_files : list[str]
        Exact filenames expected in each student's submission, e.g.
        ['classify_triangle.m', 'beaufort_classify.m'].

    Returns
    -------
    list[dict] — one entry per student, each with keys:
        'student_dir'  : full path to the student directory
        'name'         : 'Last, First' display name
        'id'           : Sakai username
        'submitted'    : sorted list of filenames actually present
        'missing'      : required files that are absent
        'present'      : required files that are present
        'all_present'  : True if no files are missing
        'grade'        : 100 if all present, 90 if any missing
        'comment'      : feedback string ready to append to comments.txt
    """
    results = []
    for sdir in get_student_dirs(assignment_dir):
        sub = submission_dir(sdir)
        submitted = sorted(os.listdir(sub)) if os.path.isdir(sub) else []
        missing = [f for f in required_files if f not in submitted]
        present = [f for f in required_files if f in submitted]
        all_present = len(missing) == 0
        grade = 100 if all_present else 90
        comment = _file_check_comment(grade, required_files, missing, submitted)
        results.append({
            "student_dir": sdir,
            "name":        student_name(sdir),
            "id":          student_id(sdir),
            "submitted":   submitted,
            "missing":     missing,
            "present":     present,
            "all_present": all_present,
            "grade":       grade,
            "comment":     comment,
        })
    return results


def _file_check_comment(grade, required_files, missing, submitted):
    """Build the comments.txt feedback string for a file-presence check."""
    if grade == 100:
        lines = [
            "Grade: 100/100",
            "All required files submitted with correct filenames:",
        ]
        lines += [f"  - {f}" for f in required_files]
    else:
        lines = [
            "Grade: 90/100",
            "One or more required files are missing or have incorrect filenames.",
            "",
            "Missing file(s):",
        ]
        lines += [f"  - {f}" for f in missing]
        lines += [
            "",
            f"Files submitted ({len(submitted)} total):",
        ]
        lines += [f"  - {f}" for f in submitted]
        lines += [
            "",
            "Note: filenames are case-sensitive. Please verify that each "
            "file is named exactly as specified in the assignment.",
        ]
    return "\n".join(lines) + "\n"


def print_file_check_summary(results):
    """Print a concise table of check_required_files() results to stdout."""
    all_ok = [r for r in results if r["all_present"]]
    issues = [r for r in results if not r["all_present"]]
    print(f"{len(all_ok)}/{len(results)} students submitted all required files.\n")
    if issues:
        print("Issues:")
        for r in issues:
            print(f"  {r['name']}")
            for f in r["missing"]:
                print(f"    MISSING: {f}")
            print(f"    Submitted: {r['submitted']}")


# ---------------------------------------------------------------------------
# Plain-text MLX parsing
# ---------------------------------------------------------------------------

def extract_code_text(path):
    """Extract executable code and prose from a plain-text MLX .m file.

    Skips %[output:...], %[appendix], %[metadata], and %[text:image:...]
    blocks, which contain large binary-encoded cached outputs.
    """
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            lines = f.readlines()
    except OSError:
        return ""

    result = []
    skip = False
    for line in lines:
        stripped = line.rstrip()
        if re.match(r"%\[(output|appendix|metadata|text:image)", stripped):
            skip = True
            continue
        if skip:
            if re.match(r"%\[", stripped) and not re.match(
                r"%\[(output|metadata|text:image)", stripped
            ):
                skip = False
            elif not stripped.startswith("%") or stripped.startswith("%[text"):
                skip = False
            else:
                continue
        if not skip:
            result.append(stripped)
    return "\n".join(result)


# ---------------------------------------------------------------------------
# Sakai grades.csv and comments.txt
# ---------------------------------------------------------------------------

def read_grades_csv(assignment_dir):
    """Read the Sakai grades.csv and return (preamble_lines, rows).

    Sakai grades.csv layout:
      line 0: assignment name + grade type
      line 1: blank
      line 2: column headers ("Display ID","ID","Last Name",...)
      line 3+: one row per student

    preamble_lines : lines 0-1 (preserved verbatim on write)
    rows           : list of dicts keyed by the line-2 column headers
    """
    path = os.path.join(assignment_dir, "grades.csv")
    with open(path, "r", newline="", encoding="utf-8-sig") as f:
        raw = f.read()
    lines = raw.splitlines()
    preamble_lines = lines[:2]      # lines 0-1
    reader = csv.DictReader(lines[2:])  # line 2 = column headers, 3+ = data
    rows = list(reader)
    return preamble_lines, rows


def write_grades_csv(assignment_dir, preamble_lines, rows):
    """Write rows back to grades.csv, preserving the Sakai preamble."""
    path = os.path.join(assignment_dir, "grades.csv")
    out = io.StringIO()
    for h in preamble_lines:
        out.write(h + "\n")
    if rows:
        writer = csv.DictWriter(
            out,
            fieldnames=rows[0].keys(),
            quoting=csv.QUOTE_ALL,
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(row)
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        f.write(out.getvalue())


def append_comment(student_dir, text):
    """Append text to a student's comments.txt (creates file if absent)."""
    path = os.path.join(student_dir, "comments.txt")
    with open(path, "a", encoding="utf-8") as f:
        f.write(text)
