include<../../../../../lib/solidpp/solidpp.scad>


//       1  <------------+
//       #               |
//       #               |
//       #               } from_top_to_groove
//       #               |
//       #    [1]        |
//       2 <---^---> 7  <+
//       #           #   |
//       #           #   |
//   +>  3           6    } groove_depth
//   |    #         #    |   
//   |     #       #     | 
//   +--->  4#####5  <---+
//   |       
//   groove_cut
//
//
// [1] = groove_width


module glue_on_hook(    interface_width,
                        wall_thickness,
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
        //// 1
        //translate([flexing_offset,0,0])
        //    cylinderpp( d=wall_thickness,
        //                h=interface_width,
        //                align="X",
        //                mod_list=[bevel_bases(bevel)]);
        //
        //// 2
        //translate([0,0,0])
        //    cylinderpp( d=wall_thickness,
        //                h=interface_width,
        //                align="Xy",
        //                mod_list=[bevel_bases(bevel)]);

        // 1
        translate([0,0,0])
            cylinderpp( d=wall_thickness,
                        h=interface_width,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 3 groove start here
        translate([0,0-from_top_to_groove,0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 3
        translate([ 0,
                    0-from_top_to_groove-(groove_depth-groove_cut),
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 4
        translate([ 0+groove_cut,
                    0-from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);

        // 5
        translate([ 0+groove_width-groove_cut,
                    0-from_top_to_groove-groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 6
        translate([ 0+groove_width,
                    0-from_top_to_groove-(groove_depth-groove_cut),
                    0])
            cylinderpp( d=wall_thickness,
                        h=groove_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);
        
        // 7
        translate([ 0+groove_width,
                    0-from_top_to_groove-groove_depth+groove_depth,
                    0])
            cylinderpp( d=wall_thickness,
                        h=tip_height,
                        align="xy",
                        mod_list=[bevel_bases(bevel)]);

    }
}
