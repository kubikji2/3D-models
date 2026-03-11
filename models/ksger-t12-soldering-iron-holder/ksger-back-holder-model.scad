use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

use<ksger-back-interface-model.scad>
use<ksger-back-slider-model.scad>

include<ksger-dimensions.scad>
include<ksger-back-interface-parameters.scad>

include<ksger-back-slider-parameters.scad>
use<ksger-back-slider-model.scad>

include<ksger-back-holder-parameters.scad>

module ksger_t12_replicate_hooks()
{
    translate([0,0,t12_z/2 + t12_int_wt])
        children();

    translate([0,0,t12_int_wt])
        children();    

}


module ksger_t12_holder_hook(clearance)
{

    _interface_d = t12_int_h + t12_int_bevel +t12_int_h;
    // slider hole
    translate([0,_interface_d,t12_slider_interface_h-t12_slider_interface_overlap])
        rotate([0,0,180])
            ksger_slider(t12_slider_interface_w, t12_slider_interface_h, neck_length=t12_int_h, clearance=clearance);
    translate([0,-clearance,0])
        cubepp([t12_slider_interface_w+2*clearance,
                _interface_d+2*clearance,
                t12_slider_interface_h], align="yz");
    
}


module ksger_t12_reinforcement_triangle(z)
{
    // middle reinforcement
    hull()
    {   
        // vertical         
        cubepp([t12_int_wt,t12_int_wt,z],align="YZ");

        // horizontal
        cubepp([t12_int_wt,t12_slider_interface_w,t12_int_wt], align="Yz");
    }
}

module ksger_t12_mounting_interface(
    clearance=0.2,
    aligning_clearance = 0.5, 
    flap_length=12,
    reinfocement_t = 4)
{
    _interface_d = t12_int_h + t12_int_bevel +t12_int_h;
    
    ksger_t12_replicate_hooks()
        translate([0,_interface_d,t12_slider_interface_h-t12_slider_interface_overlap])
            difference()
            {
                rotate([0,0,180])
                    ksger_slider(
                        t12_slider_interface_w,
                        t12_slider_interface_h,
                        neck_length=t12_int_h+clearance,
                        clearance=0);
                translate([0,0,t12_slider_interface_h])
                    rotate([45,0,0])
                        cubepp([2*t12_slider_interface_w,t12_int_h*sqrt(2),t12_int_h*sqrt(2)], align="");
                rotate([45,0,0])
                    cubepp([2*t12_slider_interface_w,t12_int_h*sqrt(2),t12_int_h*sqrt(2)], align="");
                
                mirrorpp([1,0,0], true)
                translate([t12_slider_interface_w/2,0,0])
                rotate([0,0,45])
                    cubepp([t12_int_h*sqrt(2),t12_int_h*sqrt(2),2*t12_slider_interface_h], align="");
            }
    _z = t12_z+t12_slider_interface_overlap-t12_int_wt+aligning_clearance;
    _x = t12_x+2*aligning_clearance+2*t12_int_wt;
    translate([0,-clearance,0])
    {
        difference()
        {
            union()
            {
                translate([0,0,t12_slider_interface_h+t12_int_wt-t12_slider_interface_overlap])
                    cubepp([t12_slider_interface_w,t12_int_wt,_z],
                        align="Yz");

                // top plate and alignement flaps
                mirrorpp([1,0,0], true)
                translate([0,0,t12_z+t12_slider_interface_h+aligning_clearance])
                {
                    // top plate
                    translate([0,flap_length,0])
                        cubepp([_x,
                                t12_slider_interface_w+flap_length,
                                4],
                                align="Yz");

                    // alignement flaps
                    translate([t12_x/2+aligning_clearance,0,0])
                    {
                        // back reinforcement
                        translate([t12_int_wt/2,0,0])
                            difference()
                            {
                                ksger_t12_reinforcement_triangle(z=_z);
                                // cut lower part
                                translate([0,0,-flap_length])
                                        cubepp([_z,_z,_z], align="Z");
                            }


                        hull()
                        {
                            cubepp([t12_int_wt, flap_length, 0.01], align="yxZ");
                            cubepp([t12_int_wt, 0.01, flap_length], align="yxZ");
                        }
                    }

                    // middle reinforcement
                    ksger_t12_reinforcement_triangle(z=_z);

                    // flap reinforcement
                    // ... positioning
                    _yis = t12_slider_interface_w-t12_int_wt;
                    _zis = _z;
                    _k = 1-(flap_length)/(_zis);
                    // ... orientation
                    _a = asin(_yis/_zis);
                    
                    // models
                    translate([0,-t12_int_wt-_k*(_yis),-(1-_k)*_zis])
                        rotate([_a,0,0])
                        {
                            // main reinforcement
                            cubepp([_x/2, t12_int_wt, reinfocement_t], align="xyz");
                            
                            // middle fillets
                            translate([t12_int_wt/2,0,-reinfocement_t])
                            difference()
                            {
                                cubepp([reinfocement_t, t12_int_wt, 3*reinfocement_t], align="xyz");
                                translate([0,0,reinfocement_t])
                                translate([0,0,reinfocement_t/2])
                                mirrorpp([0,0,1], true)
                                translate([0,0,-reinfocement_t/2])
                                    cylinderpp( r=reinfocement_t,
                                                h=3*t12_int_wt,
                                                zet="y", 
                                                align="xZ");
                            }

                            // end bevel
                            translate([_x/2-t12_int_wt,0,reinfocement_t])
                                difference()
                                {
                                    cubepp([reinfocement_t,t12_int_wt,reinfocement_t], align="Xyz");
                                    translate([-reinfocement_t,0,reinfocement_t])
                                        cylinderpp(r=reinfocement_t, h=3*t12_int_wt, zet="y",align="");

                                }
                        }

                }
            }
        
        // mountpoints
        _sh = get_screw_head_diameter(
            descriptor=t12_mounting_screw_descriptor,
            standard=t12_mounting_screw_standard);
        
        mirrorpp([1,0,0], true)
            translate([0,-clearance,t12_z+t12_slider_interface_h+t12_int_wt])
                translate([_x/2-t12_int_wt-_sh/2-t12_int_wt,-_sh/2,0])
                    rotate([180,0,0])
                        //coordinate_frame()
                        screw_hole(
                            descriptor=t12_mounting_screw_descriptor,
                            standard=t12_mounting_screw_standard,
                            align="t",
                            hh_off=reinfocement_t);
        
        }
    }
}

module ksger_t12_holder(clearance=0.2)
{

    slider_block_w = 16;

    _hd = get_bolt_head_diameter(   standard=t12_int_mnt_bolt_standard, 
                                    descriptor=t12_int_mnt_bolt_descriptor);
    _hole_z = max(t12_mnt_gauge_z-t12_mnt_fasterner_d-2*t12_int_wt, 21);

    difference()
    {
        union()
        {
            // frame
            ksger_interface();

            // area for the slider
            difference()
            {
                cubepp([slider_block_w+2*t12_cr,t12_int_bt,t12_z],
                        align="yz");

                mirrorpp([1,0,0], true)
                    translate([slider_block_w/2,0,(t12_z-_hole_z)/2])
                        cubepp([2*t12_cr,3*t12_int_bt,_hole_z],
                                align="xz",
                                mod_list=[round_edges(r=t12_cr, axes="xz")]);
                    
            }
        }


        ksger_t12_replicate_hooks()  
            ksger_t12_holder_hook(
                clearance=clearance);
        
    }
    
}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;


//translate([0,0,7])
//%ksger_t12_holder();

ksger_t12_mounting_interface();