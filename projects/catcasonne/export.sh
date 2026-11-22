#!/usr/bin/env bash
# Export one STL per tile type and colour: out/<name>_<colour>.stl
# Usage: ./export.sh            all tiles
#        ./export.sh Q D_start  only the named tiles
#        env: OPENSCAD, SCAD, OUT, JOBS
set -euo pipefail

OPENSCAD="${OPENSCAD:-openscad}"
SCAD="${SCAD:-catcassonne.scad}"
OUT="${OUT:-out}"
JOBS="${JOBS:-$(nproc)}"
mkdir -p "$OUT"

# 1) validate
if ! "$OPENSCAD" -o "$OUT/check.echo" -D 'MODE="check"' "$SCAD" 2>"$OUT/check.log"; then
    cat "$OUT/check.log"; echo "validation failed"; exit 1
fi
sed -n 's/^ECHO: //p' "$OUT/check.echo"

# 2) list jobs:  ECHO: "JOB", 0, "A", 2, "silver"  ->  0 A 2 silver
"$OPENSCAD" -o "$OUT/jobs.echo" -D 'MODE="list"' "$SCAD" 2>/dev/null
sed -nE 's/^ECHO: "JOB", ([0-9]+), "([^"]+)", ([0-9]+), "([^"]+)"$/\1 \2 \3 \4/p' \
    "$OUT/jobs.echo" > "$OUT/jobs.txt"

# optional filter: ./export.sh Q D_start  -> only those tiles
if [ "$#" -gt 0 ]; then
    awk -v names="$*" 'BEGIN { n = split(names, a, " "); for (i = 1; i <= n; i++) want[a[i]] = 1 }
                       want[$2]' "$OUT/jobs.txt" > "$OUT/jobs.tmp"
    mv "$OUT/jobs.tmp" "$OUT/jobs.txt"
    [ -s "$OUT/jobs.txt" ] || { echo "no tile named: $*"; exit 1; }
fi
echo "$(wc -l < "$OUT/jobs.txt") jobs, $JOBS in parallel"

# 3) export in parallel; an empty colour region fails and is skipped
export OPENSCAD SCAD OUT
xargs -P "$JOBS" -L 1 bash -c '
    i=$0 name=$1 count=$2 colour=$3
    f="$OUT/${name}_${colour}.stl"
    if "$OPENSCAD" -o "$f" -D "MODE=\"tile\"" -D "TILE_INDEX=$i" -D "LAYER=\"$colour\"" "$SCAD" 2>"$f.log"; then
        rm -f "$f.log"; echo "ok    $name x$count  $colour"
    else
        rm -f "$f"; echo "FAIL  $name  $colour  (see $f.log)"
    fi
' < "$OUT/jobs.txt"