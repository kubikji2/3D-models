include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>


module shelf_interface(shelf_thickness, wall_thickness, leg_length, interface_length)
{
    // shelf thickness interface
    hull()
    {
        cylinderpp(d=wall_thickness, h=leg_length, align="XYz");
        translate([0,shelf_thickness,0])
            cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
    }

    // length interface
    translate([0,shelf_thickness,0])
    hull()
    {
        cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
        translate([interface_length,0,0])
            cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
    }
    %cubepp([interface_length,shelf_thickness,leg_length]);
}

module leg_segment( length,
                    shelf_height,
                    leg_thickness,
                    support_length,
                    support_thickness,
                    hole_height_border,
                    hole_length_border,
                    connectors_diameter,
                    screw_descriptor,
                    screw_standard,
                    screw_offset,
                    interface_thickness,
                    interface_length,
                    shelf_thickness,
                    tightening_tool_diameter,
                    is_first=false,
                    is_last=false,
                    clearance_tight=0.1,
                    clearance_loose=0.2)
{

    difference()
    {
        union()
        {
            // main shape
            // - vertical wall
            cubepp( [support_length+interface_thickness-support_thickness/2, support_thickness, length],
                    align="xYz");
            translate([support_length+interface_thickness-support_thickness/2,0,0])
                cylinderpp(d=support_thickness,h=length, align="Yz");

            // - horizontal
            cubepp([leg_thickness, shelf_height, length], align="xYz");
            
            // - interface
            translate([interface_thickness,0,0])
                shelf_interface(shelf_thickness=shelf_thickness,
                                wall_thickness=interface_thickness,
                                leg_length=length,
                                interface_length=interface_length);
        }

        // remove waste material
        if ( (shelf_height-2*hole_height_border-leg_thickness) > 0 && (length-2*hole_length_border) > 0 )
        {
            translate([0,-hole_height_border-leg_thickness,hole_length_border])
                cubepp([3*leg_thickness,
                        shelf_height-2*hole_height_border-leg_thickness,
                        length-2*hole_length_border],
                        align="Yz",
                        mod_list=[round_edges(axes="yz", r=20)]);
        }

        // add top screw-rod related holes
        translate([leg_thickness/2,
                    -leg_thickness-hole_height_border/2,
                    0])
        {
            // screw-rod hole
            cylinderpp(d=connectors_diameter+2*clearance_loose,h=3*length, align="");
            
            // nut hole
            if (is_first)
            {
                nut_hole(   d=connectors_diameter,
                            standard="DIN985",
                            clearance=clearance_tight);
            }

            // tightening tool hole
            if (is_last)
            {
                _h = get_nut_height(d=connectors_diameter,
                                    standard="DIN985");
                translate([0,0,length])
                    cylinderpp(d=tightening_tool_diameter+2*clearance_loose,h=2*_h,align="");
            }

        }

        // add bottom screw-rod related hole
        translate([leg_thickness/2,
                    -shelf_height+hole_height_border/2,
                    0])
        {
            // screw-rod hole
            cylinderpp(d=connectors_diameter+2*clearance_loose,h=3*length, align="");
            
            // nut hole
            if (is_first)
            {
                nut_hole(   d=connectors_diameter,
                            standard="DIN985",
                            clearance=clearance_tight);
            }

            // tightening tool hole
            if (is_last)
            {
                _h = get_nut_height(d=connectors_diameter,
                                    standard="DIN985");
                translate([0,0,length])
                    cylinderpp(d=tightening_tool_diameter+2*clearance_loose,h=2*_h,align="");
            }
        }
        

        // screws
        if(is_first)
        {
            translate([ support_length-screw_offset+interface_thickness,
                        -leg_thickness,
                        screw_offset])
                rotate([90,0,0])
                    screw_hole( descriptor=screw_descriptor,
                                standard=screw_standard,
                                align="t");
        }

        if (is_last)
        {
            translate([ support_length-screw_offset+interface_thickness,
                        -leg_thickness,
                        length-screw_offset])
                rotate([90,0,0])
                    screw_hole( descriptor=screw_descriptor,
                                standard=screw_standard,
                                align="t");
        }
        
    }
}


//shelf_interface(shelf_thickness=12,
//                wall_thickness=5,
//                leg_length=200,
//                interface_length=20);

//leg_segment(length=100,
//            shelf_height=250,
//            support_length=30,
//            leg_thickness=10,
//            hole_height_border=20,
//            hole_length_border=20,
//            connectors_diameter=3,
//            screw_standard="LUXPZ",
//            screw_descriptor="M3x20",
//            screw_offset=10,
//            interface_thickness=5,
//            interface_length=20,
//            shelf_thickness=12,
//            tightening_tool_diameter=8,
//            is_first=false,
//            is_last=true);

// test print
//leg_segment(length=10,
//            shelf_height=40,
//            support_length=30,
//            support_thickness=10,
//            leg_thickness=20,
//            hole_height_border=20,
//            hole_length_border=20,
//            connectors_diameter=3,
//            screw_standard="LUXPZ",
//            screw_descriptor="M3x20",
//            screw_offset=10,
//            interface_thickness=8,
//            interface_length=30,
//            shelf_thickness=12.4,
//            tightening_tool_diameter=8,
//            is_first=false,
//            is_last=false);