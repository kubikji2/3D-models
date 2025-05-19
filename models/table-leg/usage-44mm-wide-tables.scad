
include<hip-leg-to-desc-joint.scad>
include<leg-foot.scad>
include<ankle-leg-to-nut-joint.scad>

leg_side = 44;

$fn = $preview ? 36 : 72;

/*
translate([0,0,100])
rotate([180,0,0])
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
*/

/*
translate([0,0,20])
ankle(  leg_side=44,
        leg_mount_height=10,
        leg_bottom_thickness=0,
        wall_thickness=3,
        washer_thickness=2.4,
        washer_diameter=30,
        bolt_descriptor="M10x20",
        bolt_standard="DIN933",
        nut_standard="DIN934",
        is_washer_insertable=true,
        clearance=0.1,
        bevel=5);

*/
table_leg_foot( leg_side=leg_side,
                foot_height=10,
                bolt_descriptor="M10x20",
                bevel=5);
