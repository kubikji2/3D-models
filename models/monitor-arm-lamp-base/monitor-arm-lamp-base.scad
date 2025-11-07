use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

module lamp_interface_hole( d, w, h, cable_d,
                            nut_t, nut_w,
                            clearance)
{
    _d = d + 2*clearance;
    _w = w + 2*clearance;
    _h = h + 2*clearance;
    

    translate([0,0,-clearance])
    {
        // lamp screw shape
        intersection()
        {
            cylinderpp(d=_d, h=_h, align="z");
            cubepp([_w, 2*_d,_h], align="z");
        }


        // nut hole
        _nut_D = deez_nutz_polygon_width_to_circumscribed_diameter(nut_w) + 2*clearance;
        _nut_h = nut_t + 2*clearance;
        translate([0,_d/2,0])
            cubepp([_nut_h, _nut_D, _h], align="Yz");

        // cable hole
        _cd = cable_d + 2*clearance;
        translate([0,-_w/2,0])
            cubepp([_w+2*_cd,_cd,_h],
                    align="Yz",
                    mod_list=[round_edges(d=_cd)]);

        // joining cable hole and nut hole
        cubepp([_w,_d/2,_h], align="Yz");
    }
}

module monitor_arm_interface(   d, delta_d, h, wt,
                                n_divisions, division_w,
                                bevel, rounding)
{

    difference()
    {
        // main shape
        cylinderpp(d2=d, d1=d+2*delta_d, h=h,
                    mod_list=[bevel_bases(bevel_bottom=bevel)]);

        // inner cut
        cylinderpp(d2=d-2*wt, d1=d+2*delta_d-2*wt, h=h,
                    mod_list=[round_bases(r_top=rounding)]);

        // vertical cuts
        for (i=[0:n_divisions/2-1])
        {
            rotate([0,0,i*(360/n_divisions)])
                cubepp([division_w, 2*d, h], align="z");
        }
    }

}


//module cable_holder_fasteners_hole( fastener_diameter = 2,
//                                    bolt_length       = 5,
//                                    bolt_standard     = "DIN84A",
//                                    nut_standard      = "DIN934")
//{
//    nut_hole(   d=fastener_diameter,
//                standard=nut_standard);
//    bolt_hole(  descriptor=str("M", fastener_diameter, "x", bolt_length),
//                standard=bolt_standard);
//}
//
//module cable_holder_fasteners_holes(fastener_gauge=10)
//{
//
//    mirrorpp([1,0,0], true)
//        translate([fastener_gauge/2,0,0])
//            cable_holder_fasteners_hole();
//}

//module cable_holder(fastener_gauge=10, wt=2.5, h=)

//module cable_zip_tie_hole(cable_d, ziptie_t, ziptie_w, clearance)
//{
//    _d = cable_d;
//    _t = ziptie_t + 2*clearance;
//    _h = ziptie_w + 2*clearance;
//
//    tubepp(d=_d, t=_t, h=_h, zet="y", align="Y");
//}

module cable_holder(cable_d, ziptie_t, ziptie_w, clearance, wt)
{
    _d = cable_d;
    _zt = ziptie_t + 2*clearance;
    _zw = ziptie_w + 2*clearance;
    _w = ziptie_w + 2*wt;
    _h = ziptie_t + 2*wt;
    difference()
    {   
        translate([0,0,wt])
        cubepp([_d,_w,_h],align="YZ", mod_list=[round_edges(r=wt,axes="yz")]);
        translate([0,-wt,0])
            cubepp([_d+2*clearance,_zw,_zt],align="YZ");
    }
}


module monitor_arm_lamp_base(   base_d = 35,
                                base_t = 4,
                                monitor_arm_d           = 31.5,
                                monitor_arm_delta_d     = 1,
                                monitor_arm_h           = 25,
                                monitor_arm_wt          = 3,
                                monitor_arm_n_divisions = 8,
                                monitor_arm_division_w  = 1,
                                monitor_arm_bevel       = 2,
                                monitor_arm_rounding    = 2,
                                cable_d                 = 3.2,
                                ziptie_t                = 1.0,
                                ziptie_w                = 2.5,
                                ziptie_clearance        = 0.1,
                                ziptie_wt               = 1.5,
                                cable_fixer_offset      = -10,
                                lamp_interface_d        = 10,
                                lamp_interface_w        = 7.9,
                                lamp_interface_nut_t    = 5,
                                lamp_interface_nut_w    = 13.8,
                                lamp_interface_offset   = 1)
{
    difference()
    {
        union()
        {
            // base
            cylinderpp(d=base_d,h=base_t);

            difference()
            {
                // flexible arm interface
                rotate([0,0,22.5])   
                translate([0,0,-monitor_arm_h])
                    monitor_arm_interface(  d           = monitor_arm_d,
                                            delta_d     = monitor_arm_delta_d,
                                            h           = monitor_arm_h,
                                            wt          = monitor_arm_wt,
                                            n_divisions = monitor_arm_n_divisions,
                                            division_w  = monitor_arm_division_w,
                                            bevel       = monitor_arm_bevel,
                                            rounding    = monitor_arm_rounding);
                        // hole for the ziptie
                hull()
                {
                    mirrorpp([1,0,0], true)
                        rotate([0,0,22.5])
                            cubepp([monitor_arm_division_w, monitor_arm_d, monitor_arm_h], align="ZY");
                }
            }
            
            translate([0, cable_fixer_offset , 0])
                cable_holder(   cable_d=cable_d,
                                ziptie_t=ziptie_t,
                                ziptie_w=ziptie_w,
                                wt = ziptie_wt,
                                clearance=ziptie_clearance);

        }

        // hole for lamp pole
        translate([0,lamp_interface_offset,0])
        lamp_interface_hole(    d         = lamp_interface_d,
                                w         = lamp_interface_w,
                                h         = base_t,
                                cable_d   = cable_d,
                                nut_t     = lamp_interface_nut_t,
                                nut_w     = lamp_interface_nut_w,
                                clearance = 0.1);
        


        // hole for fixing cable inplace
        //translate([0, cable_fixer_offset , 0])
        //    cable_zip_tie_hole( cable_d=cable_d,
        //                        ziptie_t=ziptie_t,
        //                        ziptie_w=ziptie_w,
        //                        clearance=ziptie_clearance);
        //

        //%translate([0,lamp_interface_offset,0])
        //    nut_hole(d=10, standard="DIN934");
    }
    
}


$fs = $preview ? 0.1 : 0.01;
$fa = $preview ? 5 : 1;

monitor_arm_lamp_base();