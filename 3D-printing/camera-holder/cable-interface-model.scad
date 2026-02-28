use<../../lib/solidpp/solidpp.scad>


include<cable-interface-parameters.scad>

module wall_interface(wt)
{

    points=[[wt/2+ci_clearance,0],
            [wt/2+ci_clearance,ci_wing_h],
            [wt/2+ci_clearance+ci_wt,0]];
    
    translate([0,ci_max_cable_d/2+ci_wt,0])
        linear_extrude(ci_wt+ci_max_cable_d)
            polygon(points);

}


module cable_interface(wt, cable_d)
{

    difference()
    {
        _x = wt+2*ci_wt+2*ci_clearance;
        _y = ci_max_cable_d+2*ci_wt;
        // main shape
        cubepp([_x, _y, ci_max_cable_d+ci_wt], align="z");

        // cable
        translate([0,0,ci_max_cable_d/2+ci_wt])
        {
            cylinderpp(d=cable_d, h=3*_y, zet="x", align="");
            cubepp([3*_x,cable_d,cable_d], align="z");
        }
    }

    // wall interface
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            wall_interface(wt=wt);
}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;


include<camera-holder-parameters.scad>
cable_interface(wt=ch_wt, cable_d=2.9);