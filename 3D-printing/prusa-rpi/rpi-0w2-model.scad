include<rpi-0w2-constants.scad>

use<../../lib/solidpp/solidpp.scad>

module rpi_0w2_holes(pcb_t)
{
    // pcb holes
    _x_off = rpi_0w2_x/2 - rpi_0w2_fastener_hole_offset;
    _y_off = rpi_0w2_y/2 - rpi_0w2_fastener_hole_offset;
    translate([rpi_0w2_x/2,rpi_0w2_y/2,0])
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([_x_off, _y_off, 0])
                    cylinderpp(d=rpi_0w2_fastener_hole_d, h=3*pcb_t, align="");
    
}

module rpi_0w2_pcb_interce(pcb_t)
{

    difference()
    {
        // pcb shape
        cubepp([rpi_0w2_x,rpi_0w2_y, pcb_t], mod_list=[round_edges(r=rpi_0w2_cr)]);

        rpi_0w2_holes(pcb_t);    
    }

}


module rpi_0w2_port_holes(clearance=0.2, W=rpi_0w2_x)
{
    %rpi_0w2_pcb_interce(1.4);

    translate([0,0,rpi_0w2_z])
    {
        // micro hdmi
        translate([rpi_0w2_mini_hdmi_x_off-clearance, clearance,-clearance])
            cubepp([rpi_0w2_mini_hdmi_w+2*clearance,
                    W,
                    rpi_0w2_mini_hdmi_h+2*clearance], align="xYz");

        // micro USB1
        translate([rpi_0w2_x-rpi_0w2_uusb1_x_off+clearance, clearance,-clearance])
            cubepp([rpi_0w2_uusb_w+2*clearance,
                    W,
                    rpi_0w2_uusb_h+2*clearance], align="XYz");

        // micro USB2
        translate([rpi_0w2_x-rpi_0w2_uusb2_x_off+clearance, clearance,-clearance])
            cubepp([rpi_0w2_uusb_w+2*clearance,
                    W,
                    rpi_0w2_uusb_h+2*clearance], align="XYz");
        
        // CSI
        translate([ rpi_0w2_x-clearance,
                    rpi_0w2_y/2,
                    rpi_0w2_csi_z_off-clearance])
            cubepp([W,
                    rpi_0w2_csi_w + 2*clearance,
                    rpi_0w2_csi_h + 2*clearance], align="xz");
        
        // micro SD 
        translate([0,rpi_0w2_y-rpi_0w2_usd_y_off+clearance,-clearance])
            cubepp([W,
                rpi_0w2_usd_w + 2*clearance,
                rpi_0w2_usd_h + 2*clearance], align="XYz");
    }
}
