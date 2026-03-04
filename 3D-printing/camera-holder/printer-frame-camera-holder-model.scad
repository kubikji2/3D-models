use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<printer-frame-camera-holder-parameters.scad>
include<printer-frame-parameters.scad>

include<links-parameters.scad>

module printer_frame_interface(thickness, clearance=0.2)
{

    _nh = get_nut_height(d=pfcm_fasteners_d, standard=pfcm_nut_standard);

    _hd = get_bolt_head_diameter(standard=pfcm_bolt_standard, descriptor=pfcm_bolt_descriptor);
    _y_off = pfcm_fasteners_d/2 + pfcm_wt + _hd/2;

    _x = 2*pfcm_wt + mk3_frame_t; 
    _y = 2*_y_off + mk3_frame_h;
    _z = thickness;

    difference()
    {
        // main shape
        cubepp([_x,_y,2*_z], align="XYz");

        // hole for printer frame
        translate([-pfcm_wt+clearance,-_y_off+clearance,])
            cubepp([mk3_frame_t+2*clearance,mk3_frame_h+2*clearance,5*_z], align="XY");

        // fastener holes
        translate([-_x/2,-_y/2,_z/2+_z])
            mirrorpp([0,1,0], true)
                translate([0,_y/2-pfcm_wt/2-_hd/2,0])
                    rotate([0,-90,0])
                        translate([0,0,-(pfcm_bolt_l)/2-_nh/2])
                        {
                            // bolt
                            bolt_hole(  descriptor=pfcm_bolt_descriptor,
                                        standard=pfcm_bolt_standard,
                                        hh_off=_y);
                            // nut
                            rotate([0,0,90])
                            nut_hole(   d=pfcm_fasteners_d,
                                        standard=pfcm_nut_standard,
                                        align="b",
                                        h_off=_y);
                        }
        
        // cut hole
        translate([-_x/2,-_y/2,0])
            cubepp([2*clearance, 3*_y, 5*_z], align="");
    }
}

module support_shape_2d(r, h)
{
    hull()
    {
        squarepp([r,r], align="xy");
        translate([pfcm_length+2*r,0.01])
            squarepp([r,r], align="Xy");
        translate([0,-h])
            squarepp([0.01,r], align="xy");

    }
}

module printer_frame_camera_holder()
{

    // main shape
    _t =  lnk_nut_part_t +(lnk_nut_part_t-get_nut_height(d=lnk_fastener_d, standard=pfcm_slot_nut_standard));
    
    printer_frame_interface(_t);

    _r = get_nut_diameter(d=lnk_fastener_d, standard=pfcm_slot_nut_standard)/2+pfcm_wt;
    _y_off = pfcm_slot_offset + _r;

    _hd = get_bolt_head_diameter(standard=pfcm_bolt_standard, descriptor=pfcm_bolt_descriptor);
    _interface_y_off = pfcm_fasteners_d/2 + pfcm_wt + _hd/2;
    difference()
    {
        
        _h = mk3_frame_h+2*_interface_y_off+_y_off-_interface_y_off-2*_r;

        // main shape
        translate([0,_y_off-_interface_y_off-2*_r,0])
        {
            //coordinate_frame()
            // support
            linear_extrude(_t)
                support_shape_2d(r=_r, h=_h);
            
            // nut slide
            translate([0,_r,0])
                hull()
                {
                    cylinderpp(r=_r, h=_t, align="xz");
                    translate([2*_r+pfcm_length,0,0])
                        cylinderpp(r=_r, h=_t, align="Xz");
                }
        }
        // lightning hole
        translate([0,_y_off-_interface_y_off-2*_r,-_t])
            linear_extrude(3*_t)
                offset(pfcm_wt)
                offset(-pfcm_wt)
                offset(-_t)
                    support_shape_2d(r=_r, h=_h);
        
        // slit for the nut
        translate([_r,_y_off-_interface_y_off-_r,0])
        {
            //nut
            translate([0,0,_t-lnk_nut_part_t])
                hull()
                {
                    nut_hole(   d=lnk_fastener_d,
                                standard=pfcm_slot_nut_standard,
                                clearance=0.2);
                    translate([pfcm_length,0,0])
                        nut_hole(   d=lnk_fastener_d,
                                    standard=pfcm_slot_nut_standard,
                                    clearance=0.2);

                }

            // bolt_hole
            hull()
            {
                cylinderpp(d=lnk_fastener_d+0.2, h=3*_t, align="");
                translate([pfcm_length,0,0])
                    cylinderpp(d=lnk_fastener_d+0.2, h=3*_t, align="");
            }
        }

        /*
        translate([_t,_y_off-_interface_y_off-2*_r,0])
        hull()
        {
            cubepp([0.01, _t, 3*_t], align="xY");
            translate([0,-(_y_off-_interface_y_off-2*_r)-mk3_frame_h-2*_interface_y_off+10,0])
                coordinate_frame()
                cubepp([0.01, _t, 3*_t],align="xy");
            translate([pfcm_length-_t,0,0])
                cubepp([_t, 0.01, 3*_t],align="Xy");
        }
        */
    }

}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

printer_frame_camera_holder();