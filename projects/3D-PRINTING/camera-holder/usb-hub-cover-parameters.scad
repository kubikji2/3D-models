

// USB ports parameter
ubc_usb_w = 13.2;
ubc_usb_l = 14;
ubc_usb_h = 5.8;
usb_z_off = 2;
usb_x_off = 4;

// USB spacing
ubc_usb_narrow_g = 3.8;
ubc_usb_wide_g = 7.85;

// DC port parameter
ubc_dc_w = 6.5;
ubc_dc_h = 5.5;
ubc_dc_H = 7;
ubc_dc_y_off = 9.5;

// LED
ubc_led_d = 3;

// PCB dimensions
ubc_pcb_w = 4*ubc_usb_w + 2*ubc_usb_narrow_g + ubc_usb_wide_g+2*usb_x_off-2;
ubc_pcb_l = 16;

// interior dimensions
ubc_int_x = 4*ubc_usb_w + 2*ubc_usb_narrow_g + ubc_usb_wide_g+2*usb_x_off;
ubc_int_y = 33.5;
ubc_int_z = usb_z_off+ubc_dc_H;

// total parameters
ubc_wt = 2;
ubc_x = ubc_int_x+2*ubc_wt;
ubc_y = ubc_int_y+ubc_wt;
ubc_z = ubc_int_z+2*ubc_wt;

// cover fasteners
ubc_fastener_d = 2;
ubc_bolt_l = 10;
ubc_bolt_descriptor = str("M", ubc_fastener_d, "x", ubc_bolt_l);
ubc_bolt_standard = "DIN84A";

// mountpoints
ubc_flaps_t = 4;
ubc_flaps_screw_d = 3;
ubc_flaps_screw_l = 20;
ubc_flaps_screw_descriptor = str("M", ubc_flaps_screw_d, "x", ubc_flaps_screw_l);
ubc_flaps_screw_standard = "LUXPZ";

