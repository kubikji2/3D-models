// Catcassonne tile data (OpenSCAD 2021.01, no dependencies)
//
// tile    = [name, count, set, features, tile_flags?]
// feature = [type, sides, flags?, at?]
//
//   sides : 0 = N, 1 = E, 2 = S, 3 = W (clockwise)
//   type  : "carpet"  sides it covers; one feature = one connected carpet
//                     (two separate caps = two features)
//           "thread"  1 side = ends in the centre (at a bowl, a carpet or a
//                     junction), 2 sides = straight or curve. Junctions are
//                     split into 1-side threads; 3+ dead ends get a junction knot,
//                     1-2 dead ends run into the nearest carpet (straight, then turning).
//                     A thread may share a side with a carpet: it leaves the city gate.
//           "bowl"    no sides; centred unless `at` = [x, y] is given
//   flags : icons  "paw" (shield), "fish" / "feather" / "mouse" (wine / wheat / cloth),
//                  "bell" (inn, on a ribbon), "cattree" (cathedral, on a carpet);
//                  write ["paw", [x, y]] to override the automatic placement
//           shapes "thin"   one-side carpet as a narrow strip (city beyond an inner field)
//                  "wedge"  one-side carpet reaching the opposite corner, leaving a
//                           field strip along the next side clockwise (I&C tile 7)
//                  "bridge" thread drawn over the other threads (roads crossing)
//                  "twist"  the ribbon gets a twist (an hourglass narrowing)
//   tile_flags : ["start"] for the start tile
//
// Two diagonal carpets on one tile leave an inner field between them automatically.
//
// Fields are not stored: whatever is not carpet / thread / bowl is field.
// Names follow the usual base-game letters A-X.

TILES = [
    // ---- base game (72) ----
    ["A",       2, "base", [ ["bowl"], ["thread", [2]] ]],
    ["B",       4, "base", [ ["bowl"] ]],
    ["C",       1, "base", [ ["carpet", [0, 1, 2, 3], ["paw"]] ]],
    ["D",       3, "base", [ ["carpet", [0]], ["thread", [1, 3]] ]],
    ["D_start", 1, "base", [ ["carpet", [0]], ["thread", [1, 3]] ], ["start"]],
    ["E",       5, "base", [ ["carpet", [0]] ]],
    ["F",       2, "base", [ ["carpet", [1, 3], ["paw"]] ]],
    ["G",       1, "base", [ ["carpet", [0, 2]] ]],
    ["H",       3, "base", [ ["carpet", [1]], ["carpet", [3]] ]],
    ["I",       2, "base", [ ["carpet", [1]], ["carpet", [2]] ]],
    ["J",       3, "base", [ ["carpet", [0]], ["thread", [1, 2]] ]],
    ["K",       3, "base", [ ["carpet", [0]], ["thread", [2, 3], ["twist"]] ]],
    ["L",       3, "base", [ ["carpet", [0]], ["thread", [1]], ["thread", [2]], ["thread", [3]] ]],
    ["M",       2, "base", [ ["carpet", [0, 3], ["paw"]] ]],
    ["N",       3, "base", [ ["carpet", [0, 3]] ]],
    ["O",       2, "base", [ ["carpet", [0, 3], ["paw"]], ["thread", [1, 2]] ]],
    ["P",       3, "base", [ ["carpet", [0, 3]], ["thread", [1, 2]] ]],
    ["Q",       1, "base", [ ["carpet", [0, 1, 3], ["paw"]] ]],
    ["R",       3, "base", [ ["carpet", [0, 1, 3]] ]],
    ["S",       2, "base", [ ["carpet", [0, 1, 3], ["paw"]], ["thread", [2]] ]],
    ["T",       1, "base", [ ["carpet", [0, 1, 3]], ["thread", [2]] ]],
    ["U",       8, "base", [ ["thread", [0, 2], ["twist"]] ]],
    ["V",       9, "base", [ ["thread", [2, 3]] ]],
    ["W",       4, "base", [ ["thread", [1]], ["thread", [2]], ["thread", [3]] ]],
    ["X",       1, "base", [ ["thread", [0]], ["thread", [1]], ["thread", [2]], ["thread", [3]] ]],

    // ---- Inns & Cathedrals (18) ----  order as on wikicarpedia
    ["IC01", 1, "inns", [ ["thread", [2, 3], ["bell"]] ]],                                  // inn, curve
    ["IC02", 1, "inns", [ ["thread", [1, 3], ["bell", "twist"]] ]],                                  // inn, straight
    ["IC03", 1, "inns", [ ["thread", [1]], ["thread", [2]], ["thread", [3], [["bell", [0, 9]]]] ]], // inn: W + E roads
    ["IC04", 1, "inns", [ ["bowl"], ["thread", [1]], ["thread", [3]] ]],                    // monastery, 2 roads end at it
    ["IC05", 1, "inns", [ ["thread", [0, 3]], ["thread", [1, 2]] ]],                        // two curves
    ["IC06", 1, "inns", [ ["carpet", [0, 3]], ["thread", [1]] ]],                           // diagonal city, road to gate
    ["IC07", 1, "inns", [ ["carpet", [3], ["wedge"]] ]],                                    // city W, field strip N
    ["IC08", 1, "inns", [ ["carpet", [0]], ["carpet", [1]], ["carpet", [2]], ["carpet", [3]] ]], // 4 cities, inner field
    ["IC09", 1, "inns", [ ["carpet", [0]], ["carpet", [2]],
                          ["thread", [0]], ["thread", [2]], ["thread", [3]] ]],             // village between 2 cities
    ["IC10", 1, "inns", [ ["carpet", [0]], ["thread", [0, 2]] ]],                           // road from city gate
    ["IC11", 2, "inns", [ ["carpet", [0, 1, 2, 3], ["cattree"]] ]],                         // cathedral
    ["IC12", 1, "inns", [ ["carpet", [0, 3], ["paw"]], ["thread", [1, 2], ["bell"]] ]],     // inn, shield
    ["IC13", 1, "inns", [ ["carpet", [0]], ["thread", [2, 3], ["bell"]] ]],                 // inn, city cap
    ["IC14", 1, "inns", [ ["carpet", [0, 3]], ["thread", [2], ["bell"]] ]],                 // inn, road to gate
    ["IC15", 1, "inns", [ ["carpet", [0]], ["carpet", [1]], ["carpet", [3]] ]],             // 3 separate cities
    ["IC16", 1, "inns", [ ["carpet", [0, 3], ["paw"]], ["carpet", [2]] ]],                  // diagonal + cap, shield
    ["IC17", 1, "inns", [ ["carpet", [1, 3], ["paw"]], ["thread", [0]], ["thread", [2]] ]], // band, 2 roads to gates

    // ---- Traders & Builders (24) ----  wine = fish (9), wheat = feather (6), cloth = mouse (5)
    ["TB01", 1, "traders", [ ["carpet", [0]], ["thread", [0, 1]] ]],                        // road from gate, curve
    ["TB02", 1, "traders", [ ["thread", [0, 2]], ["thread", [1, 3], ["bridge", "twist"]] ]],         // roads cross on a bridge
    ["TB03", 1, "traders", [ ["carpet", [0]], ["thread", [0, 2]], ["thread", [1, 3], ["bridge"]] ]],
    ["TB04", 1, "traders", [ ["carpet", [3]], ["carpet", [1], ["feather"]], ["thread", [1, 2]] ]],
    ["TB05", 1, "traders", [ ["carpet", [1, 3], ["feather"]], ["thread", [2]] ]],
    ["TB06", 1, "traders", [ ["carpet", [0, 3], ["feather"]], ["thread", [2]] ]],
    ["TB07", 1, "traders", [ ["carpet", [0, 3], ["feather"]] ]],
    ["TB08", 1, "traders", [ ["carpet", [0, 1, 3], ["feather"]] ]],
    ["TB09", 1, "traders", [ ["carpet", [0, 3], ["feather"]], ["thread", [2]] ]],
    ["TB10", 1, "traders", [ ["bowl"], ["thread", [1]], ["thread", [2]], ["thread", [3]] ]], // monastery, 3 roads
    ["TB11", 1, "traders", [ ["carpet", [0, 1], ["mouse"]], ["thread", [2]] ]],
    ["TB12", 1, "traders", [ ["carpet", [3]], ["carpet", [1], ["mouse"]], ["thread", [1, 2]] ]],
    ["TB13", 1, "traders", [ ["carpet", [0, 3], ["mouse"]], ["carpet", [1, 2]] ]],          // inner field
    ["TB14", 1, "traders", [ ["carpet", [1, 3], ["mouse"]], ["carpet", [0], ["thin"]] ]],   // inner field
    ["TB15", 1, "traders", [ ["carpet", [0, 3], ["mouse"]], ["thread", [1]], ["thread", [2]] ]],
    ["TB16", 1, "traders", [ ["carpet", [1, 3], ["fish"]], ["carpet", [2], ["thin"]] ]],    // inner field
    ["TB17", 1, "traders", [ ["carpet", [1, 3], ["fish"]] ]],
    ["TB18", 1, "traders", [ ["carpet", [1, 3], ["fish"]], ["thread", [0]], ["thread", [2]] ]],
    ["TB19", 1, "traders", [ ["carpet", [1, 3], ["fish"]], ["thread", [2]] ]],
    ["TB20", 1, "traders", [ ["carpet", [0, 3], ["fish"]] ]],
    ["TB21", 1, "traders", [ ["carpet", [0, 3], ["fish"]], ["thread", [1]], ["thread", [2]] ]],
    ["TB22", 1, "traders", [ ["carpet", [0, 1, 3], ["fish"]], ["thread", [2]] ]],
    ["TB23", 1, "traders", [ ["carpet", [0, 3], ["fish"]], ["thread", [1]] ]],
    ["TB24", 1, "traders", [ ["carpet", [0, 3], ["fish"]], ["carpet", [1, 2]] ]],           // inner field
];

EXPECTED = [["base", 72], ["inns", 18], ["traders", 24]];