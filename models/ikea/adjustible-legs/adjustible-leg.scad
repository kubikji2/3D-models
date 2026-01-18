use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// for bolt heads and nut serrations
use<../../../utils/hexagonal-serration.scad>
// for nut to washer transiotion
use<../../../utils/washer-to-nut-transition.scad>


PLATSA_INTERFACE_DIAMETER = 8;

module adjustible_leg(  leg_height,
                        leg_diameter,
                        foot_height,
                        mounting_bolt_wall_thickness,
                        mounting_bolt_head_diameter,
                        mounting_bolt_diameter = PLATSA_INTERFACE_DIAMETER,
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
                        fasteners_clearance = 0.2,
                        is_foot_reinforced = true)
{

    adjustable_fastener_diameter = deez_nuts_parse_descriptor(adjusting_bolt_descriptor)[0];


    difference()
    {
        union()
        {
            // foot
            cylinderpp( d=leg_diameter,
                        h=foot_height,
                        align="z",
                        mod_list=[bevel_bases(bevel_top=foot_bevel)]);
            
            // leg piece
            translate([0,0,foot_height])
                cylinderpp( d=leg_diameter,
                            h=leg_height-foot_height,
                            align="z",
                            mod_list=[bevel_bases(bevel_bottom=leg_bevel)]);
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
                                                descriptor=adjusting_bolt_descriptor)*(sqrt(3)/2)/2 + fasteners_clearance;
                    _n = ceil(r/fasteners_clearance)/6;
                    
                    if (!$preview)
                        rotate([0,0,30])
                            hexagonal_serration( height=_h,
                                                inradius=r,
                                                n_serration_per_side=_n,
                                                serration_bottom_d=3*fasteners_clearance,
                                                serration_top_d=4*fasteners_clearance);
                }
        
        // adjustable nut
        translate([0, 0, foot_height+fasteners_clearance])
            difference()
            {
                // nut
                nut_hole(   d=adjustable_fastener_diameter,
                            standard=adjusting_nut_standard,
                            clearance=fasteners_clearance);
                // serration
                _h = get_nut_height(d=adjustable_fastener_diameter,
                                    standard=adjusting_nut_standard)+2*fasteners_clearance;
                _r = get_nut_diameter(  d=adjustable_fastener_diameter,
                                        standard=adjusting_nut_standard,
                                        is_circumscribed=false)/2+fasteners_clearance;
                _n = ceil(_r/fasteners_clearance)/6;

                if (!$preview)
                    translate([0,0,-2*fasteners_clearance])
                        rotate([0,0,30])
                            hexagonal_serration(     height=_h,
                                                    inradius=_r,
                                                    n_serration_per_side=_n,
                                                    serration_bottom_d=3*fasteners_clearance,
                                                    serration_top_d=4*fasteners_clearance);

            }

        // washer
        nut_h = get_nut_height( d=adjustable_fastener_diameter,
                                standard=adjusting_nut_standard);
        translate([0, 0, nut_h+foot_height+0.6+fasteners_clearance])
        if (!is_undef(washer_diameter) && !is_undef(washer_thickness))
        {

            // hole for the washer
            cylinderpp(d=2*fasteners_clearance+washer_diameter, h=2*fasteners_clearance+washer_thickness, align="z");

            // hole for inserting the washer
            if (is_washer_insertable)
            {
                cubepp([_a,
                        2*fasteners_clearance+washer_diameter,
                        2*fasteners_clearance+washer_thickness],
                        align="xz");
            }
            
            // add washer transition
            // TODO manage the nut standard to nut_side_to_side dimension conversion
            nut_side = is_undef(nut_side_to_side_override)
                            ?
                                get_nut_diameter(   d=adjustable_fastener_diameter,
                                                    standard=adjusting_nut_standard) + 2*fasteners_clearance
                            :
                                nut_side_to_side_override;
            rotate([180, 0, 0])
                rotate([0, 0, 90])
                    washer_to_nut_transition(   washer_diameter=2*fasteners_clearance+washer_diameter,
                                                nut_side_to_side=nut_side,
                                                step_height=0.2);
    
        }

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

        // foot reinforcement
        if (is_foot_reinforced)
        {
            // foot reinforcement
            // circular
            //fr_wt = 0.6;
            //_fr_bolt_head_d = get_bolt_head_diameter( standard=adjusting_bolt_standard,
            //                                        descriptor=adjusting_bolt_descriptor)*(sqrt(3)/2);
            //fr_d = adjustable_fastener_diameter+(_fr_bolt_head_d-adjustable_fastener_diameter)/2;
            //fr_h = foot_height-get_bolt_head_height(standard=adjusting_bolt_standard,
            //                                    descriptor=adjusting_bolt_descriptor)-fasteners_clearance;
            //translate([0,0,fr_wt])
            //    tubepp(D=fr_d,h=fr_h,t=0.11);

            // star-shaped
            //fr_wt = 0.6;
            //fr_d = get_bolt_head_diameter( standard=adjusting_bolt_standard,
            //                                        descriptor=adjusting_bolt_descriptor)*(sqrt(3)/2);
            ////fr_d = adjustable_fastener_diameter+(_fr_bolt_head_d-adjustable_fastener_diameter)/2;
            //fr_h = foot_height-get_bolt_head_height(standard=adjusting_bolt_standard,
            //                                    descriptor=adjusting_bolt_descriptor)-fasteners_clearance;
            //rotate([0,0,30])
            //    translate([0,0,fr_wt])
            //        for (i=[0:2])
            //        {
            //            rotate([0,0,60*i])
            //                cubepp([0.11, fr_d, fr_h], align="z");
            //        }
            
            // combination
            fr_wt = 0.6;
            fr_a = (get_bolt_head_diameter(  standard=adjusting_bolt_standard,
                                            descriptor=adjusting_bolt_descriptor)*(sqrt(3)/2)-
                    adjustable_fastener_diameter)/2;
            fr_h = foot_height-get_bolt_head_height(standard=adjusting_bolt_standard,
                                                descriptor=adjusting_bolt_descriptor)-fasteners_clearance;
            //rotate([0,0,30])
                translate([0,0,fr_wt])
                { 
                    for (i=[0:5])
                    {
                        rotate([0,0,60*i])
                            translate([adjustable_fastener_diameter/2,0,0])
                                cubepp([fr_a,0.11, fr_h], align="xz");
                        rotate([0,0,30+60*i])
                            cubepp([adjustable_fastener_diameter/2, 0.11, fr_h], align="z");
                    }
                    tubepp(d=adjustable_fastener_diameter, t=0.11, h=fr_h, align="z");
                
                }
        }
    }
}