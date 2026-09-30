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
include<../pc-parts/sfx-psu-specs.scad>

// specs
include<../makerbeam-constants.scad>
include<sedlak-1-parameters.scad>

// walls
use<../makerbeam-cover-plate-model.scad>
include<../makerbeam-corner-parameters.scad>
use<panels-model.scad>

// case
makerbeam_case([300,200,300]);

translate([0,0,260])
    makerbeam_case([300,200,0], walls="", forced_walls="z", has_double_corners="true");

translate([0,0,sedlak1_level_1_h+mb1010_a])
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


// HDD SLOTS
// ... bottom HDD slots
translate([25,103,55])
    for(i=[0:5])
    {
        color(i%2==0?"teal":"lime")
        translate([i*50,0,0])
            render(10)
                hdd_slot();
    }

// ... top HDD slots
translate([25,103,185])
    for(i=[0:3])
    {
        color(i%2==1?"dodgerblue":"cyan")
            translate([i*50,0,0])
                render(10)
                    hdd_slot();
    }


// SIDE PANELS
render(30)
translate([-mb1010_a,sedlak1_mbl_y/2+mbc_wt,sedlak1_mbl_z/2+mbc_wt])
    rotate([0,0,-90])
        rotate([90,0,0])
            sedlak1_side_panel();

// bottom walls
/*
color([0.3,0.3,0.3])
    translate([-mb1010_a,sedlak1_mbl_y/2+mbc_wt,sedlak1_level_1_plate_h/2-mb1010_a])
        render(30)
            rotate([0,0,-90])
                rotate([90,0,0])
                    makerbeam_cover_plate(
                        beam_length=sedlak1_mbl_y,
                        height=sedlak1_level_1_plate_h,
                        top_corners_offset=sedlak1_level_1_plate_top_offset);
color([0.4,0.4,0.4])
    translate([-mb1010_a,sedlak1_mbl_y/2+mbc_wt,sedlak1_level_1_plate_h-mb1010_a+sedlak1_level_2_plate_h/2])
        render(30)
            rotate([0,0,-90])
                rotate([90,0,0])
                    makerbeam_cover_plate(
                        beam_length=sedlak1_mbl_y,
                        height=sedlak1_level_2_plate_h,
                        top_corners_offset=sedlak1_level_2_plate_top_offset,
                        bottom_corners_offset=sedlak1_level_2_plate_bottom_offset);
*/

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