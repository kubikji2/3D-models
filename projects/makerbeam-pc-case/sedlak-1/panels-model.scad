// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>



include<sedlak-1-parameters.scad>

// walls
use<../makerbeam-cover-plate-model.scad>
include<../makerbeam-corner-parameters.scad>

// plate
include<../makerbeam-cover-plate-parameters.scad>

// pattern
include<../hex-designer/pirate-cc0.scad>
sedlak1_side_circles_data = [];

//include<../hex-designer/bor.scad>
//sedlak1_side_circles_data = [];

/*
include<../hex-designer/symbols.scad>

// Define attractor circles: [X, Y, Radius] or [X, Y, Radius, Min_Scale]
// Coordinates (X, Y) are in millimeters relative to the pattern space
sedlak1_side_circles_data = [
    // 1. Large Off-Screen Sweeper (Bottom-Left)
    // Sits outside the left edge; projects a broad, sweeping curve into the lower-left.
    [-45, 60, 140, 0.15],

    // 2. Crisp Focal Point (Internal - Upper Right)
    // Fully inside. Center shrinks to 0 (completely solid lime green core).
    [165, 235, 60, 0.00],

    // 3. Massive Distant Attractor (Outside - Top Right)
    // A huge radius hanging off the top-right corner, creating a soft diagonal fade.
    [265, 365, 175, 0.20],

    // 4. Accent Detail (Internal - Mid Left)
    // A smaller, tighter cluster to balance the large curves on the opposite side.
    [70, 160, 42, 0.05],

    // 5. Corner Grazer (Outside - Bottom Right)
    // Centers just beyond the bottom-right corner, sweeping upward to balance Circle 1.
    [240, -20, 110, 0.10]
];
*/

module sedlak1_side_panel(
    level=undef,
    split_thicknes=0.15,
    bolt_clearance=0.2)
{
    _total_height = __mkc__beamer_length_to_total_length(sedlak1_mbl_z);
    _total_width = __mkc__beamer_length_to_total_length(sedlak1_mbl_y);

    difference()
    {
        // main shape
        makerbeam_cover_plate(
            beam_length=sedlak1_mbl_y,
            height=_total_height,
            has_pattern=false
        );

        // corner pairs and slit
        translate([0,-_total_height/2,0]) // align to sedlak1 bottom
        {
            // ... lower
            translate([0,sedlak1_level_1_plate_h,0])
            {   
                // ... corners
                makerbeam_cover_double_corner_pair_cutter(beam_length=sedlak1_mbl_y);
                // ... split
                cubepp([sedlak1_mbl_y,split_thicknes,3*mb_cover_wt], align="");
            }
            // ... upper
            translate([0,sedlak1_level_1_plate_h+sedlak1_level_2_plate_h,0])
            {
                // ... corners
                makerbeam_cover_double_corner_pair_cutter(beam_length=sedlak1_mbl_y);
                // ... split
                cubepp([sedlak1_mbl_y,split_thicknes,3*mb_cover_wt], align="");
            }
        }

        // mounting points
        translate([0,-_total_height/2,0]) // align to sedlak1 bottom
        {
            
            _side_guage = _total_width-mb1010_a;
            _corner_h = mb1010_a+2*mbc_overlap+2*mbc_wt;

            // bottom mount points
            translate([0,sedlak1_level_1_plate_h/2,0])
            {
                mirrorpp([1,0,0], true)
                    translate([_side_guage/2,
                        sedlak1_level_1_plate_h/2-_corner_h/2-mb1010_a/2,
                        -mb_cover_bolt_l_offset])
                        //coordinate_frame()
                            bolt_hole(
                                standard=mb_cover_bolt_standard,
                                descriptor=mb_cover_bold_desriptor,
                                clearance=bolt_clearance);
                mirrorpp([1,0,0], true)
                    translate([_side_guage/2,
                        -sedlak1_level_1_plate_h/2+mb1010_a+mbc_overlap+mbc_wt+mb1010_a/2,
                        -mb_cover_bolt_l_offset])
                        //coordinate_frame()
                            bolt_hole(
                                standard=mb_cover_bolt_standard,
                                descriptor=mb_cover_bold_desriptor,
                                clearance=bolt_clearance);
            }


            translate([0,sedlak1_level_1_plate_h+sedlak1_level_2_plate_h/2,0])
            {
                //coordinate_frame();
                mirrorpp([1,0,0], true)
                    mirrorpp([0,1,0], true)
                        translate([_side_guage/2,
                            sedlak1_level_2_plate_h/2-_corner_h/2-mb1010_a/2,
                            -mb_cover_bolt_l_offset])
                            //coordinate_frame()
                                bolt_hole(
                                    standard=mb_cover_bolt_standard,
                                    descriptor=mb_cover_bold_desriptor,
                                    clearance=bolt_clearance);
            }
            translate([0,sedlak1_level_1_plate_h+sedlak1_level_2_plate_h+sedlak1_level_3_plate_h/2,0])
                mirrorpp([1,0,0],true)
                    translate([_side_guage/2,0,-mb_cover_bolt_l_offset])
                        //coordinate_frame()
                        bolt_hole(
                            standard=mb_cover_bolt_standard,
                            descriptor=mb_cover_bold_desriptor,
                            clearance=bolt_clearance);
        }
       
        // pattern
        intersection()
        {
            translate([0,0,mbc_wt])
                makerbeam_cover_pattern(
                    beam_length=sedlak1_mbl_y,
                    height=_total_height,
                    pattern_height_offset = 0,
                    pattern_array = pattern_array,
                    pattern_circles_data=sedlak1_side_circles_data
                );
            
            // outline
            translate([0,0,mbc_wt-mb_cover_pattern_wt])
                linear_extrude(2*mb_cover_pattern_wt)
                    offset(-mb_cover_pattern_spacing)
                        difference()
                        {
                            makerbeam_cover_plate_shape_2d(
                                beam_length=sedlak1_mbl_y,
                                height=_total_height);
                            
                            translate([0,-_total_height/2,0])
                            {
                                translate([0,sedlak1_level_1_plate_h])
                                    makerbeam_cover_double_corner_pair_shape_2d(
                                        beam_length=sedlak1_mbl_y);
                                translate([0,sedlak1_level_1_plate_h+sedlak1_level_2_plate_h])
                                    makerbeam_cover_double_corner_pair_shape_2d(
                                        beam_length=sedlak1_mbl_y);
                            }
                        }
        }
        
    }



}

module sedlak1_panel(panel,level=undef)
{
    
    if (panel=="side")
        sedlak1_side_panel(level=level);
}

$fn=$preview?36:72;
sedlak1_side_panel();

//sedlak1_panel(level=1, panel="side");
//
//translate([0,sedlak1_level_1_plate_h/2+sedlak1_level_2_plate_h/2,0])
//    sedlak1_panel(level=2, panel="side");
//
//    sedlak1_panel(level=3, panel="side");
//translate([0,sedlak1_level_1_plate_h/2+sedlak1_level_2_plate_h+sedlak1_level_3_plate_h/2,0])