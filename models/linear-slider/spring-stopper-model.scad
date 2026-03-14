
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<spring-dimensions.scad>


// sliding rod parameters
include<sliding-rod-dimensions.scad>

include<spring-locking-parameters.scad>

include<spring-stopper-parameters.scad>


module spring_stopper_slider()
{
    _d = sr_d+2*ss_clearance;
    _D = sr_d + 2*ss_wt;
    _h = sl_fastener_d+2*ss_bt;
    difference()
    {
        tubepp(d=_d, D=_D, h=_h, align="");
        cubepp([_d,_d,3*_h], align="X");
    }
}

module spring_stopper()
{
    difference()
    {
        _d = sr_d+2*ss_clearance;
        _t = 2*ss_wt + ss_clearance;
        _h = 4*ss_bt +2*ss_clearance + sl_fastener_d;
        _D = _d + 2*_t;

        _dm =  sr_d+2*ss_clearance + 2*ss_clearance + 2*ss_wt;

        _nut_d = get_nut_diameter(d=sl_fastener_d, standard=ss_nut_standard);
        _nut_h = get_nut_height(d=sl_fastener_d, standard=ss_nut_standard);
        _nut_D = _nut_d + 2*ss_nut_wt;
        //echo(_nut_h+ss_nut_wt);
        // main shape
        translate([0,0,ss_bt/2])
            hull()
            {
                cylinderpp(d=_D, h=_h+ss_bt, align="");
                
                translate([_dm/2,0,0])
                    cubepp([_nut_h+ss_nut_wt,_nut_D, _h+ss_bt], align="x");
                    //rotate([0,90,0])
                    
            }
        //tubepp(d=_d, t=_t, h=_h, align="");

        // middle hole
        cylinderpp(d=_d,h=3*_h,align="");

        // hole for the insert
        _hi_h = 2*ss_bt +2*ss_clearance + sl_fastener_d;
        _hi_d = _d + 2*ss_wt + 2*ss_clearance;
        cylinderpp(d=_hi_d, h=_hi_h, align="");
            cubepp([_d+2*_t,_hi_d, _hi_h], align="X");

        // nut hole
        translate([_dm/2,0,0])
            rotate([0,90,0])
            {   
                nut_hole(d=sl_fastener_d, standard=ss_nut_standard, s_off=_h, align="b");
                translate([0,0,-_D/2])
                    cylinderpp(d=sl_fastener_d+ss_clearance, h=_D);    
            }

        // spring interface
        translate([0,0,_h/2])
        {
            cylinderpp(d1=spring_D+2*ss_clearance, d2=spring_D+2*ss_clearance+2*ss_bt, h=ss_bt, align="z");
            translate([0,0,ss_bt-0.1])
                cylinderpp(d=spring_D+2*ss_clearance+2*ss_bt, h=ss_bt, align="z");
        }
    }
    
}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
spring_stopper();
spring_stopper_slider();