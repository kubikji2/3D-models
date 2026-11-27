// Catcassonne score track (OpenSCAD 2021.01)
//
// Laid out like the original board: 50 numbers placed where the original has them,
// each owning the Voronoi cell around its point (the area closer to it than to any
// other number). Carpet cells (lilac, with a gold line inside) lie on the silver floor;
// black walls separate touching cells that are not next to each other on the path, and a
// white seam separates two floor cells that are (only happens with CARPET_EVERY > 2). With BLEED the cells run off the board edge, as if
// the floor continued; the gold line then stays open there, like on the tiles.
//
//   openscad score_track.scad                                           coloured preview
//   for c in silver carpet thread black white; do
//       openscad -o score_$c.stl -D "LAYER=\"$c\"" score_track.scad; done   one STL per colour

use <../../lib/solidpp/solidpp.scad>
include <art.scad>                   // for the paw and bowl pictures
include <art_placeholders.scad>

/* [Export] */
LAYER = "all";              // "all" (coloured preview) or one name from COLOURS

/* [Board, mm] */
BOARD   = [297, 210];       // outer size = box inner size minus 2 x clearance (A4 here)
BOARD_R = 3;                // rounding of the board corners
BLEED   = true;             // cells run off the board edge (false = silver frame of MARGIN around them)
MARGIN  = 4;                // frame width without BLEED; with BLEED the numbers still keep this inset
BASE_H  = 2.4;              // silver base slab
TOP_H   = 0.6;              // colour layer

/* [Cells] */
CARPET_EVERY = 2;           // carpet on multiples of this (2 = every other cell, 5 = like the original)
GROUT_W = 1.2;              // silver gap between a carpet and its neighbours; also the seam width
CELL_R  = 1.5;              // rounding of the cell corners (0 = sharp)
LLOYD   = 1;                // smoothing passes: each moves every point to its cell's centre (0 = as placed)
WALL_W  = 1.6;              // wall between touching cells that are not next to each other on the path
WALL_EXT = 3;               // a wall ending at a carpet continues this far under it, so it meets the carpet

/* [Carpet cells] */
CELL_BORDER_IN = 1.5;       // gold line this far inside the carpet edge (0 = at the edge)
CELL_BORDER_W  = 1;         // gold line width
CELL_BORDER_EDGE = true;    // the gold line also runs along the board edge (closed); false = open there
CELL_BORDER_R  = 2;         // corner radius of the gold line (outer edge; inner edge = this - width)

/* [Numbers] */
NUM_SIZE = 9;
NUM_FONT = "Liberation Sans:style=Bold";
NUM_Y    = 0;               // shift of the numbers from their cell centres (+ = up)

/* [Paw trail] */
TRAIL        = true;        // a cat walked across the board, ignoring the walls
TRAIL_FROM   = 0;           // starts at the centre of this cell...
TRAIL_TO     = 13;          // ...and ends at the centre of this one (or at the bowl, if BOWL)
TRAIL_BEND   = 0.15;        // sideways bow of the path (fraction of its length, +/- = side)
TRAIL_STEP   = 12;          // distance between prints along the path
TRAIL_GAIT   = 3;           // prints alternate this far left / right of the path
TRAIL_SIZE   = 6;           // paw print width
TRAIL_JITTER = 10;          // random turn of each print (degrees, seeded)
TRAIL_SEED   = 7;
TRAIL_CLEAR  = 9;           // no print closer than this to a number

/* [Bowl] */
BOWL       = true;          // a food bowl in the corner above number BOWL_CELL; the cat walks to it
BOWL_CELL  = 13;
BOWL_ABOVE = 15;            // bowl centre this far above the number
BOWL_W     = 16;            // bowl width
BOWL_CLEAR = 2;             // paw prints keep this far from the bowl

/* [Colours] */
COLOURS       = ["silver", "carpet", "thread", "black", "white"];   // the 5 toolheads
SEAM_COLOUR   = "white";
WALL_COLOUR   = "black";
PAW_COLOUR    = "white";
BORDER_COLOUR = "thread";
FLOOR_NUM     = "black";
CARPET_NUM    = "white";
PREVIEW_RGB   = [["silver", "#b8b8b8"], ["carpet", "#b48ad8"], ["thread", "#e6b422"],
                 ["black", "#222222"], ["white", "#f4f4f4"]];

/* [Hidden] */
$fn = 24;

// where each number sits, as [u, v] across the track area: u from the left, v from the top (0..1);
// read off the original board, so they stretch with BOARD
SITES = [
    [0.835, 0.720], [0.738, 0.734], [0.643, 0.734], [0.550, 0.747], [0.455, 0.747],   // 0-4
    [0.371, 0.754], [0.283, 0.764], [0.188, 0.806], [0.127, 0.745], [0.111, 0.638],   // 5-9
    [0.105, 0.559], [0.093, 0.410], [0.098, 0.296], [0.112, 0.208], [0.160, 0.153],   // 10-14
    [0.234, 0.149], [0.307, 0.131], [0.384, 0.142], [0.459, 0.142], [0.533, 0.142],   // 15-19
    [0.598, 0.150], [0.678, 0.127], [0.755, 0.120], [0.822, 0.127], [0.859, 0.127],   // 20-24
    [0.896, 0.194], [0.884, 0.255], [0.850, 0.331], [0.767, 0.340], [0.700, 0.354],   // 25-29
    [0.633, 0.361], [0.557, 0.361], [0.488, 0.361], [0.414, 0.358], [0.357, 0.358],   // 30-34
    [0.305, 0.354], [0.257, 0.385], [0.241, 0.444], [0.217, 0.571], [0.290, 0.598],   // 35-39
    [0.369, 0.613], [0.431, 0.598], [0.508, 0.578], [0.578, 0.578], [0.654, 0.578],   // 40-44
    [0.726, 0.578], [0.790, 0.566], [0.852, 0.542], [0.900, 0.583], [0.887, 0.630]   // 45-49
];

// ---------------------------------------------------------------- helpers
function kv(table, key) = [for (e = table) if (e[0] == key) e[1]][0];
function vsum(l, i = 0) = i >= len(l) ? [0, 0] : l[i] + vsum(l, i + 1);
function ssum(l, i = 0) = i >= len(l) ? 0 : l[i] + ssum(l, i + 1);

// ---------------------------------------------------------------- Voronoi cells
IW = BOARD[0] - 2 * MARGIN;        // track area (where SITES are spread)
IH = BOARD[1] - 2 * MARGIN;
function rect_pts(w, h) = [[-w / 2, -h / 2], [w / 2, -h / 2], [w / 2, h / 2], [-w / 2, h / 2]];
EXT  = CELL_R + GROUT_W + 1;       // with BLEED, cells reach this far past the board edge
AREA = BLEED ? rect_pts(BOARD[0] + 2 * EXT, BOARD[1] + 2 * EXT) : rect_pts(IW, IH);

function site_xy(s) = [-IW / 2 + s[0] * IW, IH / 2 - s[1] * IH];

// keep the part of convex polygon P where (p - m) . n <= 0 (Sutherland-Hodgman, one edge)
function clip_hp(P, m, n) = len(P) == 0 ? [] : let(L = len(P))
    [for (i = [0:L - 1]) let(a = P[i], b = P[(i + 1) % L], da = (a - m) * n, db = (b - m) * n)
        each concat(da <= 0 ? [a] : [], (da <= 0) != (db <= 0) ? [a + (b - a) * (da / (da - db))] : [])];

// cell of site i: the track area cut by the bisector with every other site
function vcell(S, i, P = AREA, j = 0) = j >= len(S) ? P
    : vcell(S, i, j == i ? P : clip_hp(P, (S[i] + S[j]) / 2, S[j] - S[i]), j + 1);

function centroid(P) = let(
    n = len(P),
    cr = [for (i = [0:n - 1]) let(a = P[i], b = P[(i + 1) % n]) a[0] * b[1] - b[0] * a[1]],
    A = ssum(cr) / 2
) vsum([for (i = [0:n - 1]) (P[i] + P[(i + 1) % n]) * cr[i]]) / (6 * A);

function relax(S, n) = n <= 0 ? S : relax([for (i = [0:len(S) - 1]) centroid(vcell(S, i))], n - 1);

PTS   = relax([for (s = SITES) site_xy(s)], LLOYD);
CELLS = [for (i = [0:len(PTS) - 1]) vcell(PTS, i)];
// the visible part of each cell (inside the board), for placing the numbers
function clip_rect(P, w, h) = clip_hp(clip_hp(clip_hp(clip_hp(P, [w / 2, 0], [1, 0]), [-w / 2, 0], [-1, 0]),
                                      [0, h / 2], [0, 1]), [0, -h / 2], [0, -1]);
SEEN  = [for (c = CELLS) clip_rect(c, BOARD[0], BOARD[1])];
assert(len(PTS) == 50, str("SITES has ", len(PTS), " points, needs 50"));

function is_carpet(k) = k % CARPET_EVERY == 0;

// walls: the shared edge of every two touching cells that are not consecutive on the path
// (49 -> 0 counts as consecutive: the track is a loop)
function consecutive(i, j) = j - i == 1 || (i == 0 && j == 49);
function shared_edge(i, j) = let(
    m = (PTS[i] + PTS[j]) / 2, n = (PTS[j] - PTS[i]) / norm(PTS[j] - PTS[i]),
    on = [for (p = CELLS[i]) if (abs((p - m) * n) < 1e-4) p]
) len(on) >= 2 ? [on[0], on[len(on) - 1]] : [];
// cells other than i and j that have p as a corner
function corner_cells(p, i, j) = [for (k = [0:49]) if (k != i && k != j && len([for (q = CELLS[k]) if (norm(q - p) < 1e-3) 1]) > 0) k];
function touches_carpet(p, i, j) = len([for (k = corner_cells(p, i, j)) if (is_carpet(k)) 1]) > 0;
// extend a wall end that meets a carpet corner; walls are drawn under the carpets
function wall_ends(e, i, j) = let(d = (e[1] - e[0]) / norm(e[1] - e[0]))
    [touches_carpet(e[0], i, j) ? e[0] - d * WALL_EXT : e[0], touches_carpet(e[1], i, j) ? e[1] + d * WALL_EXT : e[1]];
WALLS = [for (i = [0:48]) for (j = [i + 1:49]) if (!consecutive(i, j))
            let(e = shared_edge(i, j)) if (len(e) == 2 && norm(e[1] - e[0]) > 0.5) wall_ends(e, i, j)];
// seams: consecutive floor cells would otherwise merge into one
SEAMS = [for (i = [0:48]) for (j = [i + 1:49]) if (consecutive(i, j) && !is_carpet(i) && !is_carpet(j))
            let(e = shared_edge(i, j)) if (len(e) == 2 && norm(e[1] - e[0]) > 0.5) e];

// cell k shrunk by `inset`, corners rounded by CELL_R (the cells are convex, so offsets are cheap)
module cell_shape(k, inset = 0) {
    if (CELL_R > 0) offset(r = CELL_R) offset(delta = -(inset + CELL_R)) polygon(CELLS[k]);
    else offset(delta = -inset) polygon(CELLS[k]);
}

// gold line CELL_BORDER_IN inside the carpet edge, with rounded corners. With CELL_BORDER_EDGE
// it also runs along the board edge (a closed ring); without it, the carpet shape reaches past
// the board, so the line stays open where the carpet runs off.
module carpet_region(k) {
    if (CELL_BORDER_EDGE) intersection() { cell_shape(k, GROUT_W / 2); board_outline(); }
    else cell_shape(k, GROUT_W / 2);
}

module border_outer(k) {       // outer edge of the line: the carpet shrunk by CELL_BORDER_IN, rounded
    offset(r = CELL_BORDER_R) offset(delta = -(CELL_BORDER_IN + CELL_BORDER_R)) carpet_region(k);
}

module border_shape(k) {
    difference() {
        border_outer(k);
        offset(r = -CELL_BORDER_W) border_outer(k);
    }
}

module board_outline() {
    if (BOARD_R > 0) squarepp(BOARD, center = true, mod_list = [rounding(BOARD_R)]);
    else square(BOARD, center = true);
}

// ---------------------------------------------------------------- paw trail
NUM_AT = [for (k = [0:49]) centroid(SEEN[k]) + [0, NUM_Y]];

function bez2(a, b, c, t) = a * (1 - t) * (1 - t) + b * 2 * (1 - t) * t + c * t * t;
// the bowl: above its number, kept inside the board
BOWL_POS = let(p = centroid(SEEN[BOWL_CELL]) + [0, NUM_Y + BOWL_ABOVE])
    [p[0], min(p[1], BOARD[1] / 2 - BOWL_W / 2 - 2)];
BOWL_ART = [for (e = ART) if (e[0] == "bowl") e][0];

TRAIL_A = centroid(SEEN[TRAIL_FROM]);
TRAIL_B = BOWL ? BOWL_POS : centroid(SEEN[TRAIL_TO]);
TRAIL_D = TRAIL_B - TRAIL_A;
TRAIL_C = (TRAIL_A + TRAIL_B) / 2 + [-TRAIL_D[1], TRAIL_D[0]] * TRAIL_BEND;    // control point
TRAIL_N = 200;
TRAIL_PTS = [for (i = [0:TRAIL_N]) bez2(TRAIL_A, TRAIL_C, TRAIL_B, i / TRAIL_N)];
function cumlen(P, i = 1, acc = [0]) = i >= len(P) ? acc : cumlen(P, i + 1, concat(acc, [acc[i - 1] + norm(P[i] - P[i - 1])]));
TRAIL_LEN = cumlen(TRAIL_PTS);
// print k: [position, direction angle]
function trail_print(k) = let(
    d  = TRAIL_STEP * (k + 0.5),
    i  = max(1, [for (j = [0:TRAIL_N]) if (TRAIL_LEN[j] >= d) j][0]),
    p  = TRAIL_PTS[i], t = (TRAIL_PTS[i] - TRAIL_PTS[i - 1]) / norm(TRAIL_PTS[i] - TRAIL_PTS[i - 1]),
    side = k % 2 == 0 ? 1 : -1,
    j  = rands(-TRAIL_JITTER, TRAIL_JITTER, 1, TRAIL_SEED * 100 + k)[0]
) [p + [-t[1], t[0]] * TRAIL_GAIT * side, atan2(t[1], t[0]) - 90 + j];
TRAIL_COUNT = floor(TRAIL_LEN[TRAIL_N] / TRAIL_STEP);
PRINTS = [for (k = [0:TRAIL_COUNT - 1]) let(pr = trail_print(k))
             if (min([for (q = NUM_AT) norm(q - pr[0])]) >= TRAIL_CLEAR
                 && (!BOWL || norm(pr[0] - BOWL_POS) >= BOWL_W / 2 + TRAIL_SIZE / 2 + BOWL_CLEAR)) pr];

// one colour layer of the bowl picture (from art.scad), centred on the origin, BOWL_W wide
module bowl_layer(i) {
    file = BOWL_ART[2][i][1];
    if (file == undef) ph_bowl(BOWL_W, i);
    else if (len(BOWL_ART[2]) == 1) resize([BOWL_W, 0], auto = true) import(file, center = true);
    else scale(BOWL_W / BOWL_ART[3][0]) translate(-BOWL_ART[3] / 2) import(file);
}

module paw_print() {
    file = [for (e = ART) if (e[0] == "paw") e[2][0][1]][0];
    if (file == undef) ph_paw(TRAIL_SIZE);
    else resize([TRAIL_SIZE, 0], auto = true) import(file, center = true);
}

// ---------------------------------------------------------------- items
// painter's order (bottom to top): background (floor) < seams < walls < carpets < gold lines
//                                   < paw trail < bowl < numbers
// item = [colour, kind, cell, extra]  (cell -1 = board-wide; extra = bowl layer)
ITEMS = concat(
    [["silver", "background", -1], [SEAM_COLOUR, "seams", -1], [WALL_COLOUR, "walls", -1]],
    [for (k = [0:49]) if (is_carpet(k)) ["carpet", "carpet", k]],
    [for (k = [0:49]) if (is_carpet(k)) [BORDER_COLOUR, "border", k]],
    TRAIL ? [[PAW_COLOUR, "paws", -1]] : [],
    BOWL ? [for (i = [0:len(BOWL_ART[2]) - 1]) [BOWL_ART[2][i][0], "bowl", -1, i]] : [],
    [for (k = [0:49]) [is_carpet(k) ? CARPET_NUM : FLOOR_NUM, "number", k]]
);

module item_shape(it) {
    kind = it[1]; k = it[2];
    intersection() {
        board_outline();
        if (kind == "background") board_outline();
        else if (kind == "seams") for (e = SEAMS)
            hull() { translate(e[0]) circle(d = GROUT_W); translate(e[1]) circle(d = GROUT_W); }
        else if (kind == "carpet") cell_shape(k, GROUT_W / 2);
        else if (kind == "border") border_shape(k);
        else if (kind == "walls") for (e = WALLS)
            hull() { translate(e[0]) circle(d = WALL_W); translate(e[1]) circle(d = WALL_W); }
        else if (kind == "paws") for (pr = PRINTS) translate(pr[0]) rotate(pr[1]) paw_print();
        else if (kind == "bowl") translate(BOWL_POS) bowl_layer(it[3]);
        else if (kind == "number") translate(NUM_AT[k])
            text(str(k), size = NUM_SIZE, font = NUM_FONT, halign = "center", valign = "center");
    }
}

// each item minus what is painted above it; cells don't overlap, so a cell's item only
// needs the later items of the same cell and the board-wide ones (cell -1) subtracted
module colour_region(c) {
    n = len(ITEMS);
    for (i = [0:n - 1]) if (ITEMS[i][0] == c) difference() {
        item_shape(ITEMS[i]);
        for (j = [i + 1:1:n - 1]) if (ITEMS[i][2] < 0 || ITEMS[j][2] < 0 || ITEMS[j][2] == ITEMS[i][2])
            item_shape(ITEMS[j]);
    }
}

module board_layer(c) {
    if (c == "silver") linear_extrude(BASE_H) board_outline();
    translate([0, 0, BASE_H]) linear_extrude(TOP_H) colour_region(c);
}

// ---------------------------------------------------------------- main
if (LAYER == "all") for (c = COLOURS) color(kv(PREVIEW_RGB, c)) board_layer(c);
else board_layer(LAYER);