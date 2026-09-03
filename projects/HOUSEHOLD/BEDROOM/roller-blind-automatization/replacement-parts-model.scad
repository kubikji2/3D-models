
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

            _spacer_h = rp_part_clearance+rp_bc2hb_wheels_offset; 
            // ball chain wheel to herringbon wheel transition
            translate([0,0,_h])
                tubepp(d=_slit_d+2*rp_part_clearance,D=bc_wheel_outer_d,h=_spacer_h);
            
            // herringbone wheel
            translate([0,0,_h+_spacer_h])
                difference()
                {
                    herringbone_helical_gear(
                        // DEFINE THESE FOR THE GEAR PROFILE.
                        metric_module = rp_hb_metric_module,
                        number_of_teeth = rp_hb_n_teeth_big_wheel, // Integer as big as your CPU can handle, but smaller than 4 may not work.
                        pressure_angle = rp_hb_pressure_angle,
                        helix_angle = rp_hb_helix_angle, // Positive number for LeftHand, Negative number for RightHand
                        angular_resolution = rp_hb_angular_resolution, // 1 works good, smaller gives higher resolution.
                        width = rp_hb_width, // width = Thickness of gear
                        layer_thickness = rp_hb_layer_thickness, // measured in mm
                        back_lash = rp_hb_back_lash, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
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

    _interface_offset = rp_bc2hb_wheels_offset + rp_wheel_h + 2*rp_wheel_clearance + rp_bracket_h;
    
    // ball bearing gauge
    _slit_d = get_bb_based_ball_bearing_gauge(rp_ball_count);
    
    
    difference()
    {
        union()
        {
            roller_blind_interface(_h, interface_offset=_interface_offset);
            // add space for the ball bearing
            //translate([0,0,rp_part_clearance])
                cylinderpp(d=_slit_d-rp_part_clearance,h=_interface_offset);
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
        translate([0,0,rp_bc2hb_wheels_offset])
        {
            translate([0,0,rp_wheel_h/2])
                bb_based_ball_bearing_hole(rp_ball_count);

            translate([0,0,rp_wheel_h+rp_wheel_clearance+rp_bracket_h/2])
                bb_based_ball_bearing_hole(rp_ball_count);
        }
    }
    
}

module nema17_herring_bone_whell(shaft_clearance = 0.1)
{

    _slit_d = get_bb_based_ball_bearing_gauge(rp_dw_ball_count);

    difference()
    {
        union()
        {
            // herringbone whell
            translate([0,0,rp_hb_width])
            rotate([180,0,0])
            herringbone_helical_gear(
                // DEFINE THESE FOR THE GEAR PROFILE.
                metric_module = rp_hb_metric_module,
                number_of_teeth = rp_hb_n_teeth_drive_wheel, // Integer as big as your CPU can handle, but smaller than 4 may not work.
                pressure_angle = rp_hb_pressure_angle,
                helix_angle = rp_hb_helix_angle, // Positive number for LeftHand, Negative number for RightHand
                angular_resolution = rp_hb_angular_resolution, // 1 works good, smaller gives higher resolution.
                width = rp_hb_width, // width = Thickness of gear
                layer_thickness = rp_hb_layer_thickness, // measured in mm
                back_lash = rp_hb_back_lash, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
                is_verbose = false 
                );
            
            // bearing mount
            translate([0,0,rp_wheel_h])
                cylinderpp(d=_slit_d-0.25,h=rp_wheel_h+rp_wheel_clearance);
        }

        // hole for nema shaft
        difference()
        {
            cylinderpp(d=rp_dw_shaft_d+2*shaft_clearance, h=2*rp_hb_width, align="");
            translate([-rp_dw_shaft_d/2+rp_dw_shaft_cut_t,0,0])
                cubepp([rp_dw_shaft_d,rp_dw_shaft_d,5*rp_hb_width], align="x");
        }

        // ball bearing hole
        translate([0,0,rp_wheel_h+rp_wheel_h/2+rp_wheel_clearance])
            bb_based_ball_bearing_hole(rp_dw_ball_count);

    }

}

module nema17_holes(
    mountpoints = [0,1,2,3],
    bolt_standard = "DIN84A",
    bolt_length = nema17_mountpoints_max_dp,
    clearance = 0.2
)
{
    // middle hole
    cylinderpp(d=nema17_center_d+2*clearance, h=nema17_center_t+clearance);

    // shaft height
    cylinderpp(d=nema17_shaft_d+2*clearance,h=nema17_shaft_h);

    // mountpoints
    _n17g2 = nema17_mountpoints_g/2;
    _poses = [[-_n17g2,_n17g2],[_n17g2,_n17g2],[-_n17g2,-_n17g2],[_n17g2,-_n17g2]];
    _descriptor = str("M", nema17_mountpoints_d, "x", bolt_length);
    
    for (i=[0:3])
    {
        if (len(search(i, mountpoints)) > 0)
            translate([_poses[i][0],_poses[i][1],-nema17_mountpoints_max_dp])
                bolt_hole(standard=bolt_standard, descriptor=_descriptor);

    }

    // body
    _a = nema17_a + 2*clearance;
    _h = nema17_h + 2*clearance;
    translate([0,0,clearance])
        cubepp([_a,_a,_h], align="Z");
}

module nema17_plate(
    bracket_bolt_standard="DIN84A",
    bracket_bolt_length = 6,
    bracket_bolt_diameter = 3,
    bracket_nut_descriptor = "DIN562")
{
    _axis_distance = rp_wheels_outer_distance-rp_drive_wheel_d/2-rp_interface_wheel_d/2;
    _x = bracket_bolt_diameter/2+rp_plate_wt+rp_bm_from_center+_axis_distance+nema17_a/2;
    _y = nema17_a;

    difference()
    {
        union()
        {
            translate([-rp_bm_from_center-rp_plate_wt-bracket_bolt_diameter/2,0,0])
            {
                cubepp([_x,_y,rp_plate_t], align="xz", mod_list=[round_edges(rp_plate_wt)]);
                
                // reinforcement
                _rf_t = (_y - rp_plate_iner_cut_w)/2;
                _rf_off_x = rp_plate_wt+rp_bm_t+bracket_bolt_diameter/2;
                mirrorpp([0,1,0], true)
                    translate([_rf_off_x, rp_plate_iner_cut_w/2, rp_plate_t])
                    //coordinate_frame()
                    difference()
                    {
                        cubepp([_x-_rf_off_x, _rf_t, rp_plate_iner_cut_h]);
                        rotate([0,45,0])
                            cubepp([_x,_x,_x], align="Xz");
                    }
            }
            // nema plate
            translate([_axis_distance-nema17_a/2-rp_bm_t,0,0])
                cubepp([nema17_a+rp_bm_t,nema17_a,rp_bm_t+rp_nema17_offset+rp_bm_t], align="zx");
            
        }

        // bracket mountpoints
        _descriptor = str("M",bracket_bolt_diameter,"x",bracket_bolt_length);
        translate([-rp_bm_from_center,0,0])
            mirrorpp([0,1,0], true)
                translate([0,rp_bm_g/2,0])
                {
                    bolt_hole(standard=bracket_bolt_standard, descriptor=_descriptor);
                    nut_hole(standard=bracket_nut_descriptor,d=bracket_bolt_diameter);
                
                }
        // nema mounting
        translate([_axis_distance,0,rp_plate_t+rp_nema17_offset])
            nema17_holes(bolt_length=8);

        // bracket hole
        translate([0,0,rp_plate_t+rp_plate_iner_cut_h])
            cylinderpp(d=50,h=rp_plate_t, align="z");

    }

}

nema17_plate();


//nema17_herring_bone_whell();
//#cylinderpp(d=24);


$fn = $preview ? 36: 120;

//roller_blind_interface_replacement_part();

//translate([0,0,-bc_wheel_h-rp_part_clearance])
//    ball_chain_wheel_replacement_part();
//#cylinderpp(d=44.5,h=15);

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