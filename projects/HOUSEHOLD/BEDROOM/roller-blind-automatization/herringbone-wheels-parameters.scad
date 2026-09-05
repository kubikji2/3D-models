// HERRINGBONE WHEELS

// shared parameters
hb_metric_module = 1.5;
hb_pressure_angle = 20;
hb_helix_angle = -30;
hb_angular_resolution = 1;
hb_width = 7;
hb_layer_thickness = 1;
hb_back_lash = 0.01;

// particular wheel parameters
hb_n_teeth_big_wheel = 24;
hb_n_teeth_small_wheel = 12;

hb_wheels_clearance = 0.25;

// wheels dimensions and spacing
hb_wheels_outer_distance = 65; // NOTE: MEASURED! Depends on hb_n_teeth_small_wheel and hb_n_teeth_big_wheel
hb_drive_wheel_d = 24;         // NOTE: MEASURED! Depends on hb_n_teeth_small_wheel
hb_interface_wheel_d = 44.5;   // NOTE: MEASURED! Depends on hb_n_teeth_big_wheel
hb_wheel_axes_gauge = hb_wheels_outer_distance - hb_drive_wheel_d/2 - hb_interface_wheel_d/2;
