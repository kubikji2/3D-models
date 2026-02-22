use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

use<rpi-camera-v2-model.scad>
use<ir-light-model.scad>

use<../../utils/circular-serration.scad>


include<camera-holder-parameters.scad>

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;


module align_camera()
{
    translate([0,rpc2_y/2-rpc2_sensor_y_off,0]) //align camera to the sensor center
        children();   
}

module translate_to_light()
{
    translate([0,irl_light_d/2+rpc2_sensor_a/2+0.5,0])
        rpc2_translate_to_sensor_center()
            children();
}

module align_to_shell_origin()
{
    translate([0,-rpc2_sensor_y_off-ch_int_clearance-ch_wt,0])
        children();
}


module align_from_shell_to_shell_center()
{
    translate([0,ch_y/2,0])
        children();
}

module align_from_shell_to_interface_center()
{
    translate([0,-(ch_y-ch_x)/2+ch_y/2,0])
        children();
}

module electronics_compartment()
{

        difference()
        {
            // main shape
            union()
            {
                align_to_shell_origin()
                    difference()
                    {
                        cubepp([ch_x, ch_y, ch_z], mod_list=[round_edges(ch_cr)], align="zy");
                        
                        // inner hole
                        translate([0,ch_wt,ch_bt])
                            cubepp( [ch_int_x, ch_int_y, ch_int_z],
                                    mod_list=[round_edges(max(0,ch_cr-ch_wt))],
                                    align="zy");

                        // vertical cut
                        translate([0,0,ch_z-ch_wt])
                            cubepp([200,200,0.1], align="Z");

                    }
                
                // camera spacers
                align_camera()
                    rpc2_replicate_to_mountpoints()
                        cylinderpp(d=2*rpc2_mnt_off, h=ch_cam_z_off+ch_bt);
                
                // camera reinfocemenets
                _cam_reinf_off = rpc2_x/2-rpc2_mnt_off+ch_int_clearance;
                _cam_reinf_r = ch_x/2-_cam_reinf_off-ch_interface_offset; 
                echo(_cam_reinf_r, rpc2_mnt_off);
                translate([0,0,ch_bt-0.1])
                    align_camera()
                        rpc2_replicate_to_mountpoints()
                            cylinderpp(r1=_cam_reinf_r, r2=rpc2_mnt_off, h=ch_cam_bolt_offset+ch_wt+0.1);

                // light spacers
                translate([0,0,ch_irl_z_off+ch_bt-ch_camera_bolt_l+ch_irl_bolt_offset])
                    translate_to_light()
                    {
                        irl_replicate_to_fastners()
                            cylinderpp(d=2*ch_wt+irl_fasteners_d, h=ch_camera_bolt_l-ch_irl_bolt_offset);
                        
                        translate([0,irl_fasteners_offset-irl_light_d/2,0])
                            cubepp([ch_int_x, irl_fasteners_d+5, ch_bt], align="z");
                    }
                
                // cover extension
                //intersection()
                //{
                //    _hd = get_bolt_head_diameter(standard=ch_bolt_standard, descriptor=ch_cover_bolt_descriptor); 
                //    mirrorpp([1,0,0], true)
                //        translate([(rpc2_x-2*rpc2_mnt_off)/2,0,ch_cover_bolt_l-ch_wt])
                //            cylinderpp(d=_hd+2*ch_wt, h=ch_z-ch_cover_bolt_l+ch_wt, align="z");
                //    cubepp([ch_int_x-2*0.2, ch_int_y, 2*ch_z], align="z");
                //}

                // bottom interface extension
                align_to_shell_origin()
                    align_from_shell_to_interface_center()
                        mirrorpp([1,0,0], true)
                            mirrorpp([0,1,0], true)
                                translate([ch_int_x/2-ch_interface_offset/2, ch_int_x/2-ch_interface_offset/2,0])
                                {
                                    cylinderpp(d=ch_interface_offset+2*ch_wt,h=ch_interface_bolt_length/2);
                                      
                                }
                
                // cover columns    
                align_to_shell_origin()
                    align_from_shell_to_shell_center()
                        mirrorpp([1,0,0], true)
                            mirrorpp([0,1,0], true)
                                translate([ch_int_x/2-ch_interface_offset/2, ch_int_y/2-ch_interface_offset/2,0])
                                {

                                    _h = (ch_z-ch_wt)-ch_bt-ch_irl_z_off+(ch_light_bolt_l-ch_irl_bolt_offset)-ch_bt;
                                    translate([0,0,ch_z-_h-ch_wt])
                                        //coordinate_frame()
                                            cylinderpp(d=ch_interface_offset+2*ch_wt,h=_h-0.1);   
                                }


            }

            // camera lens hole
            #translate([0,0,ch_bt+ch_cam_z_off]) 
                cubepp([rpc2_sensor_a+0.5, rpc2_sensor_a+0.5, ch_int_z], align="z");

            // camera mountpoints cut
            #translate([0,0,ch_cam_bolt_offset])
                align_camera()
                    rpc2_replicate_to_mountpoints()
                    {
                        bolt_hole(  standard=ch_bolt_standard,
                                    descriptor = ch_camera_bolt_descriptor,
                                    hh_off=ch_camera_bolt_l);
                        nut_hole(   d=ch_fasteners_diameter,
                                    standard=ch_nut_standard,
                                    h_off=2*ch_cam_bolt_offset);
                    }
            
            // camera cable hole
            translate([0,rpc2_sensor_a/2,ch_bt])
                cubepp([rpc2_cable_w+1, ch_y, ch_irl_z_off-ch_camera_bolt_l+ch_irl_bolt_offset], align="yz");

            // ir light holes
            #translate([0,0,ch_bt+ch_irl_z_off])
                translate_to_light()
                    irl_light_hole();

                        
            // ir light mountpoint cuts
            #translate_to_light()
                irl_replicate_to_fastners()
                {
                    rotate([180,0,0])
                        nut_hole(   d=ch_fasteners_diameter,
                                    standard=ch_nut_standard,
                                    h_off = ch_irl_z_off+ch_bt-ch_camera_bolt_l+ch_irl_bolt_offset,
                                    align="t");

                    translate([0,0,ch_irl_z_off+ch_bt-ch_camera_bolt_l+ch_irl_bolt_offset])
                        bolt_hole(  standard = ch_bolt_standard,
                                    descriptor = ch_light_bolt_descriptor);
                }
            
            // ir light cable
            translate([0,ch_y-rpc2_sensor_y_off-ch_int_clearance-ch_wt, ch_int_z+ch_bt+ch_ci_clearance])
                cubepp([ch_ci_max_cable_d+2*ch_ci_wt+2*ch_ci_clearance,
                        3*ch_wt,
                        ch_ci_max_cable_d+ch_ci_wt+ch_ci_clearance], align="Z");
            
            // cover holes
            //#mirrorpp([1,0,0], true)
            //    translate([(rpc2_x-2*rpc2_mnt_off)/2,0,0])
            //        bolt_hole(  standard = ch_bolt_standard,
            //                    descriptor = ch_cover_bolt_descriptor,
            //                    hh_off=ch_z);

            // interface holes
            align_to_shell_origin()
                align_from_shell_to_interface_center()
                    mirrorpp([1,0,0], true)
                        mirrorpp([0,1,0], true)
                            translate([ch_int_x/2-ch_interface_offset/2, ch_int_x/2-ch_interface_offset/2,0])
                                translate([0,0,0])
                                {
                                    // bottom nut
                                    //coordinate_frame();
                                    translate([0,0,ch_bt])
                                        translate([0,0,ch_interface_bolt_length/2-ch_bt])
                                            rotate([0,0,90])
                                                nut_hole(   d=ch_interface_fastener_d,
                                                            standard=ch_interface_nut_standard,
                                                            align="t");
                                    // interface bolt hole
                                    cylinderpp(d=ch_interface_fastener_d+2*0.2, h=3*ch_bt, align="");

                                }

            // cover holes
            align_to_shell_origin()
                align_from_shell_to_shell_center()
                    mirrorpp([1,0,0], true)
                        mirrorpp([0,1,0], true)
                            translate([ch_int_x/2-ch_interface_offset/2, ch_int_y/2-ch_interface_offset/2,0])
                                translate([0,0,0])
                                {
                                    // cover is held using serration only
                                    translate([0,0,ch_z-ch_interface_bolt_length])
                                        difference()
                                        {
                                            // hole
                                            bolt_hole( standard=ch_interface_bolt_standard,
                                                        descriptor=ch_interface_bolt_descriptor,
                                                        clearance=0);
                                            
                                            // seration
                                            if(!$preview)
                                                circular_serration( radius=ch_interface_fastener_d/2,
                                                                    height=ch_interface_bolt_length-ch_wt,
                                                                    n_serration=20,
                                                                    serration_top_d=0.1,
                                                                    serration_bottom_d=0.2,
                                                                    $fn=12);
                                        }
                                    
                                }
        }

    %translate([0,0,ch_cam_z_off+ch_bt])
        align_camera()
            rpi_camera_v2();

}


// MAIN //
electronics_compartment();



