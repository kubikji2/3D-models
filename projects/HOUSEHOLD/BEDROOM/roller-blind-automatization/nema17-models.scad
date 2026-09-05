// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// dimensions
include<nema17-dimensions.scad>


module nema17_holes(
    mountpoints = [0,1,2,3],
    bolt_standard = "DIN84A",
    bolt_length = nema17_mountpoints_max_dp,
    clearance = 0.2,
    setting_l = 0,
    setting_angle = 0,
)
{
    // middle hole
    cylinderpp(d=nema17_center_d+2*clearance, h=nema17_center_t+clearance);

    // shaft height
    cylinderpp(d=nema17_shaft_d+2*clearance,h=nema17_shaft_h);

    // mountpoints
    _n17g2 = nema17_mountpoints_g/2;
    _poses = [[-_n17g2,_n17g2],[_n17g2,_n17g2],[-_n17g2,-_n17g2],[_n17g2,-_n17g2]];
    _descriptor = str("M", nema17_mountpoints_d, "x", bolt_length);
    

    for (i=[0:3])
    {
        if (len(search(i, mountpoints)) > 0)
            translate([_poses[i][0],_poses[i][1],-nema17_mountpoints_max_dp])
                rotate([0,0,setting_angle])
                {
                    mirrorpp([1,0,0], true)
                        translate([setting_l/2,0,0])
                            bolt_hole(  standard=bolt_standard,
                                        descriptor=_descriptor,
                                        clearance=clearance);
                    _hh = get_bolt_head_height(standard=bolt_standard, descriptor=_descriptor);
                    _hd = get_bolt_head_diameter(standard=bolt_standard, descriptor=_descriptor);
                    //coordinate_frame();
                    cubepp([setting_l,nema17_mountpoints_d+2*clearance,bolt_length], align="z");
                    translate([0,0,bolt_length-clearance])
                        cubepp([setting_l,_hd+2*clearance,_hh+2*clearance],align="z");
                }
    }

    // body
    _a = nema17_a + 2*clearance;
    _h = nema17_h + 2*clearance;
    translate([0,0,clearance])
        cubepp([_a,_a,_h], align="Z");
}

nema17_holes();