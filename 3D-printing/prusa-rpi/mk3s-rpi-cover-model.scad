use<../../lib/solidpp/solidpp.scad>

include<mk3s-rpi-cover-constants.scad>

use<mk3s-interface-model.scad>
use<rpi-0w2-model.scad>
use<rpi-0w2-eth-hat-model.scad>

module cover()
{

    difference()
    {
        // main shape
        cubepp([cover_x, cover_y, cover_h], align="z", mod_list=[round_edges(r=cover_r)]);

        // inner cut
        translate([0,0,cover_bt])
            cubepp([cover_inner_x, cover_inner_y, cover_h], align="z", mod_list=[round_edges(r=cover_inner_r)]);


        translate([-rpi_0w2_x/2,-rpi_0w2_y/2, cover_bt])
        {
            // rpi ports cut
            translate([0,0,rpi_0w2_hat_bottom_spacer_h+rpi_0w2_hat_pcb_t+rpi_0w2_hat_top_spacer_h])
                rpi_0w2_port_holes();

            // hat ports cut
            translate([0,0,rpi_0w2_hat_bottom_spacer_h])
                rpi_0w2_eth_hat_port_holes();


            // holes cut
            rpi_0w2_holes(pcb_t=cover_bt);
        }
    }

    // add hooks
    translate([0,0,cover_h])
        mk3s_interface();


}
