use<../../lib/solidpp/solidpp.scad>

include<rpi-0w2-constants.scad>
include<rpi-0w2-eth-hat-constants.scad>

include<rpi-0w2-model.scad>

module rpi_0w2_eth_hat_port_holes(clearance=0.2, W=rpi_0w2_x)
{
    %rpi_0w2_pcb_interce(1.6);

    translate([rpi_0w2_x/2,rpi_0w2_y/2,0])
    {
        // right and left usb
        mirrorpp([1,0,0], true)
            // right usb
            translate([rpi_0w2_x/2-clearance,0,clearance])
                cubepp([W,
                        rpi_0w2_hat_usb_w+2*clearance,
                        rpi_0w2_hat_usb_h+2*clearance],
                        align="xZ");
        
        // top-right usb
        translate([ rpi_0w2_x/2-rpi_0w2_hat_usb3_y_off+clearance,
                    -rpi_0w2_y/2+clearance,
                    0])
            cubepp([rpi_0w2_hat_usb_w+2*clearance,
                    W,
                    rpi_0w2_hat_usb_h+2*clearance],
                    align="XYZ");


        // left mini-usb
        translate([-rpi_0w2_x/2+clearance,0,rpi_0w2_hat_pcb_t-clearance])
            cubepp([W,
                    rpi_0w2_hat_uusb_w+2*clearance,
                    rpi_0w2_hat_uusb_h+2*clearance],
                    align="Xz");

        // RJ45 port
        translate([ -rpi_0w2_x/2-clearance+rpi_0w2_hat_rj45_w_off,
                    -rpi_0w2_y/2+clearance,
                    rpi_0w2_hat_rj45_h_off+clearance])
            cubepp([rpi_0w2_hat_rj45_w+2*clearance,
                    W,
                    rpi_0w2_hat_rj45_h+2*clearance],
                    align="xYZ");

    }
}

