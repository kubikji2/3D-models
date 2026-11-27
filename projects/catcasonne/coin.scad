// Catcassonne 50/100 lap coin (6 needed, one per player at most)
//
// Double-sided: a lilac paw (the paw picture from art.scad) with a black "50" over it on one
// face, the same with "100" on the other. In cross-section (XZ) the lilac body is an H: a rim
// running top to bottom plus a core in the middle, so the rim can't fall off; the face layers
// fill the pockets above and below the core. The paws are part of the body too, rising
// through the face layers; the black numbers sit on the core.
//
//    rim |  50 face  (silver, lilac paw, black "50")             | rim    FACE_H
//    rim |                 core                                   | rim    CORE_H
//    rim |  100 face (gold, lilac paw, black "100", mirrored)     | rim    FACE_H
//
//   openscad coin.scad                                              preview (both faces)
//   for c in carpet silver thread black; do
//       openscad -o coin_$c.stl -D "LAYER=\"$c\"" coin.scad; done      one STL per colour

include <art.scad>                   // for the paw picture
include <art_placeholders.scad>

/* [Export] */
LAYER = "all";              // "all" (preview) or "carpet" / "silver" / "thread" / "black"

/* [Coin] */
SHAPE  = "round";           // "round" or "paw" (the whole coin shaped like a paw)
COIN_W = 30;                // width of the coin
FACE_H = 0.6;               // each face (3 x 0.2 mm)
CORE_H = 0.6;               // core (3 x 0.2 mm)
RIM_W  = 1.2;               // rim width (seen from above)

/* [Numbers and paw] */
TOP_TEXT    = "50";
BOTTOM_TEXT = "100";
NUM_SIZE    = 7;
NUM_FONT    = "Liberation Sans:style=Bold";
NUM_Y       = -2;           // number centre (round coin), + = up; -3 puts it on the paw's pad
PAW         = true;         // a paw in the middle of each face, under the number
PAW_W       = 22;           // paw width
PAW_Y       = 2;            // paw centre (round coin)

/* [Colours] */
BODY_COLOUR   = "carpet";   // rim, core and paws
TEXT_COLOUR   = "black";    // the numbers
TOP_COLOUR    = "silver";   // the 50 face
BOTTOM_COLOUR = "thread";   // the 100 face (gold)
PREVIEW_RGB   = [["silver", "#b8b8b8"], ["carpet", "#b48ad8"], ["thread", "#e6b422"],
                 ["black", "#222222"], ["white", "#f4f4f4"]];

/* [Hidden] */
$fn = 64;
H_TOTAL = 2 * FACE_H + CORE_H;
s = COIN_W;
PAD_C = [0, -0.15 * s];                                     // where the numbers sit (paw: on the pad)
TOES  = [for (a = [-64, -22, 22, 64]) [0.36 * s * sin(a), -0.06 * s + 0.36 * s * cos(a)]];

function kv(table, key) = [for (e = table) if (e[0] == key) e[1]][0];

// ---------------------------------------------------------------- outline
// paw: a big pad and four toes close to it, each joined to the pad by a short neck; the
// space between neighbouring toes and the pad is filled (no enclosed slits), the notches
// between the toes stay
module paw_outline() {
    translate(PAD_C) scale([1, 0.82]) circle(d = 0.64 * s);
    for (toe = TOES) {
        translate(toe) circle(d = 0.27 * s);
        hull() { translate(toe) circle(d = 0.18 * s); translate(PAD_C + (toe - PAD_C) * 0.5) circle(d = 0.18 * s); }
    }
    for (i = [0:2]) polygon([PAD_C, TOES[i], TOES[i + 1]]);
}

module outline() {
    if (SHAPE == "paw") paw_outline();
    else circle(d = s);
}

module inner() { offset(delta = -RIM_W) outline(); }

module paw_picture() {
    file = [for (e = ART) if (e[0] == "paw") e[2][0][1]][0];
    if (file == undef) ph_paw(PAW_W);
    else resize([PAW_W, 0], auto = true) import(file, center = true);
}

// what is printed on a face, as 2D, mirrored for the bottom face so it reads when flipped
module num_mark(txt, mirrored = false) {
    intersection() {
        inner();
        mirror([mirrored ? 1 : 0, 0]) translate(SHAPE == "paw" ? PAD_C : [0, NUM_Y])
            text(txt, size = NUM_SIZE, font = NUM_FONT, halign = "center", valign = "center");
    }
}

module paw_mark(mirrored = false) {
    if (PAW && SHAPE != "paw") intersection() {
        inner();
        mirror([mirrored ? 1 : 0, 0]) translate([0, PAW_Y]) paw_picture();
    }
}

// ---------------------------------------------------------------- bodies
module body() {        // the H: rim + core, plus both paws (where no number covers them)
    linear_extrude(H_TOTAL) difference() { outline(); inner(); }
    translate([0, 0, FACE_H]) linear_extrude(CORE_H) inner();
    translate([0, 0, FACE_H + CORE_H]) linear_extrude(FACE_H) difference() { paw_mark(); num_mark(TOP_TEXT); }
    linear_extrude(FACE_H) difference() { paw_mark(true); num_mark(BOTTOM_TEXT, true); }
}

module numbers() {
    translate([0, 0, FACE_H + CORE_H]) linear_extrude(FACE_H) num_mark(TOP_TEXT);
    linear_extrude(FACE_H) num_mark(BOTTOM_TEXT, true);
}

module top_face()    { translate([0, 0, FACE_H + CORE_H]) linear_extrude(FACE_H)
                           difference() { inner(); paw_mark(); num_mark(TOP_TEXT); } }
module bottom_face() { linear_extrude(FACE_H) difference() { inner(); paw_mark(true); num_mark(BOTTOM_TEXT, true); } }

module coin_layer(c) {
    if (c == BODY_COLOUR) body();
    if (c == TEXT_COLOUR) numbers();
    if (c == TOP_COLOUR) top_face();
    if (c == BOTTOM_COLOUR) bottom_face();
}

// ---------------------------------------------------------------- main
if (LAYER == "all") {
    for (c = [BODY_COLOUR, TEXT_COLOUR, TOP_COLOUR, BOTTOM_COLOUR]) color(kv(PREVIEW_RGB, c)) coin_layer(c);
    // the same coin flipped over, to see the 100 side
    translate([COIN_W * 1.3, 0, H_TOTAL]) mirror([0, 0, 1]) mirror([1, 0, 0])
        for (c = [BODY_COLOUR, TEXT_COLOUR, TOP_COLOUR, BOTTOM_COLOUR]) color(kv(PREVIEW_RGB, c)) coin_layer(c);
} else coin_layer(LAYER);