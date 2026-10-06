#!/usr/bin/env python3
"""
grade.py — run an assignment's grading checks (grading/aNN/checks.yaml) on a
Sakai download. Workflow and check kinds: specs/spec_grading.md.

    python3 grading/grade.py a01 --reference     # reference solution + fixtures
    python3 grading/grade.py a01 --dry-run       # newest "Assignment 1_*.zip" -> report.md
    python3 grading/grade.py a01 --write --pack  # also comments.txt, grades.csv, a01_graded.zip

Student files never live in the repo. The Sakai zip is read from, and every working
file is written to, <studentwork>/<quarter>/ (grading/config.yaml; override with
--studentwork, --quarter, or --zip PATH). Every run re-extracts the zip into
<studentwork>/<quarter>/aNN/submissions/, so --write never appends twice.
"""

import argparse
import concurrent.futures as cf
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

import yaml

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import grading_utils as gu  # noqa: E402

PASS, FAIL, NA = "pass", "fail", "n/a"
MATLAB_WORKERS = 4


# ---------------------------------------------------------------------------
# Checks that run in Python
# ---------------------------------------------------------------------------

def find_file(submitted, name):
    """Exact name if present, else a case-insensitive match (still runs, F1 fails)."""
    if name in submitted:
        return name
    for f in submitted:
        if f.lower() == name.lower():
            return f
    return None


def check_files(check, cfg, submitted):
    missing = [f for f in cfg["required_files"] if f not in submitted]
    if not missing:
        return PASS, {}
    shown = []
    for f in missing:
        alt = find_file(submitted, f)
        shown.append(f"{f} (you submitted {alt})" if alt else f)
    return FAIL, {"missing": ", ".join(shown)}


def count_blocks(text):
    """Count runs of text lines and runs of code lines; blank and %% lines are neutral."""
    n_text = n_code = 0
    prev = None
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith("%%") or s.startswith("%[appendix"):
            continue
        kind = "text" if s.startswith("%[text") else "code"
        if kind != prev:
            if kind == "text":
                n_text += 1
            else:
                n_code += 1
            prev = kind
    return n_text, n_code


def check_static(check, path):
    text = gu.extract_code_text(path)
    n_text, n_code = count_blocks(text)
    missing = []
    if check.get("title") and not re.search(r"^%\[text\]\s*#\s", text, re.M):
        missing.append("a title")
    if n_text < check.get("min_text_blocks", 0):
        missing.append(f"{check['min_text_blocks']} text blocks (found {n_text})")
    if n_code < check.get("min_code_blocks", 0):
        missing.append(f"{check['min_code_blocks']} code blocks (found {n_code})")
    if check.get("equation") and not re.search(r"^%\[text\].*\$", text, re.M):
        missing.append("an equation")
    for pat in check.get("require", []):
        if not re.search(pat, open(path, encoding="utf-8", errors="replace").read(), re.M):
            missing.append(f"pattern {pat}")
    return (PASS, {}) if not missing else (FAIL, {"missing": "; ".join(missing)})


def close(x, target, rtol):
    return abs(x - target) <= rtol * abs(target) if target else abs(x) <= rtol


def check_value(check, run):
    if not run or not run["ran"]:
        return NA, {}
    sc = run["scalars"] or {}
    rtol = check.get("rtol", 0.01)
    if "expect" in check:
        found = {k: sc.get(k) for k in check["expect"]}
        ok = all(found[k] is not None and close(found[k], v, rtol) for k, v in check["expect"].items())
        shown = ", ".join(f"{k} = {'(not found)' if v is None else f'{v:.4g}'}" for k, v in found.items())
        return (PASS if ok else FAIL), {"found": shown}
    if "expect_any" in check:
        ok = any(close(v, t, rtol) for v in sc.values() if v is not None for t in check["expect_any"])
        return (PASS if ok else FAIL), {}
    if "expect_all" in check:  # every target matched by some scalar, any name
        vals = [v for v in sc.values() if v is not None]
        ok = all(any(close(v, t, rtol) for v in vals) for t in check["expect_all"])
        return (PASS if ok else FAIL), {}
    raise ValueError(f"{check['id']}: value check needs expect, expect_any or expect_all")


# ---------------------------------------------------------------------------
# MATLAB execution
# ---------------------------------------------------------------------------

def matlab_run(jobs, workdir, timeout_per_script=30):
    """Run jobs [{key, name, path}] in MATLAB; return {(key, name): result}.

    A hung script times out its batch; it is recorded as an error and the rest
    of the batch is rerun.
    """
    results = {}
    remaining = list(jobs)
    while remaining:
        fd, jobfile = tempfile.mkstemp(suffix=".json", dir=workdir)
        os.close(fd)
        outfile = jobfile.replace(".json", ".jsonl")
        Path(jobfile).write_text(json.dumps(remaining))
        cmd = f"addpath('{HERE}'); run_checks('{jobfile}', '{outfile}')"
        timed_out = False
        try:
            subprocess.run(["matlab", "-batch", cmd], stdin=subprocess.DEVNULL,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                           timeout=60 + timeout_per_script * len(remaining))
        except subprocess.TimeoutExpired:
            timed_out = True
        done = []
        if os.path.exists(outfile):
            for line in Path(outfile).read_text().splitlines():
                r = json.loads(line)
                if isinstance(r.get("scalars"), list):  # empty struct encodes as []
                    r["scalars"] = {}
                results[(r["key"], r["name"])] = r
                done.append((r["key"], r["name"]))
            os.remove(outfile)
        os.remove(jobfile)
        remaining = [j for j in remaining if (j["key"], j["name"]) not in done]
        if remaining:
            j = remaining.pop(0)
            why = "timed out (possible infinite loop or waiting for input)" if timed_out else "MATLAB exited while running it"
            results[(j["key"], j["name"])] = {"key": j["key"], "name": j["name"], "ran": False, "error": why, "scalars": {}}
    return results


def matlab_run_parallel(jobs, workdir):
    keys = sorted({j["key"] for j in jobs})
    chunks = [[j for j in jobs if j["key"] in keys[i::MATLAB_WORKERS]] for i in range(MATLAB_WORKERS)]
    results = {}
    with cf.ThreadPoolExecutor(MATLAB_WORKERS) as ex:
        for r in ex.map(lambda c: matlab_run(c, workdir) if c else {}, chunks):
            results.update(r)
    return results


# ---------------------------------------------------------------------------
# Grading one assignment
# ---------------------------------------------------------------------------

def files_for(check, cfg):
    f = check["file"]
    if f in ("all", "each"):
        return cfg["required_files"]
    return f if isinstance(f, list) else [f]


def grade_all(cfg, students, workdir):
    """students: list of (key, submission_dir). Returns per-student result dicts."""
    jobs = []
    run_files = sorted({f for c in cfg["checks"] if c["kind"] in ("runs", "value") for f in files_for(c, cfg)})
    subs = {}
    for key, sdir in students:
        submitted = sorted(os.listdir(sdir)) if os.path.isdir(sdir) else []
        subs[key] = submitted
        for name in run_files:
            actual = find_file(submitted, name)
            if actual:
                jobs.append({"key": key, "name": name, "path": str(Path(sdir) / actual)})
    runs = matlab_run_parallel(jobs, workdir) if jobs else {}

    out = []
    for key, sdir in students:
        submitted = subs[key]
        rows = []  # (check, file, status, fields)
        for c in cfg["checks"]:
            if c["kind"] == "files":
                st, fld = check_files(c, cfg, submitted)
                rows.append((c, None, st, fld))
                continue
            for name in files_for(c, cfg):
                actual = find_file(submitted, name)
                if not actual:
                    rows.append((c, name, NA, {}))
                elif c["kind"] == "static":
                    st, fld = check_static(c, str(Path(sdir) / actual))
                    rows.append((c, name, st, fld))
                elif c["kind"] == "runs":
                    r = runs.get((key, name))
                    st = PASS if r and r["ran"] else FAIL
                    rows.append((c, name, st, {"error": (r or {}).get("error", "").rstrip(".")}))
                elif c["kind"] == "value":
                    rows.append((c, name, *check_value(c, runs.get((key, name)))))
                else:
                    raise ValueError(f"unknown check kind {c['kind']}")
        graded_fail = any(c["graded"] and st == FAIL for c, _, st, _ in rows)
        grade = cfg["grade"]["fail"] if graded_fail else cfg["grade"]["pass"]
        out.append({"key": key, "submitted": submitted, "rows": rows, "grade": grade,
                    "empty": not submitted})
    return out


def render(msg, name, fld):
    return msg.format(file=name or "", **{k: v for k, v in fld.items()})


def comment_text(cfg, res):
    lines = [f"Grade: {res['grade']}/100"]
    graded = [r for r in res["rows"] if r[0]["graded"]]
    fails = [r for r in graded if r[2] == FAIL]
    if not fails:
        passes = []
        for c, _, _, _ in graded:
            if c.get("pass") and c["pass"] not in passes:
                passes.append(c["pass"])
        lines.append("Required: " + " ".join(passes))
    else:
        lines.append("Required (not yet met):")
        lines += [f"- {render(c['fail'], n, f)}" for c, n, _, f in fails]
    adv = [r for r in res["rows"] if not r[0]["graded"]]
    sugg = [render(c["fail"], n, f) for c, n, st, f in adv if st == FAIL][: cfg.get("max_suggestions", 5)]
    nice = [c["pass"] for c, n, st, f in adv if st == PASS and c.get("pass")]
    if sugg:
        lines += ["", "Suggestions:"] + [f"- {s}" for s in sugg]
    if nice:
        lines += ["", "Nice work: " + " ".join(dict.fromkeys(nice))]
    return "\n".join(lines) + "\n"


def check_cols(cfg):
    cols = []
    for c in cfg["checks"]:
        if c["kind"] == "files":
            cols.append((c["id"], None))
        else:
            cols += [(c["id"], n) for n in files_for(c, cfg)]
    return cols


def report_md(cfg, results, title):
    sym = {PASS: "✓", FAIL: "✗", NA: "–"}
    cols = check_cols(cfg)
    hdr = [f"{cid}" + (f" {n.removesuffix('.m')}" if n else "") for cid, n in cols]
    L = [f"# {cfg['assignment']} grading report: {title}", "",
         "Working file (contains usernames; gitignored). ✓ pass, ✗ fail, – not checked.", ""]
    graded = [r for r in results if not r["empty"]]
    L.append(f"Students: {len(results)}; submitted: {len(graded)}; "
             f"grade {cfg['grade']['pass']}: {sum(r['grade'] == cfg['grade']['pass'] for r in graded)}; "
             f"grade {cfg['grade']['fail']}: {sum(r['grade'] == cfg['grade']['fail'] for r in graded)}")
    if len(graded) < len(results):
        L.append(f"No submission (grade left blank): {', '.join(r['key'] for r in results if r['empty'])}")
    L += ["", "## Pass counts", "", "| Check | Pass | Fail | Not checked |", "|---|---|---|---|"]
    for i, (cid, n) in enumerate(cols):
        sts = [r["rows"][i][2] for r in graded]
        L.append(f"| {hdr[i]} | {sts.count(PASS)} | {sts.count(FAIL)} | {sts.count(NA)} |")
    L += ["", "## Per student", "", "| Student | Grade | " + " | ".join(hdr) + " |",
          "|---|---|" + "---|" * len(cols)]
    for r in results:
        if r["empty"]:
            L.append(f"| {r['key']} | — | " + " | ".join("" for _ in cols) + " |")
        else:
            L.append(f"| {r['key']} | {r['grade']} | " + " | ".join(sym[row[2]] for row in r["rows"]) + " |")
    L += ["", "## Failures", ""]
    for r in graded:
        f = [(c, n, st, fld) for c, n, st, fld in r["rows"] if st == FAIL]
        if f:
            L.append(f"- {r['key']} (submitted: {', '.join(r['submitted'])})")
            L += [f"  - {c['id']}: {render(c['fail'], n, fld)}" for c, n, st, fld in f]
    return "\n".join(L) + "\n"


# ---------------------------------------------------------------------------
# Modes
# ---------------------------------------------------------------------------

def run_reference(adir, cfg, work):
    """Reference solution must pass everything; each fixture fails only its named check."""
    work = work / "reference"
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir(parents=True)
    ref = (HERE.parent / cfg["reference_dir"]).resolve()  # relative to the repo root
    base = work / "reference"
    base.mkdir()
    for f in cfg["required_files"]:
        shutil.copy(ref / f.replace(".m", "_soln.m"), base / f)
    students = [("reference", str(base))]
    fixtures = sorted(p for p in (adir / "fixtures").iterdir() if p.is_dir()) if (adir / "fixtures").is_dir() else []
    for fx in fixtures:
        d = work / fx.name
        shutil.copytree(base, d)
        drop = fx / "DROP"
        if drop.exists():
            for f in drop.read_text().split():
                (d / f).unlink()
        for f in fx.iterdir():
            if f.name != "DROP":
                shutil.copy(f, d / f.name)
        students.append((fx.name, str(d)))
    results = grade_all(cfg, students, str(work))
    ok = True
    for r in results:
        failed = sorted({c["id"] for c, _, st, _ in r["rows"] if st == FAIL})
        want = [] if r["key"] == "reference" else sorted(r["key"].split("_")[0].split("+"))
        good = failed == want
        ok &= good
        print(f"{'OK ' if good else 'BAD'} {r['key']:<24} grade {r['grade']}  failed {failed or '-'}  expected {want or '-'}")
    (work / "report.md").write_text(report_md(cfg, results, "reference and fixtures"))
    print(f"Scratch and report in {work}")
    print("\nComment for the reference:\n" + comment_text(cfg, results[0]))
    return ok


def find_zip(adir, qdir):
    """Newest Sakai download for this assignment in the quarter folder, e.g. 'Assignment 1_ Models and Scripts _2026.zip'."""
    n = int(adir.name.lstrip("a"))
    zips = sorted(qdir.glob(f"Assignment {n}_*.zip"), key=lambda p: p.stat().st_mtime)
    if not zips:
        sys.exit(f"No 'Assignment {n}_*.zip' in {qdir} (download it from Sakai, or pass --zip PATH)")
    return zips[-1]


def run_sakai(adir, cfg, work, z, write, pack):
    sub = work / "submissions"
    shutil.rmtree(sub, ignore_errors=True)
    sub.mkdir(parents=True)
    with zipfile.ZipFile(z) as zf:
        zf.extractall(sub)
    top = [p for p in sub.iterdir() if p.is_dir()]
    if len(top) != 1:
        sys.exit(f"Expected one top-level folder in {z.name}, found {len(top)}")
    adir_s = top[0]
    sdirs = gu.get_student_dirs(str(adir_s))
    students = [(gu.student_id(s), gu.submission_dir(s)) for s in sdirs]
    print(f"{z.name}: {len(students)} students; running checks...")
    results = grade_all(cfg, students, str(work))
    (work / "report.md").write_text(report_md(cfg, results, z.name))
    (work / "report.json").write_text(json.dumps(
        [{"key": r["key"], "grade": None if r["empty"] else r["grade"], "submitted": r["submitted"],
          "checks": [{"id": c["id"], "file": n, "status": st, **fld} for c, n, st, fld in r["rows"]]}
         for r in results], indent=1))
    for r in results:
        r["comment"] = comment_text(cfg, r)
    (work / "comments_preview.md").write_text("\n".join(
        f"## {r['key']}\n\n```\n{'(no submission)' if r['empty'] else r['comment']}```\n" for r in results))
    print(f"Wrote report.md, report.json and comments_preview.md in {work}")
    if write:
        by_key = {r["key"]: r for r in results}
        for s in sdirs:
            r = by_key[gu.student_id(s)]
            if not r["empty"]:
                gu.append_comment(s, r["comment"])
        pre, rows = gu.read_grades_csv(str(adir_s))
        for row in rows:
            r = by_key.get(row["ID"]) or by_key.get(row["Display ID"])
            if r and not r["empty"]:
                row["grade"] = str(r["grade"])
        gu.write_grades_csv(str(adir_s), pre, rows)
        print(f"Wrote comments.txt and grades.csv in {sub}")
    if pack:
        out = work / f"{adir.name}_graded.zip"
        with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zf:
            for p in sorted(adir_s.rglob("*")):
                zf.write(p, p.relative_to(sub))
        print(f"Packed {out}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("assignment", help="assignment folder under grading/, e.g. a01")
    ap.add_argument("--reference", action="store_true", help="check the reference solution and fixtures")
    ap.add_argument("--dry-run", action="store_true", help="report only (default)")
    ap.add_argument("--write", action="store_true", help="append comments.txt and fill grades.csv")
    ap.add_argument("--pack", action="store_true", help="zip the graded folder for Sakai")
    ap.add_argument("--studentwork", help="student-work root (default: grading/config.yaml, relative to the repo root)")
    ap.add_argument("--quarter", help="quarter folder under the student-work root (default: grading/config.yaml)")
    ap.add_argument("--zip", help="a specific Sakai zip instead of the newest one in the quarter folder")
    a = ap.parse_args()
    adir = HERE / a.assignment
    cfg = yaml.safe_load((adir / "checks.yaml").read_text())
    conf = yaml.safe_load((HERE / "config.yaml").read_text())
    root = Path(a.studentwork or conf["studentwork"])
    if not root.is_absolute():
        root = (HERE.parent / root).resolve()  # relative to the repo root
    qdir = root / (a.quarter or conf["quarter"])
    if not qdir.is_dir():
        sys.exit(f"Student-work folder not found: {qdir}")
    work = qdir / adir.name
    work.mkdir(exist_ok=True)
    if a.reference:
        sys.exit(0 if run_reference(adir, cfg, work) else 1)
    z = Path(a.zip).resolve() if a.zip else find_zip(adir, qdir)
    run_sakai(adir, cfg, work, z, a.write, a.pack)


if __name__ == "__main__":
    main()
