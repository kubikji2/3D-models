// designed for following brush:
// https://www.aliexpress.com/item/1005004835567769.html

include<brass-brush-cover-model.scad>

brsh_l = 40+5;
// '-> relevant brush area length

c_clrn = 0.2;
// '-> clearance

plst_h = 6.5 + 2*c_clrn;
// '-> plastic height
plst_w = 12.5 + 2*c_clrn;
// '-> plastic width

wrs_h = 14 + 2*c_clrn;
// '-> wires height
wrs_w = 9 + 2*c_clrn;
// '-> wires width

// cover parameters
c_wt = 2;
// '-> cover wall thickness
c_bvl = 4;



brass_brush_cover(  plastic_length       = brsh_l,
                    plastic_thickness    = plst_h,
                    plastic_width        = plst_w,
                    wires_height         = wrs_h,
                    wires_width          = wrs_w,
                    cover_wall_thickness = c_wt,
                    cover_corner_bevel   = c_bvl,
                    clearance            = c_clrn);