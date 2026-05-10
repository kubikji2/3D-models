include<parkside-charger-interface.scad>

module parkside_charger_pin(additional_height,clearance=0.2)
{
    // wider cylinder
    cylinder(d=prks_int_D-2*clearance,h=prks_int_H-prks_int_h-clearance);

    // narrow shaft
    cylinder(d=prks_int_d-2*clearance,h=prks_int_H+additional_height);

}
