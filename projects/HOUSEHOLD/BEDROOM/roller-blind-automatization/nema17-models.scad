// libs
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

// dimensions
include<nema17-dimensions.scad>


module nema17_holes(
    mountpoints = [0,1,2,3],
    bolt_standard = "DIN84A",
    bolt_length = nema17_mountpoints_max_dp,
    clearance = 0.2
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
                bolt_hole(standard=bolt_standard, descriptor=_descriptor);

    }

    // body
    _a = nema17_a + 2*clearance;
    _h = nema17_h + 2*clearance;
    translate([0,0,clearance])
        cubepp([_a,_a,_h], align="Z");
}

nema17_holes();