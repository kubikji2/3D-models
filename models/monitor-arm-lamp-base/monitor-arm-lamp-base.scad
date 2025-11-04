use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

module lamp_interface_hole( d=10,
                            w=7.9,
                            h=4,
                            cable_d=3.2,
                            clearance=0.1)
{
    _d = d + 2*clearance;
    _w = w + 2*clearance;
    _h = h + 2*clearance;
    // main hole
    translate([0,0,-clearance])
    {
        intersection()
        {
            cylinderpp(d=_d, h=_h, align="z");
            cubepp([_w,2*_d,_h], align="z");
        }
        // cable hole
        _cd = cable_d + 2*clearance;
        cubepp([_cd, _d/2+_cd, _h], align="yz");
    }
}

module monitor_arm_interface(   d=31.5,
                                delta_d=0.5,
                                h=20,
                                wt=4,
                                n_divisions = 8,
                                division_w = 1,
                                bevel = 2)
{

    difference()
    {
        // main shape
        cylinderpp(d2=d, d1=d+2*delta_d, h=h,
                    mod_list=[bevel_bases(bevel_bottom=bevel)]);

        // inner cut
        cylinderpp(d2=d-2*wt, d1=d+2*delta_d-2*wt, h=h);

        // vertical cuts
        for (i=[0:n_divisions/2-1])
        {
            rotate([0,0,i*(360/n_divisions)])
                cubepp([division_w, 2*d, h], align="z");
        }
    }

}


module cable_holder_fasteners_hole( fastener_diameter = 2,
                                    bolt_length       = 5,
                                    bolt_standard     = "DIN84A",
                                    nut_standard      = "DIN934")
{
    nut_hole(   d=fastener_diameter,
                standard=nut_standard);
    bolt_hole(  descriptor=str("M", fastener_diameter, "x", bolt_length),
                standard=bolt_standard);
}

module cable_holder_fasteners_holes(fastener_gauge=10)
{

    mirrorpp([1,0,0], true)
        translate([fastener_gauge/2,0,0])
            cable_holder_fasteners_hole();
}

//module cable_holder(fastener_gauge=10, wt=2.5, h=)


module monitor_arm_lamp_base(   base_d = 35,
                                base_t = 4,
                                monitor_arm_d           = 31.5,
                                monitor_arm_delta_d     = 0.5,
                                monitor_arm_h           = 20,
                                monitor_arm_wt          = 3,
                                monitor_arm_n_divisions = 8,
                                monitor_arm_division_w  = 1,
                                monitor_arm_bevel       = 2,
                                cable_holder_gauge = 10,)
{
    difference()
    {
        union()
        {
            cylinderpp(d=base_d,h=base_t);

            translate([0,0,-monitor_arm_h])
                monitor_arm_interface(  d           = monitor_arm_d,
                                        delta_d     = monitor_arm_delta_d,
                                        h           = monitor_arm_h,
                                        wt          = monitor_arm_wt,
                                        n_divisions = monitor_arm_n_divisions,
                                        division_w  = monitor_arm_division_w,
                                        bevel       = monitor_arm_bevel);
        }

        lamp_interface_hole();
            
        translate([0,-8, 3])
            #rotate([0,180,0])
                cable_holder_fasteners_holes();
    }
    
}


$fs = $preview ? 0.1 : 0.01;
$fa = $preview ? 5 : 1;

monitor_arm_lamp_base();