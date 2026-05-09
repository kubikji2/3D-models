use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>


use<ivar-interface.scad>
include<../ivar-dimensions.scad>

// prusa spool holder interface parameters

prusa_frame_h = 40;
prusa_frame_t = 6;

prusa_spool_holder_interface_offset = 4;
prusa_spool_holder_width = 30;


module ziptie_ivar_interface_ziptie_holes(
    height,
    ziptie_thickness,
    ziptie_width,
    ziptie_head,
    wall_thickness,
    clearance)
{
    // ziptie holes
    ziptie_off = height/4;//(prusa_frame_h-2*prusa_spool_holder_interface_offset)/3;
    mirrorpp([0,1,0], true)
        mirrorpp([1,0,0], true)
        translate([ivar_leg_w/2+wall_thickness-clearance,ziptie_off,0])
            cubepp([2*ziptie_thickness,ziptie_width+2*clearance,ivar_leg_d+wall_thickness], align="Z");
    
    vertical_ziptie_witdth = (is_undef(ziptie_head) ? ziptie_width : ziptie_head)+2*clearance;
    mirrorpp([0,1,0], true)
        translate([0,ziptie_off,0])
            cubepp([ivar_leg_w+2*wall_thickness,vertical_ziptie_witdth,ziptie_thickness], align="Z");
}


module ziptie_ivar_interface(   height,
                                ziptie_thickness,
                                ziptie_width,
                                wall_thickness,
                                has_spool_interface,
                                ziptie_head=undef,
                                clearance = 0.2)
{
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
                    height=height,
                    clearance=_ivar_clearance);


            }

            // ivar interface
            translate([0,0,-wall_thickness+2*_ivar_clearance])
                replicate_at_ivar_interface_holes()
                    cylinderpp( d=ivar_leg_hole_diameter-2*clearance,
                                h=10+2*_ivar_clearance,
                                align="Z");
                

        }

        ziptie_ivar_interface_ziptie_holes(
            height=height,
            ziptie_thickness=ziptie_thickness,
            ziptie_width=ziptie_width,
            ziptie_head=ziptie_head,
            wall_thickness=wall_thickness,
            clearance=clearance);

    }
}
