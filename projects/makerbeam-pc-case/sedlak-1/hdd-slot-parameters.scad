// bumper dimensions
include<hdd-bumper-parameters.scad>
include<hdd-constants.scad>


hdds_sliding_clearance = 0.2;

hdds_inner_x = HDD_Z+2*hddb_wt+2*hdds_sliding_clearance;
hdds_inner_y = HDD_Y+2*hddb_wt+2*hdds_sliding_clearance;
hdds_inner_z = HDD_X+2*hddb_wt+2*hdds_sliding_clearance;

hdds_total_z = 120;


hdds_bt = 5;
hdds_wt = 3;

hdds_anchoring_nut_standard = "DIN934";


// assuming proxxon:
// https://www.proxxon.com/en/industrial/23820.php?search#23905
hdds_wrench_h = 3;
hdds_wrench_d = 9;
hdds_wrench_D = 14;
hdds_wrench_clearance = 0.5;

hdds_offset = 10;