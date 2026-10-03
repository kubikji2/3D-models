// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// makerbeam
use<../makerbeam-case.scad>
include<../makerbeam-corner-parameters.scad>
include<../makerbeam-constants.scad>

// atx ps2 psu
use<atx-ps2-psu-plate-model.scad>
include<../pc-parts/atx-ps2-psu-specs.scad>
//include<atx-ps2-psu-plate-parameters.scad>

// motherboard
use<motherboard-plate-model.scad>
include<mougol-x99-parameters.scad>

// parameters
include<marcus-aukrelius-parameters.scad>

// gpu
include<rtx-3060-specs.scad>

// hdd 2.5 inch
use<hdd-2p5-case-model.scad>

include<cover-plates-parameters.scad>
use<cover-plates-model.scad>

use<../makerbeam-cover-plate-model.scad>
_x = __mkc__beamer_length_to_total_length(ma_mbl_x);
_y = __mkc__beamer_length_to_total_length(ma_mbl_y);
_z = __mkc__beamer_length_to_total_length(ma_mbl_z);

// case
makerbeam_case([ma_mbl_x,ma_mbl_y,ma_mbl_z]);


// motherboard
//color("forestgreen")
translate([0,0,-10])
//rotate([0,0,180])
    motherboard_plate("forestgreen");

// Noctua cooler
color("navy")
    translate([mougol_x99_x-80,ma_mbl_y-mougol_x99_y/2,10])
        cubepp([125,112,158], align="z");

// PSU
translate([(ma_mbl_x+2*mbc_wt)-atx_ps2_psu_x/2,ma_mbl_y+2*mbc_wt,0])
{
    translate([0,0,ma_mbl_z/2+mbc_wt])
        atx_ps2_psu_holder(clr="darkorange");

    translate([0,0,atx_ps2_psu_z])
    rotate([0,0,180])
    render(20)
        hdd_2p5_case();
}

//translate([150,0,200])
//    cubepp([150,86,150], align="xyZ");


// GPU
color("lime")
    translate([rtx3060_x-mougol_x99_pcie_slot_y_off,22,10]) // approx
        cubepp([rtx3060_x,rtx3060_y,rtx3060_z]);


// plates
// ... left
translate([-mb1010_a,_y/2-mb1010_a,_z/2-mb1010_a])
rotate([0,0,-90])
rotate([90,0,0])
left_panel(has_pattern=true);

// ... right
translate([_x-mb1010_a,_y/2-mb1010_a,_z/2-mb1010_a])
rotate([0,0,90])
rotate([90,0,0])
right_panel(has_pattern = false);

// ... front
translate([_x/2-mb1010_a,-mb1010_a,_z/2-mb1010_a])
rotate([0,0,0])
rotate([90,0,0])
front_panel(has_pattern=false);

// ... back
translate([_x/2-mb1010_a,_y-mb1010_a,_z/2-mb1010_a])
rotate([0,0,180])
rotate([90,0,0])
back_panel(has_pattern=false);

// diaorama
//color([0.2, 0.2, 0.2])
//%translate([220,0,0])
//    difference()
//    {
//        cubepp([80,300,200]);
//        translate([100,0,0])
//            cylinderpp(d=200, h=900, zet="y");
//    }