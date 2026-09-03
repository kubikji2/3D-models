rp_wheel_h = 7;
rp_wheel_clearance = 0.25;

rp_bc2hb_wheels_offset = 2;

rp_bracket_h = 7;

rp_ball_count = 15;
rp_part_clearance = 0.25;

// herringbode parameters
rp_hb_metric_module = 1.5;
rp_hb_n_teeth_big_wheel = 24;
rp_hb_pressure_angle = 20;
rp_hb_helix_angle = -30;
rp_hb_angular_resolution = 1;
rp_hb_width = 7;
rp_hb_layer_thickness = 1;
rp_hb_back_lash = 0.01;

// drive wheel params
include<nema17-dimensions.scad>

rp_hb_n_teeth_drive_wheel = 12;
rp_dw_shaft_d = nema17_shaft_d;
rp_dw_shaft_cut_t = nema17_shaft_cut_t;
rp_dw_ball_count = 6;








