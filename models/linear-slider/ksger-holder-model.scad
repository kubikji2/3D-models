use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<ksger-holder-parameters.scad>


module ksger_soldering_iron_holder_interface()
{

    _D = kh_int_max_diameter;

    difference()
    {
        
        union()
        {
            // upper half-ring
            translate([0,0,kh_int_ring_spacing])
            {
                linear_extrude(kh_int_ring_thickness)
                offset(kh_int_ring_offseting)
                offset(-kh_int_ring_offseting)
                difference()
                {
                    circlepp(d=_D);
                    circlepp(d=kh_int_top_ring_d);
                    squarepp([kh_int_top_ring_d,kh_int_top_ring_d-2*kh_int_tight_fit], align="x");
                }
            }

            // lower ring
            tubepp( d = kh_int_bottom_ring_d,
                    D = _D,
                    h = kh_int_ring_thickness,
                    align = "Z");
            
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

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
ksger_soldering_iron_holder_interface();