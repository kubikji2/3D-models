include<../../../lib/solidpp/solidpp.scad>
include<../../../lib/deez-nuts/deez-nuts.scad>

KALLAX_CONNECTION_WIDTH = 40;
KALLAX_CONNECTION_THICKNESS = 37;

module hinge_like_interface_holes(height, wall_thickness,is_left, clearance)
{
    if (is_left)
    {
        cubepp([2*wall_thickness, height/3+2*clearance, 3*wall_thickness], align="X");
    }
    else
    {
        mirrorpp([0,1,0], true)
            translate([0,height/2+clearance,0])
                cubepp([2*wall_thickness, height/3+2*clearance, 3*wall_thickness], align="XY");
    } 
        
}

module kallax_vertical_connector(   wall_thickness,
                                    screw_descriptor = "M3.5x30",
                                    screw_standard = "LUXPZ",
                                    middle_space=0,
                                    clearance_loose=0.2)
{

    vc_x = KALLAX_CONNECTION_WIDTH + wall_thickness;
    vc_y = 2*KALLAX_CONNECTION_THICKNESS + middle_space;
    vc_z = wall_thickness;

    difference()
    {
        // main body
        translate([-wall_thickness,0,0])
        intersection()
        {
            translate([0,0,-vc_z])
                cubepp( [vc_x, vc_y, 2*vc_z],
                        align="xz",
                        mod_list=[bevel_edges(vc_z)]);
            cubepp([vc_x, vc_y, vc_z], align="xz");
        }

        // screw holes
        // top holes
        sa_x = vc_x-wall_thickness;
        sa_y = KALLAX_CONNECTION_THICKNESS-wall_thickness;
        translate([sa_x/4,middle_space/2+sa_y/4,wall_thickness])
        {
            screw_hole( descriptor=screw_descriptor,
                        standard=screw_standard,
                        align="t");
            translate([sa_x/2, sa_y/2,0])
                screw_hole( descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
        }
        
        // bottom holes
        translate([sa_x/4,-middle_space/2-sa_y/4,wall_thickness])
        {
            translate([0,-sa_y/2,0])
                screw_hole( descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
                            
            translate([sa_x/2, 0,0])
                screw_hole( descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
        }



        // interface holes
        _interface_heigth = vc_y/2;
        // top interface
        translate([0,_interface_heigth/2,0])
        hinge_like_interface_holes( height=_interface_heigth,
                                    wall_thickness=wall_thickness,
                                    is_left=true,
                                    clearance=clearance_loose);
        // bottom interface
        translate([0,-_interface_heigth/2,0])
        hinge_like_interface_holes( height=_interface_heigth,
                                    wall_thickness=wall_thickness,
                                    is_left=false,
                                    clearance=clearance_loose);
        // cut off bottom of interface
        //translate([0,0,clearance_loose])
        //    cubepp([wall_thickness, 2*vc_y, wall_thickness], align="XZ");
    }
}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.01;

// short for the 2x2 + 3x4 kallaxes
kallax_vertical_connector(wall_thickness=4, middle_space=18);
// long for the 2x4 + 4x4 kallaxes
//kallax_vertical_connector(wall_thickness=4, middle_space=18+2);

//#render()
//    rotate([0,-90,0])
//        rotate([0,0,180])
//            kallax_vertical_connector(wall_thickness=4, middle_space=18);
//
//
//%translate([KALLAX_CONNECTION_WIDTH/2,0,-KALLAX_CONNECTION_WIDTH/2])
//    cylinderpp(d=6, h=2*KALLAX_CONNECTION_THICKNESS+18, zet="y", align="");