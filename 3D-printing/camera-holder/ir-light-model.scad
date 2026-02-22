use<../../lib/solidpp/solidpp.scad>
include<ir-light-constants.scad>

module irl_replicate_to_fastners()
{
    translate([0,irl_fasteners_offset-irl_light_d/2,0])
        mirrorpp([1,0,0], true)
            translate([irl_fasteners_g/2,0,0])
                children();
}

module irl_light_hole(height=irl_light_h, clearance=0.25)
{
    // light
    cylinderpp( d=irl_light_d+2*clearance,
                h=height);
    // light sensor
    _ls_off = irl_light_d/2+clearance + irl_sensor_d/2+clearance;
    rotate([0,0,-acos((irl_light_d/2-irl_sensor_d/2)/_ls_off)])
        translate([-_ls_off,0,0])
            cylinderpp(d=irl_sensor_d+2*clearance,h=height);
    // potentiometer
    rotate([0,0,45])
        translate([irl_sensitivity_off,0,0])
            cylinderpp(d=irl_sensitivity_a+2*clearance,h=height);

    // fastener
    //irl_replicate_to_fastners()
    //    cylinderpp(d=irl_fasteners_d+2*clearance, h=height);
    
}
