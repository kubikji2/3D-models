use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>
use<../../../utils/stencils.scad>

include<../bed-planks-dimensions.scad>
include<towel-box-dimensions.scad>

module towel_box_holder(wt=3,
                        pattern_d=16)
{
    pattern_x = deez_nutz_polygon_width_to_circumscribed_diameter(pattern_d);
    pattern_y = pattern_d;

    // 1. towel box
    difference()
    {
        // outer shell
        cubepp([TOWEL_BOX_Y+2*wt,TOWEL_BOX_Z+2*wt,TOWEL_BOX_X+2*wt],align="z");
        
        // inner
        translate([0,0,wt])
            cubepp([TOWEL_BOX_Y,TOWEL_BOX_Z,TOWEL_BOX_X+2*wt],align="z");
            
        // towel hole
        translate([0,-TOWEL_BOX_Z/2,TOWEL_BOX_X/2+wt])
            cylinderpp([TOWEL_BOX_MINOR_AXIS,3*wt,TOWEL_BOX_MAJOR_AXIS], zet="y", align="", $fn=$preview ? 60 : 120);

        // front pattern
        front_count_x = floor((TOWEL_BOX_Y+2*wt)/pattern_x)+2;
        front_count_y = floor((TOWEL_BOX_X+2*wt)/pattern_y)+2;
        front_offset_x = -(TOWEL_BOX_Y+2*wt)/2 + (TOWEL_BOX_Y+2*wt-front_count_x*pattern_x)/2;
        front_offset_y = -(TOWEL_BOX_X+2*wt)/2 + (TOWEL_BOX_X+2*wt-front_count_y*pattern_y)/2;
        
        translate([0,-TOWEL_BOX_Z/2-wt,TOWEL_BOX_X/2+wt])
            rotate([90,0,0])
                stencil(pattern_size_x=pattern_x,
                        pattern_size_y=pattern_y,
                        pattern_spacing_x=0,
                        pattern_spacing_y=0,
                        pattern_count_x=front_count_x,
                        pattern_count_y=front_count_y,
                        pattern_offset_x=front_offset_x,
                        pattern_offset_y=front_offset_y,
                        modulo_offset_x=pattern_x/2,
                        modulo_offset_y=0,
                        modulo_x = 2,
                        modulo_y = 2)
                {
                    rotate([0,0,90])
                        cylinderpp(d=pattern_d, h=3*wt, align="", $fn=6);
                    
                    difference()
                    {
                        cubepp([TOWEL_BOX_Y-2*wt, TOWEL_BOX_X-2*wt, 3*wt], align="");
                        cylinderpp([TOWEL_BOX_MINOR_AXIS+4*wt,TOWEL_BOX_MAJOR_AXIS+4*wt,6*wt], align="", $fn=$preview ? 60 : 120);
            
                    }
                }
        
        // side patterns
        side_count_x = floor((TOWEL_BOX_Z+2*wt)/pattern_x)+2;
        side_count_y = floor((TOWEL_BOX_X+2*wt)/pattern_y)+2;
        side_offset_x = -(TOWEL_BOX_Z+2*wt)/2 + (TOWEL_BOX_Z+2*wt-side_count_x*pattern_x)/2;
        side_offset_y = -(TOWEL_BOX_X+2*wt)/2 + (TOWEL_BOX_X+2*wt-side_count_y*pattern_y)/2;
        mirrorpp([1,0,0], true)
            translate([TOWEL_BOX_Y/2+wt,0,TOWEL_BOX_X/2+wt])
                rotate([0,0,90])
                    rotate([90,0,0])
                        stencil(pattern_size_x=pattern_x,
                                pattern_size_y=pattern_y,
                                pattern_spacing_x=0,
                                pattern_spacing_y=0,
                                pattern_count_x=side_count_x,
                                pattern_count_y=side_count_y,
                                pattern_offset_x=side_offset_x,
                                pattern_offset_y=side_offset_y,
                                modulo_offset_x=pattern_x/2,
                                modulo_offset_y=0,
                                modulo_x = 2,
                                modulo_y = 2)
                        {
                            rotate([0,0,90])
                                cylinderpp(d=pattern_d, h=3*wt, align="", $fn=6);

                            cubepp([TOWEL_BOX_Z-2*wt, TOWEL_BOX_X-2*wt, 3*wt], align="");
                        }

        // rounding
        translate([0,TOWEL_BOX_Z/2,TOWEL_BOX_X+2*wt])
            difference()
            {
                cubepp([TOWEL_BOX_Y,wt/2,wt/2],align="yZ");
                translate([0,0,0])
                    cylinderpp(d=wt,h=TOWEL_BOX_Y,zet="x",align="yZ");
            }
        

        // add hole for removing the box
        _removal_A = (TOWEL_BOX_MAJOR_AXIS/TOWEL_BOX_X)*TOWEL_BOX_Y;
        _removal_B = (TOWEL_BOX_MINOR_AXIS/TOWEL_BOX_Y)*TOWEL_BOX_Z;
        //echo(_removal_A);
        
        cylinderpp([_removal_A,_removal_B,3*wt], align="", $fn=$preview ? 60 : 120);

    }

    // 2. plank interface
    //%translate([0,TOWEL_BOX_Z/2+wt,TOWEL_BOX_X+wt])
    //    cubepp([TOWEL_BOX_Y+3*wt, VERTICAL_PLANK_T, VERTICAL_PLANK_W], align="yZ");
    _h = TOWEL_BOX_Y+2*wt;
    translate([0,TOWEL_BOX_Z/2+wt, TOWEL_BOX_X+2*wt-wt/2])
    pairwise_hull()
    {
        cylinderpp(d=wt,h=_h,zet="x",align="");
        translate([0,VERTICAL_PLANK_T,0])
            cylinderpp(d=wt,h=_h,zet="x", align="y");
        translate([0,VERTICAL_PLANK_T-1,-VERTICAL_PLANK_W-wt-0.5])
            cylinderpp(d=wt,h=_h,zet="x", align="y");
        // stopper
        translate([0,VERTICAL_PLANK_T/2-1,-VERTICAL_PLANK_W-wt-0.5])
            cylinderpp(d=wt,h=_h,zet="x", align="y");
    }

}

$fs = $preview ? 0.25 : 0.1;
$fa = $preview ? 10 : 5;

towel_box_holder();