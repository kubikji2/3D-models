

// motor rod -> mr
ssfen_mr_d = 10.3;
ssfen_mr_h = 62;
ssfen_mr_screw_h_off = 12.3; // distance from the top to the center of the set-screw hole
ssfen_mr_screw_d = 3.75;
ssfen_mr_screw_t = 5;

// motor link -> ml
ssfen_ml_d = 7;
ssfen_ml_h = 4; 
ssfen_ml2mr_x_gauge = 9.7 + 2 + ssfen_mr_d/2; // mr to ml cylinder center distance
ssfen_ml2mr_z_offset = 6; // offset from the ml cylinder top to the mr cylinder top
ssfen_ml_based_d = 10;
ssfen_ml_screw_l = 10;
ssfen_ml_screw_d = 3.75;

// top compartement 
ssfen_tc_h = 20;

// hinge -> hng
ssfen_hng_t = 19;
ssfen_hng_d = 8;
ssfen_hng_D = 2*(ssfen_hng_d/2+20);

ssfen_hng_z_offset = 31;
ssfen_hng_y_offset = 38;

ssfen_hng_clrn_h = 25;

// plane joinng two parts together thickness
ssfen_plane_t = ssfen_hng_z_offset-ssfen_hng_clrn_h;


// cable diameter
ssfen_cable_d = 9;
ssfen_cable_min_d = 6;

// groves
ssfen_grv_w = 2;
ssfen_grv_d = 1;
ssfen_grv_l = ssfen_hng_t-2;









