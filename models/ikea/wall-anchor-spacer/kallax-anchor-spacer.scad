include<wall-anchor-spacer.scad>

kallax_width = 45;
kallax_height = 40;
kallax_diameter = 15;
kallax_height_off = 8.5;

$fa = 5;
$fs = 0.1;

module kallax_anchor_spacer(thickness)
{
    wall_anchor_spacer( width=kallax_width,
                        height=kallax_height,
                        thickness=thickness,
                        diameter=kallax_diameter,
                        height_off=kallax_height_off);
}


kallax_anchor_spacer(12);