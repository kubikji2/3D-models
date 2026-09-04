
// libs
use<../../../../lib/solidpp/solidpp.scad>

// utils
use<herringbone-gear/herringbone-helical-gear.scad>
use<bb-based-ball-bearing/bb-based-ball-bearing.scad>

// parts
use<ball-chain-wheel-model.scad>
use<roller-blind-interface-model.scad>

// dimensions
include<ball-chain-wheel-parameters.scad>
include<roller-blind-interface-constants.scad>
include<replacement-parts-constants.scad>


module ball_chain_wheel_replacement_part(
    clearance=0.2,
    fastener_clearance=0.2,
    ball_clearance=0.3,
    tightening_d=3)
{

    _bc_rbi_d = bc_rbi_d + 2*clearance; 
    _bc_rbi_edge_d = bc_rbi_edge_d + 2*clearance;
    _bc_rbi_edge_D = bc_rbi_edge_D + 2*clearance; 
    _bc_rbi_h = bc_rbi_h + clearance;
    _bc_rbsi_D = bc_rbsi_D -2*clearance;
    _bc_rbsi_h = bc_rbsi_h - clearance;

    _h = bc_wheel_h;

    // ball bearing gauge
    _slit_d = get_bb_based_ball_bearing_gauge(rp_ball_count);

    difference()
    {
        union()
        {
            // ball chain wheel
            ball_chain_wheel(
                clearance=clearance,
                fastener_clearance=fastener_clearance,
                ball_clearance=ball_clearance,
                tightening_d=tightening_d
            );

            // ball chain wheel to herringbon wheel transition
            translate([0,0,_h])
                cylinderpp(d=bc_wheel_outer_d,h=rp_part_clearance);
            
            // herringbone wheel
            translate([0,0,_h+rp_part_clearance])
                difference()
                {
                    herringbone_helical_gear(
                        // DEFINE THESE FOR THE GEAR PROFILE.
                        metric_module = 1.5,
                        number_of_teeth = 24, // Integer as big as your CPU can handle, but smaller than 4 may not work.
                        pressure_angle = 20,
                        helix_angle = -30, // Positive number for LeftHand, Negative number for RightHand
                        angular_resolution = 1, // 1 works good, smaller gives higher resolution.
                        width = 7, // width = Thickness of gear
                        layer_thickness = 1, // measured in mm
                        back_lash = 0.01, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
                        is_verbose = false 
                        );

                    // bb bearing
                    translate([0,0,rp_wheel_h/2])
                        bb_based_ball_bearing_hole(rp_ball_count);
            
                    // separation slit
                    cylinderpp(d=_slit_d+0.5, h=3*rp_wheel_h, align="");
                }
            
        }
        

        // interface
        // ... edge
        cylinderpp(d1=_bc_rbi_edge_D,d2=_bc_rbi_edge_d,h=bc_rbi_edge_h, align="z");
        // hole
        cylinderpp(d=_bc_rbi_edge_d,h=_bc_rbi_h, align="z");
        // ... hole through
        cylinderpp(d=_bc_rbi_d, h=3*_h, align="");
    }
    // roller blind spring interface
    cut([0,bc_rbsi_cut_angle])
        translate([0,0,_h])
            tubepp(d=_bc_rbi_d, D=_bc_rbsi_D, h=_bc_rbsi_h, align="z");

}


module roller_blind_interface_replacement_part(clearance=0.2)
{
    _h = rbi_piece_h;
    _rbi_piece_inner_h = rbi_pieve_inner_h - clearance;

    _rbi_spring_h = rbi_spring_h + clearance;
    //_bc_rbsi_D = bc_rbsi_D + 2*clearance;
    _bc_rbi_d = bc_rbi_d + 2*clearance;

    _rbi_axis_clip_stopper_d = rbi_axis_clip_stopper_d + 2*clearance;
    _rbi_axis_d = rbi_axis_d + 2*clearance;
    _bc_rbsi_h = bc_rbsi_h + clearance;

    _interface_offset = rp_wheel_h + 2*rp_wheel_clearance + rp_bracket_h + 2*rp_wheel_clearance;
    
    // ball bearing gauge
    _slit_d = get_bb_based_ball_bearing_gauge(rp_ball_count);
    
    
    difference()
    {
        union()
        {
            roller_blind_interface(_h, interface_offset=_interface_offset);
            // add space for the ball bearing
            //translate([0,0,rp_part_clearance])
                cylinderpp(d=_slit_d,h=_interface_offset-rp_part_clearance);
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
        cylinderpp(d=_rbi_axis_d, h=_bc_rbsi_h, align="z");

        // hole for the axis (shown in the are of the stopper)
        cylinderpp(d=_rbi_axis_clip_stopper_d,h=3*_h, align="");

        // axis hole above the stopper
        translate([0,0,rbi_axis_clip_stopper_h+_bc_rbsi_h])
            cylinderpp(d=rbi_d-2*rbi_wt, h=_h, align="z");
        
        // ball bearing holes
        translate([0,0,rp_wheel_h/2])
            bb_based_ball_bearing_hole(rp_ball_count);

        translate([0,0,rp_wheel_h+rp_wheel_clearance+rp_bracket_h/2])
            bb_based_ball_bearing_hole(rp_ball_count);

    }
    
}


$fn = $preview ? 36: 120;

//roller_blind_interface_replacement_part();

//translate([0,0,-bc_wheel_h-rp_part_clearance])
    ball_chain_wheel_replacement_part();

/*
difference()
{
    herringbone_helical_gear(
        // DEFINE THESE FOR THE GEAR PROFILE.
        metric_module = 1.5,
        number_of_teeth = 24, // Integer as big as your CPU can handle, but smaller than 4 may not work.
        pressure_angle = 20,
        helix_angle = -30, // Positive number for LeftHand, Negative number for RightHand
        angular_resolution = 1, // 1 works good, smaller gives higher resolution.
        width = 7, // width = Thickness of gear
        layer_thickness = 1, // measured in mm
        back_lash = 0.01, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
        is_verbose = false 
    );

    // bb bearing
    translate([0,0,3.5])
        bb_based_ball_bearing_hole(15);
    
    // separation slit
    _d = get_bb_based_ball_bearing_gauge(15);
        tubepp(d=_d-0.5, D=_d+0.5, h=20, align="");
}
*/

/*
translate([60,0,0])
herringbone_helical_gear(
    // DEFINE THESE FOR THE GEAR PROFILE.
    metric_module = 1.5,
    number_of_teeth = 12, // Integer as big as your CPU can handle, but smaller than 4 may not work.
    pressure_angle = 20,
    helix_angle = -30, // Positive number for LeftHand, Negative number for RightHand
    angular_resolution = 1, // 1 works good, smaller gives higher resolution.
    width = 10, // width = Thickness of gear
    layer_thickness = 1, // measured in mm
    back_lash = 0.01, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
    is_verbose = false 
);
*/