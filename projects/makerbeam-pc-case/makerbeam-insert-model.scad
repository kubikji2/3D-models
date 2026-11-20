use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<makerbeam-constants.scad>
include<makerbeam-model.scad>


module makerbeam_insert(wt=2, clearance=0.15)
{
    _nl = get_nut_diameter(d=mb1010_nut_d, standard=mb1010_nut_standard);
    _nh = get_nut_height(d=mb1010_nut_d, standard=mb1010_nut_standard);

    _l = 2*wt+_nl;

    //makerbeam_interface_hole(length=_l, clearance=clearance, has_inner_interface=false)
    difference()
    {
        translate([0,0,clearance])
            cubepp([_l,mb1010_slot_w,mb1010_id-2*clearance], align="z");
    

        // side cuts
        //#translate([0,0,-mb1010_a/2+mb1010_id])
        //    mirrorpp([0,1,0],true)
        //        rotate([45,0,0])
        //            translate([0,0,mb1010_diagonal_t/2+clearance])
        //                cubepp([3*mb1010_a,3*mb1010_a,mb1010_a],align="Z");

        //
        mirrorpp([0,1,0],true)    
            translate([0,mb1010_cw/2-clearance,0])
                rotate([45,0,0])
                    cubepp([3*mb1010_a,3*mb1010_a,mb1010_a],align="Z");

        // top cuts
        mirrorpp([0,1,0],true) 
            translate([0,mb1010_iw/2-clearance,mb1010_id])
                cubepp([2*_l, mb1010_slot_w, 2*mb1010_n+2*clearance],align="y");

        // nut hole
        translate([0,0,mb1010_id-mb1010_n-clearance])
            rotate([0,0,90])
                nut_hole(d=mb1010_nut_d, standard=mb1010_nut_standard, align="t", s_off=mb1010_slot_w);
        
        // bolt hole
        _d = mb1010_nut_d+2*clearance;
        translate([0,0,mb1010_id-mb1010_n-clearance])
            cubepp([_d,mb1010_iw,mb1010_id], align="z");




    }
    

    // #translate([0,0,-mb1010_a+mb1010_id])
        // makerbeam_interface_hole(
            // length=_l,
            // clearance=clearance,
            // zet="x",
            // has_inner_interface=true)
                // cubepp([_l/2,mb1010_a,mb1010_a], align="z");
     

}


$fn=$preview ? 36 : 144;
makerbeam_insert();