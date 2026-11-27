// Catcassonne goods tokens (Traders & Builders): fish = wine, feather = wheat, mouse = cloth
//
// Single-material tokens, as thick as the score track. Each token uses its own SVG if GOODS
// names one (e.g. a more detailed version), otherwise the tile icon's picture from art.scad,
// otherwise the placeholder.
//
//   openscad goods.scad                                         preview of all 20 tokens
//   for g in fish feather mouse; do
//       openscad -o goods_$g.stl -D "TOKEN=\"$g\"" goods.scad; done   one STL per kind
//
// Each STL holds one token; set the number of copies in the slicer (see GOODS for counts).

include <art.scad>
include <art_placeholders.scad>

/* [Export] */
TOKEN = "all";              // "all" (preview of every token) or "fish" / "feather" / "mouse"

/* [Tokens] */
TOKEN_H = 3.0;              // thickness: 2.4 + 0.6, as the score track
// [name, count, size [w, h] in mm (0 = keep the picture's proportions), svg (optional)]
//   svg: a file just for the token; leave it out (or undef) to use the icon's SVG from art.scad
GOODS = [
    ["fish",    9, [23, 0]],                                   // e.g. [18, 0], "images/selected/fish-token.svg"
    ["feather", 6, [0, 23], "images/selected/feather-hq.svg"],
    ["mouse",   5, [23, 0]],
];
PREVIEW_GAP = 4;            // spacing in the "all" preview

/* [Hidden] */
$fn = 48;

function goods(name) = [for (g = GOODS) if (g[0] == name) g][0];

// the token's picture: its own SVG from GOODS, else the icon's SVG from art.scad, else the placeholder
function token_file(name) = let(g = goods(name))
    len(g) > 3 && g[3] != undef ? g[3] : [for (e = ART) if (e[0] == name) e[2][0][1]][0];

module token_2d(name) {
    size = goods(name)[2];
    file = token_file(name);
    if (file == undef) resize(size, auto = true) art_placeholder(name, 0, max(size));
    else resize(size, auto = true) import(file, center = true);
}

module token(name) {
    linear_extrude(TOKEN_H) token_2d(name);
}

if (TOKEN == "all") {
    for (r = [0:len(GOODS) - 1]) {
        g = GOODS[r];
        for (i = [0:g[1] - 1])
            translate([i * (20 + PREVIEW_GAP), -r * (20 + PREVIEW_GAP), 0]) token(g[0]);
    }
} else token(TOKEN);