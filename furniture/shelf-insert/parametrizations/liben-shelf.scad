include<../shelf-leg.scad>

$fa = 1;
$fs = $preview ? 0.1 : 0.01;

part_name = "top"; // ["top", "bottom"]

is_first = true;
is_last = false;

if (part_name=="top")
{
    leg_segment(
        length=100,
        shelf_height=250,
        support_length=30,
        support_thickness=10,
        leg_thickness=10,
        hole_height_border=10,
        hole_length_border=10,
        connectors_diameter=3,
        screw_standard="LUXPZ",
        screw_descriptor="M3x20",
        screw_offset=10,
        interface_thickness=8,
        interface_length=30,
        shelf_thickness=12.4,
        tightening_tool_diameter=8,
        is_first=is_first,
        is_last=is_last);
}
else if (part_name=="bottom")
{
    leg_segment(
        length=100,
        shelf_height=200,
        support_length=30,
        support_thickness=10,
        leg_thickness=10,
        hole_height_border=10,
        hole_length_border=10,
        connectors_diameter=3,
        screw_standard="LUXPZ",
        screw_descriptor="M3x20",
        screw_offset=10,
        interface_thickness=8,
        interface_length=30,
        shelf_thickness=12.4,
        tightening_tool_diameter=8,
        is_first=is_first,
        is_last=is_last);
}