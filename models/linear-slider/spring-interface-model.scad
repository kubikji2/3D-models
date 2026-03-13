
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<spring-interface-parameters.scad>
include<bearing-dimensions.scad>
include<sliding-rod-dimensions.scad>

include<carriage-parameters.scad>
include<carriage-interface-parameters.scad>

include<spring-dimensions.scad>


module spring_interface(clearance=0.2)
{

    // carriage interface
    _int_d = sr_d+0.5;
    _int_D = sb_D-clearance;
    _int_h = ((car_int_g_outer+2*car_int_offset)-(2*car_wt+2*sb_h+car_bearing_spacing))/2-1;

    tubepp(D=_int_D,d=_int_d,h=_int_h);

    // ring
    _ring_D = _int_D+2*si_wt;
    translate([0,0,_int_h])
        tubepp(D=_ring_D,d=_int_d, h=si_bt);

    // spring interface
    translate([0,0,_int_h+si_bt])
        difference()
        {
            cylinderpp(d=_ring_D, h=si_bt, align="");
            cylinderpp(d1=spring_D+2*clearance, d2=spring_D+2*clearance+2*si_bt, h=si_bt, align="z");
            cylinderpp(d=_int_d, h=3*_int_h, align="");
        }
    echo(_int_d);

    

}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
spring_interface();


