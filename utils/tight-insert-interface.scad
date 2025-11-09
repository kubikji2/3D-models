use<../lib/solidpp/solidpp.scad>


// diameter -- top diameter
// delta_diameter -- bottom increment to each side of diameter
// height -- total height
// 
module tight_insert_interface(  diameter,
                                delta_diameter,
                                height,
                                wall_thickness,
                                segments_count      = 8,
                                segments_division_w = 1,
                                bevel_top           = 0,
                                bevel_bottom        = 0,
                                rounding_top        = 0,
                                rounding_bottom     = 0,
                                align               = "z")
{
    difference()
    {
        // outer shell
        cylinderpp( d1=diameter,
                    d2=diameter+2*delta_diameter,
                    h=height,
                    align=align,
                    mod_list=[bevel_bases(  bevel_top=bevel_top,
                                            bevel_bottom=bevel_bottom)]);
        // inner cut
        cylinderpp( d1=diameter-2*wall_thickness,
                    d2=diameter+2*delta_diameter-2*wall_thickness,
                    h=height,
                    align=align,
                    mod_list=[round_bases(  r_top=rounding_top,
                                            r_bottom=rounding_bottom)]);
        
        // segment division
        for (i=[0:segments_count-1])
        {
            rotate([0,0,i*(360/segments_count)])
                cubepp( [segments_division_w, diameter, 3*height],
                        align=str("y", align),
                        mod_list=[round_edges(d=segments_division_w, axes="xz")]);
        }   
    }
}