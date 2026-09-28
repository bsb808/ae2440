#!/usr/bin/env python3
"""
Check the dates on site/index.qmd (the schedule) against site/_variables.yml.

- Every week's first overview row  `| [N](#week-N) | Mon DD Mon |`  (or a collapsed
  `| [N](#week-N) | DD–DD Mon |` row for an unposted week) and every heading
  `## Week N — DD Mon` must be a Monday exactly N-1 weeks after term_start.
  Continuation rows (empty Week cell) are covered by the weekday check below.
- Every "Ddd DD Mon" mention on the page (e.g. "Fri 2 Oct", "Tue 20 Oct") must name the
  right weekday for that date in the term's year.

Usage: python3 utils/check_schedule_dates.py [site/index.qmd]
Exit status 1 if anything fails. See specs/spec_startup_new_quarter.md, task 2.
"""
import re
import sys
from datetime import date, datetime, timedelta
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
MONTHS = {m: i for i, m in enumerate(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], 1)}
DAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']


def term_start():
    text = (REPO / 'site' / '_variables.yml').read_text()
    m = re.search(r'^term_start:\s*"?(\d{4}-\d{2}-\d{2})', text, re.M)
    return datetime.strptime(m.group(1), '%Y-%m-%d').date()


def to_date(day, mon, start):
    # Quarters never span a year boundary in a way that matters here; pick the year of term_start,
    # or the next year if the month is earlier than term_start's month (fall quarter ending in Jan).
    year = start.year + (1 if MONTHS[mon] < start.month - 6 else 0)
    return date(year, MONTHS[mon], int(day))


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else REPO / 'site' / 'index.qmd'
    text = path.read_text()
    start = term_start()
    fails = []

    # First date in the Date cell of a week's first row: "Mon 28 Sep", "12–15 Oct" or "30 Nov–3 Dec".
    rows = re.findall(r'^\|\s*\[(\d+)\]\(#week-\d+\)\s*\|\s*(?:Mon )?(\d{1,2})(?:–\d{1,2})? (\w{3})', text, re.M)
    heads = re.findall(r'^## Week (\d+) — (\d{1,2}) (\w{3})', text, re.M)
    for label, items in (('overview row', rows), ('heading', heads)):
        for n, d, mon in items:
            got = to_date(d, mon, start)
            want = start + timedelta(weeks=int(n) - 1)
            if got != want:
                fails.append(f'{label} week {n}: {d} {mon} is {DAYS[got.weekday()]}, expected {want:%a %-d %b}')
    if not rows or not heads:
        fails.append('no week rows or headings found')
    if len(rows) != len(heads):
        fails.append(f'{len(rows)} overview rows but {len(heads)} week headings')

    for ddd, d, mon in re.findall(r'\b(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (\d{1,2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\b', text):
        got = to_date(d, mon, start)
        if DAYS[got.weekday()] != ddd:
            fails.append(f'"{ddd} {d} {mon}" is actually a {DAYS[got.weekday()]}')

    for f in fails:
        print('FAIL', f)
    print(f'{path.relative_to(REPO)}: {len(rows)} weeks from {start:%a %-d %b %Y}; {len(fails)} problem(s)')
    sys.exit(1 if fails else 0)


if __name__ == '__main__':
    main()
