
// solidpp
use<../../lib/solidpp/solidpp.scad>

// motherboard visual
use<gigabyte-ga-b85m-hd3-model.scad>

// hdd
use<hdd-models.scad>
include<hdd-constants.scad>

// psu
use<psu-model.scad>
include<psu-parameters.scad>

$fa = 5;
$fs = 0.1;

//
include<nas-parameters.scad>

module __uatx_nas_plate(h)
{
    cubepp([uatx_nas_x,uatx_nas_y,h], mod_list=[round_edges(r=uatx_nas_cr)]);
}

// module __uatx_

module __uatx_nas_hdd_slot(clearance=0.3)
{
    _x = uatx_nas_hdd_slot_width + 2*uatx_nas_hdd_slot_wt;
    _y = HDD_Y;
    _z = HDD_X+2*clearance+uatx_nas_hdd_slot_wt;

    _transition_a = (uatx_nas_hdd_slot_width-HDD_Z)/2;

    // TODO manage mounting

    difference()
    {
        // main shape
        cubepp([_x,_y,_z]);

        // hdd hole
        translate([uatx_nas_hdd_slot_wt,0,0])
        cubepp([uatx_nas_hdd_slot_width, 3*_y, _z-uatx_nas_hdd_slot_wt], align="xz",
                mod_list=[round_edges(r=_transition_a, axes="xz")]);

        // making frame lighter
        _w = (_y-2*uatx_nas_hdd_slot_wt - uatx_nas_hdd_slot_frames_w*(uatx_nas_hdd_slot_n_frames-1))/uatx_nas_hdd_slot_n_frames ;
        translate([0,uatx_nas_hdd_slot_wt,uatx_nas_hdd_slot_wt])
            for(i=[0:uatx_nas_hdd_slot_n_frames-1])
                translate([0,i*(uatx_nas_hdd_slot_frames_w+_w),0])
                    cubepp([3*_x, _w, _z-2*uatx_nas_hdd_slot_wt],
                        align="yz",
                        mod_list=[round_edges(r=uatx_nas_hdd_slot_frame_cr,axes="yz")]);
        
        // TODO remove material around mounting points 
    }

    

}


module __uatx_nas_hdd_rack()
{
    for (i=[0:5])
        translate([i*(uatx_nas_hdd_slot_width+uatx_nas_hdd_slot_wt),0,0])
            __uatx_nas_hdd_slot();
}

module uatx_nas_hhd_bay()
{
    // base plate
    __uatx_nas_plate(h=uatx_nas_hdd_bay_bt);

    // PSU position
    _hdd_y_off = uatx_nas_y-HDD_Y-uatx_nas_wt-uatx_nas_additional_spacing-H4_CF_H;
    render(20)
        translate([uatx_nas_wt+uatx_nas_additional_spacing, _hdd_y_off, uatx_nas_hdd_bay_bt])
            __uatx_nas_hdd_rack();
    
    // fan
    _fans_x_off = uatx_nas_wt+uatx_nas_additional_spacing + 2*(uatx_nas_hdd_slot_width+uatx_nas_hdd_slot_wt)+uatx_nas_hdd_slot_wt/2;
    %translate([_fans_x_off,uatx_nas_y-uatx_nas_wt,uatx_nas_hdd_bay_bt])
        cubepp([H4_CF_A,H4_CF_H,H4_CF_A], align="Yz");
    
    // psu
    translate([uatx_nas_x-uatx_nas_wt-psu_x,uatx_nas_y-uatx_nas_wt-psu_y,uatx_nas_hdd_bay_bt])
        psu_visual();


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

    // TODO center this


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



module uatx_motherboard_shell()
{

    // TODO basic shell
    
    // TODO power button

    // TODO slot for EPS

    // TODO ventilation for the CPU cooler

    // TODO ventilation holes on the side



}



translate([0,0,uatx_nas_hdd_shell_h+uatx_nas_motherboard_bay_bt])
    uatx_motherboard_bay();

uatx_nas_hhd_bay();