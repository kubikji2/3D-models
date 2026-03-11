use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<ksger-back-interface-parameters.scad>

module ksger_interface()
{
    
    _hd = get_bolt_head_diameter(   standard=t12_int_mnt_bolt_standard, 
                                    descriptor=t12_int_mnt_bolt_descriptor);
    
    _hole_z = max(t12_mnt_gauge_z-t12_mnt_fasterner_d-2*t12_int_wt, 21);

    difference()
    {
        cubepp( [t12_x,t12_int_bt,t12_z],
                mod_list=[round_edges(r=t12_cr, axes="xz")],
                align="yz");
        translate([0,0,(t12_z-_hole_z)/2])
            cubepp( [   t12_mnt_gauge_x-_hd/2-2*t12_int_wt,
                        3*t12_int_bt,
                        _hole_z],
                    mod_list=[round_edges(r=t12_cr, axes="xz")],
                    align="z");

        #translate([0,0,t12_z/2])
            mirrorpp([1,0,0], true)
                mirrorpp([0,0,1], true)
                    translate([-t12_mnt_gauge_x/2, 0, -t12_mnt_gauge_z/2])
                        rotate([90,0,0])
                            bolt_hole(  descriptor=t12_int_mnt_bolt_descriptor,
                                        standard=t12_int_mnt_bolt_standard,
                                        align="m");
                            //coordinate_frame();
    }

    %translate([t12_x/2-22.3,0,14])
        cylinderpp(d=12.5,h=2,align="zX", zet="y");

}

//$fa = $preview ? 10 : 5;
//$fs = $preview ? 0.1: 0.05;
//
//ksger_interface();