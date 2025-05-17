
include<hip-leg-to-desc-joint.scad>
include<leg-foot.scad>

leg_side = 44;


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


table_leg_foot(leg_side=leg_side, foot_height=10, bolt_descriptor="M10x20", bevel=5);