use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

use<../ivar-insert/ivar-insert.scad>
include<../ivar-dimensions.scad>

use<parkside-charger-pin-model.scad>
include<parkside-charger-interface.scad>

include<parkside-plg-20-c2-interface.scad>
include<parkside-plkg-12-a3-interface.scad>

// holes for the zipties
use<../ivar-interface/ziptie-ivar-interface.scad>

include<../power-strip-holder/emos-power-strip-holder-parameters.scad>
use<../power-strip-holder/emos-power-strip-holder-model.scad>

module ivar_charger_insert(
    wt = 3,
    h = 6*ivar_leg_hole_gauge_h,
    back_wall_offset = 15,
    screw_d = 3,
    screw_l = 20,
    screw_standard = "LUXPZ",
    peg_offset = 60,
    ivar_clearance = 0.2,
    ziptie_thickness = 1.5,
    ziptie_width = 4,
    ziptie_head_width = 5.6,
    emos_interface_hook_l = 20,
    emos_interface_bt = 3,
    ivar_interface_h = 2,

)
{

    screw_descriptor = str("M",screw_d,"x",screw_l);

    
    difference()
    {
        ivar_insert(
            wt=wt,
            height=h,
            back_wall_offset = back_wall_offset);
        
        screw_off = ivar_leg_w/2;
        
        // middle screws
        mirrorpp([1,0,0], true)
            translate([-(ivar_legs_gauge/2-wt),-screw_off,ivar_leg_hole_gauge_h/2])
                rotate([0,90,0])
                    screw_hole(standard=screw_standard,
                                descriptor=screw_descriptor,
                                align="t");

        // top screws
        mirrorpp([1,0,0], true)
            translate([-(ivar_legs_gauge/2-wt),-screw_off,h-ivar_leg_hole_gauge_h/2])
                rotate([0,90,0])
                    screw_hole(standard=screw_standard,
                                descriptor=screw_descriptor,
                                align="t");

        // cut front edges
        cubepp( [ivar_legs_gauge,2*wt,3*h],
                align="",
                mod_list=[bevel_edges(bevel=wt, axes="xy")]);
        
        // adding holes for the zipties

        translate([-ivar_legs_gauge/2+wt,-ivar_leg_w/2,0])
        {
            
            // upper
            translate([0,0,5*ivar_leg_hole_gauge_h-(eps_int_to_widest_point_top/2-ivar_leg_hole_gauge_h/2)])
            {
            
                top_y = (emos_interface_hook_l+eps_int_to_widest_point_top);
                bottom_y = (emos_interface_hook_l+eps_int_to_widest_point_bottom);

            
                rotate([90,0,90])
                {
                    //%emos_power_strip_holder(is_top=true, is_long=false, is_interface=false);
        
                    translate([0,eps_int_to_widest_point_top/2,0])
                        ziptie_ivar_interface_ziptie_holes(
                            height=top_y,
                            ziptie_thickness=ziptie_thickness,
                            ziptie_width=ziptie_width,
                            wall_thickness=4,
                            clearance=ivar_clearance);
                }

                translate([0,0,-eps_int_to_int_short+eps_int_to_widest_point_top/2])
                {
                    rotate([90,0,90])
                    {
                        //%emos_power_strip_holder(is_top=false, is_long=false, is_interface=false);
                        
                        translate([0,eps_int_to_widest_point_top/2,0])
                            ziptie_ivar_interface_ziptie_holes(
                                height=top_y,
                                ziptie_thickness=ziptie_thickness,
                                ziptie_width=ziptie_head_width,
                                wall_thickness=4,
                                clearance=ivar_clearance);
                    }
                }
            }

        }

    }

    difference()
    {
        mirrorpp([1,0,0], true)
            translate([-ivar_legs_gauge/2,-ivar_leg_w/2,0])
                for(i=[1:5])
                    translate([0,0,i*ivar_leg_hole_gauge_h])
                        mirrorpp([0,1,0], true)
                            translate([0,ivar_leg_hole_gauge_w/2,0])
                                //coordinate_frame()
                                spherepp([  2*ivar_interface_h,
                                            ivar_leg_hole_diameter,
                                            ivar_leg_hole_diameter]);
        
        cubepp([ivar_legs_gauge,ivar_legs_gauge,h], align="Yz");
    }

    translate([0,-ivar_leg_w-back_wall_offset+wt,h-peg_offset])
    {
        //coordinate_frame();
        
        translate([ivar_legs_gauge/4,plg_20_c2_int_H+plg_20_c2_leg_h+ivar_clearance,0])
        {
            rotate([90,0,0])
                plg_20_c2_interface_pin(clearance=ivar_clearance);
            
            translate([0,0,-plg_20_c2_int_spacing])
                rotate([90,0,0])
                    plg_20_c2_interface_pin(clearance=ivar_clearance);

        }

        translate([-ivar_legs_gauge/4,plkg_12_a3_int_H+plkg_12_a3_leg_h+ivar_clearance,0])
        {
            mirrorpp([1,0,0], true)
                translate([-plkg_12_a3_int_spacing/2,0,0])
                    rotate([90,0,0])
                        plkg_12_a3_interface_pin(clearance=ivar_clearance);
            
        }

    }


}

$fa = 5;
$fs = 0.1;

ivar_charger_insert();