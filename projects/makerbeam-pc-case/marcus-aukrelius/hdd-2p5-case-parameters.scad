
//include<atx-ps2-psu-plate-parameters.scad>
include<../pc-parts/atx-ps2-psu-specs.scad>
include<../pc-parts/hdd-2p5inch-constants.scad>

// for height computation
include<marcus-aukrelius-parameters.scad>
include<../makerbeam-corner-parameters.scad>


hc_x = atx_ps2_psu_x;
hc_y = atx_ps2_psu_y;
hc_z = (ma_mbl_z+2*mbc_wt)-atx_ps2_psu_z;

hc_bt = 1.6;
hc_border_r = 5;
hc_border_off = 5;

hc_hdd_bolt_l = 6;
hc_hdd_bolt_descriptor = str("M",HDD_2p5_MP_D,"x",hc_hdd_bolt_l); 
hc_hdd_bolt_standard = "DIN912"; 


hc_vent_wt = 4;
hc_vent_spacing = 2;