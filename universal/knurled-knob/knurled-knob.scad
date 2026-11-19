use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

module knurled_knob(
    d = 12,
    h = 6,
    bt = 3,
    wings_gauge = 18,
    wings_d = 5,
    bolt_standard = "DIN933",
    bolt_descriptor = "M3x16",
    rounding_d = 1,
    neck_d = 8,
    neck_h = 8.6,
)
{

    difference()
    {
        union()
        {
            hull()
            {
                cylinderpp(d=d, h=h, mod_list=[rounding(rounding_d)]);

                mirrorpp([1,0,0],true)
                    translate([wings_gauge/2,0,0])
                     cylinderpp(d=wings_d, h=h, mod_list=[rounding(rounding_d)]);

            }
            cylinderpp(d=neck_d, h=neck_h, align="Z");
        }

        translate([0,0,bt])
            bolt_hole(standard=bolt_standard, descriptor=bolt_descriptor, align="m", hh_off=h);
    }
}

$fa = $preview ? 10 : 5;
$fs = $preview ? 1 : 0.5;
knurled_knob();