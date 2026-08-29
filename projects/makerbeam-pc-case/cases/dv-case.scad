use<../makerbeam-case.scad>
use<motherboard-model.scad>



module design_1()
{

    makerbeam_case([300,300,200]);

    // motherboard
    color("forestgreen")
    motherboard(305,244);

    // GPU 1
    color("dimgray")
    translate([180,0,0])
        cubepp([39.8,305,152.2]);

    // GPU 2
    color("dimgray")
    translate([250,0,0])
        cubepp([39.8,305,152.2]);

    // PSU
    translate([0,300,200])
        cubepp([150,86,150], align="xYZ");


    // lower bay
    //lower_bay_h = 100;
    //translate([0,0,-lower_bay_h-10])
    //    makerbeam_case([300,300,lower_bay_h], walls="xyzXY");
}

module design_2()
{
    translate([0,0,-100])
        makerbeam_case([300,300,300]);
    
    makerbeam_case([300,300,0], walls="", forced_walls="z");

    // motherboard
    color("forestgreen")
    motherboard(305,244);

    // GPU 1
    color("dimgray")
    translate([180,0,0])
        cubepp([39.8,305,152.2]);

    // GPU 2
    color("dimgray")
    translate([250,0,0])
        cubepp([39.8,305,152.2]);

    // PSU
    translate([0,300,200])
        cubepp([150,86,150], align="xYZ");
}


design_2();