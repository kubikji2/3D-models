use<../../../../lib/solidpp/solidpp.scad>

use<parkside-charger-pin-model.scad>

include<parkside-plkg-12-a3-interface.scad>
include<parkside-plg-20-c2-interface.scad>

wt = 4;

$fn=60;



module plg_20_c2_interface_insert(clearance=0.2)
{
    plg_20_c2_interface_pin(clearance=clearance);


    translate([0,0,plg_20_c2_leg_h+plg_20_c2_int_H])
    {
        cylinderpp(d=plg_20_c2_int_D,h=wt/2);
        translate([0,0,wt/2])
            cubepp([20+plg_20_c2_int_D,plg_20_c2_int_D,wt/2],
                    align="z",
                    mod_list=[round_edges(d=plg_20_c2_int_D)]);
    }
}

//plg_20_c2_interface_insert();


module plkg_12_a3_interface_insert(clearance=0.2)
{
    plkg_12_a3_interface_pin(clearance=clearance);


    translate([0,0,plkg_12_a3_leg_h+plkg_12_a3_int_H])
    {
        cylinderpp(d=plkg_12_a3_int_D,h=wt/2);
        
        translate([0,0,wt/2])
        {
            cubepp([20+plkg_12_a3_int_D,plkg_12_a3_int_D,wt/2],
                    align="z",
                    mod_list=[round_edges(d=plkg_12_a3_int_D)]);
            
        }
    }
}

plkg_12_a3_interface_insert();