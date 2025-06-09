include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>

module fastener_pair(fastener_d, bolt_l, bolt_standard, nut_standard)
{
    // bolt
    bolt_hole(  descriptor=str("M", fastener_d, "x", bolt_l),
                standard=bolt_standard,
                align="b",
                hh_off=bolt_l);

    // nut
    nut_hole(   d=fastener_d,
                standard=nut_standard,
                h_off=bolt_l);

}


module saddle_interface(wire_diameter,
                        wire_front_gauge,
                        wire_back_gauge,
                        wire_length,
                        bike_pin_d,
                        bike_pin_h,
                        bike_pin_interface_h,
                        fastener_offset,
                        vertical_fastener_d,
                        vertical_bolt_standard,
                        vertical_bolt_l,
                        vertical_nut_standard,
                        connecting_fastener_d,
                        connecting_bolt_standard,
                        connecting_bolt_l,
                        connecting_nut_standard,
                        horizontal_fastener_d,
                        horizontal_bolt_standard,
                        horizontal_bolt_l,
                        horizontal_nut_standard, 
                        wall_thickness,
                        clearance=0.1)
{

    _x_bb=max(wire_back_gauge, wire_front_gauge)+wire_back_gauge+2*wall_thickness;

    difference()
    {
        union()
        {
            // (saddle) wire interface
            intersection()
            {
                hull()
                {
                    mirrorpp([1,0,0], true)
                        hull()
                        {
                            _d = wire_diameter+2*wall_thickness;
                            translate([wire_front_gauge/2,-wire_length/2,0])
                                sphere(d=_d);
                            translate([wire_back_gauge/2,wire_length/2])
                                sphere(d=_d);
                        }
                }

                cubepp([_x_bb,
                        wire_length,
                        wire_diameter+2*wall_thickness], align="");
            }

            // bike pin interface
            translate([0,0,wire_diameter/2+wall_thickness+0.1])
            hull()
            {
                _h = bike_pin_interface_h;
                _d = bike_pin_d+2*wall_thickness;
                // bolt connector
                translate([0,wire_length/2,0])
                    cubepp( [wire_back_gauge, 2*fastener_offset, _h],
                            mod_list=[round_edges(r=fastener_offset)],
                            align="Yz");
                
                // middle
                cubepp([_d, _d/2, _h], align="yz");

                // cylinder
                cylinderpp( d=_d,
                            h=_h,
                            align="z");
                
                // horizontal bolt
                cubepp([horizontal_bolt_l,
                        bike_pin_d/2+_h,
                        _h], align="Yz");

            }
        }

        // add wire holes
        mirrorpp([1,0,0], true)
            hull()
            {
                _d = wire_diameter+2*clearance;
                translate([wire_front_gauge/2,-wire_length/2,0])
                    sphere(d=_d);
                translate([wire_back_gauge/2,wire_length/2])
                    sphere(d=_d);
            }

        // cut into two parts
        cubepp([2*_x_bb,2*wire_length,0.1], align="");

        // add hole for the bike pin
        cylinderpp(d=bike_pin_d+2*clearance, h=bike_pin_h, align="");


        // add holes vertical the bolts
        mirrorpp([1,0,0], true)
            translate([(wire_front_gauge-wire_diameter)/2-fastener_offset,
                        -wire_length/2+fastener_offset,
                        -wire_diameter/2-wall_thickness])
                fastener_pair(  fastener_d=vertical_fastener_d,
                                bolt_l=vertical_bolt_l,
                                bolt_standard=vertical_bolt_standard,
                                nut_standard=vertical_nut_standard);

        // add holes for connecting bolts
        mirrorpp([1,0,0], true)
            translate([(wire_back_gauge-wire_diameter)/2-fastener_offset,
                        wire_length/2-fastener_offset,
                        -wire_diameter/2-wall_thickness])
                fastener_pair(  fastener_d=connecting_fastener_d,
                                bolt_l=connecting_bolt_l,
                                bolt_standard=connecting_bolt_standard,
                                nut_standard=connecting_nut_standard);

        // pin spacing cut
        translate([0,0,wire_diameter/2+wall_thickness+0.05])
            cubepp([0.5,wire_length/2,2*bike_pin_interface_h], align="Yz");


        // horizontal fastener
        translate([-horizontal_bolt_l/2,
                    -bike_pin_d/2-bike_pin_interface_h/2,
                    wire_diameter/2+wall_thickness+bike_pin_interface_h/2])
            rotate([0,90,0])
                fastener_pair(  fastener_d=horizontal_fastener_d,
                                bolt_l=horizontal_bolt_l,
                                bolt_standard=horizontal_bolt_standard,
                                nut_standard=horizontal_nut_standard);

    }


}

$fn = $preview ? 36 : 72;


saddle_interface(   wire_diameter = 6.7,
                    wire_front_gauge = 35.4+6.7,
                    wire_back_gauge = 39.5+6.7,
                    wire_length = 40,
                    bike_pin_d = 22,
                    bike_pin_h = 45,
                    bike_pin_interface_h=7,
                    fastener_offset = 4,
                    vertical_fastener_d = 3,
                    vertical_bolt_standard = "DIN84A",
                    vertical_bolt_l = 10,
                    vertical_nut_standard = "DIN934",
                    horizontal_fastener_d = 3,
                    horizontal_bolt_standard = "DIN84A",
                    horizontal_bolt_l = 16,
                    horizontal_nut_standard = "DIN934",
                    connecting_fastener_d = 3,
                    connecting_bolt_standard = "DIN84A",
                    connecting_bolt_l = 16,
                    connecting_nut_standard = "DIN934", 
                    wall_thickness = 3);