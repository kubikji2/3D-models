include<wall-anchor-spacer.scad>

kallax_width = 30;
kallax_height = 20;
kallax_diameter = 10;

$fa = 5;
$fs = 0.1;

module kallax_anchor_spacer(thickness)
{
    wall_anchor_spacer( width=kallax_width,
                        height=kallax_height,
                        thickness=thickness,
                        diameter=kallax_diameter);
}


kallax_anchor_spacer(1.5);