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
function __mkc__beamer_length_to_total_length(beam_length) = 
            __mkc__beam_length_to_inner_length(beam_length) + 2*mb1010_a;


// Helper: Clamps a value between a min and max
// created using AI assitance
function clamp(v, min_v = 0.0, max_v = 1.0) = max(min_v, min(max_v, v));

// Helper: Calculate scale factor for a single circle
// Uses a smoothstep (Hermite interpolation) for an organic falloff
// created using AI assitance
function circle_scale_factor(pt, circ, default_min_scale = 0.15) = 
    let(
        c_pos  = [circ[0], circ[1]],
        c_rad  = circ[2],
        // Use custom min_scale if defined in circle [x, y, r, min_scale], else default
        min_s  = (len(circ) > 3) ? circ[3] : default_min_scale,
        dist   = norm(pt - c_pos)
    )
    (dist >= c_rad) ? 1.0 :
    let(
        // Normalized distance 0.0 (center) to 1.0 (perimeter)
        t = clamp(dist / c_rad),
        // Smoothstep: smooth transition without harsh borders
        smooth_t = t * t * (3 - 2 * t)
    )
    min_s + (1.0 - min_s) * smooth_t;


// ====================================================================
// RECURSIVE FUNCTION: Evaluates scale across the list of circles
// Combines influences by taking the minimum scale (strongest attractor)
// ====================================================================
// created using AI assitance
function get_hex_scale(pt, circles, idx = 0, default_min_scale = 0.15) =
    (idx >= len(circles)) 
        ? 1.0 
        : min(
            circle_scale_factor(pt, circles[idx], default_min_scale),
            get_hex_scale(pt, circles, idx + 1, default_min_scale)
          );


module makerbeam_cover_corner_pair_cutter(
    beam_length,
    corner_clearance=0.2,
)
{
    // compute corner pair spacing
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

    // corner pair
    mirrorpp([1,0,0], true)
        translate([total_length/2,0, 0])
            hull()
            {
            
                __a = 2*mb1010_a+2*corner_clearance;
                __h = __a + 2*mbc_overlap+2*mbc_wt;
                cubepp([__a,__h,3*mb_cover_wt], align="");
                cubepp([__h,__a,3*mb_cover_wt], align="");
            }

}


module makerbeam_cover_double_corner_pair_cutter(
    beam_length,
    corner_clearance=0.2,
)
{
    // compute corner pair spacing
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

    // corner pair
    mirrorpp([1,0,0], true)
        translate([total_length/2,0, 0])
            hull()
            {
            
                __a = 2*mb1010_a+2*corner_clearance;
                __h = mb1010_a+2*mbc_overlap+2*mbc_wt+2*corner_clearance;
                __l = 2*(mb1010_a+mbc_overlap+mbc_wt+corner_clearance);
                cubepp([__a,__h,3*mb_cover_wt], align="");
                cubepp([__l,mb1010_a+2*corner_clearance,3*mb_cover_wt], align="");
            }

}

module makerbeam_cover_double_corner_pair_shape_2d(
    beam_length,
    corner_clearance=0.2,
)
{
    // compute corner pair spacing
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

    // corner pair
    mirrorpp([1,0], true)
        translate([total_length/2,0])
            hull()
            {
            
                __a = 2*mb1010_a+2*corner_clearance;
                __h = mb1010_a+2*mbc_overlap+2*mbc_wt+2*corner_clearance;
                __l = 2*(mb1010_a+mbc_overlap+mbc_wt+corner_clearance);
                squarepp([__a,__h], align="");
                squarepp([__l,mb1010_a+2*corner_clearance], align="");
            }

}

module makerbeam_cover_corner_cutter(
    beam_length,
    height,
    corner_clearance=0.2,
    top_corners_offset=0,
    bottom_corners_offset=0,
)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

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
    total_length = __mkc__beamer_length_to_total_length(beam_length);

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
    recess_depth=mb_cover_pattern_wt,
    pattern_d = mb_cover_pattern_d,
    pattern_spacing = mb_cover_pattern_spacing,
    pattern_height_offset = undef,
    pattern_array = undef,
    pattern_circles_data = undef
)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

    // counts
    _a = pattern_d + pattern_spacing;
    _tiling_a = sqrt( (3/4) *_a*_a);
    _x_off = _tiling_a;
    _y_off = _tiling_a*sin(120);

    _x_cnt = floor(total_length/_x_off)+1;
    _y_cnt = floor(height/_y_off);
   
    _pattern_align_x = -(inner_length/2);
    _pattern_align_y = -(height/2);
    _pattern_offset_x = -(((_x_cnt-1)*_x_off)-inner_length)/2;
    _pattern_offset_y = -((_y_cnt*_y_off)-height)/2;

    //echo(_x_cnt);
    //echo(_y_cnt);
    assert (is_undef(pattern_array) || (len(pattern_array)==_y_cnt && len(pattern_array[0]) == _x_cnt ));
    
    //_HEIGHT = height+pattern_height_offset;
    //_y_cnt_including_carry = floor((_HEIGHT)/_y_off);
    //_pattern_offset_y_from_height = ((_y_cnt_including_carry*_y_off)-_HEIGHT)/2;
    //_pattern_offset_x_from_height = (_y_cnt_including_carry-_y_cnt) % 2 == 0 ? -_tiling_a/2 : 0;

    //translate([_pattern_offset_x+_pattern_offset_x_from_height, 
    // _pattern_offset_y+_pattern_offset_y_from_height,0])
    translate([ _pattern_align_x+_pattern_offset_x,
                is_undef(pattern_height_offset) ? _pattern_align_y+_pattern_offset_y : pattern_height_offset,
                0])
                //coordinate_frame()
    for (y=[0:_y_cnt+1])
    {
        __x_off = y % 2 == 0 ? -_tiling_a/2 : 0;
        for (x=[0:_x_cnt])
        {
            pt = [x * _x_off + __x_off, y * _y_off];
            sf = is_undef(pattern_circles_data) ? 1 : get_hex_scale(pt, pattern_circles_data, default_min_scale = 0.15);
            _d = sf*pattern_d;
            if (is_undef(pattern_array) || !pattern_array[y][x])
                translate([x*_x_off+__x_off, y*_y_off,0])
                    rotate([0,0,90])
                        cylinderpp(d=_d, h=2*recess_depth, $fn=6, align="");
        }
    }

}



module makerbeam_cover_plate(
    beam_length,
    height,
    has_pattern = true,
    pattern_height_offset = undef,
    pattern_d = mb_cover_pattern_d,
    pattern_spacing = mb_cover_pattern_spacing,
    corner_clearance = 0.15,
    top_corners_offset = 0,
    bottom_corners_offset = 0,
    has_bottom_transition=false,
    has_top_transition=false,

)
{
    inner_length = __mkc__beam_length_to_inner_length(beam_length);
    total_length = __mkc__beamer_length_to_total_length(beam_length);

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
        
        if (has_pattern)
        render(30)
        translate([0,0,mb_cover_wt])
        intersection()
        {
            
            makerbeam_cover_pattern(
                beam_length=beam_length,
                height=height,
                pattern_height_offset = pattern_height_offset, // TODO this
                pattern_d=pattern_d,
                pattern_spacing=pattern_spacing
                );
            

            union()
            {
                translate([0,0,-mb_cover_pattern_wt])
                    linear_extrude(2*mb_cover_pattern_wt)
                        offset(-pattern_spacing)
                            makerbeam_cover_plate_shape_2d(
                                beam_length=beam_length,
                                height=height,
                                corner_clearance=corner_clearance,
                                top_corners_offset=top_corners_offset,
                                bottom_corners_offset=bottom_corners_offset);

                // top and button transitions
                _w = total_length-2*(mb1010_a+mbc_overlap+mbc_wt+corner_clearance)-2*pattern_spacing;
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