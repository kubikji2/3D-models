use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<usb-hub-cover-parameters.scad>

use<../../utils/circular-serration.scad>

include<cable-interface-parameters.scad>


module usb_hub_replicate_at_cover_mountpoints(clearance)
{
    _col_d = ubc_usb_narrow_g + ubc_wt-clearance;
    _col_off = (_col_d+clearance)/2-clearance/2;

    // top row
    translate([0,ubc_y-_col_off,0])
    {                
        // left hole
        translate([_col_off,0,0])
            children();
        
        // middle hole
        translate([ubc_x/2,0,0])
            children();

        // right hole
        translate([ubc_x-_col_off,0,0])
            children();
    }

    // bottom row
    translate([0,_col_off,0])
    {
        // left hole
        translate([_col_off,0,0])
            children();
        
        // right hole
        translate([ubc_x-_col_off,0,0])
            children();   
    }
}


module usb_hub_cover(clearance=0.2)
{
    _col_d = ubc_usb_narrow_g + ubc_wt-clearance;
    
    difference()
    {

        // main shape
        union()
        {
            difference()
            {
                cubepp([ubc_x,ubc_y,ubc_z], mod_list=[round_edges(r=ubc_wt, axes="xy")]);
                // middle cut
                translate([ubc_wt, ubc_wt, ubc_wt])
                    cubepp([ubc_int_x,ubc_int_y-ubc_wt,ubc_int_z]);
                    
            }

            // add columns
            usb_hub_replicate_at_cover_mountpoints(clearance=clearance)
                cylinderpp(d=_col_d, h=ubc_z);

            // add pcb lock
            _w = ubc_int_x-ubc_pcb_w;
            translate([ubc_wt+ubc_pcb_w,ubc_int_y+ubc_wt,ubc_wt])
                cubepp([_w, ubc_pcb_l, ubc_int_z], align="xYz");
        }

        // holes for the usb
        translate([ubc_wt,ubc_wt+ubc_int_y,ubc_wt+usb_z_off-clearance])
        {
            usb_port_w = ubc_usb_w + 2*clearance;
            usb_port_h = ubc_int_z-usb_z_off + clearance;
            // first port 
            translate([usb_x_off-clearance,0,0])
                cubepp([usb_port_w, 3*ubc_wt,usb_port_h], align="xz");
            // second port
            translate([usb_x_off+ubc_usb_narrow_g+ubc_usb_w-clearance,0,0])
                cubepp([usb_port_w, 3*ubc_wt,usb_port_h], align="xz");
            // third port
            translate([usb_x_off+ubc_usb_narrow_g+2*ubc_usb_w+ubc_usb_wide_g-clearance,0,0])
                cubepp([usb_port_w, 3*ubc_wt,usb_port_h], align="xz");
            // fourth port
            translate([usb_x_off+2*ubc_usb_narrow_g+3*ubc_usb_w+ubc_usb_wide_g-clearance,0,0])
                cubepp([usb_port_w, 3*ubc_wt,usb_port_h], align="xz");

        }
        // hole for the cable
        _ch_off = _col_d + (ubc_y-ubc_pcb_l-_col_d)/2;
        translate([ubc_x,_ch_off,ubc_z-ubc_wt])
            cubepp([3*ubc_wt,
                    ci_max_cable_d+2*ci_wt+2*ci_clearance,
                    ci_max_cable_d+ci_clearance+ci_wt],
                    align="Z");
        
        // hole for dc aux power
        translate([ubc_wt,ubc_wt+ubc_dc_y_off-clearance,ubc_z-ubc_wt])
            cubepp([3*ubc_wt,ubc_dc_w+2*clearance,ubc_dc_h+clearance], align="yZ");

        // hole for the LED
        translate([ubc_wt,ubc_y-ubc_usb_l+ubc_led_d,ubc_z-ubc_wt])
            translate([2*ubc_usb_narrow_g+2*ubc_usb_w+ubc_usb_wide_g/2,0,0])
                cylinderpp(d=ubc_led_d+2*clearance, h=3*ubc_wt, align="");

        // cover cut
        translate([0,0,ubc_z-ubc_wt])
            cubepp([3*ubc_int_x,3*ubc_int_x,0.2],align="");

        // cover mountpoints
        usb_hub_replicate_at_cover_mountpoints(clearance=clearance)
        {
            translate([0,0,ubc_z])
            difference()
            {
                bolt_hole(  descriptor=ubc_bolt_descriptor,
                            standard=ubc_bolt_standard,
                            align="m",
                            clearance=0);
                                            
                // seration
                if(!$preview)
                    translate([0,0,-ubc_bolt_l])
                        circular_serration( radius=ubc_fastener_d/2,
                                            height=ubc_bolt_l-ubc_wt,
                                            n_serration=20,
                                            serration_top_d=0.1,
                                            serration_bottom_d=0.2,
                                            $fn=12);
                
            }
        }

        // cut off lover left column
        translate([_col_d/2,_col_d/2,ubc_wt])
            rotate([0,0,45])
                translate([_col_d/2-1,0,0])
                    cubepp([_col_d,_col_d, ubc_int_z], align="xz");
            //coordinate_frame();
        
    }

    // flaps
    _fd = get_screw_head_diameter(  descriptor=ubc_flaps_screw_descriptor,
                                    standard=ubc_flaps_screw_standard) + 2*ubc_flaps_t;
    
    translate([ubc_x/2,ubc_y/2,0])
        mirrorpp([1,0,0], true)
            translate([ubc_x/2-0.01,0,0])
            {
                //coordinate_frame();
                difference()
                {
                    union()
                    {
                        cylinderpp(d=_fd, h=ubc_flaps_t,align="xz");
                        cubepp([_fd/2, 2*_fd, ubc_flaps_t], align="xz");
                    }
                    mirrorpp([0,1,0], true)
                        translate([0,_fd,0])
                            cylinderpp(d=_fd, h=3*ubc_flaps_t,align="x");
                    // scrw hole
                    translate([_fd/2,0,ubc_flaps_t])
                        screw_hole( descriptor=ubc_flaps_screw_descriptor,
                                    standard=ubc_flaps_screw_standard,
                                    align="t");
                }
            }
    
}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

usb_hub_cover();