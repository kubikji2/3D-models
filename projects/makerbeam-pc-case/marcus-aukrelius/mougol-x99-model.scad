include<mougol-x99-parameters.scad>

// micro atx parameters
use<../pc-parts/micro-atx-models.scad>
include<../pc-parts/micro-atx-parameters.scad>

include<mougol-x99-parameters.scad>

//

// solidpp
use<../../../lib/solidpp/solidpp.scad>

module mougol_x99_replicate_to_mount_points()
{
    translate([mougol_holes_offset_x,0,0])
    uatx_align_board_to_xyz(mougol_x99_x,mougol_x99_y)
        uatx_replicate_to_mount_points(r_hole=false, s_hole=true, l_hole=false, m_hole=false)
            children();
}

//
module mougol_x99_motherboard()
{   
    difference()
    {
        // main board
        //cubepp([mougol_x99_x,
        //        mougol_x99_y,
        //        mougol_x99_z],
        //        mod_list=[round_edges(r=mougol_x99_cr)]);
        uatx_mockup(x=mougol_x99_x,y=mougol_x99_y, z=mougol_x99_z, io_sheild_offset=mougol_holes_offset_x);

        
        // holes
        mougol_x99_replicate_to_mount_points()
            cylinderpp( d=uatx_hole_d,
                        h=3*mougol_x99_z,
                        align="");
    }
}