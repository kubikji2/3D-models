use<../../../lib/deez-nuts/deez-nuts.scad>
use<../../../lib/solidpp/solidpp.scad>


PSU_WIDTH = 107;//106.5;
PSU_HEIGHT = 49;//48.5;
PSU_WT = 3;
PSU_HOOK_HEIGHT = 4;
PSU_HOOK_OFFSET = 1;

use<generic-psu-holder.scad>

module black_psu_back_holder(
    length,
    wall_thickness,
    mounting_wall_thickness,
    screw_offset,
    screw_standard,
    screw_diameter,
    screw_length
)
{
    generic_psu_holder(
        length=length,
        psu_height=PSU_HEIGHT+PSU_HOOK_HEIGHT+PSU_HOOK_OFFSET,
        psu_width=PSU_WIDTH,
        is_through=false,
        wall_thickness=wall_thickness,
        mounting_wall_thickness=mounting_wall_thickness,
        screw_offset=screw_offset,
        screw_standard=screw_standard,
        screw_diameter=screw_diameter,
        screw_length=screw_length,
        clearance=0.15);
}

module black_psu_front_holder(
    length,
    wall_thickness,
    mounting_wall_thickness,
    screw_offset,
    screw_standard,
    screw_diameter,
    screw_length
)
{
    l = length;
    h = PSU_HEIGHT+PSU_HOOK_HEIGHT+PSU_HOOK_OFFSET;
    difference()
    {
        generic_psu_holder(
            length=l,
            psu_height=h,
            psu_width=PSU_WIDTH,
            is_through=true,
            wall_thickness=wall_thickness,
            mounting_wall_thickness=mounting_wall_thickness,
            screw_offset=screw_offset,
            screw_standard=screw_standard,
            screw_diameter=screw_diameter,
            screw_length=screw_length,
            clearance=0.15);
        // removing the middle part
        cubepp([PSU_WIDTH-2*PSU_WT-2*wall_thickness, 3*length, h], align="");
    }

    // adding hook side
    mirrorpp([1,0,0], true)
        translate([PSU_WIDTH/2-PSU_WT-wall_thickness,0,0])
        {
            //coordinate_frame()
            cubepp([wall_thickness, l, wall_thickness+PSU_HOOK_HEIGHT]);
            
            // adding hook stoppers
            cubepp([wall_thickness+PSU_WT+wall_thickness, wall_thickness, wall_thickness+PSU_HOOK_HEIGHT]);
        }
}




