use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

use<../../utils/circular-serration.scad>

include<sliding-rod-holder-parameters.scad>

include<sliding-rod-dimensions.scad>
include<item-20-dimensions.scad>

use<item-20-model.scad>

module top_slider_rod_holder(clearance=0.2)
{

    _rh = srh_rod_stopper_h+srh_bt;
    difference()
    {
        union()
        {
            // item ring
            _a = item20_a + 2*srh_wt;
            cubepp([_a, _a, srh_extrusion_stopper_h],
                    align="z",
                    mod_list=[round_edges(r=srh_wt, axes="xy")]);

            // rod holder
            _d = sr_d + 2*srh_wt;
            mirrorpp([1,0,0], true)
            hull()
            {
                cylinderpp(d=item20_a, h=_rh);
                translate([srh_rod_gauge/2, srh_rod_offset, 0])
                    cylinderpp(d=_d, h=_rh);
            }

        }

        // item hole
        translate([0,0,-srh_extrusion_stopper_h])
            item_20_hole(height=3*srh_extrusion_stopper_h,
                        groove_depth=1.5);

        // rod holes
        mirrorpp([1,0,0], true)
            translate([srh_rod_gauge/2, srh_rod_offset, 0])
                difference()
                {
                    _d = sr_d+2*clearance;
                    cylinderpp(
                        d=_d,
                        h=2*srh_rod_stopper_h,
                        align="");

                    circular_serration(  _d/2,
                            srh_rod_stopper_h,
                            n_serration=20,
                            serration_bottom_d=clearance,
                            serration_top_d=2*clearance,
                            z_align="z",
                            $fn=6);

                }
        
        // item bolt 
        mirrorpp([0,1,0], true)
            translate([0,item20_a/2+srh_wt/2,srh_extrusion_stopper_h-srh_fastener_offset])
                rotate([-90,0,0])
                    bolt_hole(  descriptor=srh_bolt_descriptor,
                                standard=srh_bolt_standard,
                                align="m",
                                hh_off=srh_extrusion_stopper_h,
                                clearance=clearance);

    }

}

module bottom_slider_rod_holder(int_clearance=0.15, clearance=0.2)
{
    //%top_slider_rod_holder();

    _a = srh_bottom_int_a + 2*srh_bottom_wt;
    difference()
    {
        //
        union()
        {
            cubepp( [_a, _a, srh_bottom_h],
                    align="z",
                    mod_list=[round_edges(r=srh_bottom_wt, axes="xy")]);
            
            // extrusion interface
            translate([srh_bottom_int_a/2 + srh_bottom_wt + item20_a/2,0,0])
            {
                //coordinate_frame();

                // item ring
                _i20a = item20_a + 2*srh_wt;
                cubepp([_i20a, _i20a, srh_bottom_h],
                        align="z",
                        mod_list=[round_edges(r=srh_wt, axes="xy")]);

                // rod interface
                _d = sr_d + 2*srh_wt;
                _rh = srh_rod_stopper_h+srh_bt;

                mirrorpp([0,1,0], true)
                hull()
                {
                    cylinderpp(d=item20_a, h=_rh);
                    translate([srh_rod_offset, srh_rod_gauge/2, 0])
                        cylinderpp(d=_d, h=_rh);
                    
                    translate([-_i20a/2,0,0])
                        cubepp([srh_wt, srh_bottom_int_a,_rh], align="Xz");
                }
            }
        }

        // top groove
        translate([0,0,srh_bottom_h-srh_bottom_interface_h])
            cubepp([srh_bottom_int_a+2*int_clearance,
                    srh_bottom_int_a+2*int_clearance,
                    srh_bottom_interface_h+int_clearance],
                    align="z");
        
        // holes removing reinforcement
        translate([-1*srh_bottom_rf,-1*srh_bottom_rf,0])
        for (xi=[0:2])
            for (yi=[0:2])
            {
                _x = xi*srh_bottom_rf;
                _y = yi*srh_bottom_rf;
                translate([_x,_y,0])
                    //coordinate_frame()
                    {
                        cubepp([srh_bottom_rf-srh_bottom_wt,
                                srh_bottom_rf-srh_bottom_wt,
                                3*srh_bottom_h],
                                align="",
                                mod_list=[round_edges(r=srh_bottom_wt, axes="xy")]);

                    }
            }
        
        // universal holes

        translate([srh_bottom_int_a/2 + srh_bottom_wt + item20_a/2,0,0])
        {
            // hole for extrusion
            translate([0,0,-srh_bottom_h])
                item_20_hole(height=3*srh_bottom_h,
                            groove_depth=1.5);

            // hole for sliding rods
            mirrorpp([0,1,0], true)
                translate([srh_rod_offset, srh_rod_gauge/2, srh_bt+srh_rod_stopper_h])
                    difference()
                    {
                        _d = sr_d+2*clearance;
                        cylinderpp(
                            d=_d,
                            h=2*srh_rod_stopper_h,
                            align="");

                        circular_serration(  _d/2,
                                srh_rod_stopper_h,
                                n_serration=20,
                                serration_bottom_d=2*clearance,
                                serration_top_d=clearance,
                                z_align="Z",
                                $fn=6);

                    }
            
            // extrusion mounting
            translate([0, 0, srh_bottom_h/2])
                mirrorpp([0,0,1], true)
                    mirrorpp([1,0,0], true)
                        translate([item20_a/2+srh_wt/2, 0, -srh_bottom_h/6])
                            rotate([0,90,0])
                                bolt_hole(  descriptor=srh_bolt_descriptor,
                                            standard=srh_bolt_standard,
                                            align="m",
                                            hh_off=srh_extrusion_stopper_h,
                                            clearance=clearance);

        }
    }

}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
bottom_slider_rod_holder();