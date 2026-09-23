use<../makerbeam-case.scad>
use<motherboard-model.scad>


// case
makerbeam_case([300,300,200]);

// motherboard
color("forestgreen")
    motherboard(210,180);

// GPU
color("dimgray")
    translate([170,0,5])
        cubepp([41,282,117]);

// Noctua cooler
color("navy")
    translate([30,30,10])
        cubepp([125,112,158]);

// PSU
translate([0,300,200])
    cubepp([150,86,150], align="xYZ");


// diaorama
//color([0.2, 0.2, 0.2])
%translate([220,0,0])
    difference()
    {
        cubepp([80,300,200]);
        translate([100,0,0])
            cylinderpp(d=200, h=900, zet="y");
    }