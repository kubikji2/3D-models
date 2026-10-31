use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>


module bed_frame_spacer(
    plank_t = 17,
    plank_w = 82,
    spacer_t = 4,
    rounding_r = 4,
    screw_d = 3.5,
    screw_standard = "LUXPZ")
{

    difference()
    {
        cubepp(
            [plank_w,plank_t, spacer_t],
            align="z",
            mod_list=[round_edges(r=rounding_r, axes="xy")]);
        
        _off = plank_t/2;
        _descriptor = str("M",screw_d,"x",2*spacer_t);

        mirrorpp([1,0,0], true)
        translate([plank_w/2-_off,0,spacer_t])
            screw_hole(descriptor=_descriptor, standard=screw_standard, align="t");
    }



}

$fn = $preview ? 36: 144;

bed_frame_spacer();