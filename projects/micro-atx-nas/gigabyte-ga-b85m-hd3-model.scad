use<micro-atx-models.scad>
include<micro-atx-parameters.scad>

include<gigabyte-ga-b85m-hd3-parameters.scad>

// solidpp
use<../../lib/solidpp/solidpp.scad>

module bg_ga_b85_hd3_replicate_to_mount_points()
{
    translate([ b_hole_left_edge_offset,
                bg_ga_b85_hd3_y-b_hole_top_edge_offset,
                0])
        uatx_replicate_to_mount_points(s_hole=false, l_hole=false, m_hole=false)
            children();
}

//
module gigabyte_ga_b85m_hd3_motherboard()
{   
    difference()
    {
        // main board
        cubepp([bg_ga_b85_hd3_x,
                bg_ga_b85_hd3_y,
                bg_ga_b85_hd3_z],
                mod_list=[round_edges(r=bg_ga_b85_hd3_cr)]);
        // holes
        bg_ga_b85_hd3_replicate_to_mount_points()
            cylinderpp( d=uatx_hold_d,
                        h=3*bg_ga_b85_hd3_z,
                        align="");
    }
}
