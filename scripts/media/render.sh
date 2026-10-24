#!/usr/bin/env bash
# render.sh — render an estate tape. Sibling of the engine's render-tape.sh ·
# same honesty contract: every verdict is the tool's own, any mutation
# happens in a throwaway copy, nothing global is touched.
#   the-bite  a shallow clone of a real carrier (nika-registry) whose estate
#             is green, mutated and restored by the tape
#   selftest  a copy of this repository's scripts/; the self-test builds its
#             own throwaway repository under TMPDIR
# Usage: bash scripts/media/render.sh [tape-name]
#   TRANSCRIPT  also write the final screen, as text, to this file
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAME="${1:-the-bite}"
TAPE="$ROOT/scripts/media/$NAME.tape"
[ -f "$TAPE" ] || { echo "no tape at $TAPE" >&2; exit 1; }
command -v vhs >/dev/null || { echo "vhs not installed (brew install vhs)" >&2; exit 1; }

rm -rf /tmp/estate-demo /tmp/estate-selftest-demo
if [ "$NAME" = "selftest" ]; then
  mkdir -p /tmp/estate-selftest-demo
  cp -R "$ROOT/scripts" /tmp/estate-selftest-demo/scripts
  (cd /tmp/estate-selftest-demo && TMPDIR=/tmp python3 scripts/selftest.py >/dev/null) || {
    echo "the self-test must pass before it is shown" >&2
    exit 1
  }
else
  # The stage: a shallow clone of a carrier repo whose estate is green.
  git clone -q --depth 1 https://github.com/supernovae-st/nika-registry.git /tmp/estate-demo
  (cd /tmp/estate-demo && python3 scripts/estate.py --check >/dev/null) || {
    echo "the carrier's estate must be green before the demo mutates it" >&2
    exit 1
  }
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK" /tmp/estate-demo /tmp/estate-selftest-demo' EXIT
cp "$TAPE" "$WORK/$NAME.tape"
[ -z "${TRANSCRIPT:-}" ] || printf 'Output %s.txt\n' "$NAME" >> "$WORK/$NAME.tape"
(cd "$WORK" && vhs "$NAME.tape")
[ -z "${TRANSCRIPT:-}" ] || cp "$WORK/$NAME.txt" "$TRANSCRIPT"

mkdir -p "$ROOT/media"
OUT="$ROOT/media/$NAME.gif"
if command -v gifsicle >/dev/null; then
  gifsicle -O3 --lossy=40 "$WORK/$NAME.gif" -o "$OUT"
else
  cp "$WORK/$NAME.gif" "$OUT"
fi
SIZE_MB=$(du -m "$OUT" | cut -f1)
[ "$SIZE_MB" -le 8 ] || { echo "✖ $OUT is ${SIZE_MB}MB (budget 8MB)" >&2; exit 1; }
echo "→ $OUT (${SIZE_MB}MB · budget 8MB)"
