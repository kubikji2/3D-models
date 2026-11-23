// Catcassonne artwork: every picture on the tiles, one entry each:
//   [name, width, layers, page]
//   width  : width of the picture on the tile (mm)
//   layers : [[colour, svg], ...] painted in this order (later on top); svg = undef draws
//            the placeholder from art_placeholders.scad, so pictures can be swapped in one by one
//   page   : only for pictures with more than one layer: the SVG page size [w, h] as
//            OpenSCAD reads it. All layers of one picture must be saved with the same page,
//            then they line up. One-layer pictures are simply centred, no page needed.
// The flags in tiles.scad ("paw", "fish", ...) refer to these names; "bowl" draws the
// monastery and "knot" the junction where 3+ ribbons meet.
// Colours: "silver", "carpet", "thread", "black", "white" (the five toolheads).

ART = [
    ["paw",      8, [["white", "images/selected/paw.svg"]]],
    ["fish",     7, [["black", "images/selected/fish.svg"]]],
    ["feather",  7, [["black", "images/selected/feather.svg"]]],
    ["mouse",    7, [["black", undef]]],
    ["bell",     8, [["white", undef]]],
    ["cattree", 18, [["black", "images/selected/cat-tree.svg"]]],
    ["bowl",    20, [["black", "images/selected/cat-dish-simple.svg"],
                     ["white", "images/selected/cat-dish-simple-fill.svg"]], [200, 200]],
    ["knot",     10, [["thread", undef]]],
];
