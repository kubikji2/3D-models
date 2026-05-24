include<parkside-charger-interface.scad>

include<parkside-plkg-12-a3-interface.scad>
include<parkside-plg-20-c2-interface.scad>


module parkside_charger_pin(additional_height,clearance=0.2)
{
    // wider cylinder
    cylinder(d=prks_int_D-2*clearance,h=prks_int_H-prks_int_h-clearance);

    // narrow shaft
    cylinder(d=prks_int_d-2*clearance,h=prks_int_H+additional_height);

}


module plkg_12_a3_interface_pin(clearance=0.2)
{
            
    // wider cylinder
    cylinder(d=plkg_12_a3_int_D-2*clearance,h=plkg_12_a3_int_H-plkg_12_a3_int_h-clearance);

    // narrow shaft
    cylinder(d=plkg_12_a3_int_d-2*clearance,h=plkg_12_a3_int_H+plkg_12_a3_leg_h);

}



module plg_20_c2_interface_pin(clearance=0.2)
{
            
    // wider cylinder
    cylinder(d=plg_20_c2_int_D-2*clearance,h=plg_20_c2_int_H-plg_20_c2_int_h-clearance);

    // narrow shaft
    cylinder(d=plg_20_c2_int_d-2*clearance,h=plg_20_c2_int_H+plg_20_c2_leg_h);

}



