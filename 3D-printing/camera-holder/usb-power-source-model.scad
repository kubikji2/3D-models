use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<usb-power-source-parameters.scad>


module power_source_frame(wt=ups_wt)
{
    _h = AG_Y;
    _H = _h + 2*wt;

    //%translate([0,wt,wt])
    //    cubepp([AG_X,AG_Z,AG_Y], align="Yz");

    difference()
    {
        // main shape
        translate([0,wt,0])
            cubepp( [AG_X+2*wt,AG_Z+wt,_H],
                    align="Yz",
                    mod_list=[bevel_edges(wt,axes="xy")]);
        // inner hole
        translate([0,wt,wt])
            cubepp( [AG_X,AG_Z,_h],
                    align="Yz");
        // port access
        translate([0,0,0])
            cubepp( [AG_X-2*AG_OFF, AG_Z-wt, 3*_H],
                    align="Y");
        // front port hole
        translate([0,0,_H-wt])
            cubepp( [AG_X-2*AG_OFF+2*wt, AG_Z-wt, 3*wt],
                    align="Yz",
                    mod_list=[bevel_edges(wt, axes="xz")]);
        
        // back port hole
        translate([0,0,wt])
            cubepp( [AG_X-2*AG_OFF+2*wt, AG_Z-wt, 3*wt],
                    align="YZ",
                    mod_list=[bevel_edges(wt, axes="xz")]);
        
        // bottom cooling hole 
        translate([0,-AG_Z,_H/2])
            cubepp( [AG_X-2*AG_OFF, 3*wt, AG_Y-2*wt],
                    align="",
                    mod_list=[bevel_edges(AG_OFF, axes="xz")]);   
    }
}

module flap()
{
    _fd = get_screw_head_diameter(  descriptor=ups_mp_screw_descriptor,
                                    standard=ups_mp_screw_standard) + 2*ups_mp_wt;
    //coordinate_frame();
    translate([0,0,_fd])
    rotate([90,0,0])
    difference()
    {
        union()
        {
            cylinderpp(d=_fd, h=ups_mp_wt,align="xz");
            cubepp([_fd/2, 2*_fd, ups_mp_wt], align="xz");
        }
        mirrorpp([0,1,0], true)
            translate([0,_fd,0])
                cylinderpp(d=_fd, h=3*ups_mp_wt,align="x");
        // scrw hole
        translate([_fd/2,0,ups_mp_wt])
            screw_hole( descriptor=ups_mp_screw_descriptor,
                        standard=ups_mp_screw_standard,
                        align="t");
    }
            
}

module mount_points()
{

    mirrorpp([1,0,0], true)
    translate([AG_X/2,ups_wt,0])
    {
        // remove bevel
        cubepp([ups_wt, ups_mp_wt, AG_Y+2*ups_wt], align="xYz");

        translate([ups_wt,0,AG_Y/2+ups_wt])
            // z-dimension center
            mirrorpp([0,0,1], true)
                // align to bottom
                translate([0,0,-AG_Y/2-ups_wt])
                    //coordinate_frame()
                    flap();
            
    }
}

module power_source_holder()
{
    // frame
    power_source_frame();
    
    // mountpoints
    mount_points();
}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

power_source_holder();

