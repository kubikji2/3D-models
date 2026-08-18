include<../../../../../lib/solidpp/solidpp.scad>


//            interface_gauge
//          ++^++
//          v   v
//       
//     +>  2#####3  <-----------+
// [1] |   #     #              |
//     |   #     #              |
//     +>  1#0   #              } from_top_to_groove
//         ^ ^   #              |
//         | |   #    [2]       |
//         +++   4 <---^--> 9  <+
//         [3]   #          #   |
//               #          #   |
//           +>  5          8    } groove_depth
//           |    #        #    |   
//           |     #      #     | 
//           +--->  6#####7  <---+
//           |       
//           groove_cut
//  
//
// [1] = interface_length
// [2] = groove_width
// [3] = interface_latch

module towel_hook_with_latch(   wall_thickness,
                                interface_length,
                                interface_gauge,
                                interface_width,
                                interface_latch,
                                groove_width,
                                groove_depth,
                                groove_height,
                                groove_cut,
                                from_top_to_groove,
                                tip_height,
                                bevel=0,
                                flexing_offset=0.5)
{
    pairwise_hull()
    {
        // 0
        translate([flexing_offset+interface_latch,0,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="XY",
                        mod_list=[bevel_bases(bevel)]);

        // 1
        translate([flexing_offset,0,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="XY",
                        mod_list=[bevel_bases(bevel)]);
        
        // 2
        translate([0,interface_length,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="Xy",
                        mod_list=[bevel_bases(bevel)]);

        // 2
        translate([interface_gauge,interface_length,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 4 groove start here
        translate([interface_gauge,interface_length-from_top_to_groove,0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 5
        translate([ interface_gauge,
                    interface_length-from_top_to_groove-(groove_depth-groove_cut),
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 6
        translate([ interface_gauge+groove_cut,
                    interface_length-from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);

        // 7
        translate([ interface_gauge+groove_width-groove_cut,
                    interface_length-from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 8
        translate([ interface_gauge+groove_width,
                    interface_length-from_top_to_groove-(groove_depth-groove_cut),
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 9
        translate([ interface_gauge+groove_width,
                    interface_length-from_top_to_groove-groove_depth+groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=tip_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);

    }
}
