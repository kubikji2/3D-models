// Catcassonne placeholder pictures
//
// Drawn when an ART entry in catcassonne.scad has no SVG file (undef).
// Every module draws its picture in 2D, `s` mm wide, centred on the origin.
// Pictures with several colour layers also get the layer index `i` (0 = bottom).
//
// See them all enlarged, in their colours:
//   openscad -D 'MODE="art"' catcassonne.scad      (or set MODE = "art" in the Customizer)
//
// Keep details >= 1 mm at the final size: with s = 8, a factor of 0.13 is 1.04 mm.

use<../../lib/solidpp/solidpp.scad>

module art_placeholder(name, i, s) {
    if      (name == "paw")     ph_paw(s);
    else if (name == "fish")    ph_fish(s);
    else if (name == "feather") ph_feather(s);
    else if (name == "mouse")   ph_mouse(s);
    else if (name == "bell")    ph_bell(s);
    else if (name == "cattree") ph_cattree(s);
    else if (name == "bowl")    ph_bowl(s, i);
    else if (name == "knot")    ph_knot(s);
    else square(s, center = true);              // unknown name: a plain square
}

// ---------------------------------------------------------------- bell (inn)
// A jingle bell seen from the side: a ball with a slot across it, a sound hole
// below the slot, and a loop on top that holds it on the ribbon.
BELL_SLOT_W = 0.1;     // slot width            (fraction of s)
BELL_SLOT_L = 0.72;     // slot length
BELL_SLOT_Y = -0.02;    // slot centre height
BELL_HOLE_D = 0.2;     // sound hole diameter
BELL_HOLE_Y = -0.15;    // sound hole centre height
//BELL_HOLE_X = -0.30;    // sound hole centre height
BELL_LOOP   = true;     // loop on top
BELL_LOOP_D = 0.34;     // loop outer diameter
BELL_LOOP_T = 0.10;     // loop wall thickness
BELL_LOOP_Y = 0.52;     // loop centre height

module ph_bell(s) {
    difference() {
        union() {
            circle(d = s);
            squarepp([(1+1.5*BELL_SLOT_W)*s,BELL_SLOT_W*s], mod_list=[rounding(BELL_SLOT_W*s/2)], align="");
            if (BELL_LOOP) translate([0, BELL_LOOP_Y * s]) circle(d = BELL_LOOP_D * s);

        }
        //translate([-BELL_SLOT_L * s / 2, (BELL_SLOT_Y - BELL_SLOT_W / 2) * s])
        translate([0, BELL_HOLE_Y*s]) 
            squarepp([BELL_SLOT_W * s, BELL_SLOT_L * s], align="Y");
        translate([0, BELL_HOLE_Y * s]) circle(d = BELL_HOLE_D * s);
        if (BELL_LOOP) translate([0, BELL_LOOP_Y * s]) circle(d = (BELL_LOOP_D - 2 * BELL_LOOP_T) * s);
    }
}

// ---------------------------------------------------------------- paw (shield)
module ph_paw(s) {
    translate([0, -0.18 * s]) scale([1, 0.8]) circle(d = 0.5 * s);             // pad
    for (a = [-66, -22, 22, 66])                                                // toes
        translate([0.38 * s * sin(a), -0.1 * s + 0.38 * s * cos(a)]) circle(d = 0.18 * s);
}

// ---------------------------------------------------------------- goods
module ph_fish(s) {
    translate([0.1 * s, 0]) scale([1, 0.5]) circle(d = 0.75 * s);              // body
    polygon([[-0.2 * s, 0], [-0.5 * s, 0.22 * s], [-0.5 * s, -0.22 * s]]);     // tail
}

module ph_feather(s) {
    rotate(30) scale([0.25, 1]) circle(d = s);
}

module ph_mouse(s) {
    hull()
    {
        scale([1, 0.5]) circle(d = 0.75 * s);           // body
        translate([0.45*s,-0.05*s]) circle(d=0.05*s);        // nose
    }
    translate([0.2 * s, 0.2 * s]) circle(d = 0.2 * s);                        // ear
    translate([0, 0]) squarepp([0.6 * s, 0.08 * s],align="X");              // tail
}

// ---------------------------------------------------------------- cat tree (cathedral)
module ph_cattree(s) {
    translate([-0.08 * s, -0.5 * s]) square([0.16 * s, s]);                    // trunk
    for (y = [-0.5, -0.1, 0.3]) translate([-0.3 * s, y * s]) square([0.6 * s, 0.12 * s]);
}

// ---------------------------------------------------------------- bowl (monastery)
module ph_bowl(s, i) {
    circle(d = i == 0 ? s : 0.72 * s);         // layer 0: rim, layer 1: food
}

// ---------------------------------------------------------------- knot (junction)
module ph_knot(s) {

    circlepp(d=s, fn=8);
    //ringpp(D = s, d=0.7*s, $fn=8);
}
