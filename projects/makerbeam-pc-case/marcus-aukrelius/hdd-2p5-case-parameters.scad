
//include<atx-ps2-psu-plate-parameters.scad>
include<../pc-parts/atx-ps2-psu-specs.scad>

// for height computation
include<marcus-aukrelius-parameters.scad>
include<../makerbeam-corner-parameters.scad>


hc_x = atx_ps2_psu_x;
hc_y = atx_ps2_psu_y;
hc_z = (ma_mbl_z+2*mbc_wt)-atx_ps2_psu_z;


