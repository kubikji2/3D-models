include<emos-power-strip-holder-parameters.scad>
//include<power-strip-parameters.scad>

include<../ivar-dimensions.scad>
include<../ivar-interface/ziptie-ivar-interface.scad>


use<../../../../lib/solidpp/solidpp.scad>


$fs=0.5;
$fa=5;
$fn=36;

module emos_power_strip_interface(eps_int_to_widest_point,wt=3, hook_l = 20, clearance=0.15)
{
    // nub ...
    // ... wider part
    translate([0,0,eps_int_h])
        cylinderpp(d=eps_int_D-2*clearance,h=eps_int_H);
    // ... thinner part
    cylinderpp(d=eps_int_d-2*clearance,h=eps_int_h+eps_int_H);

    // clip ons
    translate([0,eps_int_to_widest_point,0])
    difference()
    {
        _x = eps_w + 2*clearance+2*wt;
        _y = hook_l;
        _z = eps_t + 2*clearance+2*wt;
        translate([0,0,-wt])
            cubepp( [_x, _y, _z],
                    align="z",
                    mod_list=[round_edges(r=wt, axes="xz")]);
        
        cubepp( [eps_w + 2*clearance, 2*_y, eps_t + 2*clearance], align="z");

        cubepp( [eps_w + 2*clearance - 2*eps_w_off, 2*_y, 2*_z], align="z");
        
    }

}



//emos_power_strip_interface();

module emos_power_strip_holder( 
    is_top=true,
    is_long=true,
    is_interface=true,
    hook_l=20,
    bt = 3,
    wt = 2.4,
    ivar_interface_wt = 4,
    ivar_clearance = 0.2,
    ivar_nut_standard = "DIN934",
    ivar_nut_diameter = 3,
    ivar_nut_additional_depth = 1,
    ivar_bolt_y_tolerance = 3,
    ziptie_thickness = 1.5,
    ziptie_width = 4,
    ziptie_head_width = 5.6,
    clearance = 0.15)
{

    //
    eps_int_to_widest_point = is_top ? eps_int_to_widest_point_top : eps_int_to_widest_point_bottom;

    // ivar ibterface positioning variables
    _length = (is_long ? eps_int_to_int_long : eps_int_to_int_short);
    _holes_off = -_length + eps_int_to_widest_point_top/2-ivar_leg_hole_gauge_h/2;
    _min_idx = floor(_length/ivar_leg_hole_gauge_h);

    _ziptie_width = is_interface ? ziptie_width : ziptie_head_width + (is_top ? 0 : ivar_bolt_y_tolerance);

    // connecting plane
    _x = eps_w+2*wt+2*clearance;
    _y = (hook_l+eps_int_to_widest_point);
    difference()
    {
        union()
        {
            // emos interface
            if (is_interface)
                emos_power_strip_interface(
                    eps_int_to_widest_point=eps_int_to_widest_point,
                    wt=wt,
                    hook_l=hook_l,
                    clearance=clearance );

            // ivar interface
            translate([0,eps_int_to_widest_point/2,-bt])
                difference()
                {
                    ziptie_ivar_interface(  height=_y,
                                            ziptie_thickness = ziptie_thickness,
                                            ziptie_width = _ziptie_width,
                                            wall_thickness = ivar_interface_wt,
                                            clearance = ivar_clearance);
                    if(!is_top)
                    {
                        translate([0,0,-ivar_interface_wt+ivar_clearance/2])
                            cubepp([ivar_leg_w+2*ivar_clearance,_y,2*ivar_leg_d], align="Z");

                    }
                }
            
            // interface connector
            if (is_interface)
                translate([0,eps_int_to_widest_point/2,0])
                    hull()
                    {
                        cubepp([_x,_y, bt], align="Z");
                        translate([0,0,-bt])
                            cubepp(
                                [ivar_leg_w+2*ivar_interface_wt+2*ivar_clearance,_y, ivar_interface_wt],
                                align="Z");

                    }
            
            // pegs for the non-interface, bottom parts
            if(!is_interface && !is_top)
            {

                intersection()
                {
                    // the part area
                    translate([0,-ivar_leg_hole_diameter/2-ivar_clearance,0])
                        cubepp([_x,ivar_leg_hole_gauge_h+ivar_leg_hole_diameter,ivar_leg_hole_depth], align="yZ");
                    
                    // position pegs to correct offset
                    for (i=[_min_idx:ceil(_length/ivar_leg_hole_gauge_h)+1])
                        translate([0,_holes_off+i*ivar_leg_hole_gauge_h,-bt])
                            mirrorpp([1,0,0], true)
                                translate([ivar_leg_hole_gauge_w/2,0,0])
                                    //coordinate_frame()
                                    cylinderpp( d=ivar_leg_hole_diameter-2*ivar_clearance,
                                                h=ivar_leg_hole_depth/2,
                                                align="Z");
                }
            }
        }

        // redrilling ziptie holes to the ivar-emos interface joiner
        translate([0,eps_int_to_widest_point/2,-bt])
            ziptie_ivar_interface_ziptie_holes(
                height=_y,
                ziptie_thickness=ziptie_thickness,
                ziptie_width=_ziptie_width,
                wall_thickness=ivar_interface_wt,
                clearance=ivar_clearance);
    

        // emos studs holes
        translate([0,eps_int_to_widest_point,0])
            cubepp(
                [eps_w,eps_studs_d+2*clearance,2*eps_studs_h],
                align="",
                mod_list=[round_edges(d=eps_studs_d+2*clearance)]);


        // movable pegs for the bottom interface part                
        if (!is_top && is_interface)
        {

            nut_d = get_nut_diameter(d=ivar_nut_diameter, standard=ivar_nut_standard);
            nut_h = get_nut_height(d=ivar_nut_diameter, standard=ivar_nut_standard);
            
            for (i=[_min_idx:ceil(_length/ivar_leg_hole_gauge_h)+1])
                translate([0,_holes_off+i*ivar_leg_hole_gauge_h,0])
                    mirrorpp([1,0,0], true)
                        translate([ivar_leg_hole_gauge_w/2,0,0])
                            //coordinate_frame()
                            union()
                            {
                                hull()
                                {
                                    mirrorpp([0,1,0], true)
                                        translate([0,ivar_bolt_y_tolerance/2,0])
                                        rotate([0,0,90])
                                            nut_hole(   d=ivar_nut_diameter,
                                                        standard=ivar_nut_standard,
                                                        clearance=0.25,
                                                        h_off=ivar_nut_additional_depth,
                                                        align="t");
                                }
                                hull()
                                {
                                    mirrorpp([0,1,0], true)
                                        translate([0,ivar_bolt_y_tolerance/2,0])
                                            cylinderpp(d=ivar_nut_diameter+2*clearance, h=2*(ivar_leg_hole_depth), align="");
                                }

                                //hull()
                                //{
                                //    mirrorpp([0,1,0], true)
                                //        translate([0,ivar_bolt_y_tolerance/2,0])
                                //            cylinderpp(d=head_d+2*clearance, h=2*head_h+2*clearance, align="");
                                //}
                                //hull()
                                //{
                                //    mirrorpp([0,1,0], true)
                                //        translate([0,ivar_bolt_y_tolerance/2,0])
                                //            cylinderpp(d=shaft_d+2*clearance, h=2*(ivar_leg_hole_depth), align="");
                                //}
                                
                            };
        }


    }
    
    
}

module emos_power_strip_holder_pegs(
    bt = 3,
    ivar_interface_wt = 4,
    ivar_nut_additional_depth = 1,
    bolt_length = 20,
    bolt_d = 3,
    clearance=0.2
)
{

    _h = bolt_length-ivar_interface_wt-bt+ivar_nut_additional_depth/2;

    tubepp(d=bolt_d+2*clearance, D=ivar_leg_hole_diameter-2*clearance, h=_h);
}

//emos_power_strip_holder_pegs();

//emos_power_strip_holder(is_top=true);
//
//translate([0,eps_int_to_widest_point_top/2,-10])
//for (i=[0:8])
//    translate([0,i*ivar_leg_hole_gauge_h,0])
//    replicate_at_ivar_interface_holes()
//        coordinate_frame();
//
//translate([0,eps_int_to_int_short,0])
//    emos_power_strip_holder(is_top=false, is_long=false);


emos_power_strip_holder(is_top=true, is_long=true, is_interface=false);