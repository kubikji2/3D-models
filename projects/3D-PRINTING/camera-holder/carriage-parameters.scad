include<links-parameters.scad>
include<tightening-head-constants.scad>
include<rail-parameters.scad>

carriage_clearance = 0.25;

carriage_thickness = 8;//lnk_middle_part_t+lnk_nut_part_t;//th_spacing_d/2 - rail_neck_w;
//echo(carriage_thickness);

carriage_height = 20;
carriage_wt = 2;
carriage_top_offset = 1;