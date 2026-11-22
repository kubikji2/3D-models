// Catcassonne test board: a few tiles laid out together, to check how
// carpets, gold lines and threads continue across tile edges and corners.
//
// Any setting from catcassonne.scad can be overridden below the include,
// e.g. WAVE = false; or CORNER_M = 3;

include <catcassonne.scad>

MODE = "none";      // switch off catcassonne.scad's own output
BOARD_GAP = 0.5;    // mm between tiles (0 = seamless)

// [tile name, quarter turns clockwise]
BOARD = [
    [["B", 0], ["E", 2], ["M", 2]],
    [["E", 1], ["C", 0], ["R", 3]],
    [["V", 0], ["E", 0], ["N", 1]],
];

// a showcase of expansion tiles (edges NOT matched), swap it in to try:
// BOARD = [
//     [["TB13", 0], ["IC08", 0], ["TB24", 1]],
//     [["IC16", 0], ["TB14", 0], ["IC15", 2]],
//     [["TB06", 0], ["IC17", 0], ["TB15", 0]],
// ];

function tile_index(name) = let(r = [for (i = [0:len(TILES) - 1]) if (t_name(TILES[i]) == name) i])
    assert(len(r) > 0, str("no tile named ", name)) r[0];

for (r = [0:len(BOARD) - 1]) for (c = [0:len(BOARD[r]) - 1]) {
    i = tile_index(BOARD[r][c][0]);
    translate([c * (T + BOARD_GAP), -r * (T + BOARD_GAP), 0])
        rotate(-90 * BOARD[r][c][1])
            tile(TILES[i], "all", i);
}