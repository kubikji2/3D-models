include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>

include<leg-interface.scad>

module hip( leg_side,
            wall_thickness,
            wall_height,
            bottom_thickness,
            bottom_offset,
            screw_descriptor="M3.5x20",
            screw_standard="LUXPZ",
            reinfocement_width=undef,
            has_rounded_corners=true,
            clearance=0.1,
            leg_interface_width=1,
            leg_interface_depth=0.5)
{
    // TODO add teeth for leg dimension variations

    _reinforcement_width = is_undef(reinfocement_width) ? wall_thickness : reinfocement_width;

    difference()
    {
        // top part
        union()
        {
            translate([0,0,bottom_thickness])
                difference()
                {
                    // outer shell
                    cubepp([2*wall_thickness+leg_side,
                            2*wall_thickness+leg_side,
                            wall_height],
                            align="z",
                            mod_list=[round_edges(r=wall_thickness)]);

                    // space for the hole
                    cubepp([2*clearance+leg_side,
                            2*clearance+leg_side,
                            3*wall_height], align="");
                }

            // flat part
            cubepp([2*bottom_offset + 2*wall_thickness + leg_side,
                    2*bottom_offset + 2*wall_thickness + leg_side,
                    bottom_thickness],
                    mod_list=has_rounded_corners ? [round_edges(r=bottom_offset)] : [],
                    align="z");
        }

        // mounting holes to the table
        mirrorpp([1,1,0], true)
            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                    translate([leg_side/2+wall_thickness+bottom_offset/2,leg_side/4,bottom_thickness])
                        screw_hole( standard=screw_standard,
                                    descriptor=screw_descriptor,
                                    align="t");
        
        // mounting holes to the leg
        mirrorpp([1,1,0], true)
            mirrorpp([0,1,0], true)
                translate([ 0,
                            -leg_side/2-wall_thickness,
                            bottom_thickness+wall_height/2])
                    rotate([90,0,0])
                        screw_hole( standard=screw_standard,
                                    descriptor=screw_descriptor,
                                    align="t");

    }

    // reinforcements
    mirrorpp([1,1,0], true)
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([leg_side/2+clearance,-leg_side/2,0])
                    hull()
                    {
                        cubepp([wall_thickness+bottom_offset-clearance,
                                _reinforcement_width,
                                bottom_thickness]);
                        cubepp([wall_thickness,
                                _reinforcement_width,
                                bottom_thickness+wall_height]);
                    }
    
    // leg interface
    translate([0,0, bottom_thickness])
        leg_interface(  leg_side = leg_side,
                        interface_height = wall_height,
                        interface_width = leg_interface_width,
                        interface_depth = leg_interface_depth,
                        clearance=clearance);

}
