
// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// utils
use<herringbone-gear/herringbone-helical-gear.scad>
use<bb-based-ball-bearing/bb-based-ball-bearing.scad>

// parts
use<ball-chain-wheel-model.scad>
use<roller-blind-interface-model.scad>

// dimensions
include<ball-chain-wheel-parameters.scad>
include<roller-blind-interface-constants.scad>
//include<replacement-parts-constants.scad>

// herringbone wheel interface parameters
include<herringbone-wheels-parameters.scad>

// ball chain drive parameters for interface bb ball-braring
include<ball-chain-drive-parameters.scad>

// this module parameters
include<roller-blind-damper-parameters.scad>

module roller_blind_damper_replacement(clearance=0.2)
{
    _h = rbi_piece_h;
    _rbi_piece_inner_h = rbi_pieve_inner_h - clearance;

    _rbi_spring_h = rbi_spring_h + clearance;
    //_bc_rbsi_D = bc_rbsi_D + 2*clearance;
    _bc_rbi_d = bc_rbi_d + 2*clearance;

    _rbi_axis_clip_stopper_d = rbi_axis_clip_stopper_d + 2*clearance;
    _rbi_axis_d = rbi_axis_d + 2*clearance;
    _bc_rbsi_h = bc_rbsi_h + clearance;

    _interface_offset = bcd_bc_to_hb_offset + hb_width + 2*hb_wheels_clearance + rbd_bracket_h;
    
    // ball bearing gauge
    _slit_d = get_bb_based_ball_bearing_gauge(bcd_ball_count);
    
    
    difference()
    {
        union()
        {
            roller_blind_interface(
                _h,
                interface_offset=_interface_offset,
                clearance=0);
            
            // add space for the ball bearing
            //translate([0,0,hb_wheels_clearance])
                cylinderpp(d=_slit_d-hb_wheels_clearance,h=_interface_offset);
        }

        difference()
        {
            // main shape
            cut([0,rbi_wedge_angle])
                cylinderpp(d=rbi_d-2*rbi_wt, h=_rbi_piece_inner_h, align="z");
            
            translate([0,0,_rbi_spring_h])
                tubepp(d=_rbi_axis_d, D=_bc_rbi_d-2*clearance, h=_h, align="z");
    
        }

        // inner cut for the spring meachanism piece
        cylinderpp(d=_bc_rbi_d, h=_rbi_spring_h);

        // inner slide-in cut for the axis
        cylinderpp(d=_rbi_axis_d, h=_bc_rbsi_h+clearance, align="z");

        // hole for the axis (shown in the are of the stopper)
        cylinderpp(d=_rbi_axis_clip_stopper_d,h=3*_h, align="");

        // axis hole above the stopper
        translate([0,0,rbi_axis_clip_stopper_h+_bc_rbsi_h-clearance])
            cylinderpp(d=rbi_d-2*rbi_wt, h=_h, align="z");
        
        // ball bearing holes
        translate([0,0,bcd_bc_to_hb_offset])
        {
            translate([0,0,hb_width/2])
                bb_based_ball_bearing_hole(bcd_ball_count);

            translate([0,0,hb_width+hb_wheels_clearance+rbd_bracket_h/2])
                bb_based_ball_bearing_hole(bcd_ball_count);
        }
    }
    
}

$fn = $preview ? 36: 120;

roller_blind_damper_replacement();