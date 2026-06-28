

use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<sencor-SFE-3027WH-neck-dimensions.scad>


module ssfen_cable_hole(wt, is_bottom=false)
{
    _align = is_bottom ? "Z" : "z";

    translate([0,ssfen_mr_d/2+wt+(ssfen_hng_y_offset-ssfen_hng_D/2-ssfen_mr_d/2-wt)/2,-ssfen_tc_h-ssfen_plane_t])
    rotate([0,0,is_bottom ? 0 : 180])
    {
        _h = ssfen_hng_z_offset+ssfen_hng_D/2-ssfen_plane_t; 
        cylinderpp( d=ssfen_cable_d,
                    h=_h,
                    align=_align);   
        cubepp([ssfen_hng_t+ssfen_ml2mr_x_gauge, ssfen_cable_min_d, _h], align=str("x",_align));
    }
}

module ssfen_top_interface_holes(wt)
{
    // motor shaft hole
    translate([0,0,0.1])
        cylinderpp(d=ssfen_mr_d, h=ssfen_mr_h+0.1, align="Z");

    // motor shaft stopper
    translate([ssfen_mr_d/2+ssfen_mr_screw_t,0,-ssfen_mr_screw_h_off])
        cylinderpp(d=ssfen_mr_screw_d, h=3*ssfen_mr_screw_t, align="", zet="x");

    // motor shaft
    translate([-ssfen_ml2mr_x_gauge,0,-ssfen_ml2mr_z_offset+0.1])
        cylinderpp( d=ssfen_ml_screw_d+0.1,
                    h=ssfen_ml_screw_l,
                    align="Z",
                    mod_list=[round_bases(d_bottom=ssfen_ml_screw_d)]);
}   

module ssfen_top_interface(wt = 3)
{

    union()
    {
        // motor rod interface
        cylinderpp(d=ssfen_hng_t,
                    h=ssfen_mr_h+wt,
                    align="Z");

        // motor screw
        translate([0,0,-ssfen_ml2mr_z_offset-ssfen_ml_h])
            cubepp([ssfen_mr_d/2+ssfen_mr_screw_t,
                    ssfen_mr_screw_d+2*wt,
                    ssfen_tc_h-ssfen_ml2mr_z_offset-ssfen_ml_h],
                    align="xZ"
            );

        // motor link interface
        translate([-ssfen_ml2mr_x_gauge,0,-ssfen_ml2mr_z_offset])
        {
            
            cylinderpp(d=ssfen_ml_d,h=ssfen_ml_h, align="Z");
            translate([0,0,-ssfen_ml_h])
                cylinderpp(d=ssfen_ml_based_d,h=ssfen_tc_h-ssfen_ml_h-ssfen_ml2mr_z_offset, align="Z");
        }

        // connecting the motor rod interface to the motor link interface
        translate([0,0,-ssfen_ml2mr_z_offset-ssfen_ml_h])
        {
            cubepp([ssfen_ml2mr_x_gauge,
                    ssfen_ml_based_d,
                    ssfen_tc_h-ssfen_ml_h-ssfen_ml2mr_z_offset],
                    align="XZ");
        }
            
    }
}

module ssfen_hinge_interface()
{
    cylinderpp(d=ssfen_hng_D, h=ssfen_hng_t, zet="x", align="");
}

module ssfen_hinge_holes()
{
    cylinderpp(d=ssfen_hng_d, h=3*ssfen_hng_t, zet="x", align="");
    for (i=[0:16])
    rotate([i*(120/16),0,0])
        translate([0,0,-ssfen_hng_D/2])
            cubepp([ssfen_grv_l, ssfen_grv_w, ssfen_grv_d],align="z", mod_list=[round_edges(d=ssfen_grv_w)]);
}

module ssfen_plate(wt=3)
{
    linear_extrude(ssfen_plane_t)
        offset(wt)
            offset(-wt)
                hull()
                {
                    circlepp(d=2*(ssfen_ml2mr_x_gauge+ssfen_ml_based_d/2+wt));
                    translate([0,ssfen_hng_y_offset+ssfen_hng_D/4])
                        squarepp([ssfen_hng_t+2*wt,wt], align="y");
                }

}

module fasterner_pair(
    fasterner_d = 3,
    bolt_standard = "DIN84A",
    bolt_length = 10,
    nut_standard = "DIN934")
{
    bolt_descriptor = str("M",fasterner_d,"x",bolt_length);
    _hh = get_bolt_head_height(descriptor=bolt_descriptor, standard=bolt_standard);

    translate([0,0,-bolt_length-_hh])
    {
        bolt_hole(  descriptor=bolt_descriptor,
                    standard=bolt_standard,
                    clearance=0.2,
                    sh_off=1);

        nut_hole(   d=fasterner_d,
                    standard=nut_standard,
                    s_off=100,
                    clearance=0.2);
    }
}

module ssfen_neck(
    wt = 3,
    fasterner_d = 3,
    bolt_standard = "DIN84A",
    bolt_length = 10,
    nut_standard = "DIN934"
)
{
    difference()
    {
        union()
        {
            // top interface
            ssfen_top_interface(wt=wt);
            
            // hinge interface
            translate([0,ssfen_hng_y_offset,-ssfen_tc_h-ssfen_hng_z_offset])
                ssfen_hinge_interface();
            
            // connector
            hull()
            {
                // hinge
                translate([0,ssfen_hng_y_offset,-ssfen_tc_h-ssfen_hng_z_offset])
                    cylinderpp(d=ssfen_hng_D, h=ssfen_hng_t, zet="x", align="");

                // rod
                translate([0,0,-ssfen_tc_h])
                    cylinderpp( d=ssfen_hng_t,
                            h=ssfen_mr_h+wt-ssfen_tc_h,
                            align="Z");

                // plane
                translate([0,ssfen_hng_y_offset+ssfen_hng_D/4,-ssfen_tc_h])
                    cubepp([ssfen_hng_t,
                            ssfen_hng_D/2+ssfen_hng_D/4,
                            ssfen_plane_t],
                            align="YZ");
            }

            // plane
            translate([0,0,-ssfen_tc_h-ssfen_plane_t])
                ssfen_plate();
            
            // side mountpoints
            translate([0,0,-ssfen_tc_h-ssfen_plane_t])
            {
                bolt_descriptor = str("M",fasterner_d,"x",bolt_length);
                _hh = get_bolt_head_height(descriptor=bolt_descriptor, standard=bolt_standard);
                
                _d = ssfen_mr_d+2*wt;
                _h = bolt_length-ssfen_plane_t+_hh;
                _H = 2*_h;

                
                intersection()
                {
                    _D = 2*(ssfen_ml2mr_x_gauge+ssfen_ml_based_d/2+wt);
                    cylinderpp( d=_D,
                                h=_h, align="Z");
                    cubepp([_D,_d,_h], align="xZ");
                }

                translate([0,0,-_h])    
                //coordinate_frame()
                hull()
                {
                    
                    cylinderpp(d=_d,h=_h, align="Z");
                    cubepp([_d, _d/2, _h], align="yZ");
                                 
                    intersection()
                    {
                        _D = 2*(ssfen_ml2mr_x_gauge+ssfen_ml_based_d/2+wt);

                        cylinderpp( 
                                    d1=_d,
                                    d2=_D,
                                    h=_h, align="Z");
                        cubepp([_D,_d,_h], align="xZ");
                    }
                }
            }

            // top reinforcements
            translate([0,0,-ssfen_tc_h])
            intersection()
            {                        
                _D = 2*(ssfen_ml2mr_x_gauge+ssfen_ml_based_d/2+wt);
                _h = ssfen_tc_h-ssfen_ml_h-ssfen_ml2mr_z_offset;
                cylinderpp(d1=_D, d2=2*wt+ssfen_mr_d, h=_h, align="z");
                translate([-_D+ssfen_mr_d/2+ssfen_mr_screw_t,0,0])
                cubepp([_D, _D, _h],align="xz");
            }
                
        }   
        
        // top cabel hole
        ssfen_cable_hole(wt=wt, is_bottom=false);
        
        // bottom cabel hole
        ssfen_cable_hole(wt=wt, is_bottom=true);  
        

        // top interface hole
        ssfen_top_interface_holes(wt=wt);

        // hinge holes
        translate([0,ssfen_hng_y_offset,-ssfen_tc_h-ssfen_hng_z_offset])
            ssfen_hinge_holes();

        // cut plane
        translate([0,0,-ssfen_tc_h-ssfen_plane_t])
            cubepp([200,200,0.1], align="");


        // back mounting
        translate([0,ssfen_hng_y_offset,-ssfen_tc_h])
            fasterner_pair();
        translate([0,ssfen_hng_y_offset-ssfen_hng_D/4,-ssfen_tc_h])
            fasterner_pair();

        // side mounting
        translate([ssfen_ml2mr_x_gauge,0,-ssfen_tc_h])
            fasterner_pair();


    }
}


$fn = $preview ? 60 : 180;

ssfen_neck();