include<inverted-template.scad>
include<plank-inverted-template-holder.scad>

include<../../../lib/solidpp/solidpp.scad>
include<../../../lib/deez-nuts/deez-nuts.scad>

IVAR_SHAPE_A = 35;
IVAR_SHAPE_B = 8;
IVAR_SHAPE_H = 30;
IVAR_SHAPE_CLEARANCE = 0.2;

module __ivar_plank(x=42, y=10, z=10)
{
    cubepp([x, y, z], align="z");
}

module __ivar_shape()
{
    cubepp([    IVAR_SHAPE_A + 2*IVAR_SHAPE_CLEARANCE,
                IVAR_SHAPE_B + 2*IVAR_SHAPE_CLEARANCE,
                IVAR_SHAPE_H],
            mod_list=[round_edges(d=IVAR_SHAPE_B)], align="z");
}

module __ivar_fastener_hole()
{

    bolt_hole(  standard="DIN84A",
                descriptor="M3x14");
    nut_hole(   standard="DIN934",
                d=3,
                h_off=10);
}

module ivar_template_setup(stopper_width=10)
{
    
    %__ivar_shape();
    
    difference()
    {
        union()
        {
            // plank holder
            plank_holder(bottom_thickness=3, stopper_width=stopper_width, wall_thickness=3, wall_height=10, drill_l=IVAR_SHAPE_H)
            {
                __ivar_shape();
                __ivar_plank();
            }

            // shape inverted template
            
            translate([0,0,-0.1])
                rotate([180,0,0])
                    inverted_template(bottom_thickness=0.01, stopper_width=stopper_width, stopper_height=12) 
                        __ivar_shape();
            
        }

        // fastener holes
        // x-axis
        mirrorpp([1,0,0], true)
            translate([drm_d/2+drm_drill_d/2+stopper_width/2+IVAR_SHAPE_A/2,0,-12.5])
                __ivar_fastener_hole();
        // y-axis
        mirrorpp([0, 1,0], true)
            translate([0,drm_d/2+drm_drill_d/2+stopper_width/2+IVAR_SHAPE_B/2,-12.5])
                __ivar_fastener_hole();
    }
    
}

$fn = $preview ? 36 : 72;

ivar_template_setup();

/*
#translate([0,IVAR_SHAPE_B/2,-6])
    cylinderpp(d=drm_drill_d, h=10, align="yz");
%translate([0,IVAR_SHAPE_B/2+drm_drill_d/2, -5])
    tubepp(D=drm_d, d=drm_drill_d+0.2, h=5, align="z");
*/