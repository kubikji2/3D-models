include<roller-blind-interface-constants.scad>
use<../../../../lib/solidpp/solidpp.scad>



module roller_blind_interface(length, clearance=0.1)
{

    _rbi_stopper_hole_w = rbi_stopper_hole_w+2*clearance;
    _rbi_stopper_d = rbi_stopper_d-2*clearance;
    _rbi_d = rbi_d-2*clearance;
    _rbi_fin_w = rbi_fin_w-2*clearance;
    _rbi_fin_h = rbi_fin_h-clearance;

    // interface
    difference()
    {
        cylinderpp(d=_rbi_stopper_d, h=rbi_stopper_w);
        difference()
        {
            for(i=[0:rbi_fin_count-1])
                rotate([0,0,i*(360/rbi_fin_count)])
                    cubepp([_rbi_stopper_hole_w, rbi_stopper_d, 3*rbi_stopper_w], align="y");
            cylinderpp(d=_rbi_stopper_d-2*rbi_stopper_h, h=3*rbi_stopper_w, align="");
        }
    }

    // stopper
    difference()
    {
        cylinderpp(d=_rbi_d, h=rbi_stopper_w+rbi_stopper_h);
        difference()
        {
            for(i=[0:rbi_fin_count-1])
                rotate([0,0,i*(360/rbi_fin_count)])
                    cubepp([_rbi_stopper_hole_w,
                            rbi_stopper_d,
                            2*(rbi_stopper_w+rbi_stopper_h)],
                            align="y",
                            mod_list=[round_edges(d=_rbi_stopper_hole_w,axes="xz")]);
            cylinderpp( d=rbi_stopper_d-2*clearance-2*rbi_stopper_h,
                        h=3*(rbi_stopper_w+rbi_stopper_h),
                        align="");

        }
    }

    // fins area with variable lenth
    translate([0,0,rbi_stopper_w+rbi_stopper_h])
    {
        cylinderpp(d=_rbi_d,h=length);
        
        for(i=[0:rbi_fin_count-1])
            rotate([0,0,i*(360/rbi_fin_count)])
                translate([0,0,0])
                    hull()
                    {
                        cubepp([0.1,_rbi_d/2, length],align="yz");
                        cubepp([_rbi_fin_w,_rbi_d/2, length-rbi_fin_slope_l],align="yz");
                        cubepp([0.01,_rbi_d/2+rbi_fin_h, length-rbi_fin_slope_l],align="yz");
                        
                    }
                    coordinate_frame();
        
    
    }



}


$fn=$preview ? 36 : 120;

difference()
{
    roller_blind_interface(20);

    cylinderpp(d=rbi_d-5,h=3*20, align="");

}