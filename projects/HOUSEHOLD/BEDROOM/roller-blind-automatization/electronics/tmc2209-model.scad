// essentials
use<../../../../../lib/solidpp/solidpp.scad>
use<../../../../../lib/deez-nuts/deez-nuts.scad>

include<tmc2209-parameters.scad>

module dupont_holes_line(height, n_holes, pin_clearance=0.2)
{
    _a = dupont_a+2*pin_clearance;

    difference()
    {
        // main body
        cubepp([dupont_spacing*n_holes,dupont_spacing,height],align="xz");
        // holes
        for (i=[0:n_holes-1])
            translate([(0.5+i)*dupont_spacing,0,0])
                cubepp(
                    [_a,_a,3*height],
                    align="");
    }
}


module tmc2209_holder(pin_clearance=0.2)
{

    _g = (tmc2209_dupont_spacing-1)*dupont_spacing/2;
    mirrorpp([0,1,0],true)
        translate([0,_g,0])
            dupont_holes_line(
                height=tmc2209_dupont_l,
                n_holes=tmc2209_dupont_count,
                pin_clearance=pin_clearance);
}

cubepp([dupont_spacing*tmc2209_dupont_count,dupont_spacing*tmc2209_dupont_spacing,1.6],align="xz");

translate([0,0,1.6])
tmc2209_holder();
