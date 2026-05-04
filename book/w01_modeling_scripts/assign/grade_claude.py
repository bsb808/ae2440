#!/usr/bin/env python3
"""
This python script is for grading and adding comments to submissions for a course.

The one positional argument is the path to the AssignmentName directory.

The directory structure for an AssignmentName is as follows (for two students)

AssignmentName/
├── grades.csv
├── Student Name1
│   ├── comments.txt
│   ├── Feedback Attachment(s)
│   ├── Submission attachment(s)
│   │   ├── aquarium.m
│   │   ├── bike_update.m
│   │   ├── penny.m
│   │   └── pennywithair.m
│   └── timestamp.txt
└── Student Name2
    ├── comments.txt
    ├── Feedback Attachment(s)
    ├── Submission attachment(s)
    │   ├── aquarium.m
    │   ├── bike_update.m
    │   ├── penny.m
    │   └── pennywithair.m
    └── timestamp.txt


For each student:
- Append comments to "comments.txt" file using Python logging (writes to file and terminal).
  Includes demarcation for each student.
- Evaluate files in the "Submission attachment(s)" directory.
  Check for: [penny.m, pennywithair.m, bike_update.m, aquarium.m]
- If all files present: log success and assign grade of 100.
- If any missing: log which files are missing, log files present vs expected, assign grade of 90.

Write grades to the existing "grades.csv" file (modify only the "grade" column).
"""

import argparse
import re
import csv
import logging
import os
import sys
from datetime import datetime
from pathlib import Path

# Files required in each submission
REQUIRED_FILES = ["penny.m", "pennywithair.m", "bike_update.m", "aquarium.m"]

SUBMISSION_DIR = "Submission attachment(s)"


def setup_student_logger(comments_path: Path, student_name: str) -> logging.Logger:
    """
    Create a logger that writes to both the student's comments.txt and stdout.
    Returns the logger; caller is responsible for removing handlers when done.
    """
    logger = logging.getLogger(f"grader.{student_name}")
    logger.setLevel(logging.DEBUG)
    logger.handlers.clear()          # avoid duplicate handlers on re-runs
    logger.propagate = False

    fmt = logging.Formatter("%(asctime)s  %(levelname)s  %(message)s",
                            datefmt="%Y-%m-%d %H:%M:%S")

    # File handler — overwrite comments.txt each run
    fh = logging.FileHandler(comments_path, mode="w", encoding="utf-8")
    fh.setFormatter(fmt)
    logger.addHandler(fh)

    # Stream handler — stdout
    sh = logging.StreamHandler(sys.stdout)
    sh.setFormatter(fmt)
    logger.addHandler(sh)

    return logger


def close_logger(logger: logging.Logger) -> None:
    """Flush and close all handlers on the given logger."""
    for handler in logger.handlers[:]:
        handler.flush()
        handler.close()
        logger.removeHandler(handler)


def grade_student(student_dir: Path) -> tuple[str, int]:
    """
    Grade a single student directory.

    Returns
    -------
    (student_folder_name, grade)
    """
    student_name = student_dir.name
    comments_path = student_dir / "comments.txt"
    submission_path = student_dir / SUBMISSION_DIR

    logger = setup_student_logger(comments_path, student_name)

    # ── Demarcation banner ──────────────────────────────────────────────────
    banner = f"{'='*60}"
    logger.info(banner)
    logger.info(f"GRADING: {student_name}")
    logger.info(f"Timestamp: {datetime.now().isoformat(timespec='seconds')}")
    logger.info(banner)

    # ── Check submission directory exists ──────────────────────────────────
    if not submission_path.is_dir():
        logger.error(f"Submission directory not found: '{SUBMISSION_DIR}'")
        logger.info(f"Assigning grade: 90 (missing submission directory)")
        close_logger(logger)
        return student_name, 90

    # ── Collect submitted files (case-insensitive comparison) ──────────────
    submitted = {f.name for f in submission_path.iterdir() if f.is_file()}
    submitted_lower = {name.lower(): name for name in submitted}

    present = []
    missing = []
    for req in REQUIRED_FILES:
        if req.lower() in submitted_lower:
            present.append(req)
        else:
            missing.append(req)

    # ── Evaluate and assign grade ──────────────────────────────────────────
    if not missing:
        grade = 100
        logger.info("All required files are present.")
        logger.info(f"Files found: {sorted(present)}")
        logger.info(f"Grade assigned: {grade}")
    else:
        grade = 90
        logger.warning("One or more required files are MISSING.")
        logger.warning(f"Missing files : {sorted(missing)}")
        logger.info(   f"Files present : {sorted(present)}")
        logger.info(   f"Required list : {sorted(REQUIRED_FILES)}")
        logger.info(   f"Grade assigned: {grade}")

    close_logger(logger)
    return student_name, grade


def find_student_dirs(assignment_dir: Path) -> list[Path]:
    """Return subdirectories that look like student folders (not hidden, not system)."""
    skip = {"__pycache__", ".DS_Store"}
    return sorted(
        p for p in assignment_dir.iterdir()
        if p.is_dir() and p.name not in skip and not p.name.startswith(".")
    )


# ── Validation ─────────────────────────────────────────────────────────────────

def warn(msg: str) -> None:
    """Print a formatted WARNING to stderr."""
    print(f"  WARNING: {msg}", file=sys.stderr)


def validate_assignment_dir(assignment_dir: Path) -> bool:
    """
    Validate the top-level assignment directory structure.

    Checks:
      - grades.csv exists
      - At least one student subdirectory is present

    Returns True if the directory looks valid enough to proceed, False otherwise.
    Prints warnings for every problem found (does not short-circuit).
    """
    ok = True

    # Must be an actual directory (belt-and-suspenders; main() already checks this)
    if not assignment_dir.is_dir():
        warn(f"'{assignment_dir}' is not a directory.")
        return False

    # grades.csv must be present
    if not (assignment_dir / "grades.csv").is_file():
        warn(f"'grades.csv' not found in '{assignment_dir.name}'. "
             "Grades cannot be written.")
        ok = False

    # There should be at least one student folder
    student_dirs = find_student_dirs(assignment_dir)
    if not student_dirs:
        warn(f"No student subdirectories found in '{assignment_dir.name}'.")
        ok = False

    return ok


def validate_student_dir(student_dir: Path) -> bool:
    """
    Validate a single student directory against the expected structure:

        <Student Name>/
        ├── comments.txt               (may be absent on first run — just noted)
        ├── Feedback Attachment(s)/    (directory)
        ├── Submission attachment(s)/  (directory — required)
        │   └── *.m  files
        └── timestamp.txt              (file)

    Returns True if the directory is structurally sound, False if critical
    pieces are missing.  Prints a WARNING for every problem found.
    """
    name = student_dir.name
    ok = True

    # ── timestamp.txt ──────────────────────────────────────────────────────
    if not (student_dir / "timestamp.txt").is_file():
        warn(f"[{name}] 'timestamp.txt' is missing.")
        # Non-fatal; grading can still proceed

    # ── Feedback Attachment(s) directory ───────────────────────────────────
    feedback_dir = student_dir / "Feedback Attachment(s)"
    if not feedback_dir.exists():
        warn(f"[{name}] 'Feedback Attachment(s)' directory is missing.")
    elif not feedback_dir.is_dir():
        warn(f"[{name}] 'Feedback Attachment(s)' exists but is not a directory.")

    # ── Submission attachment(s) directory — critical ──────────────────────
    submission_dir = student_dir / SUBMISSION_DIR
    if not submission_dir.exists():
        warn(f"[{name}] '{SUBMISSION_DIR}' directory is missing — cannot evaluate files.")
        ok = False
    elif not submission_dir.is_dir():
        warn(f"[{name}] '{SUBMISSION_DIR}' exists but is not a directory.")
        ok = False
    else:
        # Warn about unexpected file types inside the submission directory
        unexpected = [
            f.name for f in submission_dir.iterdir()
            if f.is_file() and not f.name.lower().endswith(".m")
        ]
        if unexpected:
            warn(f"[{name}] Unexpected file(s) in '{SUBMISSION_DIR}': {sorted(unexpected)}")

    # ── Unexpected items directly inside the student folder ────────────────
    known_names = {
        "comments.txt",
        "timestamp.txt",
        "feedback attachment(s)",
        "submission attachment(s)",
    }
    unexpected_top = [
        p.name for p in student_dir.iterdir()
        if p.name.lower() not in known_names
        and not p.name.startswith(".")
    ]
    if unexpected_top:
        warn(f"[{name}] Unexpected item(s) in student folder: {sorted(unexpected_top)}")

    return ok


def update_grades_csv(csv_path: Path, grades: dict[str, int]) -> None:
    """
    Update the 'grade' column in the grades.csv file.

    The CSV format is:
        "Assignment Name ","SCORE_GRADE_TYPE"
        ""
        "Display ID","ID","Last Name","First Name","grade","Submission date","Late submission"
        "student.name1","student.name1","Name1","Student","","2026-04-02T04:00:05Z","On time"
        ...

    Matching strategy: reconstruct the student folder name from "First Name" + " " + "Last Name"
    and compare it to the keys in `grades`.  Also try Display ID as a fallback.
    """
    if not csv_path.is_file():
        print(f"WARNING: grades.csv not found at {csv_path}. Skipping CSV update.",
              file=sys.stderr)
        return

    with open(csv_path, newline="", encoding="utf-8-sig") as fh:
        raw = fh.read()

    lines = raw.splitlines(keepends=True)

    # Find the header row (the one containing "Display ID")
    header_line_idx = None
    for i, line in enumerate(lines):
        if "Display ID" in line:
            header_line_idx = i
            break

    if header_line_idx is None:
        print("WARNING: Could not locate header row in grades.csv. Skipping update.",
              file=sys.stderr)
        return

    # Parse from the header row onward
    data_lines = lines[header_line_idx:]
    reader = csv.DictReader(
        (l.rstrip("\r\n") for l in data_lines),
        quoting=csv.QUOTE_ALL,
    )
    fieldnames = reader.fieldnames

    if fieldnames is None or "grade" not in fieldnames:
        print("WARNING: 'grade' column not found in grades.csv header. Skipping update.",
              file=sys.stderr)
        return

    # Build a lookup keyed by display ID extracted from the folder name.
    #
    # Folder names follow the pattern:  "Last, First(display.id)"
    # e.g. "Arrigo, Patrick(patrick.arrigo)"
    #
    # The display ID in parentheses is the most reliable match key because it
    # appears verbatim in the CSV "Display ID" column.
    _paren_re = re.compile(r"\(([^)]+)\)\s*$")

    grades_lookup: dict[str, int] = {}   # display_id.lower() → grade
    for folder_name, g in grades.items():
        m = _paren_re.search(folder_name)
        if m:
            grades_lookup[m.group(1).strip().lower()] = g
        else:
            # Fallback for folders that don't follow the "Last, First(id)" pattern:
            # store the whole folder name lowercased so something still matches.
            grades_lookup[folder_name.strip().lower()] = g

    updated_rows = []
    for row in reader:
        first      = row.get("First Name", "").strip()
        last       = row.get("Last Name",  "").strip()
        display_id = row.get("Display ID", "").strip().lower()

        matched_grade = grades_lookup.get(display_id)

        if matched_grade is not None:
            row["grade"] = str(matched_grade)
        else:
            print(f"  WARNING: No grade match found for '{first} {last}' "
                  f"(Display ID: {display_id}).", file=sys.stderr)
            print(f"           Available keys: {sorted(grades_lookup.keys())}",
                  file=sys.stderr)
            print("           Grade left unchanged.", file=sys.stderr)

        updated_rows.append(row)

    # Re-serialise: keep the preamble lines before the header, then write updated data
    preamble = lines[:header_line_idx]
    import io
    buf = io.StringIO()
    writer = csv.DictWriter(
        buf,
        fieldnames=fieldnames,
        quoting=csv.QUOTE_ALL,
        lineterminator="\r\n",
    )
    writer.writeheader()
    writer.writerows(updated_rows)

    with open(csv_path, "w", newline="", encoding="utf-8-sig") as fh:
        fh.writelines(preamble)
        fh.write(buf.getvalue())

    print(f"\nGrades written to: {csv_path}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Grade student submissions and update grades.csv."
    )
    parser.add_argument(
        "assignment_dir",
        type=Path,
        help="Path to the AssignmentName directory.",
    )
    args = parser.parse_args()

    assignment_dir: Path = args.assignment_dir.resolve()

    if not assignment_dir.is_dir():
        print(f"ERROR: '{assignment_dir}' is not a directory.", file=sys.stderr)
        sys.exit(1)

    # ── Top-level structure validation ─────────────────────────────────────
    print(f"Validating assignment directory: '{assignment_dir.name}' …")
    if not validate_assignment_dir(assignment_dir):
        print("ERROR: Assignment directory failed validation. Aborting.", file=sys.stderr)
        sys.exit(1)

    student_dirs = find_student_dirs(assignment_dir)

    # ── Per-student structure validation ───────────────────────────────────
    invalid_student_names: list[str] = []
    for student_dir in student_dirs:
        if not validate_student_dir(student_dir):
            invalid_student_names.append(student_dir.name)

    if invalid_student_names:
        print(
            f"\nWARNING: {len(invalid_student_names)} student folder(s) have critical "
            f"structural problems and will be skipped: {invalid_student_names}",
            file=sys.stderr,
        )
        student_dirs = [d for d in student_dirs if d.name not in invalid_student_names]

    if not student_dirs:
        print("ERROR: No valid student directories remain after validation. Aborting.",
              file=sys.stderr)
        sys.exit(1)

    print(f"\nFound {len(student_dirs)} valid student folder(s) in '{assignment_dir.name}'.\n")

    grades: dict[str, int] = {}
    for student_dir in student_dirs:
        folder_name, grade = grade_student(student_dir)
        grades[folder_name] = grade
        print()  # blank line between students in terminal output

    # ── Summary ────────────────────────────────────────────────────────────
    print("=" * 60)
    print("GRADING SUMMARY")
    print("=" * 60)
    for name, grade in grades.items():
        print(f"  {name:<40} {grade}")
    print()

    # ── Update CSV ─────────────────────────────────────────────────────────
    csv_path = assignment_dir / "grades.csv"
    update_grades_csv(csv_path, grades)


if __name__ == "__main__":
    main()