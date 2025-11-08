use<../lib/solidpp/solidpp.scad>

module circular_serration(  radius,
                            height,
                            n_serration,
                            serration_bottom_d,
                            serration_top_d,
                            z_align="z")
{

    for (i=[0:n_serration-1])
    {
        rotate([0,0,i*(360/n_serration)])
            translate([radius,0,0])
                cylinderpp(d1=serration_bottom_d, d2=serration_top_d, h=height, align=z_align);
    }
}