use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<tightening-head-constants.scad>
include<links-parameters.scad>

include<camera-interface-constants.scad>

use<camera-holder-model.scad>

use<bracket.scad>

module ci_bracket()
{
    _brr = get_bracket_rounding_radius();
    _bd = get_bracket_diameter();

    difference()
    {

        hull()
        {
            cubepp([2*lnk_nut_part_t,_bd/2, ci_h], align="xZ");
            translate([0,0,_bd/2])
                cylinderpp(d=th_inner_d, h=2*lnk_nut_part_t,zet="x", align="x");
        }
        // nuthole
        translate([lnk_nut_part_t,0,_bd/2])
            rotate([0,-90,0])
            {
                    nut_hole(   d=lnk_fastener_d,
                                standard=lnk_nut_standard, align="b");
                
                bolt_hole(standard=lnk_bolt_standard,
                            descriptor=lnk_bolt_descriptor);
            }

        // cut
        translate([lnk_nut_part_t,0,lnk_nut_part_t])
        {
            cubepp([2*lnk_nut_part_t, _bd, _bd], align="xz");
            cylinderpp(r=lnk_nut_part_t, h=_bd, zet="y", align="x");
        }
    }
}

module camera_interface()
{
    // baseplane    
    difference()
    {
        union()
        {
            // baseplate
            cubepp([ci_a, ci_a, ci_h],
                    align="z",
                    mod_list=[round_edges(r=ch_cr)]);
            // bracket
            align_from_shell_to_interface_center()
                align_to_shell_origin()
                    translate([-_brr-_bd/2,0,ci_h])
                        coordinate_frame()
                            ci_bracket();
        }
        
        // mountpoints
        _mnt_off = ci_a/2 - ch_interface_offset/2;
        mirrorpp([0,1,0], true)
            mirrorpp([1,0,0], true)
                translate([_mnt_off, _mnt_off, ci_h])
                    bolt_hole(  standard=ch_interface_bolt_standard,
                                descriptor=ch_interface_bolt_descriptor,
                                align="m");

    }

    // mountpoint
    _brr = get_bracket_rounding_radius();
    _bd = get_bracket_diameter();





    align_from_shell_to_interface_center()
        align_to_shell_origin()
            translate([-_brr-_bd/2,0,ci_h])
                %aligned_bracket();

}


$fn = $preview ? 30 : 120;
camera_interface();