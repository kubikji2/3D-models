// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// params
include<marcus-aukrelius-parameters.scad>
include<cover-plates-parameters.scad>

// walls
use<../makerbeam-cover-plate-model.scad>
include<../makerbeam-corner-parameters.scad>

// plate
include<../makerbeam-cover-plate-parameters.scad>
use<../hexagonal-crack.scad>

module beamer_length(
    beamer_length,
    split_thicknes=0.15,
    bolt_clearance=0.2,
    eps = 0.2,
    has_pattern = true
)
{
    _total_height = __mkc__beamer_length_to_total_length(ma_mbl_z);
    _total_width = __mkc__beamer_length_to_total_length(beamer_length);

    difference()
    {
        // main shape
        makerbeam_cover_plate(
            beam_length=beamer_length,
            height=_total_height,
            has_pattern=has_pattern,
            pattern_d=ma_cover_pattern_d,
            pattern_spacing=ma_cover_pattern_spacing
        );

        // mountpoints
        __corner_offset = (mb1010_a+mbc_wt+mbc_overlap) + mb1010_a/2;
        translate([0,0,-mb_cover_bolt_l_offset])
            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                {
                    //coordinate_frame()
                    // ... vertical corner mountpoints
                    translate([_total_width/2-mb1010_a/2,_total_height/2-__corner_offset,0])
                        bolt_hole(
                            standard=mb_cover_bolt_standard,
                            descriptor=mb_cover_bold_desriptor,
                            clearance=bolt_clearance);

                    // ... horizontal mountpoints
                    translate([_total_width/2-__corner_offset,_total_height/2-mb1010_a/2,0])
                        bolt_hole(
                            standard=mb_cover_bolt_standard,
                            descriptor=mb_cover_bold_desriptor,
                            clearance=bolt_clearance);
                    // middle points
                    translate([ma_cover_mnt_middle_off,_total_height/2-mb1010_a/2,0])
                        bolt_hole(
                            standard=mb_cover_bolt_standard,
                            descriptor=mb_cover_bold_desriptor,
                            clearance=bolt_clearance);
                    
                }
        
        // split
        _a = mb_cover_pattern_d + mb_cover_pattern_spacing;
        _tiling_a = sqrt( (3/4) *_a*_a);
        _segment_length = _tiling_a/cos(180/6)/2;

        hexagonal_crack(
            h=mb_cover_wt,
            l=_total_height,
            segment_length = _segment_length,
            eps=eps
        );

        rotate([0,0,180])
        hexagonal_crack(
            h=mb_cover_wt,
            l=_total_height,
            segment_length = _segment_length,
            eps=eps
        );
        
    }


}

function round_to_closest_hex_row(value, use_floor=true) =
    let(
        height = ma_mbl_z,
        _a = ma_cover_pattern_d + ma_cover_pattern_spacing,
        _tiling_a = sqrt( (3/4) *_a*_a),
        _y_off = _tiling_a*sin(120),
        _y_cnt_float = value/_y_off 
    ) (use_floor ? floor(_y_cnt_float) : ceil(_y_cnt_float))*_y_off;

function round_to_closest_hex_col(value, use_floor=true) =
    let(
        height = ma_mbl_z,
        _a = ma_cover_pattern_d + ma_cover_pattern_spacing,
        _tiling_a = sqrt( (3/4) *_a*_a),
        _x_off = _tiling_a,
        _x_cnt_float = value/_x_off 
    ) (use_floor ? floor(_x_cnt_float) : ceil(_x_cnt_float))*_x_off;

function get_panel_y_origin() = 
    let(
        height = ma_mbl_z,
        _a = ma_cover_pattern_d + ma_cover_pattern_spacing,
        _tiling_a = sqrt( (3/4) *_a*_a),
        _y_off = _tiling_a*sin(120),
        _y_cnt = floor(height/_y_off),
        _pattern_align_y = -(height/2),
        _pattern_offset_y = -((_y_cnt*_y_off)-height)/2
    )
    _pattern_align_y+_pattern_offset_y-_y_off;


// right panel with no holes
module right_panel(has_pattern = true)
{
    beamer_length(beamer_length = ma_mbl_y, has_pattern = has_pattern);
}

// left panel with only GPU hole
module left_panel(has_pattern = true)
{
    _original_pattern_offset=get_panel_y_origin();
    _rounded_offset_value = round_to_closest_hex_row(ma_cover_gpu_vent_h_off);
    _pattern_height_offset = _original_pattern_offset+_rounded_offset_value;

    difference()
    {
        beamer_length(beamer_length = ma_mbl_y, has_pattern = has_pattern);

        _grid_h = ma_cover_gpu_vent_h;
        translate([0,0,0])
            makerbeam_cover_pattern(
                beam_length=ma_mbl_y-60,
                height=_grid_h,
                recess_depth = 2*mbc_wt,
                pattern_height_offset = _pattern_height_offset,
                pattern_d=ma_cover_pattern_d,
                pattern_spacing=ma_cover_pattern_spacing
            );

    }
    
}


// front panel with only Noctua panel
module front_panel(has_pattern=true)
{
    _total_height = __mkc__beamer_length_to_total_length(ma_mbl_z);
    _total_width = __mkc__beamer_length_to_total_length(ma_mbl_x);

    _original_pattern_offset = get_panel_y_origin();
    _rounded_offset_value = round_to_closest_hex_row(ma_cover_noctua_h_off);
    _pattern_height_offset = _original_pattern_offset+_rounded_offset_value;

    _pattern_x_offset = round_to_closest_hex_col(-_total_width/2+ma_cover_noctua_x/2+ma_cover_noctua_x_off);

    difference()
    {
        beamer_length(beamer_length = ma_mbl_x, has_pattern = has_pattern);

        _grid_h = ma_cover_noctua_h;
        translate([_pattern_x_offset,0,0])
            makerbeam_cover_pattern(
                beam_length=ma_cover_noctua_x,
                height=_grid_h,
                recess_depth = 2*mbc_wt,
                pattern_height_offset = _pattern_height_offset,
                pattern_d=ma_cover_pattern_d,
                pattern_spacing=ma_cover_pattern_spacing
            );

    }
}


// back plate component parameters
// ... PSU
include<atx-ps2-psu-plate-parameters.scad>
include<../pc-parts/atx-ps2-psu-specs.scad>

// back panel with all of these fancy holes
module back_panel(has_pattern=true)
{
    _total_height = __mkc__beamer_length_to_total_length(ma_mbl_z);
    _total_width = __mkc__beamer_length_to_total_length(ma_mbl_x);

    _original_pattern_offset = get_panel_y_origin();
    _rounded_offset_value = round_to_closest_hex_row(ma_cover_noctua_h_off);
    _pattern_height_offset = _original_pattern_offset+_rounded_offset_value;


    difference()
    {
        union()
        {
            beamer_length(beamer_length = ma_mbl_x, has_pattern = has_pattern);

            // add PSU border
            translate([
                -_total_width/2+mb1010_a-ma_cover_pattern_spacing,
                -_total_height/2+mb1010_a-ma_cover_pattern_spacing,
                0])
                cubepp([
                    atx_ps2_psu_x+2*ma_cover_pattern_spacing,
                    atx_ps2_psu_z+2*ma_cover_pattern_spacing,
                    mb_cover_wt], align="xyz");
        }

        // corners
        makerbeam_cover_corner_cutter(beam_length = ma_mbl_x, height=_total_height);

        // noctua vent hole
        _noctua_grid_h = ma_cover_noctua_h;
        _noctua_grid_x_offset = round_to_closest_hex_col(_total_width/2-ma_cover_noctua_x/2-ma_cover_noctua_x_off);
        translate([_noctua_grid_x_offset,0,0])
            makerbeam_cover_pattern(
                beam_length=ma_cover_noctua_x,
                height=_noctua_grid_h,
                recess_depth = 2*mbc_wt,
                pattern_height_offset = _pattern_height_offset,
                pattern_d=ma_cover_pattern_d,
                pattern_spacing=ma_cover_pattern_spacing
            );
        
        
        
        // PSU
        translate([-_total_width/2+mb1010_a,-_total_height/2+mb1010_a,0])
        {

            // through hole
            translate([sph_wt,sph_wt,0])
                cubepp([
                    atx_ps2_psu_x-2*sph_wt,
                    atx_ps2_psu_z-2*sph_wt,
                    3*mb_cover_wt], align="xy");
            
            // bevels
            cubepp([
                atx_ps2_psu_x,
                atx_ps2_psu_z,
                3*mb_cover_wt],
                mod_list=[bevel_edges(sph_wt)],
                align="xyz");
        
        }
    }
}

back_panel();



