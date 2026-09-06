
// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// utils
use<herringbone-gear/herringbone-helical-gear.scad>
use<bb-based-ball-bearing/bb-based-ball-bearing.scad>

// herringbone
include<herringbone-wheels-parameters.scad>

// parameters
include<nema17-wheel-parameters.scad>

// ball bearings
include<nema17-bearing-parameters.scad>

// circular serration
include<../../../../utils/circular-serration.scad>

module nema17_herring_bone_whell(
    shaft_clearance = 0.1,
    ball_bearing_type = "bearing"
)
{

    _slit_d = get_bb_based_ball_bearing_gauge(dw_ball_count);
    _bearring_z_off = (hb_width-bearing_bracket_bearing_h)/2;

    difference()
    {
        union()
        {
            // herringbone whell
            translate([0,0,hb_width])
            rotate([180,0,0])
            herringbone_helical_gear(
                // DEFINE THESE FOR THE GEAR PROFILE.
                metric_module = hb_metric_module,
                number_of_teeth = hb_n_teeth_small_wheel, // Integer as big as your CPU can handle, but smaller than 4 may not work.
                pressure_angle = hb_pressure_angle,
                helix_angle = hb_helix_angle, // Positive number for LeftHand, Negative number for RightHand
                angular_resolution = hb_angular_resolution, // 1 works good, smaller gives higher resolution.
                width = hb_width, // width = Thickness of gear
                layer_thickness = hb_layer_thickness, // measured in mm
                back_lash = hb_back_lash, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
                is_verbose = false 
                );
            
            // bearing mount
            if (ball_bearing_type=="bb")
                translate([0,0,hb_width])
                    cylinderpp(d=_slit_d-0.25,h=hb_width+hb_wheels_clearance);
            else if (ball_bearing_type=="bearing")
            {
                translate([0,0,hb_width])
                {
                    // connector
                    cylinderpp(d=_slit_d,h=_bearring_z_off);   
                    // stopper
                    cylinderpp( d=bearing_bracket_bearing_d+2*bearing_bracket_bearing_stopper,
                                h=_bearring_z_off+hb_wheels_clearance);   
                    // peg for the bearing
                    translate([0,0,_bearring_z_off+hb_wheels_clearance])
                    {
                        _r = bearing_bracket_bearing_d/2 + shaft_clearance;
                        cylinderpp( r=_r,
                                    h=bearing_bracket_bearing_h+hb_wheels_clearance);

                        circular_serration(
                            radius=_r,
                            height=bearing_bracket_bearing_h+hb_wheels_clearance,
                            n_serration=36,
                            serration_bottom_d=4*shaft_clearance,
                            serration_top_d=2*shaft_clearance);
                    }
                }
            }
        }

        // hole for nema shaft
        difference()
        {
            cylinderpp(d=dw_shaft_d+2*shaft_clearance, h=2*hb_width, align="");
            translate([-dw_shaft_d/2+dw_shaft_cut_t,0,0])
                cubepp([dw_shaft_d,dw_shaft_d,5*hb_width], align="x");
        }

        // ball bearing hole
        if (ball_bearing_type=="bb")
            translate([0,0,hb_width+hb_width/2+hb_wheels_clearance])
                bb_based_ball_bearing_hole(dw_ball_count);

    }

}

$fn = $preview ? 36: 120;

nema17_herring_bone_whell();