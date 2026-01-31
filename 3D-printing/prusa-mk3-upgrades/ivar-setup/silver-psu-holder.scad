use<../../../lib/deez-nuts/deez-nuts.scad>
use<../../../lib/solidpp/solidpp.scad>

$fn=$preview?36:144;

PSU_INT_L = 24;
PSU_INT_W = 3.8;
PSU_INT_SPACING = 3.2;
PSU_INT_GAUGE = PSU_INT_W + PSU_INT_SPACING;
PSU_SIDE_OFF = 7;
PSU_END_OFF = 9.5-PSU_INT_SPACING/2;

use<generic-psu-holder.scad>


module psu_interface_element(   length,
                                width,
                                height,
                                bevel)
{
    hull()
    {
        translate([+length/2-width/2,0,0])
            cylinderpp(d=width, h=height, mod_list=[bevel_bases(bevel_top=bevel)]);
        
        translate([-length/2+width/2,0,0])
            cylinderpp(d=width, h=height, mod_list=[bevel_bases(bevel_top=bevel)]);
    }
}

module psu_interface(   number_of_interfaces,
                        height,
                        clearance)
{

    w = PSU_INT_W - 2*clearance;
    l = PSU_INT_L - 2*clearance;
    h = 3*height/2;
    for (i=[0:number_of_interfaces-1])
    {
        translate([0,(0.5+i)*PSU_INT_GAUGE+clearance,0])
        {
            // left
            translate([PSU_SIDE_OFF+clearance+l/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            
            //translate([PSU_SIDE_OFF+clearance, 0, 0])
            //%cubepp( [l, w, height],
            //        mod_list=[round_edges(d=w)],
            //        align="xz");
        
            // middle
            translate([PSU_WIDTH/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            //%translate([PSU_WIDTH/2, 0, 0])
            //    cubepp( [l, w, h],
            //            mod_list=[round_edges(d=w)],
            //            align="z");

            // right
            translate([PSU_WIDTH-PSU_SIDE_OFF-clearance-l/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            //%translate([PSU_WIDTH-PSU_SIDE_OFF-clearance, 0, 0])
            //    cubepp( [l, w, h],
            //            mod_list=[round_edges(d=w)],
            //            align="Xz");
        }
    }
}

PSU_WIDTH = 100;
PSU_HEIGHT = 50;

module silver_psu_holder_front(
    number_of_interfaces,
    wall_thickness,
    mounting_wall_thickness,
    interface_height,
    screw_offset,
    screw_standard,
    screw_diameter,
    screw_length,
    clearance=0.15)
{
    l = PSU_INT_GAUGE*number_of_interfaces;


    generic_psu_holder(
        length=l,
        psu_height=PSU_HEIGHT+interface_height,
        psu_width=PSU_WIDTH,
        is_through=true,
        wall_thickness=wall_thickness,
        mounting_wall_thickness=mounting_wall_thickness,
        screw_offset=screw_offset,
        screw_standard=screw_standard,
        screw_diameter=screw_diameter,
        screw_length=screw_length,
        clearance=clearance
    );
    
    // interface
    translate([-PSU_WIDTH/2,0,wall_thickness-clearance])
        psu_interface(  number_of_interfaces=number_of_interfaces,
                        height=interface_height,
                        clearance=clearance);

}



module silver_psu_holder_back(
    number_of_interfaces,
    wall_thickness,
    mounting_wall_thickness,
    interface_height,
    screw_offset,
    screw_standard,
    screw_diameter,
    screw_length,
    clearance=0.15)
{
    l = PSU_INT_GAUGE*number_of_interfaces+PSU_END_OFF;


    generic_psu_holder(
        length=l,
        psu_height=PSU_HEIGHT+interface_height,
        psu_width=PSU_WIDTH,
        is_through=false,
        wall_thickness=wall_thickness,
        mounting_wall_thickness=mounting_wall_thickness,
        screw_offset=screw_offset,
        screw_standard=screw_standard,
        screw_diameter=screw_diameter,
        screw_length=screw_length,
        clearance=clearance
    );

        // interface
    translate([-PSU_WIDTH/2,0,wall_thickness-clearance])
        psu_interface(  number_of_interfaces=number_of_interfaces,
                        height=interface_height,
                        clearance=clearance);
}
