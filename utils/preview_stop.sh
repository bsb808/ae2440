#!/usr/bin/env bash
# Stop every Quarto preview of this repo's site (any port).
# Usage: utils/preview_stop.sh
set -u

repo="$(cd "$(dirname "$0")/.." && pwd)"
pidfile="${TMPDIR:-/tmp}/ae2440-preview.pid"

# Match only the quarto wrapper ("[bash ]/path/quarto preview site ...") and its deno child
# ("/path/deno run ... preview site ..."), anchored at the program name so a shell whose
# command line merely mentions "quarto preview site" is not matched.
pids="$(pgrep -f '^(bash )?[^ ]*quarto preview site|^[^ ]*deno run .*preview site' || true)"

# Never kill this script's own ancestors.
ancestors=" "
p=$$
while [ "$p" -gt 1 ] 2>/dev/null; do
  ancestors="$ancestors$p "
  p="$(awk '{print $4}' "/proc/$p/stat" 2>/dev/null || echo 1)"
done

# Keep only processes started from this repo, so previews of other projects survive.
mine=""
for pid in $pids; do
  case "$ancestors" in *" $pid "*) continue ;; esac
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
