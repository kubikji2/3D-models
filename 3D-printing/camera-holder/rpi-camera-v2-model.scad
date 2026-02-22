use<../../lib/solidpp/solidpp.scad>
include<rpi-camera-v2-constants.scad>


module rpc2_replicate_to_mountpoints()
{
    _x = rpc2_x-2*rpc2_mnt_off;
    _y = rpc2_y-2*rpc2_mnt_off;
    translate([0,-(_y/2-rpc2_mnt_g_y/2),0])
        mirrorpp([1,0,0],true)
            mirrorpp([0,1,0],true)
                translate([_x/2,rpc2_mnt_g_y/2,0])
                    children();
}

module rpc2_translate_to_sensor_center()
{
    translate([0,-rpc2_y/2+rpc2_sensor_y_off,0])
        children();
}

module rpc2_camera_hole(height=10)
{
    rpc2_translate_to_sensor_center()
        cubepp([rpc2_sensor_a,rpc2_sensor_a,height], align="z");
}


module rpi_camera_v2()
{

    color([0.25, 0.25, 0.25])
    difference()
    {
        cubepp([rpc2_x, rpc2_y, rpc2_pcb_t], mod_list=[round_edges(rpc2_cr)], align="z");
        rpc2_replicate_to_mountpoints()
            cylinderpp(d=rpc2_mnt_d, h=3*rpc2_pcb_t, align="");    
    }

    // camera sensor
    color([0.4,0.4,0.4])
        rpc2_camera_hole(3);
}
