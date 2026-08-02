


// interface parameters

kh_int_top_ring_d = 17.5;   // T12 soldering iron dimension
kh_int_top_ring_stopper = 1;


kh_int_bottom_ring_d = 17;  // T12 soldering iron dimension
kh_int_bottom_ring_h = 3.5; // T12 soldering iron dimension
kh_int_bottom_ring_stopper = 1;

kh_int_ring_spacing = 15;    // T12 soldering iron dimension
kh_int_max_diameter = 24;   // T12 soldering iron dimension


kh_int_ring_thickness = 5;
kh_int_tight_fit = 0.5;
kh_int_ring_offset_smoothing = 1.5;


// fasters parameters
include<carriage-interface-parameters.scad>

kh_bolt_l = 10;
kh_bolt_descriptor = str("M", car_int_fastener_d, "x", kh_bolt_l);
kh_bolt_standard = "DIN84A";

kh_plate_t = kh_bolt_l-car_int_fastener_offset;
kh_plate_off = 5;