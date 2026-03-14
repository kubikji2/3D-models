


use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<spring-locking-parameters.scad>

module tighterning_head()
{

    difference()
    {
        _hh = get_bolt_head_height(
                descriptor=sl_bolt_descriptor,
                standard=sl_bolt_standard);
        _leaf_h = _hh+sl_nut_bt;
        
        union()
        {

            // middle part
            cylinderpp(d=sl_inner_d,h=sl_neck_h+_leaf_h);   
            
            // leafs
            for(i=[0:2])
            {
                rotate([0,0,i*120])
                hull()
                {
                    cylinderpp(d=sl_inner_d,h=_leaf_h);
                    translate([sl_spacing_d/2-sl_leaf_d/2,0,0])
                        cylinderpp(d=sl_leaf_d,h=_leaf_h);      
                }

            }
        }

        // bolt hole
        rotate([180,0,0])
        bolt_hole(
            descriptor=sl_bolt_descriptor,
            standard=sl_bolt_standard,
            align="t", 
            clearance=0);

        // increase hole
        cylinderpp(d=sl_fastener_d+0.4, h=3*sl_bolt_l, align="");
    }

}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

tighterning_head();
