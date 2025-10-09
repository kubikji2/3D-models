include<../../lib/solidpp/solidpp.scad>

// include interface
include<../../utils/clip-on-rod-interface.scad>



module power_strip_interface(
    peg_d,
    peg_h,
    peg_D,
    peg_H
)
{
    // lower part
    cylinderpp(d=peg_d, h=peg_h, zet="x", align="x");
    // upper part
    translate([peg_h,0,0])
        cylinderpp(d=peg_D, h=peg_H, zet="x", align="x");

}

module power_strip_holder(  rod_diameter = 35,
                            interface_width = 45,
                            height = 20,
                            peg_offset = 16.5,
                            wall_thickness = 3,
                            stopper_length = 2,
                            peg_d=3.5,
                            peg_h=2,
                            peg_D=5.5,
                            peg_H=2)
{
    // rod_interface
    clip_on_rod_interface(  rod_diameter=rod_diameter,
                            height=height,
                            wall_thickness=wall_thickness,
                            insert_gauge=rod_diameter-2*stopper_length);
    // middle part
    difference()
    {
        hull()
        {
            cubepp([rod_diameter/2+wall_thickness,
                    rod_diameter+2*wall_thickness,
                    height],
                    align="xz",
                    mod_list=[round_edges(d=wall_thickness)]);
            translate([rod_diameter/2,0,0])
                cubepp([wall_thickness, interface_width, height],
                        align="xz",
                        mod_list=[round_edges(d=wall_thickness)]);
        }
        cylinderpp(d=rod_diameter, h=3*height, align="");
    }

    // power stip interface peg
    //difference()
    //{
        translate([rod_diameter/2+wall_thickness, peg_offset, height/2])
            power_strip_interface(  peg_d = peg_d,
                                    peg_h = peg_h,
                                    peg_D = peg_D,
                                    peg_H = peg_H);
        //cubepp([2*rod_diameter, 2*rod_diameter, 2*rod_diameter], align="Z");
    //}
    

}

$fs = $preview ? 0.1 : 0.01;
$fa = $preview ? 5 : 1;
power_strip_holder();

