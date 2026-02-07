use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>


use<ivar/ivar-interface.scad>
include<ivar/ivar-dimensions.scad>

// prusa spool holder interface parameters

prusa_frame_h = 40;
prusa_frame_t = 6;

prusa_spool_holder_interface_offset = 4;
prusa_spool_holder_width = 30;

module spool_holder_interface(  ziptie_thickness,
                                ziptie_width,
                                wall_thickness,
                                bolt_descriptor,
                                bolt_standard,
                                nut_standard,
                                has_spool_interface,
                                ziptie_head=undef,
                                clearance = 0.2)
{
    _height = prusa_frame_h+2*prusa_spool_holder_interface_offset;
    _prusa_spool_holder_width = prusa_spool_holder_width + 2*clearance;

    _ivar_clearance = 0.1;

    difference()
    {
        union()
        {
            // main shape
            difference()
            {
                ivar_interface_basic_geometry(
                    wall_thickness=wall_thickness,
                    height=_height,
                    clearance=_ivar_clearance);


            }

            // ivar interface
            translate([0,0,-wall_thickness+2*_ivar_clearance])
                replicate_at_ivar_interface_holes()
                    cylinderpp( d=ivar_leg_hole_diameter-2*clearance,
                                h=10+2*_ivar_clearance,
                                align="Z");
                
            // spool holder interface
            if (has_spool_interface)
            {
                // lower
                cubepp([prusa_spool_holder_width+2*wall_thickness, prusa_frame_h-2*prusa_spool_holder_interface_offset, prusa_spool_holder_interface_offset], align="z");
                translate([0,0,prusa_spool_holder_interface_offset])
                {
                    cubepp([_prusa_spool_holder_width,prusa_frame_h,prusa_frame_t], align="z");
                    mirrorpp([1,0,0], true)
                        translate([_prusa_spool_holder_width/2,0,0])
                            cubepp([wall_thickness-clearance, _height, prusa_frame_t], align="xz");
                }
            }

        }

        // ziptie holes
        ziptie_off = (prusa_frame_h-2*prusa_spool_holder_interface_offset)/3;
        mirrorpp([0,1,0], true)
            mirrorpp([1,0,0], true)
            translate([ivar_leg_w/2+wall_thickness,ziptie_off,0])
                cubepp([2*ziptie_thickness,ziptie_width,3*ivar_leg_d], align="");
        vertical_ziptie_witdth = is_undef(ziptie_head) ? ziptie_width : ziptie_head;
        mirrorpp([0,1,0], true)
            translate([0,ziptie_off,0])
                cubepp([3*ivar_leg_w,vertical_ziptie_witdth,ziptie_thickness], align="Z");

        // bolt holes for mounting the interface
        if (has_spool_interface)
        {
            // splitting to two parts
            translate([0,0, prusa_spool_holder_interface_offset/2])
                cubepp([2*prusa_spool_holder_width,2*prusa_frame_h,0.1], align="");
            
            // adding bolt and nut holes
            mirrorpp([0,1,0], true)
                mirrorpp([1,0,0], true)
                    translate([ivar_leg_hole_gauge_w/2,ziptie_off/2,-wall_thickness+0.5])
                    {
                        bolt_hole( standard=bolt_standard,
                                    descriptor=bolt_descriptor,
                                    sh_off=10,
                                    hh_off=10);
                        nut_hole(   d=deez_nuts_parse_descriptor(bolt_descriptor)[0],
                                    standard=nut_standard,
                                    h_off=1);
                    }

        }
    }
}
