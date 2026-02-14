use<solder-spool.scad>


$fn = $preview ? 36 : 144;

solder_spool(
    shaft_diameter=15,
    shaft_height=25,
    flange_thickness=3,
    flange_diameter=35,
    wall_thickness=1.5,
    inner_hole_diameter=11,
    solder_hole_diameter=2);