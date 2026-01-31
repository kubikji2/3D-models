use<../../lib/deez-nuts/deez-nuts.scad>
use<../../lib/solidpp/solidpp.scad>

// convert the cylinder r/d from being being outradius to inradius, 
// i.e. resulting n-sided prism is no longe inscribed, but outscribed to cylinder
function outradius_to_inradius(r, fn=6) = r/cos(360/(2*fn));


module table_leg_foot(  leg_side,
                        foot_height,
                        bolt_descriptor,
                        bolt_standard="DIN933",
                        bevel=0,
                        bolt_head_hight_override=undef,
                        bolt_head_side_to_side_override=undef,
                        has_reinforcemnt=true,
                        reinforcement_offset=1,
                        clearance=0.1)
{

    _d = outradius_to_inradius(leg_side, 8);

    difference()
    {
        rotate([0,0,45/2])
            cylinderpp(d=_d, h=foot_height, $fn=8, mod_list=[bevel_bases(bevel_top=bevel)]);

       
        // reinforcements
        if (has_reinforcemnt)
        {
            descriptor_data = deez_nuts_parse_descriptor(bolt_descriptor);
            //bolt_l = descriptor_data[1];
            bolt_d = descriptor_data[0];
            bolt_head_height = get_bolt_head_height(standard=bolt_standard,
                                                    descriptor=bolt_descriptor);
            _h = foot_height-bolt_head_height-2*reinforcement_offset;
            translate([0,0,reinforcement_offset])
                tubepp(d=bolt_d, D=bolt_d+0.2, h=_h);
        }

        // hole for the bolt head
        translate([0,0,foot_height])
            if (is_undef(bolt_head_hight_override) && is_undef(bolt_head_side_to_side_override))
            {
                rotate([0,180,0])
                    bolt_hole(descriptor=bolt_descriptor, standard=bolt_standard, align="m");
            }
            else
            {
                translate([0,0,clearance])
                cylinderpp( d=outradius_to_inradius(bolt_head_side_to_side_override)+2*clearance,
                            h=bolt_head_hight_override+2*clearance,
                            align="Z",
                            $fn=6);
            }
    }

}
