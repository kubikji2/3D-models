include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>

module ankle(leg_side, leg_mount_height, leg_bottom_thickness, wall_thickness, bolt_descriptor, bolt_standard="DIN933", nut_standard="DIN934", washer_thickness=undef, washer_diameter=undef, is_washer_insertable=true, clearance=0.1, bevel=0)
{

    difference()
    {
        descriptor_data = deez_nuts_parse_descriptor(bolt_descriptor);
        bolt_l = descriptor_data[1];
        fastener_d = descriptor_data[0];
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

        // nut holde
        nut_hole(   d=fastener_d,
                    standard=nut_standard,
                    clearance=clearance);

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
        }
    }

}
