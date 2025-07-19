include<shelf-leg.scad>

$fa = 1;
$fs = $preview ? 0.1 : 0.01;

// left segment
leg_segment(length=100,
            shelf_height=250,
            support_length=30,
            support_thickness=10,
            leg_thickness=20,
            hole_height_border=20,
            hole_length_border=20,
            connectors_diameter=3,
            screw_standard="LUXPZ",
            screw_descriptor="M3x20",
            screw_offset=10,
            interface_thickness=8,
            interface_length=30,
            shelf_thickness=12.4,
            tightening_tool_diameter=8,
            is_first=false,
            is_last=false);

// right segment

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