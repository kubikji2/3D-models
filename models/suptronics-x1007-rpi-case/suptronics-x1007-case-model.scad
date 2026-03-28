use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<rpi5-dimensions.scad>
include<rpi5-active-cooling-dimensions.scad>
include<suptronics-x1007-dimensions.scad>

include<suptronics-x1007-case-parameters.scad>

use<rpi5-model.scad>

module hermes_logo()
{
    translate([-80,44,x1k7_case_z-0.6])
        rotate([0,0,-90])
            linear_extrude(0.6)
                scale([0.3,0.3,1])
                    import("import/Caduceus.dxf");
}

module suptronics_x1k7_case_fastener()
{

    bolt_hole(  descriptor=x1k7_cover_bolt_descriptor,
                standard=x1k7_cover_bolt_standard,
                align="m");
    
    translate([0,0,-x1k7_case_bt])
        cylinderpp(d=3.9, h=x1k7_cover_bolt_l, align="Z");

}


module suptronics_x1k7_case(
    is_cover,
    clearance=0.2)
{

    difference()
    {
        union()
        {
            // shell
            difference()
            {
                // main shape
                shape_h = !is_cover ? x1k7_case_z-x1k7_case_bt-x1k7_case_inner_clearance : x1k7_case_z;
                cubepp([x1k7_case_x, x1k7_case_y, shape_h],
                        align="z",
                        mod_list = [round_edges(r=x1k7_case_cr)]);

                // inner cut
                translate([0,0,x1k7_case_bt])
                    cubepp([x1k7_case_inner_x, x1k7_case_inner_y, x1k7_case_inner_z],
                        align="z");

                // splitting cut
                _cut_t = is_cover ? x1k7_case_z : x1k7_case_inner_clearance;
                translate([0,0,x1k7_case_bt+x1k7_case_inner_z])
                    cubepp([2*x1k7_case_x,2*x1k7_case_x,_cut_t], align="Z");
            
            }


            // adding cover mountpoints reinforcements
            if (!is_cover)
                translate([0,0,x1k7_case_bt-x1k7_case_inner_clearance])
                {
                    mirrorpp([1,0,0], true)
                    translate([-x1k7_case_inner_x/2,-x1k7_case_inner_y/2,0])
                        cylinderpp(r=x1k7_case_cr,h=x1k7_case_inner_z);
                    
                    translate([-x1k7_case_inner_x/2,x1k7_case_inner_y/2,0])
                        cylinderpp(r=x1k7_case_cr,h=x1k7_case_inner_z);
                }

        }

        // case cover mountpoint fasteners
        translate([0,0,x1k7_case_z])
        {
            mirrorpp([1,0,0], true)
            translate([-x1k7_case_inner_x/2,-x1k7_case_inner_y/2,0])
                suptronics_x1k7_case_fastener();
            
            translate([-x1k7_case_inner_x/2,x1k7_case_inner_y/2,0])
                suptronics_x1k7_case_fastener();
        }

        // x1k7 holes 
        translate([
            -x1k7_case_inner_x/2+x1k7_case_inner_clearance,
            -x1k7_case_inner_y/2+x1k7_case_inner_clearance+x1k7_case_inner_y_space,
            0])
        {
            coordinate_frame(txt="x1k7 origin");
            
            // fasteners
            translate([stx1k7_mnt1_x_off, stx1k7_mnt1_y_off,0])
                rotate([180,0,0])
                    bolt_hole(  descriptor=x1k7_mnt_bolt_descriptor,
                                standard=x1k7_mnt_bolt_standard,
                                align="m");

            translate([stx1k7_mnt2_x_off, stx1k7_mnt2_y_off,0])
                rotate([180,0,0])
                    bolt_hole(  descriptor=x1k7_mnt_bolt_descriptor,
                                standard=x1k7_mnt_bolt_standard,
                                align="m");

            translate([stx1k7_mnt3_x_off, stx1k7_mnt3_y_off,0])
                rotate([180,0,0])
                    bolt_hole(  descriptor=x1k7_mnt_bolt_descriptor,
                                standard=x1k7_mnt_bolt_standard,
                                align="m");

            translate([stx1k7_mnt4_x_off, stx1k7_mnt4_y_off,0])
                rotate([180,0,0])
                    bolt_hole(  descriptor=x1k7_mnt_bolt_descriptor,
                                standard=x1k7_mnt_bolt_standard,
                                align="m");
        
            // x1k7 LED indicators
            translate([stx1k7_led_x_off,0,stx1k7_spacer_h+stx1k7_pcb_t])
            {
                for(i=[0:stx1k7_led_count-1])
                    translate([i*stx1k7_led_spacing,0,0])
                        cylinderpp(
                            d=1.75+0.2,
                            h=2*(x1k7_case_inner_y_space+x1k7_case_wt),
                            zet="y",
                            align="Y");
            }
        }

        

        // rpi5 holes
        translate([
            x1k7_case_inner_x/2-x1k7_case_inner_clearance,
            -x1k7_case_inner_y/2+x1k7_case_inner_clearance+x1k7_case_inner_y_space,
            stx1k7_spacer_h + stx1k7_pcb_t + stx1k7_rpi_spacer_h+x1k7_case_bt])
            rotate([0,0,90])
            {
                coordinate_frame(txt="rpi5 origin");

                // rpi holes
                rpi5_connector_holes(
                    clearance=clearance,
                    wall_thickness=x1k7_case_wt+x1k7_case_inner_clearance+x1k7_case_inner_y_space);

                // vent hole
                translate([rpi5_ac_fan_x_off,rpi5_ac_fan_y_off,0])
                    cylinder(d=rpi5_ac_fan_d,h=x1k7_case_z);
            }
        
        // logo
        hermes_logo();

        // ventilation slits
        translate([-x1k7_case_inner_x/2,0,x1k7_case_bt])
        {
            coordinate_frame();
            _h = x1k7_case_inner_z - x1k7_case_bt;
            _useful_w = x1k7_case_inner_y-2*x1k7_case_cr;
            __splitable_w = _useful_w - x1k7_vent_width;
            _n_slits = floor(__splitable_w/(x1k7_vent_width+x1k7_vent_spacing));
            __offset = (_useful_w-(_n_slits*(x1k7_vent_width+x1k7_vent_spacing)+x1k7_vent_width))/2;

            //echo(_useful_w);
            translate([0,-__splitable_w/2,0])
                for(i=[0:_n_slits])
                {
                    translate([0,i*(x1k7_vent_width+x1k7_vent_spacing)+__offset,0])
                        cubepp([3*x1k7_case_wt,x1k7_vent_width,_h],
                                align="z",
                                mod_list=[round_edges(d=x1k7_vent_width, axes="yz")]);
                }
        }


    }


    // fan duct
    if (is_cover)
    render(4)
    translate([
        x1k7_case_inner_x/2-x1k7_case_inner_clearance,
        -x1k7_case_inner_y/2+x1k7_case_inner_clearance+x1k7_case_inner_y_space,
        stx1k7_spacer_h + stx1k7_pcb_t + stx1k7_rpi_spacer_h+x1k7_case_bt+rpi5_pcb_t +rpi5_ac_fan_h])
        rotate([0,0,90])
        {
            
            // vent hole
            translate([rpi5_ac_fan_x_off,rpi5_ac_fan_y_off,0])
            {

                difference()
                {   
                    _h = x1k7_case_inner_z-(stx1k7_spacer_h + stx1k7_pcb_t + stx1k7_rpi_spacer_h + rpi5_pcb_t +rpi5_ac_fan_h);
                    _wt = 1;
                    cylinderpp( d1=2*_wt+rpi5_ac_fan_blade_d,
                                d2=2*_wt+rpi5_ac_fan_d,
                                h=_h);
                    cylinderpp( d1=rpi5_ac_fan_blade_d,
                                d2=rpi5_ac_fan_d,
                                h=_h);
                }
            }
                
        }
}




$fn = $preview ? 36 : 144;
suptronics_x1k7_case(is_cover=false);
//hermes_logo();