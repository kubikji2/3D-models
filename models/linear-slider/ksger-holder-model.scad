use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<ksger-holder-parameters.scad>


module ring_with_stopper(h, D, d, stopper)
{
    linear_extrude(h)
        offset(kh_int_ring_offset_smoothing)
            offset(-kh_int_ring_offset_smoothing)
                difference()
                {
                    circlepp(d=D);
                    circlepp(d=d);
                    squarepp([d,d-2*stopper], align="x");
                }
}

module ksger_soldering_iron_holder_interface()
{

    _D = kh_int_max_diameter;

    difference()
    {
        
        union()
        {
            // upper half-ring
            translate([0,0,kh_int_ring_spacing])
                ring_with_stopper(
                    h=kh_int_ring_thickness,
                    D=_D,
                    d=kh_int_top_ring_d,
                    stopper=kh_int_top_ring_stopper);
            

            // lower half-ring
            translate([0,0,-kh_int_ring_thickness])
                ring_with_stopper(
                        h=kh_int_ring_thickness,
                        D=_D,
                        d=kh_int_bottom_ring_d,
                        stopper=kh_int_bottom_ring_stopper);
            
            // ring holder
            difference()
            {
                __h = kh_int_ring_thickness+kh_int_ring_spacing+kh_int_ring_thickness;
                translate([0,0,-kh_int_ring_thickness])
                    cubepp([kh_int_max_diameter/2,
                            kh_int_max_diameter,
                            __h],
                            align="Xz");
                
                // soldering iron cut
                translate([0,0,-kh_int_ring_thickness])
                    cylinderpp( d=kh_int_max_diameter,
                                h=3*__h);
                // middle cut
                cubepp([kh_int_max_diameter,kh_int_max_diameter,kh_int_ring_spacing], align="Xz");
            }
        }
    }
}

module ksger_soldering_iron_holder()
{
    _a = car_int_gauge + 2*kh_plate_off;

    // plate
    difference()
    {
        union()
        {
            cubepp( [kh_plate_t,_a,_a],
                    align="X",
                    mod_list=[round_edges(r=kh_plate_off, axes="yz")]);

            // soldering iron interface
            translate([kh_int_max_diameter/2,0,-car_int_gauge/2])
                ksger_soldering_iron_holder_interface();
                
        }

        mirrorpp([0,1,0], true)
            mirrorpp([0,0,1], true)
                translate([0,car_int_gauge/2,car_int_gauge/2])
                    rotate([0,90,0])
                        //coordinate_frame()
                        bolt_hole(  standard=kh_bolt_standard,
                                    descriptor=kh_bolt_descriptor,
                                    align="m",
                                    hh_off=kh_bolt_l);
    }



}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
ksger_soldering_iron_holder();