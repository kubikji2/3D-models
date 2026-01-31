
use<hole-clearance-tester.scad>

// parameters

diameter = 3;
height = 6;
min_clearance = 0;
max_clearance = 0.3;
clearance_increment = 0.05;

wall_thickness = 3;

$fn = $preview ? 30 : 120;

hole_clearance_tester(  base_diameter = diameter,
                        height = height,
                        min_clearance = min_clearance,
                        max_clearance = max_clearance,
                        clearance_increment = clearance_increment,
                        wall_thickness=wall_thickness);