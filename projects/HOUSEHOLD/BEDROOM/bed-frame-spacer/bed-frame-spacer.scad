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

module bed_frame_spacer_drill_guide(
    wt=2,
    wh=10,
    bt=2,
    plank_t = 17,
    plank_w = 82,
    screw_d = 3.5,
    clearance=0.4)
{
    _plank_w = plank_w+2*clearance;
    _plank_t = plank_t+2*clearance;


    difference()
    {
        cubepp([_plank_w+2*wt, _plank_t+2*wt, bt+wh], align="z", mod_list=[round_edges(r=wt)]);
        translate([0,0,bt])
            cubepp([_plank_w, _plank_t, bt+wh], align="z");
        
        _off = plank_t/2;
        mirrorpp([1,0,0], true)
            translate([plank_w/2-_off,0,0])
                cylinderpp(d=screw_d,h=3*(bt+wh), align="");
    }

}


$fn = $preview ? 36: 144;

//bed_frame_spacer();
bed_frame_spacer_drill_guide();