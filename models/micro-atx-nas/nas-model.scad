
// solidpp
use<../../lib/solidpp/solidpp.scad>

// motherboard visual
use<gigabyte-ga-b85m-hd3-model.scad>


//
include<nas-parameters.scad>

module __uatx_nas_plate(h)
{
    cubepp([uatx_nas_x,uatx_nas_y,h], mod_list=[round_edges(r=uatx_nas_cr)]);
}

module __uatx_nas_hdd_rack()
{

}

module uatx_nas_hhd_bay()
{

    __uatx_nas_plate(h=uatx_nas_hdd_bay_bt);

}

module uatx_nas_hhd_shell()
{
    
}


module __uatx_motherboard_mount_point(transition_a = 3, clearance=0.1)
{
    // TODO add serration or increase hole for the heat inserts

    // main shape
    tubepp( d=bg_ga_b85_hd3_mount_point_d+2*clearance,
            D=bg_ga_b85_hd3_spacer_d,
            h=bg_ga_b85_hd3_spacer_h,
            align="Z");
    
    // transition
    translate([0,0,-bg_ga_b85_hd3_spacer_h])
        difference()
        {
            tubepp( d=bg_ga_b85_hd3_spacer_d-clearance,
                    D=bg_ga_b85_hd3_spacer_d+2*transition_a,
                    h=transition_a);
            toruspp(t=2*transition_a,
                    d=bg_ga_b85_hd3_spacer_d,
                    align="z",
                    $fs=0.1);
        }
    
}

module uatx_motherboard_bay()
{
    // baseplate with holes for cables
    difference()
    {
        // baseplate
        __uatx_nas_plate(h=uatx_nas_motherboard_bay_bt);
        
        // cable hole
        translate([ uatx_nas_wt+uatx_nas_additional_spacing,
                    uatx_nas_wt+uatx_nas_additional_spacing,
                    0])
            cubepp([bg_ga_b85_hd3_x,
                    uatx_nas_cable_space,
                    3*uatx_nas_motherboard_bay_bt],
                    align="xy",
                    mod_list=[round_edges(r=bg_ga_b85_hd3_cr)]);
    }

    // motherboard mountpoints
    translate([ uatx_nas_additional_spacing+uatx_nas_wt,
                uatx_nas_additional_spacing+uatx_nas_cable_space+uatx_nas_wt,
                bg_ga_b85_hd3_spacer_h+uatx_nas_motherboard_bay_bt])
    {
        // motherboard visuals
        %gigabyte_ga_b85m_hd3_motherboard();
        
        // mountpoints
        bg_ga_b85_hd3_replicate_to_mount_points()
            __uatx_motherboard_mount_point();
    }

    // TODO add hinges for opening NAS

}

uatx_motherboard_bay();


module uatx_motherboard_shell()
{

    // TODO basic shell
    
    // TODO power button

    // TODO slot for EPS

    // TODO ventilation for the CPU cooler

    // TODO ventilation holes on the side



}