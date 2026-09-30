
sedlak1_mbl_x = 300;
sedlak1_mbl_y = 200;
sedlak1_mbl_z = 300;

sedlak1_mountpoints_h = 6.5;
sedlak1_mountpoints_bolt_l = 10;


sedlak1_cable_hole_w = 20;
sedlak1_anchoring_offset = 20;


// plating
include<../makerbeam-constants.scad>
include<../makerbeam-corner-parameters.scad>

sedlak1_level_1_h = 120;
sedlak1_level_1_plate_h = mb1010_a+sedlak1_level_1_h+mb1010_a/2;
sedlak1_level_1_plate_top_offset = mb1010_a/2;

sedlak1_level_2_h = 120;
sedlak1_level_2_plate_h = mb1010_a/2+sedlak1_level_2_h+mb1010_a/2;
sedlak1_level_2_plate_top_offset = mb1010_a/2;
sedlak1_level_2_plate_bottom_offset = -mb1010_a/2;

sedlak1_level_3_plate_h = (sedlak1_mbl_z+2*mbc_wt+2*mb1010_a)-sedlak1_level_1_plate_h-sedlak1_level_2_plate_h;
sedlak1_level_3_plate_bottom_offset = -mb1010_a/2;