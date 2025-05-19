
include<hip-leg-to-desc-joint.scad>
include<leg-foot.scad>
include<ankle-leg-to-nut-joint.scad>

leg_side = 44;

selected_part = "all"; // ["all", "hip", "ankle", "foot"]

if (selected_part == "all" || selected_part=="hip")
{
    translate([0,0,selected_part == "all" ? 100 : 0])
    rotate([ selected_part == "all" ? 180 : 0,0,0])
    hip(    leg_side = leg_side,
            wall_thickness = 3,
            wall_height = 20,
            bottom_thickness = 5,
            bottom_offset = 12,
            screw_descriptor="M3.5x20",
            screw_standard="LUXPZ",
            reinfocement_width=undef,
            has_rounded_corners=true,
            clearance=0.1);
}


if (selected_part == "all" || selected_part == "ankle")
{
    translate([0,0,selected_part == "all" ? 20 : 0])
    ankle(  leg_side=44,
            leg_mount_height=10,
            leg_bottom_thickness=0,
            wall_thickness=3,
            washer_thickness=3,
            washer_diameter=30,
            bolt_descriptor="M10x20",
            bolt_standard="DIN933",
            nut_standard="DIN934",
            //is_washer_insertable=true,
            clearance=0.1,
            bevel=5,
            nut_height_override=8.2,
            nut_side_to_side_override=15.9);
}


if (selected_part == "all" || selected_part == "foot")
{
    table_leg_foot( leg_side=leg_side,
                    foot_height=10,
                    bolt_descriptor="M10x20",
                    bevel=5,
                    bolt_head_side_to_side_override=16.8,
                    bolt_head_hight_override=6.5);
}