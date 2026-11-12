#!/usr/bin/env bash
# Stop every Quarto preview of this repo's site (any port).
# Usage: utils/preview_stop.sh
set -u

repo="$(cd "$(dirname "$0")/.." && pwd)"
pidfile="${TMPDIR:-/tmp}/ae2440-preview.pid"

# Match the quarto wrapper and its deno child by their command line: "preview site".
pids="$(pgrep -f "quarto.*preview site|deno.*preview site" || true)"

# Keep only processes started from this repo, so previews of other projects survive.
mine=""
for pid in $pids; do
  cwd="$(readlink "/proc/$pid/cwd" 2>/dev/null || true)"
  [ "$cwd" = "$repo" ] && mine="$mine $pid"
done

if [ -z "$mine" ]; then
  echo "No preview running for $repo."
else
  kill $mine 2>/dev/null
  for _ in 1 2 3 4 5; do
    alive=""
    for pid in $mine; do kill -0 "$pid" 2>/dev/null && alive="$alive $pid"; done
    [ -z "$alive" ] && break
    sleep 1
  done
  [ -n "$alive" ] && kill -9 $alive 2>/dev/null
  echo "Stopped preview (pids:$mine)."
fi
rm -f "$pidfile"
