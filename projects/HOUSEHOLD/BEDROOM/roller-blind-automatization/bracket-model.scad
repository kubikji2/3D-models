// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// ball chain drive parameters
use<bb-based-ball-bearing/bb-based-ball-bearing.scad>

// herringbone wheel interface parameters
include<herringbone-wheels-parameters.scad>

// small wheel bb ball-bearing
include<nema17-wheel-parameters.scad>
// big wheel bb ball-bearing
include<ball-chain-drive-parameters.scad>

// this module parameters
include<bracket-parameters.scad>

include<roller-blind-interface-constants.scad>

include<roller-blind-damper-parameters.scad>

include<nema17-bearing-parameters.scad>

module bearing_brackets(
    clearance=0.2,
    ball_bearing_type = "bearing"
)
{
    _bigger_wheel_g = get_bb_based_ball_bearing_gauge(bcd_ball_count);
    _smaller_wheel_g = get_bb_based_ball_bearing_gauge(dw_ball_count);
    
    _bigger_wheel_d = _bigger_wheel_g + rbd_ball_d + 2*bearing_bracket_wt;
    _smaller_wheel_d = _smaller_wheel_g + rbd_ball_d + 2*bearing_bracket_wt;

    difference()
    {
        hull()
        {
            cylinderpp(d=_bigger_wheel_d, h=rbd_bracket_h, mod_list=[round_bases(d=rbd_bracket_h)]);
            if (ball_bearing_type=="bb")
            {
                translate([hb_wheel_axes_gauge,0,0])
                    cylinderpp(d=_smaller_wheel_d, h=rbd_bracket_h, mod_list=[round_bases(d=rbd_bracket_h)]);
            }
            else if (ball_bearing_type=="bearing")
            {
                _d = bearing_bracket_bearing_D+2*(bearing_bracket_positioner_l+bh_wheels_setting_l);
                translate([hb_wheel_axes_gauge,0,0])
                    cylinderpp(d=_d, h=rbd_bracket_h, mod_list=[round_bases(d=rbd_bracket_h)]);
                
            }
        }

        // bigger wheel ball bearing
        translate([0,0,rbd_bracket_h/2])
            rotate([0,0,0])
                bb_based_ball_bearing_hole(bcd_ball_count);

        // bigger wheel bracket inner hole
        cylinderpp(d=_bigger_wheel_g+2*clearance,h=3*rbd_bracket_h, align="");

        // smaller ball bearing
        if (ball_bearing_type == "bb")
        {
            translate([hb_wheel_axes_gauge,0,rbd_bracket_h/2])
            {
                rotate([0,0,180])
                    bb_based_ball_bearing_hole(dw_ball_count);
                // smaller wheel bracket inner hole

                cylinderpp(d=_smaller_wheel_g+2*clearance,h=3*rbd_bracket_h, align="");

            }
        }
        else if (ball_bearing_type == "bearing")
        {
            translate([hb_wheel_axes_gauge,0,rbd_bracket_h/2])
            {
                _bd = bearing_bracket_bearing_D+2*bearing_bracket_bearing_clearance;
                _bh = bearing_bracket_bearing_h+2*bearing_bracket_bearing_clearance;
                //coordinate_frame();
                
                // hole for the bearing
                mirrorpp([1,0,0], true)
                    translate([bh_wheels_setting_l/2,0,0])
                    {
                        cylinderpp(d=_bd,h=_bh, align="");
                        cylinderpp(d=bearing_bracket_bearing_D-2*bearing_bracket_bearing_stopper,h=3*rbd_bracket_h, align="");
                    }
                
                translate([bh_wheels_setting_l/2,0,(rbd_bracket_h-bearing_bracket_bearing_h)/2])
                    cylinderpp(d=_bd,h=rbd_bracket_h, align="");

                cubepp([bh_wheels_setting_l,_bd,_bh], align="");
                cubepp([bh_wheels_setting_l,
                        bearing_bracket_bearing_D-2*bearing_bracket_bearing_stopper,
                        3*rbd_bracket_h], align="");

                for (i=[0:2])
                {
                    rotate([0, 0, i*1200]) 
                        translate([bearing_bracket_bearing_D/2-bh_wheels_setting_l/2,0,0])
                            rotate([0,90,0])   
                            {
                                //coordinate_frame();                                
                                bolt_hole(  descriptor=bearing_bracket_positioner_descriptor,
                                            standard=bearing_bracket_positioner_standard,
                                            hh_off=_bigger_wheel_d);
                                rotate([0,0,180])
                                translate([0,0,bearing_bracket_positioner_l/2])
                                    nut_hole(  d=bearing_bracket_positioner_d,
                                                standard=bearing_bracket_nut_standard,
                                                align="m",
                                                s_off=rbd_bracket_h);
                            }
                            
                }
            }
        }
    }

}

$fn = $preview ? 36: 120;

bearing_brackets();