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

module bearing_brackets(clearance=0.2)
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
            translate([hb_wheel_axes_gauge,0,0])
                cylinderpp(d=_smaller_wheel_d, h=rbd_bracket_h, mod_list=[round_bases(d=rbd_bracket_h)]);

        }

        // bigger wheel ball bearing
        translate([0,0,rbd_bracket_h/2])
            rotate([0,0,0])
                bb_based_ball_bearing_hole(bcd_ball_count);
        // bigger wheel bracket inner hole
        cylinderpp(d=_bigger_wheel_g+2*clearance,h=3*rbd_bracket_h, align="");

        // smaller ball bearing
        translate([hb_wheel_axes_gauge,0,rbd_bracket_h/2])
        {
            rotate([0,0,180])
                bb_based_ball_bearing_hole(dw_ball_count);
            // smaller wheel bracket inner hole

            cylinderpp(d=_smaller_wheel_g+2*clearance,h=3*rbd_bracket_h, align="");

        }
    }

}

$fn = $preview ? 36: 120;

bearing_brackets();