use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<hdd-constants.scad>


module replicate_hdd_holes(one_side_only=true)
{

    //%cubepp([HDD_Z,HDD_X,HDD_Y],align="zx");

    if(one_side_only)
    {
        // S1 holes
        translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S1_X])
            children();

        // S2 holes
        translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S2_X])
            children();

        // S3 holes
        translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S3_X])
            children();
    }
    else
    {
        mirrorpp([0,1,0], true)
        {
            // S1 holes
            translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S1_X])
                children();

            // S2 holes
            translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S2_X])
                children();

            // S3 holes
            translate([HDD_MP_S_Z,HDD_X/2,HDD_MP_S3_X])
                children();
        }
    }
}



//$fs = 0.1;
//$fa = 5;
//
//replicate_hdd_holes()
//    cylinderpp(d=HDD_MP_D,h=HDD_MP_D, align="y", zet="y");