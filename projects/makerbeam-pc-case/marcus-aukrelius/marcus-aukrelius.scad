// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

use<../makerbeam-case.scad>
use<motherboard-plate-model.scad>


include<marcus-aukrelius-parameters.scad>

// case
makerbeam_case([ma_mbl_x,ma_mbl_y,ma_mbl_z]);

// motherboard
color("forestgreen")
translate([0,0,-10])
//rotate([0,0,180])
    motherboard_plate();

// GPU
color("dimgray")
    translate([100,22,5])
        cubepp([41,282,117]);

// Noctua cooler
color("navy")
    translate([170,170,10])
        cubepp([125,112,158]);

// PSU
translate([150,0,200])
    cubepp([150,86,150], align="xyZ");


// diaorama
//color([0.2, 0.2, 0.2])
//%translate([220,0,0])
//    difference()
//    {
//        cubepp([80,300,200]);
//        translate([100,0,0])
//            cylinderpp(d=200, h=900, zet="y");
//    }