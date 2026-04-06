use<../../lib/solidpp/solidpp.scad>

include<sewing-scissors-handle-dimensions.scad>

module handle_cross_section_shape()
{
    _a = ss_h-ss_handle_t;

    circlepp(d=ss_handle_t, align="Xy");

    translate([0,ss_h/2])
        squarepp([_a,_a], align="X");
    

    translate([0,ss_h/2])
        circlepp(d=ss_handle_t, align="Xy");
}


module sewing_scissors_handle()
{
    _ss_l = ss_handle_length - ss_handle_width;

    // round segments
    mirrorpp([0,1,0], true)
        translate([0,_ss_l/2,0])
            rotate_extrude(angle=180)
                translate([ss_handle_width/2, 0])
                    handle_cross_section_shape();
    
    // straignt segment
    mirrorpp([1,0,0], true)
        translate([ss_handle_width/2,_ss_l/2,0])
            rotate([90,0,0])
                linear_extrude(_ss_l)
                    handle_cross_section_shape();

    difference()
    {
        _l = ss_handle_length/2-ss_handle_t+ss_scissors_int_l;
        // body
        translate([ss_handle_width/2,0,0])
            cubepp([ss_stump_w, _l, ss_h],
                    align="Xyz",
                    mod_list=[round_edges(d=ss_handle_t, axes="xz")]);

        // hole for the scissors
        translate([ss_handle_width/2-ss_stump_wt_inner,_l+0.01,ss_h/2])
            cubepp([ss_scissors_int_w,ss_scissors_int_l,ss_scissors_int_t],
                    align="XY");
        
        // cut
        cubepp([ss_handle_width-ss_handle_t, _ss_l, 3*ss_h], align="");

        translate([0,_ss_l/2, 0])
            cylinderpp(d=ss_handle_width-ss_handle_t, h=3*ss_h, align="");

    }


}

$fn = $preview ? 36 : 120;
sewing_scissors_handle();