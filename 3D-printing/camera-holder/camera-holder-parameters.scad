include<ir-light-constants.scad>
include<rpi-camera-v2-constants.scad>

ch_unified_nut_standard = "DIN934";
ch_unified_bolt_standard = "DIN84A";

// cover mounting
ch_interface_fastener_d = 2;
ch_interface_offset = 6;

ch_interface_nut_standard = ch_unified_nut_standard;
ch_interface_bolt_standard = ch_unified_bolt_standard;
ch_interface_bolt_length = 5;
ch_interface_bolt_descriptor = str("M", ch_interface_fastener_d, "x", ch_interface_bolt_length);

// wall and bottom thicknesses
ch_bt = 2;
ch_wt = 1.2;

ch_int_clearance = 0.25;
ch_int_x = rpc2_x+2*ch_int_clearance+2*ch_interface_offset;
ch_int_y = rpc2_y+irl_fasteners_offset+2*ch_int_clearance+2;
ch_int_z = 10;

ch_x = ch_int_x+2*ch_wt;
ch_y = ch_int_y+2*ch_wt;
ch_z = ch_int_z+ch_wt+ch_bt;
ch_cr = 4;

// camera prameters
ch_cam_z_off = 3;
ch_cam_bolt_offset = rpc2_pcb_t;

// light parameters
ch_irl_z_off = 6;
ch_irl_bolt_offset = 2;

// fasteners
ch_fasteners_diameter = 2;
ch_nut_standard = ch_unified_nut_standard;
ch_bolt_standard = ch_unified_bolt_standard;
ch_camera_bolt_l = 5;
ch_camera_bolt_descriptor = str("M", ch_fasteners_diameter, "x", ch_camera_bolt_l);
ch_light_bolt_l = ch_camera_bolt_l;
ch_light_bolt_descriptor = str("M", ch_fasteners_diameter, "x", ch_light_bolt_l);

ch_cover_bolt_l = 10;
ch_cover_bolt_descriptor = str("M", ch_fasteners_diameter, "x", ch_cover_bolt_l);


