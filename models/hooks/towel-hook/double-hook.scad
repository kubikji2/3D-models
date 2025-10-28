include<../../../lib/solidpp/solidpp.scad>


//     interface_gauge
//    +^+
//    v v
//   1###2  <-----------+
//       #              |
//       #              |
//       #              } from_top_to_groove
//       #              |
//       #              |
//       #          7  <+
//       #          #   |
//       #    [1]   #   |
//   +>  3 <---^--> 6    } groove_depth
//   |    #        #    |   
//   |     #      #     | 
//   +--->  4#####5  <---+
//   |       
//   groove_cut
//
//
// [1] = groove_width


module towel_double_hook(   wall_thickness,
                            interface_length,
                            interface_gauge,
                            interface_width,
                            groove_width,
                            groove_depth,
                            groove_height,
                            groove_cut,
                            from_top_to_groove,
                            tip_height,
                            bevel=0,
                            flexing_offset=0.5)
{
    mirrorpp([1,0,0], true)
    pairwise_hull()
    {
        // 1
        translate([0,0,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="Xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 2
        translate([interface_gauge/2,0,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 3 groove start here
        translate([interface_gauge/2-flexing_offset,
                    -from_top_to_groove-(groove_depth-groove_cut),0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 4
        translate([ interface_gauge/2+groove_cut,
                    -from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 5
        translate([ interface_gauge/2+groove_width-groove_cut,
                    -from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 6
        translate([ interface_gauge/2+groove_width,
                    -from_top_to_groove-(groove_depth-groove_cut),
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 7
        translate([ interface_gauge/2+groove_width,
                    -from_top_to_groove,
                    0])
            cylinderpp( d=wall_thickness,
                        h=tip_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);

    }
}
