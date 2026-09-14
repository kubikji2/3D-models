include<hdd-constants.scad>

hddb_wt = 4;
hddb_height = HDD_MP_B_Y+hddb_wt;
hddb_rounding = 2;
hddb_clearance = 0.2;

hddb_bolt_clearance = 0.2;
hddb_bolt_standard = "DIN84A";
hddb_bolt_l = 5;
hddb_bolt_descriptor = str("M", HDD_MP_D, "x", hddb_bolt_l);
hddb_bolt_offset = hddb_bolt_l - (HDD_MP_MAX_DP-hddb_bolt_clearance);


