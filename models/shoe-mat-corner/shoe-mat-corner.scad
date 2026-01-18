use<../../lib/solidpp/solidpp.scad>
// Shoe mat corners for shoe mat with stick-on floor protector

module shoe_mat_corner( border_d = 90,
                        border_wt = 2.2,
                        border_h = 15,
                        floor_d = 30,
                        heght_diff = 2,
                        bt = 2,
                        wt = 2,
                        stick_on_d = 17,
                        stick_on_off = 1,
                        hook_h = 2,
                        hook_stopper = 0.2,
                        interface_l = 10)
{

    interface = 0;    

    outer_d = border_d + 2*wt;
    cut([90,360])
    union()
    {
        // bottom
        cylinderpp(d=outer_d,h=bt);

        // height difference
        translate([0,0,bt])
            cylinderpp(d=floor_d,h=heght_diff);
        
        translate([0,0,bt])
            tubepp(D=outer_d, t=wt, h=hook_h);
        translate([0,0,bt+hook_h])
            tubepp(D=outer_d, t=wt+hook_stopper, h=bt);

        // hook back
        /*
        cut([70,90])
        cut([35,55])
        cut([0,20])
        translate([0,0,bt])
        union()
        {
            difference()
            {
                cylinderpp(d=border_d-2*border_wt, h=hook_h+bt);
                cylinderpp( d=border_d-2*border_wt-2*wt,
                            h=3*(hook_h+bt),
                            mod_list=[bevel_bases(bevel_bottom=hook_h+bt)]);
            }
            // top ring
            translate([0,0,hook_h])
                tubepp(D=border_d-2*border_wt+2*hook_stopper, t=hook_stopper+wt, h=bt);
        }
        */

    }

    // interface
    mirrorpp([-1,1,0], true)
    {
        // bottom
        cubepp([interface_l, outer_d/2, bt],align="Xyz");

        // hook wall
        translate([0,outer_d/2,bt])
            cubepp([interface_l, wt, hook_h], align="XYz");
        // top hook outer
        translate([0,outer_d/2,bt+hook_h])
            cubepp([interface_l, wt+hook_stopper, bt], align="XYz");
        // top hook inner
        translate([0,border_d/2-border_wt-wt,bt+hook_h])
            cubepp([interface_l, wt+hook_stopper, bt], align="Xyz");
        
        // bottom stopper
        translate([0, outer_d/2-border_wt-wt,bt])
        hull()
        {
            cubepp([interface_l, wt, bt+hook_h], align="XYz");
            cubepp([interface_l, wt+bt+hook_h, bt], align="XYZ");
        }

        // back part
        translate([0,-interface_l,0])
            cubepp([interface_l, interface_l+floor_d/2, bt+heght_diff],align="Xyz"); 
    }



}


