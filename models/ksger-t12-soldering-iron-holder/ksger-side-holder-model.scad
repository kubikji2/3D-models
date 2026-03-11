use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<ksger-side-interface-parameters.scad>
include<ksger-side-holder-parameters.scad>

use<ksger-side-interface-model.scad>
use<ksger-side-slider-parameters.scad>
include<ksger-side-slider-model.scad>

module ksger_side_holder_side_interface(clearance=t12_sh_slide_clearance)
{
    _middle_strip_h = t12_si_slider_neck_w + 2*t12_si_slider_bevel;
    _hole_z = t12_z/2 - _middle_strip_h/2 - t12_si_wt;
    _hole_y = t12_y - 2*t12_si_wt;
    difference()
    {
        t12_side_interface();
        translate([0,t12_si_wt+t12_si_bt,t12_z/2])
        mirrorpp([0,0,1], true)
            translate([0,0,-_middle_strip_h/2])
            {
                cubepp([3*t12_si_wt, _hole_y,_hole_z],
                        align="yZ",
                        mod_list=[round_edges(r=t12_si_wt, axes="yz")]);
            }
    }

    // slider
    _slider_neck_h = t12_si_slider_neck_h + t12_sh_slide_clearance + t12_si_wt;
    translate([0,t12_si_bt-clearance,t12_z/2])
        rotate([-90,0,0])
            rotate([0,0,90])
                t12_ksger_side_slider_model(t12_y+clearance, neck_h=_slider_neck_h, clearance=0);

}

module ksger_side_holder_slider()
{
    //coordinate_frame();

    _x = t12_x+2*t12_si_wt+2*t12_sh_slide_clearance;
    _y = t12_y + 2*t12_si_bt + 2*0.2;

    _fin_z = t12_z + t12_sh_slide_clearance +  t12_si_slider_bevel;
    
    // top plate
    difference()
    {
        cubepp( [_x+2*t12_sh_slide_w,_y,t12_sh_bt],
                align="yz",
                mod_list=[round_edges(d=t12_sh_bt, axes="xz")]);

        // screw holes
        _shh = get_screw_head_diameter(descriptor=t12_sh_screw_descriptor,
                                        standard=t12_sh_screw_standard);
        _sxg = t12_x-2*_shh;
        _syg = t12_y-2*_shh;
        translate([0,_y/2,0])
            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                    translate([_sxg/2, _syg/2,0])
                        rotate([180,0,0])
                            screw_hole( descriptor=t12_sh_screw_descriptor,
                                        standard=t12_sh_screw_standard,
                                        align="t");

    }
    mirrorpp([1,0,0], true)
        translate([_x/2,0,0])
        {
            
            translate([0,0,t12_si_bt])
                difference()
                {
                    cubepp([t12_sh_slide_w,_y,t12_z+t12_sh_bt+t12_sh_slide_clearance],
                            align="xyZ",
                            mod_list=[round_edges(d=t12_sh_slide_w, axes="xz")]);

                    // slider top
                    translate([0,t12_sh_slide_clearance,-t12_z/2-t12_sh_bt-t12_sh_slide_clearance])
                        rotate([-90,0,0])
                            rotate([0,0,-90])
                                t12_ksger_side_slider_model(t12_y+t12_si_bt+t12_sh_slide_clearance,
                                    clearance=0.2);
                                    
                    // slider bottom
                    translate([0,t12_si_bt+t12_sh_slide_clearance,-t12_z/2-t12_sh_bt-t12_sh_slide_clearance-t12_si_slider_bevel])
                        rotate([-90,0,0])
                            rotate([0,0,-90])
                                t12_ksger_side_slider_model(t12_y+t12_sh_slide_clearance,
                                    clearance=0.2);
                    
                    // slider cone
                    translate([0,t12_si_bt/2+t12_sh_slide_clearance,-t12_z/2-t12_sh_bt-t12_sh_slide_clearance])
                        mirrorpp([0,0,1], true)
                            rotate([30,0,0])
                                rotate([90,0,0])
                                    rotate([0,0,-90])
                                        t12_ksger_side_slider_model(2*t12_si_bt,
                                            clearance=0.2);

                    // bottom cut-out
                    translate([0,0,-_fin_z-t12_sh_bt+t12_si_slider_bevel+t12_sh_slide_w/2])
                        translate([0,t12_sh_slide_w/2,0])
                            cubepp([3*t12_sh_slide_w,
                                    _y-t12_sh_slide_w,
                                    t12_z/2-t12_sh_slide_w-t12_si_slider_neck_w/2-t12_si_slider_bevel-t12_si_slider_bevel],
                                align="yz",
                                mod_list=[round_edges(d=t12_sh_slide_w, axes="yz")]);
                    
                    // top cut-out
                    translate([0,0,-t12_sh_bt-t12_sh_slide_w/2])
                        translate([0,t12_sh_slide_w/2,0])
                            cubepp([3*t12_sh_slide_w,
                                    _y-t12_sh_slide_w,
                                    t12_z/2-t12_si_slider_neck_w/2-t12_si_slider_bevel-t12_si_slider_bevel-t12_sh_slide_w/2],
                                align="yZ",
                                mod_list=[round_edges(d=t12_sh_slide_w, axes="yz")]);
                    
                }
            }
}





$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

translate([0,0,t12_si_slider_bevel])
mirrorpp([1,0,0], true)
    translate([-t12_x/2,0,0])
        ksger_side_holder_side_interface();


translate([0,0,t12_z + t12_sh_slide_clearance +  t12_si_slider_bevel])
    ksger_side_holder_slider();