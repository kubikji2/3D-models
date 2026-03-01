include<carriage-parameters.scad>

use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

use<rail-model.scad>

module carriage()
{
    _x = rail_neck_h+ri_hook_h+ri_hook_h+carriage_thickness-carriage_top_offset;
    _y = rail_neck_w+2*ri_slope_d+2*carriage_wt;

    _x_off = _x+carriage_top_offset-(carriage_thickness/2);

    // main shape
    difference()
    {
        translate([carriage_top_offset,0,0])
        {
            cubepp([_x,
                    _y,
                    carriage_height],
                    align="xz",
                    mod_list=[bevel_edges(carriage_wt, axes="xy")]);
            
            translate([_x,0,0])
                cubepp([carriage_wt,
                        _y,
                        carriage_height],
                        align="Xz");
            // elevation for smooth rotation
            translate([_x,0,carriage_height/2])
                intersection()
                {
                    cylinderpp( d1=_y,
                                d2=th_inner_d,
                                h=_x_off-carriage_thickness/2, zet="x", align="x");
                    translate([0,rail_neck_w/2,0])
                    cubepp([_x,_y,carriage_height], align="xY");
                    //coordinate_frame();
                }
        }

        // hole
        translate([0,0,-carriage_height/2])
            rail_shape(height=2*carriage_height, clearance=carriage_clearance);
    
        // slit
        translate([0,_y/2-(carriage_wt+ri_slope_d)-carriage_clearance,0])
            cubepp([10*_x,4*carriage_clearance,3*carriage_height], align="");

        // vertical hole
        translate([_x+carriage_top_offset-(lnk_nut_part_t)+_x_off-carriage_thickness/2,0,carriage_height/2])
            rotate([0,90,0])
            {
                bolt_hole(standard=lnk_bolt_standard, descriptor=lnk_bolt_descriptor);
                //coordinate_frame()
                nut_hole(d=lnk_fastener_d, standard=lnk_nut_standard, h_off=_x);
            }



        // horizontal holes
        translate([ _x_off,
                    0,
                    carriage_thickness/2])
        {
            translate([0,_y/2,0])
                rotate([90,90,0])
                    nut_hole(d=lnk_fastener_d, standard=lnk_nut_standard, h_off=carriage_thickness);
            
            translate([0,-_y/2-carriage_clearance,0])
                rotate([90,0,0])
                    bolt_hole(  descriptor=str("M",lnk_fastener_d,"x",_y),
                                standard=lnk_bolt_standard,
                                clearance=0.2,
                                align="m");
        }

        translate([ _x_off,
                    0,
                    carriage_height-carriage_thickness/2])
        {
            translate([0,-_y/2,0])
                rotate([-90,90,0])
                    nut_hole(d=lnk_fastener_d, standard=lnk_nut_standard, h_off=carriage_thickness);
            
            translate([0,_y/2+carriage_clearance,0])
                rotate([-90,0,0])
                    bolt_hole(  descriptor=str("M",lnk_fastener_d,"x",_y),
                                standard=lnk_bolt_standard,
                                clearance=0.2,
                                align="m");
        }
    }

}

$fn = $preview ? 36 : 144;
carriage();
%rail();



