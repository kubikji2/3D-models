// solidpp
use<../../lib/solidpp/solidpp.scad>

module pen_cover(
    h=23,
    d=7.4,
    wt=1.2,
    int_t = 0.2,
    int_w = 1,
    int_off = 2,
    inner_cover_d = 4.2,
    inner_cover_h = 8
    )
{

    difference()
    {
        cylinderpp(d=d+2*wt, h=h+wt, align="z",
            mod_list=[bevel_bases(bevel_bottom = wt)]);
        translate([0,0,wt])
            cylinderpp(d=d, h=h+wt, align="z");
    }

    n_int = 8;

    translate([0,0,h+wt-int_off/2])
        for(i=[0:n_int-1])
            rotate([0,0,i*(360/n_int)])
                translate([d/2,0,0])
                    spherepp([2*int_t, int_w, int_off]);
                        //coordinate_frame();

    translate([0,0,wt])
        tubepp(d=inner_cover_d, D=d, h=inner_cover_h, align="z");
}


$fa=5;
$fs=0.1;

pen_cover();