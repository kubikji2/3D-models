

// dimensions
include<ball-chain-wheel-parameters.scad>

// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// utils
use<herringbone-gear/herringbone-helical-gear.scad>
use<bb-based-ball-bearing/bb-based-ball-bearing.scad>

// parts
use<ball-chain-wheel-model.scad>
//use<roller-blind-interface-model.scad>

// dimensions
include<ball-chain-wheel-parameters.scad>

// herringbone wheel interface parameters
include<herringbone-wheels-parameters.scad>

// ball chain drive parameters
include<ball-chain-drive-parameters.scad>

module ball_chain_drive_replacement_part(
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
    _slit_d = get_bb_based_ball_bearing_gauge(bcd_ball_count);

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

            _spacer_h = bcd_clearance+bcd_bc_to_hb_offset; 
            // ball chain wheel to herringbon wheel transition
            translate([0,0,_h])
                tubepp(d=_slit_d+2*bcd_clearance,D=bc_wheel_outer_d,h=_spacer_h);
            
            // herringbone wheel
            translate([0,0,_h+_spacer_h])
                difference()
                {
                    herringbone_helical_gear(
                        // DEFINE THESE FOR THE GEAR PROFILE.
                        metric_module = hb_metric_module,
                        number_of_teeth = hb_n_teeth_big_wheel, // Integer as big as your CPU can handle, but smaller than 4 may not work.
                        pressure_angle = hb_pressure_angle,
                        helix_angle = hb_helix_angle, // Positive number for LeftHand, Negative number for RightHand
                        angular_resolution = hb_angular_resolution, // 1 works good, smaller gives higher resolution.
                        width = hb_width, // width = Thickness of gear
                        layer_thickness = hb_layer_thickness, // measured in mm
                        back_lash = hb_back_lash, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
                        is_verbose = false 
                        );

                    // bb bearing
                    translate([0,0,hb_width/2])
                        bb_based_ball_bearing_hole(bcd_ball_count);
            
                    // separation slit
                    cylinderpp(d=_slit_d+0.5, h=3*hb_width, align="");
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

$fn = $preview ? 36: 120;

ball_chain_drive_replacement_part();