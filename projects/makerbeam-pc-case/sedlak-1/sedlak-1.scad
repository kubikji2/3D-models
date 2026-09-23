// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

use<../makerbeam-case.scad>
// motherboard
use<motherboard-plate.scad>
// slot
use<hdd-slot-model.scad>

// psu
use<sfx-psu-holder-model.scad>
include<sfx-psu-specs.scad>

// case
makerbeam_case([300,200,300]);

translate([0,0,260])
    makerbeam_case([300,200,0], walls="", forced_walls="z", has_double_corners="true");

translate([0,0,130])
    makerbeam_case([300,200,0], walls="", forced_walls="z", has_double_corners="true");

// motherboard
translate([0,0,250])
{
    //color("gray")
        sedlak_motherboard_plate();

    //// PCIe card
    //color("forestgreen")
    //    translate([180,0,0])
    //        cubepp([30,170,70]);
}

// bottom HDD

translate([25,103,55])
    for(i=[0:5])
    {
        color(i%2==0?"teal":"lime")
        translate([i*50,0,0])
            render(10)
                hdd_slot();
    }

// botom HDD row
translate([25,103,185])
    for(i=[0:3])
    {
        color(i%2==1?"dodgerblue":"cyan")
            translate([i*50,0,0])
                render(10)
                    hdd_slot();
    }

module hdd()
{
    color("lightgray")
        cubepp([26, 147, 102]);
}

// psu
translate([260,206,120+60+10])
{
    color("crimson")
        render(10)
            sfx_psu_holder();

    // psu
    //color("gray")
    %cubepp([sfx_psu_x,sfx_psu_y,sfx_psu_z], align="Y");
}

// fans
//color("darkorange")
%translate([3+150,206,0])
{
    mirrorpp([1,0,0], true)
        translate([10,0,0])
            cubepp([120,25,120], align="xyz");
    
    mirrorpp([1,0,0], true)
        translate([10,0,10+120])
            cubepp([120,25,120], align="xyz");
    
    
}