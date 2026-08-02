// solidpp
use<../../lib/solidpp/solidpp.scad>

include<psu-parameters.scad>

module psu_ventilation_holes(M=10)
{
    // ventilation holes
    vent_x_off=(psu_x-psu_mount_point_gauge_x)/2;
    vent_z_off=(psu_z-psu_mount_point_gauge_z)/2;
    translate([vent_x_off,psu_y,vent_z_off])
        cubepp([psu_mount_point_gauge_x,M,psu_mount_point_gauge_z],
                mod_list=[bevel_edges(bevel=psu_vent_bevel, axes="xz")],
                align="xyz");
    
    // fan holes
    translate([psu_x,psu_fan_y_off,psu_fan_z_off])
        intersection()
        {
            cubepp([M,psu_fan_y,psu_fan_z], align="xyz");
            translate([0,psu_fan_y/2,psu_fan_z/2])
                cylinderpp(d=psu_fan_d, h=M, zet="x", align="x");
        }
}


module psu_replicate_to_mount_points(show_visual=false)
{

    if (show_visual)
        psu_visual();

    translate([psu_x/2,psu_y,psu_z/2])
        mirrorpp([1,0,0], true)
            mirrorpp([0,0,1], true)
                translate([psu_mount_point_gauge_x/2,0,psu_mount_point_gauge_z/2])
                    children();
}


module psu_visual()
{
    %color("silver")
        cubepp([psu_x,psu_y,psu_z]);
    
    psu_replicate_to_mount_points()
        coordinate_frame();

    %psu_ventilation_holes();
}

psu_visual();