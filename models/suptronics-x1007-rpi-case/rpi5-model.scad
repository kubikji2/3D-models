use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<rpi5-dimensions.scad>


module rpi5_connector_holes(clearance, wall_thickness = 5)
{
    
    // pcb
    %cubepp([rpi5_x, rpi5_y, rpi5_pcb_t], mod_list=[round_edges(d=(rpi5_y-rpi5_mnt_g_y)/2)]);

    translate([0,0,rpi5_pcb_t-clearance])
    {

        _wt = wall_thickness + 2*clearance;

        // bottom connectors
        translate([0,clearance,0])
        {
            // usbc
            translate([rpi5_usbc_x_off,0,0])
                cubepp([rpi5_usbc_w+2*clearance,
                        _wt,
                        rpi5_usbc_h+2*clearance], align="Yz");

            // mini usb1
            translate([rpi5_mini_usb1_x_off,0,0])
                cubepp([rpi5_mini_usb_w+2*clearance,
                        _wt,
                        rpi5_mini_usb_h+2*clearance], align="Yz");

            // mini usb2
            translate([rpi5_mini_usb2_x_off,0,0])
                cubepp([rpi5_mini_usb_w+2*clearance,
                        _wt,
                        rpi5_mini_usb_h+2*clearance], align="Yz");
        }


        translate([rpi5_x-clearance,0,0])
        {
            __wt = _wt + rpi5_connector_x_overlap;
            
            // ethernet
            translate([0,rpi5_eth_y_off,0])
                cubepp([__wt,
                        rpi5_eth_w+2*clearance,
                        rpi5_eth_h+2*clearance], align="xz");

            // usb tower 1
            translate([0,rpi5_usb1_y_off,0])
                cubepp([__wt,
                        rpi5_usb_w+2*clearance,
                        rpi5_usb_h+2*clearance], align="xz");

            // usb tower 2
            translate([0,rpi5_usb2_y_off,0])
                cubepp([__wt,
                        rpi5_usb_w+2*clearance,
                        rpi5_usb_h+2*clearance], align="xz");
        }
        

        translate([clearance,0,0])
        {
            
            // LED hole
            translate([0,rpi5_led_y_off,0])
                cylinderpp( d=rpi5_led_d+2*clearance,
                            h=_wt,
                            zet="x",
                            align="Xz");

            // power button hole
            translate([0,rpi5_power_button_y_off,0])
                cylinderpp( d=rpi5_power_button_d+2*clearance,
                            h=_wt,
                            zet="x",
                            align="Xz");

        }

    }

}


$fn=36;
rpi5_connector_holes(0.2);