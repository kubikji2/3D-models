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

        // ventilation holes
        // horizontal ventilation holes
        h_spacing = (rpi_0w2_x-(cover_vent_h_count-1)*cover_vent_h_t)/cover_vent_h_count + cover_vent_h_t;
        for (i=[0:cover_vent_h_count-1])
        {
            _off = i*h_spacing -rpi_0w2_x/2;
            _w = h_spacing-cover_vent_h_t;
            _l = i > 1 && i < cover_vent_h_count-2 ? rpi_0w2_y : rpi_0w2_y-4*rpi_0w2_fastener_hole_offset;
            if (i != 4)
            {
                translate([_off,0,0])
                    cubepp( [_w, _l, 3*cover_bt],
                            align="x",
                            mod_list=[round_edges(d=_w)]);
            }
        }

        // vertical ventilation holes
        v_spacing = (rpi_0w2_x-2*rpi_0w2_fastener_hole_offset-(cover_vent_v_count-1)*cover_vent_v_t)/cover_vent_v_count + cover_vent_v_t;
        for (i=[0:cover_vent_v_count-1])
        {
            _off = i*v_spacing -(rpi_0w2_x-2*rpi_0w2_fastener_hole_offset)/2;
            _w = v_spacing-cover_vent_v_t;
            translate([_off,cover_inner_y/2,cover_bt])
                cubepp( [_w, 3*cover_wt, cover_inner_h-cover_bt],
                        align="xz",
                        mod_list=[round_edges(d=_w, axes="xz")]);
        }

        // add hole for the ethernet cable velcro
        translate([-rpi_0w2_x/2+4.5*h_spacing-0.5*cover_vent_h_t,0,0])
        mirrorpp([1,0,0], true)
            translate([cover_eth_cable_width/2,0,0])
                cubepp([h_spacing-cover_vent_h_t,cover_eth_velcro_width,3*cover_bt], align="x");

    }

    // add hooks
    translate([0,0,cover_h])
        mk3s_interface();


}
