use<../lib/solidpp/solidpp.scad>

module serration_line(  height,
                        length,
                        n_serration,
                        top_d,
                        bottom_d)
{

    increment = length/n_serration;
    for (i=[0:n_serration])
    {
        _off = -length/2 + i*increment;
        translate([0,_off,0])
            cylinderpp(d1=bottom_d, d2=top_d, h=height);
    }
}


module hexagonal_seration(  height,
                            inradius,
                            n_serration_per_side,
                            serration_bottom_d,
                            serration_top_d,
                            )
{
    for(side=[0:5])
    rotate([0,0,side*(360/6)])
        translate([inradius,0,0])
            serration_line( height=height,
                            length=inradius,
                            n_serration=n_serration_per_side,
                            top_d=serration_top_d,
                            bottom_d=serration_bottom_d);
}
