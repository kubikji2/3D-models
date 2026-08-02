use<../../lib/solidpp/solidpp.scad>

include<suptronics-x1007-case-parameters.scad>
include<rpi5-dimensions.scad>


use<../../lib/deez-nuts/deez-nuts.scad>
use<../../utils/stencils.scad>
use<../../utils/circular-serration.scad>



_h = x1k7_case_inner_z-(stx1k7_spacer_h + stx1k7_pcb_t + stx1k7_rpi_spacer_h + rpi5_pcb_t +rpi5_ac_fan_h)-x1k7_case_inner_clearance;
_wt = rpi5_connector_x_overlap;
_insert_wt = 1;

clearance=0.2;
$fn=$preview ? 36 : 144;


// cone
difference()
{   
    cylinderpp( d1=2*_wt+rpi5_ac_fan_blade_d,
                d2=2*_wt+rpi5_ac_fan_d-2*_insert_wt,
                h=_h);

    hull()
    {
        translate([0,0,_h])
            cylinderpp( d=rpi5_ac_fan_d-2*_insert_wt,
                        h=0.1);
        translate([0,rpi5_connector_x_overlap,0])
            cylinderpp(d=rpi5_ac_fan_blade_d,
                        h=0.1,
                        align="Z");
    }

    

}


translate([0,0,_h])
{         
    tubepp( D=rpi5_ac_fan_d-2*clearance,
            t = _insert_wt,
            h=x1k7_case_bt);

    // add circular serration
    circular_serration( 
        radius=rpi5_ac_fan_d/2-clearance,
        height=x1k7_case_bt,
        n_serration=100,
        serration_top_d=0.3,
        serration_bottom_d=0.4,
        $fn=16);

    translate([0,0,_h-_insert_wt])
    difference()
    {
        cylinderpp( d=rpi5_ac_fan_d-2*clearance,
                    h=_insert_wt);

        pattern_d = 5;
        pattern_x = deez_nutz_polygon_width_to_circumscribed_diameter(pattern_d);
        pattern_y = pattern_d;

        front_count_x = floor((rpi5_ac_fan_d+2*_insert_wt)/pattern_x)+2;
        front_count_y = floor((rpi5_ac_fan_d+2*_insert_wt)/pattern_y)+2;
        front_offset_x = -(rpi5_ac_fan_d+2*_insert_wt)/2 + (rpi5_ac_fan_d+2*_insert_wt-front_count_x*pattern_x)/2;
        front_offset_y = -(rpi5_ac_fan_d+2*_insert_wt)/2 + (rpi5_ac_fan_d+2*_insert_wt-front_count_y*pattern_y)/2;

                stencil(pattern_size_x=pattern_x,
                        pattern_size_y=pattern_y,
                        pattern_spacing_x=0,
                        pattern_spacing_y=0,
                        pattern_count_x=front_count_x,
                        pattern_count_y=front_count_y,
                        pattern_offset_x=front_offset_x,
                        pattern_offset_y=front_offset_y,
                        modulo_offset_x=pattern_x/2,
                        modulo_offset_y=0,
                        modulo_x = 2,
                        modulo_y = 2)
                {
                    rotate([0,0,90])
                        cylinderpp(d=pattern_d, h=3*_insert_wt, align="", $fn=6);
                    
                    cylinderpp(d=rpi5_ac_fan_d-2*clearance-2*_insert_wt,h=_insert_wt);
                }
    }

}
