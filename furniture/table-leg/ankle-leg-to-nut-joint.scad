use<../../lib/deez-nuts/deez-nuts.scad>
use<../../lib/solidpp/solidpp.scad>

use<leg-interface.scad>
use<../../utils/washer-to-nut-transition.scad>

module ankle(   leg_side,
                leg_mount_height,
                leg_bottom_thickness,
                wall_thickness,
                bolt_descriptor,
                bolt_standard="DIN933",
                nut_standard="DIN934",
                screw_descriptor="M3.5x20",
                screw_standard="LUXPZ",
                washer_thickness=undef,
                washer_diameter=undef,
                is_washer_insertable=false,
                clearance=0.1,
                bevel=0,
                nut_side_to_side_override=undef,
                nut_height_override=undef,
                has_reinforcemnt=true,
                reinforcement_offset=1,
                leg_interface_width=1,
                leg_interface_depth=0.5)
{
    // TODO check mutex groups for nut dimensions

    // TODO add teeth for leg dimension variations

    descriptor_data = deez_nuts_parse_descriptor(bolt_descriptor);
    bolt_l = descriptor_data[1];
    fastener_d = descriptor_data[0];

    difference()
    {
        _a = leg_side+2*wall_thickness;
        _z = leg_mount_height+leg_bottom_thickness+bolt_l;
        // main shape
        cubepp([_a, _a, _z], align="z", mod_list=[bevel_bases(bevel_bottom=bevel), round_edges(r=wall_thickness)]);

        // hole for the leg
        translate([0,0,_z+clearance])
            cubepp([leg_side+2*clearance, leg_side+2*clearance, leg_mount_height+2*clearance], align="Z");

        // hole for the bolt
        rotate([0,180,0])
            translate([0,0,clearance])
                bolt_hole(  standard=bolt_standard,
                            descriptor=bolt_descriptor, 
                            align="m", 
                            clearance=clearance);

        // nut hole
        if (is_undef(nut_side_to_side_override) && is_undef(nut_height_override))
        {
            nut_hole(   d=fastener_d,
                        standard=nut_standard,
                        clearance=clearance);
        }
        else
        {
            basic_nut_hole( d=nut_side_to_side_override,
                            h=nut_height_override,
                            clearance=clearance);
        }

        // washer hole(s)
        if (!is_undef(washer_diameter) && !is_undef(washer_thickness))
        {
            nut_h = get_nut_height(d=fastener_d, standard=nut_standard);
            translate([0,0,nut_h])
            {
                // hole for the washer
                cylinderpp(d=2*clearance+washer_diameter, h=2*clearance+washer_thickness, align="z");

                // hole for inserting the washer
                if (is_washer_insertable)
                {
                    cubepp([_a,
                            2*clearance+washer_diameter,
                            2*clearance+washer_thickness],
                            align="xz");
                }
            }

            // add washer transition
            // TODO manage the nut standard to nut_side_to_side dimension conversion
            translate([0, 0, nut_h])
                rotate([180, 0, 0])
                    rotate([0, 0, 90])
                        washer_to_nut_transition(   washer_diameter=2*clearance+washer_diameter,
                                                    nut_side_to_side=2*clearance+nut_side_to_side_override,
                                                    step_height=0.2);
        }

        // mounting holes to the leg
        mirrorpp([1,1,0], true)
            mirrorpp([0,1,0], true)
                translate([ 0,
                            -leg_side/2-wall_thickness,
                            leg_mount_height/2+leg_bottom_thickness+bolt_l])
                    rotate([90,0,0])
                        screw_hole( standard=screw_standard,
                                    descriptor=screw_descriptor,
                                    align="t");
        
        /*
        //mirrorpp([1,1,0], true)
        mirrorpp([0,1,0], true)
            translate([ 0,
                        -leg_side/2-wall_thickness,
                        leg_mount_height/3+leg_bottom_thickness+bolt_l])
                rotate([90,0,0])
                    screw_hole( standard=screw_standard,
                                descriptor=screw_descriptor,
                                align="t");
        
        mirrorpp([1,0,0], true)
            translate([ -leg_side/2-wall_thickness,
                        0,
                        2*leg_mount_height/3+leg_bottom_thickness+bolt_l])
                rotate([0,-90,0])
                    screw_hole( standard=screw_standard,
                                descriptor=screw_descriptor,
                                align="t");
        */

        // reinforcements
        if (has_reinforcemnt)
        {
            nut_h = get_nut_height(d=fastener_d, standard=nut_standard);
            _washer_height = is_undef(washer_diameter) || is_undef(washer_thickness) ? 0 : washer_thickness;
            _h = leg_bottom_thickness+bolt_l-nut_h-(_washer_height)-2*reinforcement_offset;
            _d = washer_diameter-fastener_d;
            //bolt_head_height = get_bolt_head_height(standard=bolt_standard,
            //                                        descriptor=bolt_descriptor);
            translate([0,0,reinforcement_offset+nut_h+_washer_height])
                tubepp(d=_d, D=_d+0.2, h=_h);
        }
    }

    // leg interface
    translate([0,0,leg_bottom_thickness+bolt_l])
        leg_interface(  leg_side = leg_side,
                        interface_height = leg_mount_height,
                        interface_width = leg_interface_width,
                        interface_depth = leg_interface_depth,
                        clearance=clearance);

}
