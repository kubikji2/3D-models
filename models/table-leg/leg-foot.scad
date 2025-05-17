include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>

// convert the cylinder r/d from being being outradius to inradius, 
// i.e. resulting n-sided prism is no longe inscribed, but outscribed to cylinder
function outradius_to_inradius(r, fn=6) = r/cos(360/(2*fn));


module table_leg_foot(leg_side, foot_height, bolt_descriptor, bolt_standard="DIN933", bevel=0)
{

    _d = outradius_to_inradius(leg_side, 8);

    difference()
    {
        rotate([0,0,45/2])
            cylinderpp(d=_d, h=foot_height, $fn=8, mod_list=[bevel_bases(bevel_top=bevel)]);

        // hole for the bolt head
        translate([0,0,foot_height])
            rotate([0,180,0])
                bolt_hole(descriptor=bolt_descriptor, standard=bolt_standard, align="m");

    }

}
