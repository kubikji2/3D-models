use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<odroid-h4-constants.scad>

module lower_spacer(clearance=0.2)
{
    _d = H4_PCB_MP_DIAMETER+2*clearance;
    tubepp( d=_d,
            D=H4_PCB_MP_CLEARED_DIAMETER,
            h=H4_PCB_BOTTOM_MINIMAL_CLEARANCE);
}


module replicate_pcb_holes()
{
    // left up hole
    translate([H4_PCB_MP_LU_X, H4_PCB_MP_LU_Y,0])
        children();

    // left down hole
    translate([H4_PCB_MP_LD_X, H4_PCB_MP_LD_Y,0])
        children();
    
    // right up hole
    translate([H4_PCB_MP_RU_X, H4_PCB_MP_RU_Y,0])
        children();

    // right down hole
    translate([H4_PCB_MP_RD_X, H4_PCB_MP_RD_Y,0])
        children();
}

module port_holes(t=5)
{
    // power port
    translate([H4_PORTS_POWER_OFF,0,0])
        cubepp([H4_PORTS_POWER_W, t, H4_PORTS_POWER_H], align="z");
    
    // first USB
    translate([H4_PORTS_USB1_OFF,0,0])
        cubepp([H4_PORTS_USB1_W, t, H4_PORTS_USB1_H], align="z");

    // second USB
    translate([H4_PORTS_USB2_OFF,0,0])
        cubepp([H4_PORTS_USB2_W, t, H4_PORTS_USB2_H], align="z");

    // first media
    translate([H4_PORTS_MEDIA1_OFF,0,0])
        cubepp([H4_PORTS_MEDIA1_W, t, H4_PORTS_MEDIA1_H], align="z");

    // second media
    translate([H4_PORTS_MEDIA2_OFF,0,0])
        cubepp([H4_PORTS_MEDIA2_W, t, H4_PORTS_MEDIA2_H], align="z");

    // audio
    translate([H4_PORTS_AUDIO_OFF,0,0])
        cubepp([H4_PORTS_AUDIO_W, t, H4_PORTS_AUDIO_H], align="z");
}


module pcb_visual()
{
    %color("darkblue")
    difference()
    {
        cubepp( [H4_PCB_A,H4_PCB_A,H4_PCB_T],
                align="z",
                mod_list=[round_edges(r=3)]);

        translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
            replicate_pcb_holes()
                cylinderpp(d=3.52,h=3*H4_PCB_T, align="");
    }
}

$fs = 0.1;
$fa = 5;

pcb_visual();

translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
    port_holes();