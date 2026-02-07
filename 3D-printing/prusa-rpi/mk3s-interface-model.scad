use<../../lib/solidpp/solidpp.scad>

include<mk3s-interface-constants.scad>

module mk3s_interface_hook()
{

    // main body
    cubepp([mk3si_t, mk3si_w, mk3si_h], align="XYz");

    // hook top
    translate([0,0,mk3si_h])
        cubepp([mk3si_hook_t, mk3si_w, mk3si_hook_h/2], align="XYZ");

    // hook beak
    translate([-mk3si_hook_t,0,mk3si_h])
        rotate([0,-mk3si_hook_angle,0])
            cubepp([mk3si_hook_a, mk3si_w, mk3si_hook_h], align="XYZ");
}

module mk3s_interface_hook_pair()
{
    mirrorpp([0,1,0], true)
        translate([0,-m3si_hooks_g/2,0])
            mk3s_interface_hook();
}


module mk3s_interface()
{
    mirrorpp([1,0,0], true)
        translate([-m3si_pairs_g/2,0,0])
            mk3s_interface_hook_pair();
}

