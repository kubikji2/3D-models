use<../../lib/solidpp/solidpp.scad>

use<rpi-0w2-model.scad>

include<rpi-0w2-constants.scad>


module rpi_zero_frame()
{   

    d = 4.5;
    h = 1.5;
    g_x = rpi_0w2_x-2*rpi_0w2_fastener_hole_offset;
    g_y = rpi_0w2_y-2*rpi_0w2_fastener_hole_offset;

    difference()
    {
        import("import/rpi-zero-frame.stl", 10);
        //%translate([-rpi_0w2_fastener_hole_offset,-rpi_0w2_y+rpi_0w2_fastener_hole_offset,0])
        //    rpi_0w2_pcb_interce(1.4);
        
        translate([rpi_0w2_x/2-rpi_0w2_fastener_hole_offset,-rpi_0w2_y/2+rpi_0w2_fastener_hole_offset,0])
        {
            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                    translate([g_x/2,g_y/2,-h])
                        cylinderpp(d=d, h=3*h, align="z");
        }

    }
}

