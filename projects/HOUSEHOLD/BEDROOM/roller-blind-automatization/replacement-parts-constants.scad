rp_wheel_h = 7;
rp_wheel_clearance = 0.25;

rp_bc2hb_wheels_offset = 2;

rp_bracket_h = 7;

rp_ball_count = 15;
rp_part_clearance = 0.25;

// herringbone parameters
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


// bracket mountpoints
rp_bm_g = 24; // gauge
rp_bm_from_center = 22; // distance from the roller blind axis
rp_bm_t = 5;


rp_plate_wt = 3;
rp_plate_t = 5;

rp_wheels_outer_distance = 65;
rp_drive_wheel_d = 24;
rp_interface_wheel_d = 44.5;

rp_plate_iner_cut_w = 31;
rp_plate_iner_cut_h = 4;

rp_nema17_offset = 1;


