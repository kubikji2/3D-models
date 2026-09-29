include<makerbeam-leg-parameters.scad>

use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

module makerbeam_leg(bolt_clearance=0.2)
{

    _nd = get_nut_diameter(d=mb1010_bolt_d,standard=ml_nut_standard);

    difference()
    {
        union()
        {
            cylinderpp(d=ml_D,h=ml_h, mod_list=[bevel_bases(bevel_top=max(0,(ml_D-mb1010_a)/2))]);
        }

        translate([0,0,ml_wt-bolt_clearance])
            cylinderpp(d=mb1010_bolt_d+2*bolt_clearance, h=ml_h, align="z");

        translate([0,0,ml_h-mb1010_bolt_l])
        nut_hole(   d=mb1010_bolt_d,
                    standard=ml_nut_standard,
                    clearance=bolt_clearance);
    }


}


$fn = $preview ? 36 : 72;
makerbeam_leg();