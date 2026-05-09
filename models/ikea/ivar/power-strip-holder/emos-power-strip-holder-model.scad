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
    hook_l=20,
    bt = 3,
    wt = 2.4,
    ivar_interface_wt = 4,
    ivar_clearance = 0.2,
    //ivar_screw_descriptor = "M3x30",
    //ivar_screw_standard = "LUXPZ",
    //ivar_bolt_descriptor = "M3x30",
    //ivar_bolt_standard = "DIN84A",
    ivar_nut_standard = "DIN934",
    ivar_nut_diameter = 3,
    ivar_nut_additional_depth = 1,
    ivar_bolt_y_tolerance = 3,
    ziptie_thickness = 1.5,
    ziptie_width = 4,
    clearance = 0.15)
{

    //
    eps_int_to_widest_point = is_top ? eps_int_to_widest_point_top : eps_int_to_widest_point_bottom;

    // connecting plane
    _x = eps_w+2*wt+2*clearance;
    _y = 2*(hook_l/2+eps_int_to_widest_point/2);
    difference()
    {
        union()
        {
            // emos interface
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
                                            ziptie_width = ziptie_width,
                                            wall_thickness = ivar_interface_wt,
                                            clearance = ivar_clearance);
                    if(!is_top)
                    {
                        translate([0,0,-ivar_interface_wt])
                            cubepp([ivar_leg_w+2*ivar_clearance,_y,2*ivar_leg_d], align="Z");

                    }
                }
            
            // interface connector
            translate([0,eps_int_to_widest_point/2,0])
                hull()
                {
                    cubepp([_x,_y, bt], align="Z");
                    translate([0,0,-bt])
                        cubepp(
                            [ivar_leg_w+2*ivar_interface_wt+2*ivar_clearance,_y, ivar_interface_wt],
                            align="Z");

                }
        }

        
        translate([0,eps_int_to_widest_point/2,-bt])
            ziptie_ivar_interface_ziptie_holes(
                height=_y,
                ziptie_thickness=ziptie_thickness,
                ziptie_width=ziptie_width,
                wall_thickness=ivar_interface_wt,
                clearance=ivar_clearance);
    

        // emos studs holes
        translate([0,eps_int_to_widest_point,0])
            cubepp(
                [eps_w,eps_studs_d+2*clearance,2*eps_studs_h],
                align="",
                mod_list=[round_edges(d=eps_studs_d+2*clearance)]);
        

        //
        //translate([0,eps_int_to_widest_point/2,0])
        //    if (is_top)
        //    {
        //        translate([0,0,0])
        //            mirrorpp([1,0,0], true)
        //                translate([ivar_leg_hole_gauge_w/2,0,0])
        //                    screw_hole(
        //                        standard=ivar_screw_standard,
        //                        descriptor=ivar_screw_descriptor,
        //                        align="t");
        //    }
        
        
        translate([0,eps_int_to_widest_point/2,0])
            if (!is_top)
            {
                ivar_peg_mount_points_offset = (168%ivar_leg_hole_gauge_h) + (eps_int_to_widest_point_top-eps_int_to_widest_point_bottom);
                //head_d = get_bolt_head_diameter(descriptor=ivar_bolt_descriptor,standard=ivar_bolt_standard);
                //head_h = get_bolt_head_height(descriptor=ivar_bolt_descriptor,standard=ivar_bolt_standard);
                //head_h = 0;
                //shaft_d = float(ivar_bolt_descriptor[1]);
                nut_d = get_nut_diameter(d=ivar_nut_diameter, standard=ivar_nut_standard);
                nut_h = get_nut_height(d=ivar_nut_diameter, standard=ivar_nut_standard);
                
                echo(ivar_peg_mount_points_offset);
                translate([0,ivar_peg_mount_points_offset,0])
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
    bolt_d = 2,
    clearance=0.2
)
{

    _h = bolt_length-ivar_interface_wt-bt+ivar_nut_additional_depth/2;

    tubepp(d=bolt_d+2*clearance, D=ivar_leg_hole_diameter-2*clearance, h=_h);
}

//emos_power_strip_holder_pegs();

emos_power_strip_holder(is_top=false);


//translate([0,eps_int_to_widest_point_top/2,-10])
//for (i=[0:6])
//    translate([0,i*ivar_leg_hole_gauge_h,0])
//    replicate_at_ivar_interface_holes()
//        coordinate_frame();
//

//translate([0,eps_int_to_int,0])
//    emos_power_strip_holder(is_top=false);