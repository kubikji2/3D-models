use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<tightening-head-constants.scad>
include<links-parameters.scad>

function get_bracket_rounding_radius() = get_bolt_head_height(
                descriptor=lnk_bolt_descriptor,
                standard=lnk_bolt_standard) +  th_clearance + lnk_head_part_t;

function get_bracket_diameter() = th_spacing_d + 2*th_clearance;

module aligned_bracket()
{
    _hh = get_bolt_head_height(
                descriptor=lnk_bolt_descriptor,
                standard=lnk_bolt_standard);

    _rr = lnk_head_part_t + _hh + th_clearance;
    _d = th_spacing_d + 2*th_clearance;

    translate([_rr/2,-_rr/2-_d/2,0])
        bracket();
}

module bracket()
{
    
    _d = th_spacing_d + 2*th_clearance;
    _hh = get_bolt_head_height(
                descriptor=lnk_bolt_descriptor,
                standard=lnk_bolt_standard);

    _rr = lnk_head_part_t + _hh + th_clearance;

    union()
    {
        mirrorpp([-1,1,0], true)
        translate([_rr/2, -_rr/2, 0])
        difference()
        {
            translate([0,0,_d/2-th_inner_d/2])
            union()
            {
                translate([_d/2-th_inner_d/2,0,0])
                cylinderpp(d=th_inner_d, h=lnk_middle_part_t, zet="y", align="xYz");
                cubepp([_d/2, lnk_middle_part_t, th_inner_d], align="xYz");
            }
            
            // hole
            translate([_d/2,0,_d/2])
                cylinderpp(d=lnk_fastener_d+0.2, h=3*lnk_middle_part_t, zet="y", align="");
        }
        
        
        
        translate([0,0,_d/2-th_inner_d/2])
        intersection()
        {
            //coordinate_frame();
            difference()
            {
                translate([-_rr/2-lnk_middle_part_t, -_rr/2-lnk_middle_part_t,0])
                    cubepp([_rr+lnk_middle_part_t,_rr+lnk_middle_part_t,th_inner_d]);
                translate([_rr/2, _rr/2,0])
                    cylinderpp(r=_rr, h=3*_d, align="");
            }
            // 
            translate([_rr/2, _rr/2,0])
                    cylinderpp(r=_rr+lnk_middle_part_t, h=3*_d, align="");
        }
    }


}

$fn = $preview ? 36:144;
bracket();