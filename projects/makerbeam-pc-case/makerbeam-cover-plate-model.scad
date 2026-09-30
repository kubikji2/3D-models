// master requirements
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// makerbeam dimensions
include<makerbeam-constants.scad>

// corners
include<makerbeam-corner-parameters.scad>
//use<makerbeam-corner-model.scad>

// parameters
include<makerbeam-cover-plate-parameters.scad>


function __mkc__beam_length_to_inner_length(beam_length) = 
            beam_length + 2*mbc_wt;
function __mkc__inner_length_to_total_length(beam_length) = 
            __mkc__beam_length_to_inner_length(beam_length) + 2*mb1010_a;


module makerbeam_cover_corner_cutter(
    beam_length,
    height,
    corner_clearance=0.2,
    top_corners_offset=0,
    bottom_corners_offset=0,
)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__inner_length_to_total_length(beam_length);

    //mirrorpp([0,1,0], true)
    mirrorpp([1,0,0], true)
        translate([total_length/2, -height/2+bottom_corners_offset, 0])
            hull()
            {
            
                __a = 2*mb1010_a+2*corner_clearance;
                __h = __a + 2*mbc_overlap+2*mbc_wt;
                cubepp([__a,__h,3*mb_cover_wt], align="");
                cubepp([__h,__a,3*mb_cover_wt], align="");
            }

    // top corners
    mirrorpp([1,0,0], true)
        translate([total_length/2, height/2+top_corners_offset, 0])
            hull()
            {
            
                __a = 2*mb1010_a+2*corner_clearance;
                __h = __a + 2*mbc_overlap+2*mbc_wt;
                cubepp([__a,__h,3*mb_cover_wt], align="");
                cubepp([__h,__a,3*mb_cover_wt], align="");
            }
}

module makerbeam_cover_plate_shape_2d(
    beam_length,
    height,
    corner_clearance=0.2,
    top_corners_offset=0,
    bottom_corners_offset=0,
)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__inner_length_to_total_length(beam_length);

    difference()
    {
        squarepp([total_length, height], align="");

        // bottom corners
        mirrorpp([1,0], true)
            translate([total_length/2, -height/2+bottom_corners_offset, 0])
                hull()
                {
                
                    __a = 2*mb1010_a+2*corner_clearance;
                    __h = __a + 2*mbc_overlap+2*mbc_wt;
                    squarepp([__a,__h], align="");
                    squarepp([__h,__a], align="");
                }

        mirrorpp([1,0], true)
            translate([total_length/2, height/2+top_corners_offset, 0])
                hull()
                {
                
                    __a = 2*mb1010_a+2*corner_clearance;
                    __h = __a + 2*mbc_overlap+2*mbc_wt;
                    squarepp([__a,__h], align="");
                    squarepp([__h,__a], align="");
                }
    }
}

module makerbeam_cover_pattern(
    beam_length,
    height,
    pattern_height_offset = 0
)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__inner_length_to_total_length(beam_length);

    // counts
    _a = mb_cover_pattern_d + mb_cover_pattern_spacing;
    _tiling_a = sqrt( (3/4) *_a*_a);
    _x_off = _tiling_a;
    _y_off = _tiling_a*sin(120);

    _x_cnt = floor(total_length/_x_off)+1;
    _y_cnt = floor(height/_y_off);
   
    _pattern_align_x = -(inner_length/2);
    _pattern_align_y = -(height/2);
    _pattern_offset_x = -(((_x_cnt-1)*_x_off)-inner_length)/2;
    _pattern_offset_y = -((_y_cnt*_y_off)-height)/2;

    
    _HEIGHT = height+pattern_height_offset;
    _y_cnt_including_carry = floor((_HEIGHT)/_y_off);
    _pattern_offset_y_from_height = ((_y_cnt_including_carry*_y_off)-_HEIGHT)/2;
    _pattern_offset_x_from_height = (_y_cnt_including_carry-_y_cnt) % 2 == 0 ? -_tiling_a/2 : 0;

    //translate([_pattern_offset_x+_pattern_offset_x_from_height, 
    // _pattern_offset_y+_pattern_offset_y_from_height,0])
    translate([ _pattern_align_x,
                _pattern_align_y+pattern_height_offset,
                0])
    for (y=[0:_y_cnt+1])
    {
        __x_off = y % 2 == 0 ? -_tiling_a/2 : 0;
        for (x=[0:_x_cnt])
        {
            translate([x*_x_off+__x_off, y*_y_off,0])
                rotate([0,0,90])
                    cylinderpp(d=mb_cover_pattern_d, h=2*mb_cover_pattern_wt, $fn=6, align="");
        }
    }

}



module makerbeam_cover_plate(
    beam_length,
    height,
    has_pattern = true,
    pattern_height_offset = 0,
    corner_clearance = 0.15,
    top_corners_offset = 0,
    bottom_corners_offset = 0,
    has_bottom_transition=false,
    has_top_transition=false,

)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__inner_length_to_total_length(beam_length);

    _corner_offset = top_corners_offset+bottom_corners_offset;

    difference()
    {
        // main shape
        cubepp([total_length, height, mb_cover_wt], align="z");

        // cut off corners
        //translate([0,(bottom_corners_offset+top_corners_offset)/2,0])
        makerbeam_cover_corner_cutter(
            beam_length=beam_length,
            height=height,
            corner_clearance=corner_clearance,
            top_corners_offset=top_corners_offset,
            bottom_corners_offset=bottom_corners_offset);
        
        render(30)
        translate([0,0,mb_cover_wt])
        intersection()
        {
            
            makerbeam_cover_pattern(
                beam_length=beam_length,
                height=height,
                pattern_height_offset = pattern_height_offset // TODO this
                );
            

            union()
            {
                translate([0,0,-mb_cover_pattern_wt])
                    linear_extrude(2*mb_cover_pattern_wt)
                        offset(-mb_cover_pattern_spacing)
                            makerbeam_cover_plate_shape_2d(
                                beam_length=beam_length,
                                height=height,
                                corner_clearance=corner_clearance,
                                top_corners_offset=top_corners_offset,
                                bottom_corners_offset=bottom_corners_offset);

                // top and button transitions
                _w = total_length-2*(mb1010_a+mbc_overlap+mbc_wt+corner_clearance)-2*mb_cover_pattern_spacing;
                if (has_bottom_transition)
                    cubepp([_w,height,3*mb_cover_wt], align="Y");

                if (has_top_transition)
                    cubepp([_w,height,3*mb_cover_wt], align="y");
            }


        
        }
        
    }


}


// bottom one

makerbeam_cover_plate(200, 135, top_corners_offset=5);

translate([0,135+0.2])
makerbeam_cover_plate(200, 135, bottom_corners_offset=-5);

use<makerbeam-corner-model.scad>
use<makerbeam-double-corner-model.scad>
translate([113,62.5,0])
%translate([-mb1010_a/2,mb1010_a/2,mb1010_a/2])
    rotate([90,0,0])
    rotate([0,0,180])
        makerbeam_double_corner();