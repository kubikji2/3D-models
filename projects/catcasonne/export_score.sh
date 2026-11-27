#!/usr/bin/env bash
# Export the score track as one STL per colour: out/score_<colour>.stl
# Usage: ./export_score.sh                         default settings
#        ./export_score.sh -D 'PAW_COLOUR="black"' any extra -D overrides are passed to OpenSCAD
#        env: OPENSCAD, SCAD, OUT, JOBS
set -euo pipefail

OPENSCAD="${OPENSCAD:-openscad}"
SCAD="${SCAD:-score_track.scad}"
OUT="${OUT:-out}"
JOBS="${JOBS:-$(nproc)}"
COLOURS=(silver carpet thread black white)
mkdir -p "$OUT"

export OPENSCAD SCAD OUT
printf '%s\n' "${COLOURS[@]}" | xargs -P "$JOBS" -I{} bash -c '
    c={}; f="$OUT/score_$c.stl"
    if "$OPENSCAD" -o "$f" -D "LAYER=\"$c\"" "$@" "$SCAD" 2>"$f.log"; then
        rm -f "$f.log"; echo "ok    $c"
    else
        rm -f "$f"; echo "FAIL  $c  (see $f.log; an unused colour fails with an empty object)"
    fi
' _ "$@"