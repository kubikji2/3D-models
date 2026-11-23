// Catcassonne tile engine (OpenSCAD 2021.01)
//
//   openscad catcassonne.scad                                   preview of all tiles
//   openscad -o x.echo -D 'MODE="check"' catcassonne.scad       validation report
//   openscad -o A_carpet.stl -D 'MODE="tile"' -D TILE_INDEX=0 -D 'LAYER="carpet"' catcassonne.scad
//   openscad -D 'MODE="art"' catcassonne.scad                    all ART pictures, enlarged
//
// Each tile is exported as one body per colour; all bodies share the origin,
// so they load into PrusaSlicer as parts of one multi-material object.

include <tiles.scad>
include <art.scad>
include <art_placeholders.scad>
use <../../lib/solidpp/solidpp.scad>

/* [Mode] */
MODE       = "preview";   // "preview" | "tile" | "check" | "list" | "art"
TILE_INDEX = 0;
LAYER      = "all";       // "all" (coloured preview) or one name from COLOURS

/* [Geometry, mm] */
T          = 45;          // tile side
TILE_R     = 2;           // rounding of the tile's vertical corners (0 = sharp)
BASE_H     = 0.6;         // silver base slab (3 x 0.2 mm)
TOP_H      = 0.6;         // colour layer (3 x 0.2 mm)
CORNER_M   = 4;           // sets where a carpet's inner edge ends (its slanted edges run to the corners)
DIAG_E     = 2.5;         // a diagonal edge bows this far in at its middle (2 diagonals -> inner field 2x)
CAP_D      = 10;          // depth of a one-side carpet (trapezoid)
CAP_THIN_D = 5;           // depth of a "thin" cap (city strip beyond an inner field)
BAND_CAP_D = 12;          // depth of the field notches on a two-side band
U_OPEN_D   = 14;          // depth of the field notch on a three-side carpet
WEDGE_S    = 10;          // width of the field strip left by a "wedge" carpet
THREAD_W   = 4;
THREAD_STEM = 5;          // a ribbon ending in a carpet runs this far straight in from the tile edge,
THREAD_SINK = 3;          // then turns to the nearest carpet edge and ends this far inside it
BRIDGE_GAP = 1.2;         // field border around a "bridge" thread
CARPET_GAP = 0.6;         // field gap between separate carpets on one tile
PAW_T      = 0.45;        // how far the paw moves from the corner towards the carpet centre (0..1)
$fn = 64;

/* [Ribbons] */
RIBBON_A     = 6;         // largest sideways swing of a ribbon (centre to peak); reduced where tight
RIBBON_A_DEAD = 0.6;      // dead ends (into a junction / bowl) swing only this fraction of it
RIBBON_STEM  = 4;         // each ribbon leaves a tile edge straight and centred for this length
RIBBON_FADE  = 6;         // ...and the swing fades in over this length
RIBBON_CLEAR = 1.5;       // min gap between a ribbon and carpets, the bowl, other ribbons, the tile edge
TWIST_P      = 0;         // chance of a random twist per ribbon (seeded); the "twist" flag forces one
TWIST_W      = 1.2;       // ribbon width at the narrowest point of a twist
TWIST_L      = 5;         // length of a twist

/* [Carpet decoration] */
TASSELS      = false;     // tassels along the carpet edges that face a field
FRINGE_L     = 2;         // tassel length (mm, before jitter)
FRINGE_W     = 1;         // tassel width
FRINGE_P     = 2.5;       // tassel pitch
FRINGE_END   = 1.5;       // keep tassels this far from the ends of an edge
FRINGE_JIT   = 0.3;       // random length variation, +-fraction of FRINGE_L
FRINGE_CLEAR = 0.8;       // tassels keep this far from threads
FRINGE_NEAR  = 4.5;       // drop a tassel whose tip is this close to another carpet (inner fields)
WAVE         = true;      // sine-wave edges instead of straight ones
WAVE_A       = 0.5;       // wave amplitude
WAVE_L       = 4;         // target wavelength (adjusted to fit each edge)
WAVE_FADE    = 3;         // near a tile corner the edge is straight; the wave eases in over this length
TIP_SHORTEN  = 4;         // straight tips at unshared corners are this much shorter (one more wave)
TIP_MIN      = 2;         // ...but never shorter than this
BORDER       = true;      // decorative line just inside the carpet edge
BORDER_COLOUR = "thread";
BORDER_IN    = 1.5;       // distance of the line from the carpet edge
BORDER_W     = 1;         // line width

/* [Hidden] */
H = T / 2;

/* [Colours] */
COLOURS = ["silver", "carpet", "thread", "black", "white"];   // = the 5 toolheads
PREVIEW_RGB = [["silver", "#b8b8b8"], ["carpet", "#8e44ad"], ["thread", "#e6b422"],
               ["black", "#222222"], ["white", "#f4f4f4"]];

// artwork: the ART table lives in art.scad, placeholders in art_placeholders.scad

/* [Hidden] */
SHAPE_FLAGS = ["thin", "wedge", "bridge", "twist"];   // flags that change a shape instead of adding an icon

// ---------------------------------------------------------------- helpers

function kv(table, key) = let(r = [for (e = table) if (e[0] == key) e[1]])
    assert(len(r) > 0, str("missing key: ", key)) r[0];
function has(l, x) = len([for (e = l) if (e == x) 1]) > 0;
function same_set(a, b) = len(a) == len(b) && len([for (e = a) if (!has(b, e)) 1]) == 0;
function sum(l, i = 0) = i >= len(l) ? 0 : l[i] + sum(l, i + 1);
function count(l, x) = len([for (e = l) if (e == x) 1]);

function t_name(t)  = t[0];
function t_count(t) = t[1];
function t_set(t)   = t[2];
function t_feats(t) = t[3];
function t_flags(t) = len(t) > 4 ? t[4] : [];

function f_type(f)  = f[0];
function f_sides(f) = len(f) > 1 ? f[1] : [];
function f_flags(f) = len(f) > 2 ? f[2] : [];
function f_at(f)    = len(f) > 3 ? f[3] : undef;

function fl_name(fl) = is_list(fl) ? fl[0] : fl;
function fl_at(fl)   = is_list(fl) ? fl[1] : undef;
function has_flag(f, name) = has([for (fl = f_flags(f)) fl_name(fl)], name);

// ---------------------------------------------------------------- rotation
// Every shape is drawn in a canonical orientation and rotated by k quarter
// turns clockwise: side s -> (s + k) % 4, point (x, y) -> (y, -x).

function canon(sides) =
    len(sides) == 1 ? [0] :
    len(sides) == 2 ? (abs(sides[0] - sides[1]) == 2 ? [1, 3] : [0, 1]) :
    len(sides) == 3 ? [0, 1, 3] :
    [0, 1, 2, 3];
function rot_sides(s, k) = [for (c = s) (c + k) % 4];
function find_rot(sides, c) = let(ks = [for (k = [0:3]) if (same_set(rot_sides(c, k), sides)) k])
    assert(len(ks) > 0, str("no rotation of ", c, " gives ", sides)) ks[0];
function rot_cw(p, k) = k == 0 ? p : rot_cw([p[1], -p[0]], k - 1);

// ---------------------------------------------------------------- carpets
// Rugs with straight edges, drawn canonically and rotated. Every carpet covers its sides
// from corner to corner: its slanted edges run from the inner vertices straight to the
// exact tile corners, so carpets on neighbouring tiles always meet.
// All point lists run counter-clockwise: the field is on the right of each edge.

function cap_depth(f) = has_flag(f, "thin") ? CAP_THIN_D : CAP_D;

function cap_pts(d) = let(m = CORNER_M)
    [[H, H], [-H, H], [-H + m + d, H - d], [H - m - d, H - d]];
function diag_pts() = [[H, -H], [H, H], [-H, H], [1, 1] * DIAG_E / sqrt(2)];
function band_pts() = let(m = CORNER_M, n = BAND_CAP_D, c = n - m)
    [[-H, H], [-H, -H], [-H + c, -H + n], [H - c, -H + n],
     [H, -H], [H, H], [H - c, H - n], [-H + c, H - n]];
function u_pts() = let(m = CORNER_M, u = U_OPEN_D, c = u - m)
    [[-H, H], [-H, -H], [-H + c, -H + u], [H - c, -H + u], [H, -H], [H, H]];
// "wedge": carpet on N reaching the SE corner, leaving a field strip along E
function wedge_pts() = [[H - WEDGE_S, H], [-H, H], [H, -H]];
function full_pts() = [[-H, H], [-H, -H], [H, -H], [H, H]];

function carpet_pts_canon(c, f) =
    c == [0]       ? (has_flag(f, "wedge") ? wedge_pts() : cap_pts(cap_depth(f))) :
    c == [0, 1]    ? diag_pts() :
    c == [1, 3]    ? band_pts() :
    c == [0, 1, 3] ? u_pts() :
    full_pts();

function carpet_pts(f) = let(c = canon(f_sides(f)), k = find_rot(f_sides(f), c))
    [for (p = carpet_pts_canon(c, f)) rot_cw(p, k)];

// an edge lying on the tile border (it continues on the neighbouring tile)
function on_edge(a, b) = (a[0] == b[0] && abs(a[0]) == H) || (a[1] == b[1] && abs(a[1]) == H);
function ff(P, i) = let(n = len(P)) !on_edge(P[(i + n) % n], P[(i + n + 1) % n]);   // edge i faces field
function is_corner(c) = abs(abs(c[0]) - H) < 1e-6 && abs(abs(c[1]) - H) < 1e-6;
function unit(v) = v / norm(v);
function cross2(a, b) = a[0] * b[1] - a[1] * b[0];

// Near a tile corner a carpet ends in a tip; over the first tip_len of an edge leaving a
// corner (direction u) the edge is straight and the gold line runs straight into the corner.
// tip_len is chosen so that line runs through the middle of the tip.
function tip_len(u, Le, short = false) = let(
    sn = min(abs(u[0]), abs(u[1])), D = BORDER_IN + BORDER_W / 2,
    L = min(D / (0.5 * max(sn, 0.1)) + 0.5, 0.8 * Le)
) short ? max(TIP_MIN, L - TIP_SHORTEN) : L;
function tip_lens(a, b) = let(Le = norm(b - a))
    [is_corner(a) ? tip_len(unit(b - a), Le) : -1, is_corner(b) ? tip_len(unit(a - b), Le) : -1];

// sine wave along an edge a -> b: a whole number of waves, zero at both ends,
// switched off over the tip lengths tl = [at a, at b] (-1 = no tip there)
function wave_count(L) = max(1, round(L / WAVE_L));
function smooth(x) = x >= 1 ? 1 : x <= 0 ? 0 : x * x * (3 - 2 * x);
function wave_disp(L, s, tl = [-1, -1]) = !WAVE ? 0 :
    WAVE_A * sin(360 * wave_count(L) * s / L)
    * (tl[0] >= 0 ? smooth((s - tl[0]) / WAVE_FADE) : 1)
    * (tl[1] >= 0 ? smooth((L - s - tl[1]) / WAVE_FADE) : 1);
function wave_inner(a, b, tl = undef) = let(
    L = norm(b - a), d = (b - a) / L, n = [d[1], -d[0]], N = wave_count(L) * 8,
    t = tl == undef ? tip_lens(a, b) : tl
) [for (k = [1:N - 1]) a + d * (L * k / N) + n * wave_disp(L, L * k / N, t)];

// Widened tips: at a corner with one field edge that no other carpet on the tile uses,
// the tip edge runs parallel to the gold line, BORDER_IN outside the line's outer edge, so
// the carpet strip outside the line keeps its width into the corner. The line's outer edge
// (its boundary with that strip) passes exactly through the corner. The tip edge meets the
// field-side tile edge at x, a little way from the corner. Corners shared with another
// carpet keep the plain tip (widened tips would overlap there).
function shared(v, others) = len([for (o = others) for (q = carpet_pts(o)) if (norm(q - v) < 1e-6) 1]) > 0;
function widened(P, i, others) = is_corner(P[i]) && ff(P, i) != ff(P, i - 1) && !shared(P[i], others);

function tip_geom(P, i) = let(        // [x, e]: x on the field-side tile edge, e where the tip ends
    n = len(P), v = P[i], fwd = ff(P, i),
    w = fwd ? P[(i + 1) % n] : P[(i + n - 1) % n],
    u = unit(w - v), e = v + u * tip_len(u, norm(w - v), true),
    dd = fwd ? u : -u, nout = [dd[1], -dd[0]],                  // field edge direction / outward normal
    g = unit(e - nout * BORDER_IN - v),                         // gold line's outer edge, from the corner
    ub = unit((fwd ? P[(i + n - 1) % n] : P[(i + 1) % n]) - v), // carpet's own tile edge
    ue = abs(ub[0]) > 0.5 ? [0, -sign(v[1])] : [-sign(v[0]), 0], // the other tile edge, into the tile
    tx = cross2(e - v, g) / cross2(ue, g)
) [v + ue * tx, e];

// outline as [point, kind]: 0 = vertex, 1 = x (on a tile edge), 2 = e (end of a straight tip)
function carpet_marked(f, others) = let(P = carpet_pts(f), n = len(P))
    [for (i = [0:n - 1]) each (!widened(P, i, others) ? [[P[i], 0]] :
        let(xe = tip_geom(P, i)) ff(P, i) ? [[P[i], 0], [xe[0], 1], [xe[1], 2]]
                                          : [[xe[1], 2], [xe[0], 1], [P[i], 0]])];

function end_tip(A, B) = A[1] == 2 ? 0 : is_corner(A[0]) ? tip_len(unit(B[0] - A[0]), norm(B[0] - A[0])) : -1;

function carpet_outline(f, others = []) = let(Q = carpet_marked(f, others), n = len(Q))
    [for (i = [0:n - 1]) let(A = Q[i], B = Q[(i + 1) % n],
                             tip = (A[1] == 1 && B[1] == 2) || (A[1] == 2 && B[1] == 1))
        each concat([A[0]], WAVE && !on_edge(A[0], B[0]) && !tip
            ? wave_inner(A[0], B[0], [end_tip(A, B), end_tip(B, A)]) : [])];

// `all` = every carpet on the tile (f included); needed to know which corners are shared
module carpet_shape(f, all = []) { polygon(carpet_outline(f, [for (c = all) if (c != f) c])); }

// tassels: small rectangles sticking out of every field-facing edge
function seg_tassels(a, b, seed) = let(
    L = norm(b - a), d = (b - a) / L, n = [d[1], -d[0]],
    k = L < 2 * FRINGE_END ? 0 : floor((L - 2 * FRINGE_END) / FRINGE_P) + 1,
    s0 = (L - (k - 1) * FRINGE_P) / 2,
    j = k > 0 ? rands(-FRINGE_JIT, FRINGE_JIT, k, seed) : [],
    e = n * -(0.3 + (WAVE ? WAVE_A : 0))
) [for (i = [0:1:k - 1]) let(
        c = a + d * (s0 + i * FRINGE_P), w = d * FRINGE_W / 2, o = n * FRINGE_L * (1 + j[i]))
    [c - w + e, c + w + e, c + w + o, c - w + o]];

function seg_dist(p, a, b) = let(ab = b - a, t = max(0, min(1, ((p - a) * ab) / (ab * ab))))
    norm(p - (a + ab * t));
function poly_dist(p, P) = min([for (i = [0:len(P) - 1]) seg_dist(p, P[i], P[(i + 1) % len(P)])]);

// tassels of one carpet; a tassel whose tip comes near another carpet is dropped whole
function carpet_tassels(f, seed, others = []) = let(
    P = carpet_pts(f), n = len(P), OP = [for (o = others) carpet_pts(o)],
    all = [for (i = [0:n - 1]) if (ff(P, i)) each seg_tassels(P[i], P[(i + 1) % n], seed * 16 + i)]
) [for (q = all) let(tip = (q[2] + q[3]) / 2)
      if (len([for (Q = OP) if (poly_dist(tip, Q) < FRINGE_NEAR) 1]) == 0) q];

module fringe_shape(f, seed, others, threads) {
    difference() {
        for (q = carpet_tassels(f, seed, others)) polygon(q);
        for (o = others) offset(r = CARPET_GAP) carpet_shape(o, concat(others, [f]));
        for (t = threads) offset(r = FRINGE_CLEAR) thread_shape(f_sides(t));
    }
}

// Decorative line BORDER_IN inside the carpet edge, only where the carpet meets field:
// a true offset of the field edge (it follows the waves exactly), cut back near the tile
// corners; there a straight link runs from the exact corner to the line, so the lines of
// neighbouring tiles meet in the corner. The link's length is chosen so that it runs
// through the middle of the carpet's tip rather than along the tile border.
function corner_link(P, i) = let(
    n = len(P), v = P[i], fwd = ff(P, i),
    w = fwd ? P[(i + 1) % n] : P[(i + n - 1) % n],                  // other end of the field edge
    a = fwd ? v : w, b = fwd ? w : v,                                // field edge in outline order
    Le = norm(b - a), d = (b - a) / Le, nout = [d[1], -d[0]],
    D = BORDER_IN + BORDER_W / 2,
    L = tip_len(unit(w - v), Le),                                    // link length along the edge
    s = fwd ? L : Le - L,                                            // position along a -> b
    p1 = a + d * s + nout * (wave_disp(Le, s, tip_lens(a, b)) - D),
    g = unit(p1 - v), gin = fwd ? [-g[1], g[0]] : [g[1], -g[0]]       // inward normal of the link
) [v + gin * BORDER_W / 2, p1, v];   // start shifted so the line's outer edge passes the corner

// links only at corners shared with another carpet; widened tips carry the line by themselves
function corner_links(P, others) = let(n = len(P))
    [for (i = [0:n - 1]) if (is_corner(P[i]) && ff(P, i) != ff(P, i - 1) && shared(P[i], others)) corner_link(P, i)];

module border_shape(f, all = []) {
    links = corner_links(carpet_pts(f), [for (c = all) if (c != f) c]);
    difference() {
        intersection() {
            carpet_shape(f, all);
            difference() {
                offset(r = BORDER_IN + BORDER_W) difference() { square(T, center = true); carpet_shape(f, all); }
                offset(r = BORDER_IN) difference() { square(T, center = true); carpet_shape(f, all); }
            }
        }
        for (lk = links) translate(lk[2]) circle(r = norm(lk[1] - lk[2]));
    }
    for (lk = links)
        hull() { translate(lk[0]) circle(d = BORDER_W, $fn = 16); translate(lk[1]) circle(d = BORDER_W, $fn = 16); }
}

// icon anchors
function carpet_centre_canon(c, f) =
    c == [0]       ? (has_flag(f, "wedge") ? [(H - WEDGE_S) / 3, T / 6] : [0, H - cap_depth(f) * 0.45]) :
    c == [0, 1]    ? [1, 1] * (T / 6 + DIAG_E / 3) :
    c == [0, 1, 3] ? [0, U_OPEN_D / 4] :
    [0, 0];
function carpet_corners_canon(c, f) =
    c == [0]       ? (has_flag(f, "wedge") ? wedge_pts() : [[-H + CORNER_M, H], [H - CORNER_M, H]]) :
    c == [0, 1]    ? [[-H, H], [H, H], [H, -H]] :
    c == [1, 3]    ? [[-H, 0], [H, 0]] :
    c == [0, 1, 3] ? [[-H, H], [H, H], [H, -H + CORNER_M], [-H, -H + CORNER_M]] :
    full_pts();

function carpet_centre(f) = let(c = canon(f_sides(f)))
    rot_cw(carpet_centre_canon(c, f), find_rot(f_sides(f), c));

// paw: the carpet corner closest to the tile's top-left, pulled towards the carpet centre
function carpet_paw_spot(f) = let(
    c = canon(f_sides(f)), k = find_rot(f_sides(f), c), m = carpet_centre_canon(c, f),
    pts = [for (v = carpet_corners_canon(c, f)) rot_cw(v + (m - v) * PAW_T, k)],
    score = [for (p = pts) p[0] - p[1]],
    best = min(score)
) [for (i = [0:len(pts) - 1]) if (score[i] == best) pts[i]][0];

// ---------------------------------------------------------------- threads

module thread_canonical(c) {
    if (c == [0]) { translate([-THREAD_W / 2, 0]) square([THREAD_W, T / 2]); circle(d = THREAD_W); }
    else if (c == [1, 3]) square([T, THREAD_W], center = true);
    else if (c == [0, 1]) translate([T / 2, T / 2]) difference() {
        circle(r = T / 2 + THREAD_W / 2, $fn = 180);
        circle(r = T / 2 - THREAD_W / 2, $fn = 180);
    }
}

module thread_shape(sides) {
    c = canon(sides);
    rotate(-90 * find_rot(sides, c)) thread_canonical(c);
}

// ---------------------------------------------------------------- ribbons
// A ribbon's centre line is a list of [point, envelope, s] (s = length along it). It leaves
// each tile edge straight and centred for RIBBON_STEM, then swings sideways by A (half a wave
// or a whole wave, k = 1 / 2; curves always half), fading in and out over RIBBON_FADE. Dead ends
// swing half a wave, less far (RIBBON_A_DEAD), and end straight in the centre.
function ribbon_env(s, L) = smooth((s - RIBBON_STEM) / RIBBON_FADE) * smooth((L - s - RIBBON_STEM) / RIBBON_FADE);

function ribbon_canon(c, A, k) =
    c == [1, 3] ? let(L = T, N = 60)
        [for (i = [0:N]) let(s = L * i / N, e = ribbon_env(s, L)) [[-H + s, A * e * sin(180 * k * s / L)], e, s]] :
    c == [0, 1] ? let(L = H * PI / 2, N = 48)
        [for (i = [0:N]) let(s = L * i / N, e = ribbon_env(s, L), t = 180 + 90 * i / N,
                             r = H + A * e * sin(180 * k * s / L)) [[H + r * cos(t), H + r * sin(t)], e, s]] :
    let(L = H, N = 30)
        [for (i = [0:N]) let(s = L * i / N, e = ribbon_env(s, L)) [[A * e * sin(180 * s / L), H - s], e, s]];

function ribbon_path(f, A, k) = let(c = canon(f_sides(f)), r = find_rot(f_sides(f), c))
    [for (q = ribbon_canon(c, A, k)) [rot_cw(q[0], r), q[1], q[2]]];

// does a ribbon keep clear of carpets (except one it leaves through a city gate), the bowl,
// the tile edge and the ribbons placed before it?
function ribbon_ok(P, f, carpets, bowl, prev) = let(
    m    = THREAD_W / 2 + RIBBON_CLEAR,
    cps  = [for (c = carpets) if (len([for (sd = f_sides(f)) if (has(f_sides(c), sd)) 1]) == 0) carpet_pts(c)],
    free = [for (q = P) if (q[1] > 0.01) q[0]],
    near = [for (Q = prev) for (q = Q) if (q[1] > 0.01 || norm(q[0]) > 8) q[0]],
    bad  = [for (p = free) if (
              max(abs(p[0]), abs(p[1])) > H - m
           || len([for (C = cps) if (inside(p, C) || poly_dist(p, C) < m) 1]) > 0
           || (bowl && len(f_sides(f)) == 2 && norm(p) < art_width("bowl") / 2 + m)
           || len([for (q = near) if (norm(q - p) < THREAD_W + RIBBON_CLEAR) 1]) > 0) 1]
) len(bad) == 0;

// centre lines of all ribbons of a tile, placed one after another; each takes the largest of
// RIBBON_A x [1, 2/3, 1/3, 0] that keeps clear. Result: [[path, twist position or -1], ...]
function ribbon_paths(threads, carpets, bowl, seed, i = 0, acc = []) = i >= len(threads) ? acc : let(
    f  = threads[i],
    r  = rands(0, 1, 4, seed * 7 + i),
    k  = r[0] < 0.5 || canon(f_sides(f)) != [1, 3] ? 1 : 2,
    Am = RIBBON_A * (len(f_sides(f)) == 1 ? RIBBON_A_DEAD : 1),
    sg = r[1] < 0.5 ? -1 : 1,
    prev = [for (j = [0:1:len(acc) - 1]) if (!has_flag(f, "bridge") && !has_flag(threads[j], "bridge")) acc[j][0]],
    ok = [for (a = [1, 2 / 3, 1 / 3]) if (ribbon_ok(ribbon_path(f, sg * a * Am, k), f, carpets, bowl, prev)) a],
    P  = ribbon_path(f, len(ok) > 0 ? sg * ok[0] * Am : 0, k),
    L  = P[len(P) - 1][2],
    tw = has_flag(f, "twist") || r[2] < TWIST_P ? L * (0.35 + 0.3 * r[3]) : -1
) ribbon_paths(threads, carpets, bowl, seed, i + 1, concat(acc, [[P, tw]]));

// half-width along the ribbon, narrowing to TWIST_W at a twist (an hourglass)
function ribbon_hw(s, tw) = let(x = tw < 0 ? 1 : abs(s - tw) / (TWIST_L / 2))
    (x >= 1 ? THREAD_W : TWIST_W + (THREAD_W - TWIST_W) * smooth(x)) / 2;

module ribbon_shape(P, tw = -1) {
    m = len(P);
    N = [for (k = [0:m - 1]) let(t = P[min(m - 1, k + 1)][0] - P[max(0, k - 1)][0]) [t[1], -t[0]] / norm(t)];
    polygon(concat([for (k = [0:m - 1]) P[k][0] + N[k] * ribbon_hw(P[k][2], tw)],
                   [for (k = [m - 1:-1:0]) P[k][0] - N[k] * ribbon_hw(P[k][2], tw)]));
}

// where an icon sits on a ribbon: partway along it
function ribbon_spot(P, f) = P[round((len(f_sides(f)) == 2 ? (canon(f_sides(f)) == [1, 3] ? 0.3 : 0.5) : 0.55) * (len(P) - 1))][0];

// A dead-end thread that ends in a carpet (no bowl or junction on the tile): straight in
// from its edge for THREAD_STEM, then to the nearest field-facing carpet edge and
// THREAD_SINK beyond it. If a carpet covers the tile centre, it simply runs to the centre.
function inside(p, P) = let(n = len(P)) len([for (i = [0:n - 1]) let(a = P[i], b = P[(i + 1) % n])
    if (((a[1] > p[1]) != (b[1] > p[1])) && (p[0] < (b[0] - a[0]) * (p[1] - a[1]) / (b[1] - a[1]) + a[0])) 1]) % 2 == 1;
function seg_near(p, a, b) = let(ab = b - a, t = max(0, min(1, ((p - a) * ab) / (ab * ab)))) a + ab * t;

function dead_path(f, carpets) = let(
    s  = f_sides(f)[0],
    e  = rot_cw([0, H], s),
    st = rot_cw([0, H - THREAD_STEM], s),
    covered = len([for (c = carpets) if (inside([0, 0], carpet_pts(c))) 1]) > 0
) covered ? [e, [0, 0]] : let(
    cands = [for (c = carpets) let(P = carpet_pts(c), n = len(P))
                for (i = [0:n - 1]) let(a = P[i], b = P[(i + 1) % n]) if (!on_edge(a, b))
                    let(q = seg_near(st, a, b)) [norm(q - st), q]],
    best = min([for (x = cands) x[0]]),
    q = [for (x = cands) if (x[0] == best) x[1]][0]
) best < 0.01 ? [e, st] : [e, st, q + (q - st) / best * THREAD_SINK];

module path_shape(P) {
    for (i = [0:len(P) - 2]) hull() { translate(P[i]) circle(d = THREAD_W); translate(P[i + 1]) circle(d = THREAD_W); }
}

function path_spot(P) = len(P) == 3 ? P[1] + (P[2] - P[1]) * 0.4 : (P[0] + P[1]) / 2;

function thread_spot_canon(c) =
    c == [0]    ? [0, T / 4] :
    c == [0, 1] ? [T / 2, T / 2] - [1, 1] * (T / 2) / sqrt(2) :
    [-T / 4, 0];
function thread_spot(sides) = let(c = canon(sides))
    rot_cw(thread_spot_canon(c), find_rot(sides, c));

// ---------------------------------------------------------------- icons

// `routed` = the carpets that dead-end threads run into (undef if threads are not routed);
// `rib` = this thread's ribbon path (undef for carpets)
function icon_spot(f, name, routed = undef, rib = undef) =
    name == "paw"          ? carpet_paw_spot(f) :
    name == "cattree"      ? [0, 0] :
    f_type(f) == "carpet"  ? carpet_centre(f) :
    f_type(f) == "thread"  ? (routed != undef && len(f_sides(f)) == 1 ? path_spot(dead_path(f, routed))
                             : rib != undef ? ribbon_spot(rib, f) : thread_spot(f_sides(f))) :
    [0, 0];

function art(name) = let(r = [for (e = ART) if (e[0] == name) e]) assert(len(r) > 0, str("no ART entry: ", name)) r[0];
function art_width(name) = art(name)[1];
function art_layers(name) = art(name)[2];

// one colour layer of a picture, centred on the origin
module art_layer(name, i) {
    e = art(name); w = e[1]; layers = e[2]; file = layers[i][1];
    page = len(e) > 3 ? e[3] : undef;
    if (file == undef) art_placeholder(name, i, w);
    else if (len(layers) == 1) resize([w, 0], auto = true) import(file, center = true);
    else {
        assert(page != undef, str("ART '", name, "' has several layers: give its page size [w, h]"));
        scale(w / page[0]) translate(-page / 2) import(file);
    }
}

// ---------------------------------------------------------------- items
// A tile is drawn as items in painter's order (bottom to top):
// item = [colour, kind, feature_or_name, at_or_seed, extra]
//   background (silver) < threads < junction < bridge border + bridge thread
//   < carpets < fringe < border lines < bowl < icons
// `seed` makes the random fringe repeatable: the same tile always looks the same.

function tile_items(t, seed = 0) = let(
    fs      = t_feats(t),
    threads = [for (f = fs) if (f_type(f) == "thread") f],
    normal  = [for (f = threads) if (!has_flag(f, "bridge")) f],
    bridges = [for (f = threads) if (has_flag(f, "bridge")) f],
    carpets = [for (f = fs) if (f_type(f) == "carpet") f],
    nc      = len(carpets),
    bowls   = [for (f = fs) if (f_type(f) == "bowl") f],
    dead    = len([for (f = threads) if (len(f_sides(f)) == 1) 1]),
    junction = dead >= 3 && len(bowls) == 0,
    routed   = dead >= 1 && dead <= 2 && len(bowls) == 0 && nc > 0,
    ribs     = ribbon_paths(threads, carpets, len(bowls) > 0, seed),          // aligned with `threads`
    rib_of   = function (f) ribs[[for (j = [0:len(threads) - 1]) if (threads[j] == f) j][0]]
) concat(
    [["silver", "background", undef, undef, []]],
    [for (f = normal) routed && len(f_sides(f)) == 1
        ? ["thread", "path", dead_path(f, carpets), undef, []]
        : ["thread", "ribbon", rib_of(f)[0], rib_of(f)[1], []]],
    junction ? [for (i = [0:len(art_layers("knot")) - 1]) [art_layers("knot")[i][0], "art", ["knot", i], [0, 0], []]] : [],
    [for (f = bridges) each [["silver", "bridge_gap", rib_of(f)[0], rib_of(f)[1], []],
                             ["thread", "ribbon", rib_of(f)[0], rib_of(f)[1], []]]],
    [for (i = [0:1:nc - 1])
        ["carpet", "carpet", carpets[i], undef, carpets]],
    TASSELS ? [for (i = [0:1:nc - 1])
        ["carpet", "fringe", carpets[i], seed * 8 + i, [[for (j = [0:1:nc - 1]) if (j != i) carpets[j]], threads]]] : [],
    BORDER ? [for (f = carpets) [BORDER_COLOUR, "border", f, undef, carpets]] : [],
    [for (f = bowls) let(p = f_at(f) == undef ? [0, 0] : f_at(f))
        for (i = [0:len(art_layers("bowl")) - 1]) [art_layers("bowl")[i][0], "art", ["bowl", i], p, []]],
    [for (f = fs) for (fl = f_flags(f)) if (!has(SHAPE_FLAGS, fl_name(fl)))
        let(nm = fl_name(fl), at = fl_at(fl) == undef
                ? icon_spot(f, nm, routed ? carpets : undef, f_type(f) == "thread" ? rib_of(f)[0] : undef)
                : fl_at(fl))
        for (i = [0:len(art_layers(nm)) - 1]) [art_layers(nm)[i][0], "art", [nm, i], at, []]]
);

module item_shape(it) {
    kind = it[1];
    intersection() {
        tile_outline();
        if (kind == "background") tile_outline();
        else if (kind == "thread") thread_shape(f_sides(it[2]));
        else if (kind == "path") path_shape(it[2]);
        else if (kind == "ribbon") ribbon_shape(it[2], it[3]);
        else if (kind == "bridge_gap") offset(r = BRIDGE_GAP) ribbon_shape(it[2], it[3]);
        else if (kind == "carpet") difference() {
            carpet_shape(it[2], it[4]);
            for (o = it[4]) if (o != it[2]) offset(r = CARPET_GAP) carpet_shape(o, it[4]);
        }
        else if (kind == "fringe") fringe_shape(it[2], it[3], it[4][0], it[4][1]);
        else if (kind == "border") border_shape(it[2], it[4]);
        else if (kind == "art") translate(it[3]) art_layer(it[2][0], it[2][1]);
    }
}

// the tile outline: a square with rounded corners; clips every colour layer
module tile_outline() {
    if (TILE_R > 0) squarepp(T, center = true, mod_list = [rounding(TILE_R)]);
    else square(T, center = true);
}

// 2D region of one colour: each item minus everything painted above it
module colour_region(t, c, seed = 0) {
    items = tile_items(t, seed);
    n = len(items);
    for (i = [0:1:n - 1]) if (items[i][0] == c) difference() {
        item_shape(items[i]);
        for (j = [i + 1:1:n - 1]) item_shape(items[j]);
    }
}

module tile_layer(t, c, seed = 0) {
    if (c == "silver") linear_extrude(BASE_H) tile_outline();
    translate([0, 0, BASE_H]) linear_extrude(TOP_H) colour_region(t, c, seed);
}

module tile(t, layer = "all", seed = 0) {
    if (layer == "all") for (c = COLOURS) color(kv(PREVIEW_RGB, c)) tile_layer(t, c, seed);
    else tile_layer(t, layer, seed);
}

function tile_colours(t) = let(used = [for (it = tile_items(t)) it[0]])
    [for (c = COLOURS) if (has(used, c)) c];

// ---------------------------------------------------------------- checks

// a side is C if any carpet touches it (a thread may lead out of a city gate), else R or F
function side_code(t, s) = let(ty = [for (f = t_feats(t)) if (has(f_sides(f), s)) f_type(f)])
    has(ty, "carpet") ? "C" : has(ty, "thread") ? "R" : "F";
function tile_edges(t) = str(side_code(t, 0), side_code(t, 1), side_code(t, 2), side_code(t, 3));

function tile_errors(t) = let(
    fs        = t_feats(t),
    claimed   = [for (f = fs) each f_sides(f)],
    c_sides   = [for (f = fs) if (f_type(f) == "carpet") each f_sides(f)],
    t_sides   = [for (f = fs) if (f_type(f) == "thread") each f_sides(f)],
    dup       = [for (s = [0:3]) if (count(c_sides, s) > 1 || count(t_sides, s) > 1) s],
    bad_side  = [for (c = claimed) if (c < 0 || c > 3) c],
    threads   = [for (f = fs) if (f_type(f) == "thread") f],
    bad_thr   = [for (f = threads) if (len(f_sides(f)) < 1 || len(f_sides(f)) > 2) f],
    bad_carp  = [for (f = fs) if (f_type(f) == "carpet" && len(f_sides(f)) < 1) f],
    dead      = len([for (f = threads) if (len(f_sides(f)) == 1) 1]),
    has_bowl  = len([for (f = fs) if (f_type(f) == "bowl") 1]) > 0,
    has_carp  = len([for (f = fs) if (f_type(f) == "carpet") 1]) > 0,
    bad_type  = [for (f = fs) if (!has(["carpet", "thread", "bowl"], f_type(f))) f_type(f)],
    known     = concat([for (e = ART) e[0]], SHAPE_FLAGS),
    bad_flag  = [for (f = fs) for (fl = f_flags(f)) if (!has(known, fl_name(fl))) fl_name(fl)],
    bad_shape = concat(
        [for (f = fs) if ((has_flag(f, "thin") || has_flag(f, "wedge"))
                          && (f_type(f) != "carpet" || len(f_sides(f)) != 1)) f],
        [for (f = fs) if ((has_flag(f, "bridge") || has_flag(f, "twist")) && f_type(f) != "thread") f])
) concat(
    len(dup) > 0      ? [str("side used twice: ", dup)] : [],
    len(bad_side) > 0 ? [str("side out of range: ", bad_side)] : [],
    len(bad_thr) > 0  ? ["a thread must touch 1 or 2 sides (split crossings)"] : [],
    len(bad_carp) > 0 ? ["a carpet needs at least one side"] : [],
    (dead > 0 && dead < 3 && !has_bowl && !has_carp) ? ["dead-end thread with nothing to end at"] : [],
    len(bad_type) > 0 ? [str("unknown feature type: ", bad_type)] : [],
    len(bad_flag) > 0 ? [str("unknown flag: ", bad_flag)] : [],
    len(bad_shape) > 0 ? ["thin/wedge need a one-side carpet, bridge/twist need a thread"] : []
);

module run_checks() {
    for (i = [0:len(TILES) - 1]) {
        t = TILES[i];
        e = tile_errors(t);
        echo(str(i, "  ", t_name(t), "  x", t_count(t), "  ", t_set(t), "  ", tile_edges(t),
                 len(e) > 0 ? str("  ERROR: ", e) : ""));
    }
    for (s = EXPECTED) {
        have = sum([for (t = TILES) if (t_set(t) == s[0]) t_count(t)]);
        echo(str(s[0], ": ", have, " / ", s[1], have == s[1] ? "  ok" : "  MISMATCH"));
    }
    errors = sum([for (t = TILES) len(tile_errors(t))]);
    assert(errors == 0, str(errors, " tile error(s), see above"));
}

module run_list() {   // one line per export job, parsed by export.sh
    for (i = [0:len(TILES) - 1]) for (c = tile_colours(TILES[i]))
        echo("JOB", i, t_name(TILES[i]), t_count(TILES[i]), c);
}

module run_preview(cols = 8) {
    for (i = [0:len(TILES) - 1])
        translate([(i % cols) * (T + 8), -floor(i / cols) * (T + 14), 0]) {
            tile(TILES[i], "all", i);
            color("black") translate([0, -T / 2 - 8]) linear_extrude(0.4)
                text(str(t_name(TILES[i]), "  x", t_count(TILES[i])), size = 4, halign = "center");
        }
}

// ---------------------------------------------------------------- main

// every ART picture, ART_ZOOM times enlarged, its layers stacked in their colours,
// with a frame showing the picture's width on the tile
ART_ZOOM = 5;
module run_art() {
    for (n = [0:len(ART) - 1]) {
        name = ART[n][0]; w = art_width(name); L = art_layers(name);
        translate([n * 25 * ART_ZOOM, 0, 0]) scale([ART_ZOOM, ART_ZOOM, 1]) {
            for (i = [0:len(L) - 1])
                color(kv(PREVIEW_RGB, L[i][0])) translate([0, 0, 0.2 * i]) linear_extrude(0.2) art_layer(name, i);
            color("#b8b8b8") translate([0, 0, -0.2]) linear_extrude(0.1)
                difference() { square(w + 1, center = true); square(w + 0.6, center = true); }
            color("black") translate([0, -w / 2 - 3, 0]) linear_extrude(0.1)
                text(str(name, "  ", w, " mm", L[0][1] == undef ? "  (placeholder)" : ""), size = 1, halign = "center");
        }
    }
}

if (MODE == "preview") run_preview();
else if (MODE == "tile") tile(TILES[TILE_INDEX], LAYER, TILE_INDEX);
else if (MODE == "check") run_checks();
else if (MODE == "list") run_list();
else if (MODE == "art") run_art();
