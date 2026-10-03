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
    eps = 0.2
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
            has_pattern=true,//!$preview,
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
                    translate([ma_plate_mnt_middle_off,_total_height/2-mb1010_a/2,0])
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

module right_panel()
{
    beamer_length(beamer_length = ma_mbl_y);
}

module left_panel()
{
    _total_height = __mkc__beamer_length_to_total_length(ma_mbl_z);

    difference()
    {
        beamer_length(beamer_length = ma_mbl_y);

        _grid_h = ma_plate_gpu_vent_h;
        translate([0,-_total_height/2+_grid_h/2+ma_plate_gpu_vent_h_off,0])
            makerbeam_cover_pattern(
                beam_length=ma_mbl_y-60,
                height=_grid_h,
                recess_depth = 2*mbc_wt,
                pattern_height_offset = cos(60)*ma_cover_pattern_spacing/2,
                pattern_d=ma_cover_pattern_d,
                pattern_spacing=ma_cover_pattern_spacing
            );

    }
    
}


left_panel();



