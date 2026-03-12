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
                cylinderpp(d=_d, h=_rh);
                translate([srh_rod_gauge/2, srh_rod_offset, 0])
                    cylinderpp(d=_d, h=_rh);
            }

        }

        // item hole
        translate([0,0,-srh_extrusion_stopper_h])
            item_20_hole(height=3*srh_extrusion_stopper_h);

        // rod holes
        mirrorpp([1,0,0], true)
            translate([srh_rod_gauge/2, srh_rod_offset, 0])
                difference()
                {
                    _d = sr_d+2*clearance;
                    cylinderpp(
                        d=_d,
                        h=3*srh_rod_stopper_h,
                        align="");

                    circular_serration(  _d/2,
                            _rh,
                            n_serration=20,
                            serration_bottom_d=clearance,
                            serration_top_d=2*clearance,
                            z_align="z",
                            $fn=6);

                }
        
        // item bolt 
        mirrorpp([1,0,0], true)
            translate([item20_a/2,0,srh_extrusion_stopper_h-srh_fastener_offset])
                rotate([0,90,0])
                    bolt_hole(  descriptor=srh_bolt_descriptor,
                                standard=srh_bolt_standard,
                                align="m",
                                hh_off=srh_extrusion_stopper_h,
                                clearance=clearance);

    }

}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
top_slider_rod_holder();