use<../makerbeam-case.scad>
use<motherboard-model.scad>


// case
makerbeam_case([300,200,300]);

translate([0,0,240])
    makerbeam_case([300,200,0], walls="", forced_walls="z");

translate([0,0,120])
    makerbeam_case([300,200,0], walls="", forced_walls="z");

// motherboard
translate([0,0,240])
{
    color("gray")
        motherboard(244, 175);

    // PCIe card
    color("forestgreen")
        translate([180,0,0])
            cubepp([30,170,70]);
}

// top HDD
translate([20,0,125])
    for(i=[0:5])
    {
        translate([i*40,0,0])
            hdd();
    }

// botom HDD row
translate([20,0,5])
    for(i=[0:3])
    {
        translate([i*40,0,0])
            hdd();
    }

module hdd()
{
    color("lightgray")
    cubepp([26, 147, 102]);
}

