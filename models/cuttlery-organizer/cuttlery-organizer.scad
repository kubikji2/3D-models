include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>

module fastener_pair(   fastener_d,
                        bolt_standard,
                        bolt_length,
                        nut_standard,
                        clearance
                        )
{
    rotate([-90,0,0])
    rotate([0,0,90])
    translate([0,0,-bolt_length/2])
    {
        // bolt hole
        bolt_hole(  descriptor=str("M",fastener_d,"x",bolt_length),
                    standard=bolt_standard,
                    clearance=clearance,
                    align="b",
                    hh_off=bolt_length,
                    sh_off=1);

        // nut hole
        nut_hole(   d=fastener_d,
                    standard=nut_standard,
                    align="b",
                    clearance=clearance,
                    s_off=10);
    }
}



module cuttlery_segment(width,
                        height,
                        length,
                        wall_thickness,
                        fastener_d,
                        bolt_standard,
                        bolt_length,
                        nut_standard,
                        fastener_offset,
                        has_left_interface=true,
                        has_right_interface=true,
                        clearance=0.1,
                        rounding_diameter=undef
)
{
    difference()
    {
        // overall hole
        cubepp([width, length, height], align="z");

        // capsule hole
        _rounding_diameter = is_undef(rounding_diameter) ? max(width, height) : rounding_diameter ;
        translate([0,0,wall_thickness])
            cubepp([width-2*wall_thickness,
                    length-2*wall_thickness,
                    2*height],
                    align="z",
                    mod_list=[round_edges(d=_rounding_diameter-2*wall_thickness-1, axes="xyz")]);

        if (has_left_interface)
        {
            mirrorpp([0,1,0], true)
                translate([width/2,length/2-bolt_length,fastener_offset])
                    rotate([0,0,45])
                        fastener_pair( fastener_d=fastener_d,
                                        bolt_standard=bolt_standard,
                                        bolt_length=bolt_length,
                                        nut_standard=nut_standard,
                                        clearance=clearance);
        }

        if (has_right_interface)
        {
            mirrorpp([0,1,0], true)
                translate([-width/2,length/2-bolt_length,fastener_offset])
                    rotate([0,0,45])
                        fastener_pair( fastener_d=fastener_d,
                                        bolt_standard=bolt_standard,
                                        bolt_length=bolt_length,
                                        nut_standard=nut_standard,
                                        clearance=clearance);
            
        }
        
    }

}