
// Sliding Rod Holder -- SRH

srh_wt = 2.4;
srh_bt = 3;

srh_rod_gauge = 50;
srh_rod_offset = 0;

srh_rod_stopper_h = 5;
srh_extrusion_stopper_h = 15;

srh_fastener_offset = (srh_extrusion_stopper_h-srh_rod_stopper_h-srh_bt)/2;

srh_fastener_d = 3;
srh_bolt_l = 5;
srh_bolt_descriptor = str("M", srh_fastener_d, "x", srh_bolt_l);
srh_bolt_standard = "DIN84A";

// bottom holder parameters
srh_bottom_h = 30;
srh_bottom_interface_h = 5;

srh_bottom_wt = 2.5;

// interface dimension
srh_bottom_int_a = 150;
// reinforcement spacing
srh_bottom_rf = 50;

// universal holder parameters
//srh_bottom_uh_z_off = 5;
//srh_bottom_uh_width = 5;
//srh_bottom_uh_spacing = 5;
