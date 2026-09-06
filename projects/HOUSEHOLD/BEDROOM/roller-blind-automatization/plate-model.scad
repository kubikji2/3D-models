
// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// nema17 interface
include<nema17-dimensions.scad>
use<nema17-models.scad>

// plate parameters
include<plate-parameters.scad>

// herringbone wheels 
include<herringbone-wheels-parameters.scad>


module nema17_plate_wall_mounted(
    bracket_bolt_standard="DIN84A",
    bracket_bolt_length = 6,
    bracket_bolt_diameter = 3,
    bracket_nut_descriptor = "DIN562")
{
    //_axis_distance = rp_wheels_outer_distance-rp_drive_wheel_d/2-rp_interface_wheel_d/2;
    _x = bracket_bolt_diameter/2+plate_wt+bracket_mountpoints_from_center+hb_wheel_axes_gauge+nema17_a/2;
    _y = nema17_a;

    // reinforcement
    _rf_t = (_y - plate_cut_inner_w)/2;
    _rf_off_x = plate_wt+bracket_mountpoints_t+bracket_bolt_diameter/2;

    difference()
    {
        union()
        {
            translate([-bracket_mountpoints_from_center-plate_wt-bracket_bolt_diameter/2,0,0])
            {
                cubepp([_x,_y,plate_t], align="xz", mod_list=[round_edges(plate_wt)]);
                
                // reinforcement
                mirrorpp([0,1,0], true)
                    translate([_rf_off_x, plate_cut_inner_w/2, plate_t])
                    //coordinate_frame()
                    difference()
                    {
                        cubepp([_x-_rf_off_x, _rf_t, plate_cut_inner_h]);
                        rotate([0,45,0])
                            cubepp([_x,_x,_x], align="Xz");
                    }
            }
            
            // nema plate
            translate([hb_wheel_axes_gauge-nema17_a/2-bracket_mountpoints_t,0,0])
                cubepp([nema17_a+bracket_mountpoints_t,nema17_a,bracket_mountpoints_t+plate_nema17_z_offset+bracket_mountpoints_t], align="zx");

        }

        // bracket mountpoints
        _descriptor = str("M",bracket_bolt_diameter,"x",bracket_bolt_length);
        translate([-bracket_mountpoints_from_center,0,0])
            mirrorpp([0,1,0], true)
                translate([0,bracket_mountpoints_g/2,0])
                {
                    bolt_hole(standard=bracket_bolt_standard, descriptor=_descriptor);
                    nut_hole(standard=bracket_nut_descriptor,d=bracket_bolt_diameter);
                
                }
        // nema mounting
        translate([hb_wheel_axes_gauge,0,plate_t+rp_nema17_offset])
            nema17_holes(mountpoints=[1,3],bolt_length=8);

        // bracket hole
        translate([0,0,plate_t+plate_cut_inner_h])
            cylinderpp(d=plate_cut_circular_d,h=plate_t, align="z");

        // inner circular cut
        translate([0,0,plate_t])
        {
            translate([plate_cut_circular_d/2-plate_cut_inner_iffset,0,0])
                cylinderpp(d=plate_cut_inner_w,h=3*plate_cut_inner_h, align="Xz");
            translate([-plate_cut_circular_d/2,0,0])
                cubepp([plate_cut_inner_w,plate_cut_inner_w,_rf_t], align="xz");
        }
    }

}


module nema17_plate_ceiling_mounted(
    bracket_bolt_standard="DIN84A",
    bracket_bolt_length = 6,
    bracket_bolt_diameter = 3,
    bracket_nut_descriptor = "DIN562")
{

    _bracket_mount_w = bracket_mountpoints_g + bracket_bolt_diameter + 2*plate_wt;
    _bracket_mount_x_off = bracket_bolt_diameter/2+plate_wt+bracket_mountpoints_from_center;
    _nema17_l_projected = cos(45-plate_nema17_z_rot)*sqrt(2)*nema17_a/2;
    _nema_17_l = hb_wheel_axes_gauge + _nema17_l_projected;

    //_axis_distance = rp_wheels_outer_distance-rp_drive_wheel_d/2-rp_interface_wheel_d/2;
    _x2 = max(_bracket_mount_x_off,nema17_a/2);
    _x = 2*_x2;
    _y = _bracket_mount_w/2+_nema_17_l;
    _z = bracket_mountpoints_t+plate_nema17_z_offset+bracket_mountpoints_t;

    // reinforcement
    _rf_t = (_y - plate_cut_inner_w)/2;
    _rf_off_x = plate_wt+bracket_mountpoints_t+bracket_bolt_diameter/2;


    difference()
    {
        union()
        {
            
            translate([-_bracket_mount_x_off,-_bracket_mount_w/2,0])
                cubepp([_x,_y,plate_t],mod_list=[round_edges(plate_wt)]);
            
            // nema plate
            translate([0,hb_wheel_axes_gauge-nema17_a/2-bracket_mountpoints_t,0])
                cubepp([_x,
                        _nema_17_l,
                        plate_t+plate_nema17_z_offset+plate_t],
                        align="yz",
                        mod_list=[round_edges(plate_wt)]);

        }

        // bracket mountpoints
        _descriptor = str("M",bracket_bolt_diameter,"x",bracket_bolt_length);
        translate([-bracket_mountpoints_from_center,0,0])
            mirrorpp([0,1,0], true)
                translate([0,bracket_mountpoints_g/2,0])
                {
                    bolt_hole(standard=bracket_bolt_standard, descriptor=_descriptor);
                    nut_hole(standard=bracket_nut_descriptor,d=bracket_bolt_diameter);
                
                }
        
        // nema mounting
        #translate([0,hb_wheel_axes_gauge,plate_t+plate_nema17_z_offset])
            rotate([0,0,plate_nema17_z_rot])
                nema17_holes(   mountpoints=[0,1,3],
                                bolt_length=8,
                                setting_l=plate_nema17_setting_l,
                                setting_angle=90-plate_nema17_z_rot);
        
        // inner circular cut
        translate([0,0,plate_t+plate_cut_inner_h])
            cylinderpp(d=plate_cut_circular_d,h=plate_t, align="z");

        // bracket hole
        translate([0,0,plate_t])
        {
            _off = plate_cut_circular_d/2-plate_cut_inner_iffset;
            __x = bracket_mountpoints_from_center+bracket_bolt_diameter+plate_wt+_off-plate_cut_inner_w/2;
            __y = bracket_mountpoints_w;
            translate([_off,0,0])
                cylinderpp(d=__y,h=3*plate_cut_inner_h, align="Xz");
            translate([_off-plate_cut_inner_w/2,0,0])
                cubepp([__x,__y,_rf_t], align="Xz");
        }
    }

}




$fn = $preview ? 36: 120;

//%nema17_plate_wall_mounted();
nema17_plate_ceiling_mounted();
