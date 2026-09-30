// bumper dimensions
include<hdd-bumper-parameters.scad>
include<../pc-parts/hdd-constants.scad>


hdds_sliding_clearance = 0.5;

hdds_inner_x = HDD_Z+2*hddb_wt+2*hdds_sliding_clearance;
hdds_inner_y = HDD_Y+2*hddb_wt+2*hdds_sliding_clearance;
hdds_inner_z = HDD_X+2*hddb_wt+2*hdds_sliding_clearance;

hdds_total_z = 120;


hdds_bt = 5;
hdds_wt = 4;

// makerbeam anchoring nut
hdds_anchoring_nut_standard = "DIN934";

// wrench parameters
// assuming proxxon:
// https://www.proxxon.com/en/industrial/23820.php?search#23905
hdds_wrench_h = 3;
hdds_wrench_d = 9;
hdds_wrench_D = 14;
hdds_wrench_clearance = 0.5;

// hdd offset from the back
hdds_offset = 10;

// hinge parameters
hdds_hinge_axis_d = 3;
hdds_hinge_axis_bolt_standard = "DIN84A";
hdds_hinge_axis_bolt_l = 30;
hdds_hinge_axis_bolt_descriptor = str("M",hdds_hinge_axis_d,"x",hdds_hinge_axis_bolt_l);
hdds_hinge_axis_nut_standard = "DIN985";
//hdds_hinge_fasteners_clearance = 0.2;
hdds_hinge_axis_clearance = 0.5;


// connector parameters
hdds_connectors_d = 3;
hdds_connectors_bolt_standard = "DIN84A";
hdds_connectors_bolt_l = 12;
hdds_connectors_bolt_descriptor = str("M",hdds_connectors_d,"x",hdds_connectors_bolt_l);
//hdds_connectors_fasteners_clearance = 0.2;
hdds_connectors_nut_standard = "DIN934";

// cut_planes
hdds_cut_plane_t = 0.15;
hdds_cut_plane_angle = 45;
hdds_cut_plane_connectors_d = 3;
hdds_cut_plane_connectors_bolt_standard = "DIN84A";
hdds_cut_plane_connectors_bolt_l = 18;
hdds_cut_plane_connectors_bolt_l_off = 10;
hdds_cut_plane_connectors_bolt_descriptor = str("M",hdds_cut_plane_connectors_d,"x",hdds_cut_plane_connectors_bolt_l);
hdds_cut_plane_connectors_nut_standard = "DIN934";
