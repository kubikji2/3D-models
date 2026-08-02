use<../../../lib/solidpp/solidpp.scad>
use<adjustible-leg.scad>

$fs = 0.1;
$fa = 5;

adjustible_leg( leg_height=45,
                leg_diameter=50,
                foot_height=10,
                mounting_bolt_wall_thickness=4,
                mounting_bolt_head_diameter=14,
                washer_thickness=1.5,
                washer_diameter=29.5,
                foot_bevel = 5,
                leg_bevel = 5,
                is_foot_reinforced = false
                );

//%translate([0,0,45])
//    cylinderpp(d=8, h=20, align="Z");