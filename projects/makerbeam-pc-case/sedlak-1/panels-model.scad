// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>



include<sedlak-1-parameters.scad>

// walls
use<../makerbeam-cover-plate-model.scad>
include<../makerbeam-corner-parameters.scad>

// pattern
include<../makerbeam-cover-plate-parameters.scad>


module sedlak1_panel(level, panel)
{

    if (level == 1)
    {
        if (panel=="side")
            makerbeam_cover_plate(
                beam_length=sedlak1_mbl_y,
                height=sedlak1_level_1_plate_h,
                top_corners_offset=sedlak1_level_1_plate_top_offset,
                has_top_transition=true);

    }
    
    if (level == 2)
    {
        if (panel=="side")
            makerbeam_cover_plate(
                beam_length=sedlak1_mbl_y,
                height=sedlak1_level_2_plate_h,
                top_corners_offset=sedlak1_level_2_plate_top_offset,
                bottom_corners_offset=sedlak1_level_2_plate_bottom_offset,
                //pattern_height_offset=sedlak1_level_1_plate_h,
                has_top_transition=true,
                has_bottom_transition=true);

    }

    if (level == 3)
    {
        echo(sedlak1_level_1_plate_h+sedlak1_level_2_plate_h);
        if (panel=="side")
            makerbeam_cover_plate(
                beam_length=sedlak1_mbl_y,
                height=sedlak1_level_3_plate_h,
                bottom_corners_offset=sedlak1_level_3_plate_bottom_offset,
                //pattern_height_offset=27.5, // IDK TBH
                pattern_height_offset=-10, // IDK TBH
                has_bottom_transition=true);
                //sedlak1_level_1_plate_h+sedlak1_level_2_plate_h);
    }

}

sedlak1_panel(level=1, panel="side");

translate([0,sedlak1_level_1_plate_h/2+sedlak1_level_2_plate_h/2,0])
    sedlak1_panel(level=2, panel="side");

translate([0,sedlak1_level_1_plate_h/2+sedlak1_level_2_plate_h+sedlak1_level_3_plate_h/2,0])
    sedlak1_panel(level=3, panel="side");