include<../../lib/solidpp/solidpp.scad>

$fn = $preview ? 36 : 144;

body_x = 51;
body_y = 18;
// total available width
body_z = 200;
body_wt = 2.4;
body_cr = body_wt;
body_virsual_z = 220;

// mophead params
mh_wt = 2.4;
mh_d = 20;
mh_l = 160;
mh_transition_r = 5;
mh_shaft_wt = 1.6;
mh_n_holes = 6;

mh_shaft_offset = 30;

// mop shaft loop parameters
ms_d = 30;
ms_loop_l = 20;

// hook parameters
hook_d = 10;
hook_l = ms_d/2+ms_loop_l/2;
hook_b = 4;
hook_transition_r = hook_d/2;

module interface()
{

    difference()
    {
        translate([-body_wt, -body_wt,0])
        cubepp([body_x+body_wt,
                body_y+body_wt,
                body_z+body_wt],
                mod_list=[round_edges(body_cr, axes="xy")]);

        cubepp([body_x+body_wt,
                body_y+body_wt,
                3*(body_z+body_wt)], align="xy");
        
    }

}

module mophead_rack()
{

    _h = (mh_l+2*mh_wt);
    _y_off = -mh_shaft_offset;//-mh_d;
    _z_tmp_off = _h/2;

    render(10)
    intersection()
    {
        
        union()
        {
            difference()
            {
                translate([-mh_transition_r,0,0])
                    cubepp([mh_d+2*mh_transition_r, -_y_off+mh_d/2,_h], align="xYz");
                translate([mh_shaft_wt,_y_off-mh_shaft_wt,0])
                    cylinderpp(d=mh_d-2*mh_shaft_wt, h=3*_h, align="xY");
            }
            translate([-mh_transition_r,0,_h])
                cubepp([mh_d+2*mh_transition_r, mh_transition_r+body_wt, 2*mh_transition_r], align="xY");
        }
        


        // brackets
        // singe bracket
        translate([0,0,_z_tmp_off])
        mirrorpp([0,0,1], true)
        translate([0,0,-_z_tmp_off])
        union()
        {
            linear_extrude(mh_wt, convexity=10)
                hull()
                {
                    // body interface   
                    squarepp([mh_d, body_wt], align="xY");

                    // shaft interface
                    translate([0,_y_off])
                        circlepp(d=mh_d, align="xY");
                }

            translate([0,0,mh_wt])
            {
                // shaft transition
                translate([mh_d/2,_y_off-mh_d/2,0])
                intersection()
                {
                    difference()
                    {
                        cylinderpp(d=mh_d+2*mh_transition_r, h=mh_transition_r, align="z");
                        toruspp(d=mh_d,t=2*mh_transition_r, align="z");
                    }

                    cubepp([mh_d, 3*mh_d, mh_d], align="y");
                }

                // body transition
                translate([0,0,-mh_wt/2])
                mirrorpp([0,0,1], true)
                translate([0,0,mh_wt/2])
                translate([0,-body_wt,0])
                    difference()
                    {
                        translate([-mh_transition_r,0,-body_wt/2])
                            cubepp([mh_d+2*mh_transition_r, mh_transition_r, mh_transition_r+body_wt/2], align="xYz");
                        translate([0,-mh_transition_r, mh_transition_r])
                            cylinderpp(r=mh_transition_r, h=3*mh_d, zet="x", align="");
                        translate([+mh_d/2,0,0])
                            mirrorpp([1,0,0], true)
                                translate([mh_d/2+mh_transition_r,0,0])
                                    cylinderpp(r=mh_transition_r, h=3*(mh_transition_r+body_wt), align="Y");
                    }
            }

        }
    }
    

    // shaft
    difference()
    {
        translate([0, _y_off, 0])
            tubepp(D=mh_d, t=mh_shaft_wt, h=_h, align="xYz");

        hole_d = (3.14*mh_d)/mh_n_holes-mh_shaft_wt;
        r_count = floor((mh_l-2*mh_transition_r)/hole_d);
        coordinate_frame()
        translate([ mh_d/2,
                    _y_off-mh_d/2,
                    (mh_l-(r_count*hole_d))/2+mh_transition_r+mh_wt])
            for(r=[0:r_count-1])
                rotate([0,0,r%2==0?(360/(2*mh_n_holes)):0])
                    translate([0,0,r*hole_d])
                        for(i=[0:mh_n_holes-1])
                        {
                            rotate([0,0,i*(360/mh_n_holes)])
                                cylinderpp(d1=0,d2=hole_d, h=mh_d/2, zet="x", align="x", $fn=6);
                        }
    }


}

module mop_hook()
{
    translate([body_x/2,-body_wt,0])
    {
        // hook
        pairwise_hull()
        {
            // base
            cylinderpp(h=body_wt,d=hook_d,align="Y", zet="y");
            
            translate([0,-hook_l,0])
                spherepp(d=hook_d);
            
            translate([-hook_b,-hook_l-hook_b,0])
                spherepp(d=hook_d);
            
            translate([-2*hook_b,-hook_l-hook_b,0])
                spherepp(d=hook_d);
        }

        // base transition
        difference()
        {
            cylinderpp(d=hook_d+2*hook_transition_r, h=hook_transition_r, align="Y", zet="y");
            toruspp(d=hook_d, t=2*hook_transition_r, align="Y",zet="y");
        }
    }
}

module mop_rack()
{
    // body
    interface();

    // mophead rack
    translate([body_x/2-mh_d/2,0,0])
        mophead_rack();

    // mop hook
    translate([0,0,(mh_l + 2*mh_wt) + (body_virsual_z-(mh_l + 2*mh_wt))/2])
        mop_hook();

}

mop_rack();