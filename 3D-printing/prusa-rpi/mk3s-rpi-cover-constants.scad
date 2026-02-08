include<mk3s-interface-constants.scad>
include<rpi-0w2-eth-hat-constants.scad>
include<rpi-0w2-constants.scad>

cover_bt = 2;
cover_inner_h = mk3si_additional_depth + rpi_0w2_hat_top_spacer_h + rpi_0w2_hat_pcb_t + rpi_0w2_hat_bottom_spacer_h;
cover_h = cover_inner_h + cover_bt;

cover_x = mk3si_bb_x;
cover_y = mk3si_bb_y;
cover_r = mk3si_bb_r;


cover_wt = 2;
cover_inner_clearance = 1;
cover_inner_x = cover_x-2*cover_wt;//rpi_0w2_x+2*cover_inner_clearance;
cover_inner_y = cover_y-2*cover_wt;//rpi_0w2_y+2*cover_inner_clearance;
cover_inner_r = rpi_0w2_cr;

// ventilation
// ... horizontal
cover_vent_h_count = 12;
cover_vent_h_t = 1.8;
// ... vertical
cover_vent_v_count = 12;
cover_vent_v_t = 1.8;

// ethernet cable velcro
cover_eth_cable_width = 5;
cover_eth_velcro_width = 12.5;

