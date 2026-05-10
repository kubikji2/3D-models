use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

use<../ivar-insert/ivar-insert.scad>
include<../ivar-dimensions.scad>

use<parkside-charger-pin-model.scad>
include<parkside-charger-interface.scad>

include<parkside-plg-20-c2.inerface.scad>
include<parkside-plkg-12-a3-inerface.scad>


module ivar_charger_insert(
    wt = 4,
    h = 6*ivar_leg_hole_gauge_h,
    back_wall_offset = 15,
    screw_d = 3,
    screw_l = 20,
    screw_standard = "LUXPZ",
    peg_offset = 60

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

    }

    

    translate([0,-ivar_leg_w-back_wall_offset+wt+prks_int_H,h-peg_offset])
    {
        //coordinate_frame();
        
        translate([ivar_legs_gauge/4,plg_20_c2_leg_h,0])
        {
            rotate([90,0,0])
                parkside_charger_pin(additional_height=plg_20_c2_leg_h);
            translate([0,0,-plg_20_c2_int_spacing])
                rotate([90,0,0])
                    parkside_charger_pin(additional_height=plg_20_c2_leg_h);

        }

        translate([-ivar_legs_gauge/4,plkg_12_a3_leg_h,0])
        {
            mirrorpp([1,0,0], true)
                translate([-plkg_12_a3_int_spacing/2,0,0])
                    rotate([90,0,0])
                        parkside_charger_pin(additional_height=plkg_12_a3_leg_h);
            
        }

    }


}

ivar_charger_insert();