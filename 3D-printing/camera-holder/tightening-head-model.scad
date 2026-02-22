use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<tightening-head-constants.scad>
include<links-parameters.scad>

module tighterning_head()
{

    difference()
    {
        union()
        {
            _hh = get_bolt_head_height(
                descriptor=lnk_bolt_descriptor,
                standard=lnk_bolt_standard);
            // middle part
            cylinderpp(d=th_inner_d,h=lnk_head_part_t+_hh);   
            
            // leafs
            for(i=[0:2])
            {
                rotate([0,0,i*120])
                hull()
                {
                    cylinderpp(d=th_inner_d,h=lnk_head_part_t);
                    translate([th_spacing_d/2-th_leaf_d/2,0,0])
                        cylinderpp(d=th_leaf_d,h=lnk_head_part_t);      
                }

            }
        }

        // bolt hole
        rotate([180,0,0])
        bolt_hole(
            descriptor=lnk_bolt_descriptor,
            standard=lnk_bolt_standard,
            align="t", 
            clearance=0);
    }

}


$fn = $preview ? 36:144;
tighterning_head();
