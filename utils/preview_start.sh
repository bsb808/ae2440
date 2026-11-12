#!/usr/bin/env bash
# Start a fresh Quarto preview of the course site in the background and open it in the browser.
# Stops any running preview of this repo first.
# Usage: utils/preview_start.sh [port]     (default port 4321)
# Log: ${TMPDIR:-/tmp}/ae2440-preview.log
# Note: do not run "quarto render site" while the preview is up; both write site/_site/ and the preview breaks.
set -eu

port="${1:-4321}"
repo="$(cd "$(dirname "$0")/.." && pwd)"
log="${TMPDIR:-/tmp}/ae2440-preview.log"
pidfile="${TMPDIR:-/tmp}/ae2440-preview.pid"

"$repo/utils/preview_stop.sh"

cd "$repo"
nohup quarto preview site --port "$port" --no-browser >"$log" 2>&1 &
echo $! >"$pidfile"

# Wait up to 60 s for the server to come up.
for _ in $(seq 1 60); do
  if grep -q "Listening on" "$log" 2>/dev/null; then
    url="http://localhost:$port/"
    echo "Preview running at $url (log: $log)"
    xdg-open "$url" >/dev/null 2>&1 || true
    exit 0
  fi
  if ! kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    echo "Preview failed to start; last lines of $log:" >&2
    tail -20 "$log" >&2
    exit 1
  fi
  sleep 1
done
echo "Preview did not report ready within 60 s; see $log" >&2
exit 1
