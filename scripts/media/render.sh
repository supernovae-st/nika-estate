#!/usr/bin/env bash
# render.sh — render an estate tape against the shared tool on a REAL
# carrier repo copy (nika-registry · byte-identical estate.py). Sibling
# of the engine's render-tape.sh · same honesty contract: every verdict
# is the tool's own, the mutation happens in a throwaway copy, nothing
# global is touched. Usage: bash scripts/media/render.sh [tape-name]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAME="${1:-the-bite}"
TAPE="$ROOT/scripts/media/$NAME.tape"
[ -f "$TAPE" ] || { echo "no tape at $TAPE" >&2; exit 1; }
command -v vhs >/dev/null || { echo "vhs not installed (brew install vhs)" >&2; exit 1; }

# The stage: a shallow clone of a carrier repo whose estate is green.
rm -rf /tmp/estate-demo
git clone -q --depth 1 https://github.com/supernovae-st/nika-registry.git /tmp/estate-demo
(cd /tmp/estate-demo && python3 scripts/estate.py --check >/dev/null) || {
  echo "the carrier's estate must be green before the demo mutates it" >&2
  exit 1
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK" /tmp/estate-demo' EXIT
cp "$TAPE" "$WORK/$NAME.tape"
(cd "$WORK" && vhs "$NAME.tape")

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
