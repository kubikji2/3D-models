
include<../../../lib/deez-nuts/deez-nuts.scad>
include<../../../lib/solidpp/solidpp.scad>


module generic_psu_holder(
    length,
    psu_height,
    psu_width,
    is_through,
    wall_thickness,
    mounting_wall_thickness,
    screw_offset,
    screw_standard,
    screw_diameter,
    screw_length,
    clearance=0.15)
{
    l = length + (is_through ? 0 : wall_thickness);
    hole_l = length + clearance;
    h = 2*wall_thickness  + psu_height;
    w = 2*wall_thickness + psu_width;
    
    difference()
    {   
        // main geometry
        cubepp([w,l,h], align="yz");

        // add hole
        translate([0,0.01,wall_thickness-clearance])
            cubepp([psu_width+2*clearance,
                    2*hole_l,
                    psu_height+2*clearance],
                    align="z");
        if (!is_through)
        {
            translate([0,0.01,2*wall_thickness-clearance])
                cubepp([psu_width+2*clearance-2*wall_thickness,
                        3*hole_l,
                        psu_height+2*clearance-2*wall_thickness],
                        align="z");
        }
    }

    
    // fastener places
    screw_descriptor = str("M", screw_diameter, "x",  screw_length);
    fw = get_screw_head_diameter(descriptor=screw_descriptor,
                                standard=screw_standard);
    rr = min(fw/2 + screw_offset, l/2);
    mirrorpp([1,0,0], true)
    translate([w/2,0,h-mounting_wall_thickness])
    difference()
    {
        translate([-rr,0,0])
        // main shape
        cubepp([screw_offset+fw/2+2*rr, l, mounting_wall_thickness],
                mod_list=[round_edges(r=rr)]);

        // cut left rounding
        cubepp([2*rr, 3*l, 3*mounting_wall_thickness], align="X");
        
        // hole for the screws\
        _s_off = l >= 20 ? screw_offset + fw/2 : l/2;
        translate([screw_offset+fw/2,_s_off,0])
            rotate([0,180,0])
                screw_hole(descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
        
        if(l >= 20)
            translate([screw_offset+fw/2,l-_s_off,0])
                rotate([0,180,0])
                    screw_hole(descriptor=screw_descriptor,
                                standard=screw_standard,
                                align="t");
    }

}


module psu_back_holder( length,
                        psu_height,
                        psu_width,
                        wall_thickness,
                        mounting_wall_thickness,
                        screw_offset,
                        screw_standard,
                        screw_diameter,
                        screw_length,
                        clearance=0.15)
{
    psu_holder( length,
                psu_height,
                psu_width,
                true,
                wall_thickness,
                mounting_wall_thickness,
                screw_offset,
                screw_standard,
                screw_diameter,
                screw_length,
                clearance);
    
   
}