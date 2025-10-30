use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

use<../../../../utils/hexagonal-serration.scad>

PLATSA_INTERFACE_DIAMETER = 8;

module platsa_adjustible_leg(   leg_height,
                                leg_diameter,
                                foot_height,
                                mounting_bolt_wall_thickness,
                                mounting_bolt_head_diameter,
                                mounting_bolt_diameter = PLATSA_INTERFACE_DIAMETER,
                                washer_thickness=undef,
                                washer_diameter=undef,
                                adjusting_bolt_standard = "DIN933",
                                adjusting_bolt_descriptor = "M10x20",
                                //adjusting_bolt_head_hight_override=undef,
                                //adjusting_bolt_head_side_to_side_override=undef,
                                adjusting_nut_standard = "DIN934",
                                adjusting_nut_side_to_side_override=undef,
                                adjusting_nut_height_override=undef,
                                washer_thickness=undef,
                                washer_diameter=undef,
                                is_washer_insertable=false,
                                foot_bevel = 0,
                                leg_bevel = 0,
                                fasteners_clearance = 0.2)
{

    difference()
    {
        union()
        {
            // foot
            /*
            cylinderpp( d=leg_diameter,
                        h=foot_height,
                        align="z",
                        mod_list=[bevel_bases(bevel_top=foot_bevel)]);
            */
            // leg piece
            ///*
            translate([0,0,foot_height])
                cylinderpp( d=leg_diameter,
                            h=leg_height-foot_height,
                            align="z",
                            mod_list=[bevel_bases(bevel_bottom=leg_bevel)]);
            //*/
        }

        // middle cut
        translate([0,0,foot_height])
            cylinderpp( r=leg_diameter,
                        h=0.01,
                        align="");
        
        // adjustable bolt
        translate([0,0,foot_height])
            rotate([180,0,0])
                difference()
                {
                    bolt_hole(  standard=adjusting_bolt_standard,
                                descriptor=adjusting_bolt_descriptor,
                                align="m",
                                clearance=fasteners_clearance);
                    
                    _h = get_bolt_head_height(standard=adjusting_bolt_standard,
                                            descriptor=adjusting_bolt_descriptor)+fasteners_clearance;

                    r = get_bolt_head_diameter( standard=adjusting_bolt_standard,
                                                descriptor=adjusting_bolt_descriptor,
                                                is_inradius=true)*(sqrt(3)/2)/2 + fasteners_clearance;
                    _n = floor(r/fasteners_clearance)/4;

                    rotate([0,0,30])
                        hexagonal_seration( height=_h,
                                            inradius=r,
                                            n_serration_per_side=_n,
                                            serration_bottom_d=1.5*fasteners_clearance,
                                            serration_top_d=2*fasteners_clearance);
                }
        
        // adjustable nut
        translate([0, 0, foot_height+fasteners_clearance])
            difference()
            {
                // nut
                _d = deez_nuts_parse_descriptor(adjusting_bolt_descriptor)[0];
                nut_hole(   d=_d,
                            standard=adjusting_nut_standard,
                            clearance=fasteners_clearance);
                // serration
                _h = get_nut_height(d=_d,
                                    standard=adjusting_nut_standard)+2*fasteners_clearance;
                _r = get_nut_diameter(  d=_d,
                                        standard=adjusting_nut_standard,
                                        is_inradius=true)/2+fasteners_clearance;
                _n = floor(_r/fasteners_clearance)/4;

                translate([0,0,-fasteners_clearance])
                rotate([0,0,30])
                    hexagonal_seration(     height=_h,
                                            inradius=_r,
                                            n_serration_per_side=_n,
                                            serration_bottom_d=1.5*fasteners_clearance,
                                            serration_top_d=2*fasteners_clearance);

            }

        // TODO washer

        // interface holes
        translate([0,0,foot_height])
        {
            // add interface shaft hole
            cylinderpp( d=mounting_bolt_diameter+2*fasteners_clearance,
                        h=leg_height,
                        align="z");

            // add interface head hole
            cylinderpp( d=mounting_bolt_head_diameter+2*fasteners_clearance,
                        h=leg_height-foot_height-mounting_bolt_wall_thickness,
                        align="z");
        }
    }
}