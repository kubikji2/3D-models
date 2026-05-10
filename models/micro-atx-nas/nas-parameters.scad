include<gigabyte-ga-b85m-hd3-parameters.scad>


uatx_nas_cable_space = 10;


uatx_nas_cr = 5;
uatx_nas_wt = 4;

uatx_nas_additional_spacing = 5;

uatx_nas_x = bg_ga_b85_hd3_x + 2*uatx_nas_additional_spacing+2*uatx_nas_wt;
uatx_nas_y = bg_ga_b85_hd3_y + 2*uatx_nas_additional_spacing+uatx_nas_cable_space+2*uatx_nas_wt;

// individual comapartements heights
uatx_nas_hdd_bay_bt = 3;
uatx_nas_hdd_shell_h = 0;

uatx_nas_motherboard_bay_bt = 3;
uatx_nas_motherboard_shell_h = 0;


uatx_nas_z = uatx_nas_hdd_bay_bt+uatx_nas_hdd_shell_h+uatx_nas_motherboard_bay_bt+uatx_nas_motherboard_shell_h;
