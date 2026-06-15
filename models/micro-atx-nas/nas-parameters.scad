include<gigabyte-ga-b85m-hd3-parameters.scad>
include<psu-parameters.scad>
include<cooling-fan-constants.scad>

uatx_nas_cable_space = 20; // must be at least 15 for the power cable!


uatx_nas_cr = 5;
uatx_nas_wt = 4;

uatx_nas_additional_spacing = 5;

// individual comapartements heights

/////////////
// HDD BAY //
/////////////
uatx_nas_hdd_bay_bt = 3;
uatx_nas_hdd_shell_h = max(HDD_X+uatx_nas_hdd_slot_wt,psu_z,H4_CF_A)+uatx_nas_additional_spacing;


// HDD slot parameters
uatx_nas_hdd_slot_width = 30;
uatx_nas_hdd_slot_wt = 4;
uatx_nas_hdd_slot_frame_cr = 2*uatx_nas_hdd_slot_wt;
uatx_nas_hdd_slot_n_frames = 4;
uatx_nas_hdd_slot_frames_w = 8;

// HDD Bay max content width
__uatx_nas_hdd_bay_max_width = 6*(uatx_nas_hdd_slot_width+uatx_nas_hdd_slot_wt)+uatx_nas_hdd_slot_wt+psu_x;


// m
uatx_nas_motherboard_bay_bt = 3;
uatx_nas_motherboard_shell_h = 0;




uatx_nas_x = max(bg_ga_b85_hd3_x,__uatx_nas_hdd_bay_max_width) + 2*uatx_nas_additional_spacing+2*uatx_nas_wt;
uatx_nas_y = bg_ga_b85_hd3_y + uatx_nas_additional_spacing+uatx_nas_cable_space+2*uatx_nas_wt;




uatx_nas_z = uatx_nas_hdd_bay_bt+uatx_nas_hdd_shell_h+uatx_nas_motherboard_bay_bt+uatx_nas_motherboard_shell_h;
