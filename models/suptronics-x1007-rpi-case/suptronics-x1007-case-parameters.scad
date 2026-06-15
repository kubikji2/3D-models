include<rpi5-dimensions.scad>
include<rpi5-active-cooling-dimensions.scad>
include<suptronics-x1007-dimensions.scad>

x1k7_case_cr = 3;
x1k7_case_bt = 3;
x1k7_case_wt = 3;
x1k7_case_inner_clearance = 1;

x1k7_case_inner_y_space = x1k7_case_cr+rpi5_connector_x_overlap;

x1k7_case_inner_x = stx1k7_x+2*x1k7_case_inner_clearance;
x1k7_case_inner_y = rpi5_x+x1k7_case_inner_y_space+2*x1k7_case_inner_clearance;
x1k7_case_inner_z = stx1k7_spacer_h + stx1k7_pcb_t + stx1k7_rpi_spacer_h + rpi5_pcb_t + rpi5_usb_h + x1k7_case_inner_clearance;

x1k7_case_x = x1k7_case_inner_x + 2*x1k7_case_wt;
x1k7_case_y = x1k7_case_inner_y + 2*x1k7_case_wt;
x1k7_case_z = x1k7_case_inner_z + 2*x1k7_case_bt;

// fasteners
x1k7_mnt_bolt_d = 2.5;
x1k7_mnt_bolt_l = 8;
x1k7_mnt_bolt_descriptor = str("M", x1k7_mnt_bolt_d,"x", x1k7_mnt_bolt_l);
x1k7_mnt_bolt_standard = "DIN912";

x1k7_cover_bolt_d = 3;
x1k7_cover_bolt_l = 10;
x1k7_cover_bolt_descriptor = str("M", x1k7_cover_bolt_d,"x", x1k7_cover_bolt_l);
x1k7_cover_bolt_standard = "DIN84A";


// ventilation
x1k7_vent_width = 3;
x1k7_vent_spacing = 3;