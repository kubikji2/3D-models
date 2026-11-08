use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>


module strip_interface(strip_w, strip_t, height, clearance, wt)
{

    _length = strip_w+2*wt+2*clearance;
    _bevel = min(wt,height/2)/2;

    coordinate_frame();
    
    // back wall
    cubepp([_length, wt, height], align="yz");
    
    // sides
    mirrorpp([1,0,0], true)
    {
        translate([_length/2,0,0])
            cubepp([wt,wt+strip_t+height/2+2*clearance, height],
            align="Xyz", mod_list=[bevel_edges(bevel=_bevel, axes="xz")]);
    
        translate([(strip_w+2*clearance)/2,0,0])
            cubepp([_bevel,wt+strip_t+height/2+2*clearance, height], align="xyz");
        
    }
    // loop
    translate([0,wt+strip_t+2*clearance,0])
        cylinderpp(
            d=height,
            h=_length,
            zet="x",
            align="yz",
            mod_list=[bevel_bases(bevel=_bevel)]);

}

module bed_frame_strip_holder(
    wt = 4,
    corner_a = 17.5,
    height = 10,
    strip_w = 26.5,
    strip_t = 3,
    screw_d = 3.5,
    screw_standard = "LUXPZ",
    clearance=0.2)
{
    _a = 2*corner_a+sqrt(2)*wt;

    difference()
    {   
        union()
        {
            hull()
                mirrorpp([-1,1,0],true)
                    cubepp([0.1,_a, height]);
            

            // wings
            mirrorpp([-1,1,0],true)
                cubepp([wt,_a+height, height],
                    mod_list=[round_edges(d=height, axes="zy")]);
        }

        // corner cut
        cubepp([2*corner_a,2*corner_a,_a], align="");

        // screw holes
        mirrorpp([-1,1,0],true)
            translate([wt,_a+height/2, height/2])
                rotate([0,90,0])
                    screw_hole(descriptor=str("M",screw_d,"x",3*wt), standard=screw_standard, align="t");
    }

    translate([corner_a, corner_a,0])
    rotate([0,0,-45])
    strip_interface(
        strip_w=strip_w,
        strip_t=strip_t,
        wt=wt,
        height=height,
        clearance=clearance);


}

$fn = $preview ? 36: 144;

//bed_frame_spacer();
bed_frame_strip_holder();