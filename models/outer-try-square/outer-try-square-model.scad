include<../../lib/solidpp/solidpp.scad>

module outer_try_square(wall_thickness, bottom_thickness, side_length, stopper_height, wood_width=undef)
{

    // bottom
    hull()
    {
        _w = is_undef(wood_width) ? wall_thickness : 2*wall_thickness+wood_width;
        cubepp([_w, side_length, bottom_thickness], mod_list=[round_edges(r=wall_thickness/2)]);
        cubepp([side_length, _w, bottom_thickness], mod_list=[round_edges(r=wall_thickness/2)]);
    }

    // stoppers
    cubepp([wall_thickness, side_length, bottom_thickness+stopper_height], mod_list=[round_edges(r=wall_thickness/2)]);
    cubepp([side_length, wall_thickness, bottom_thickness+stopper_height], mod_list=[round_edges(r=wall_thickness/2)]);
    
    // inner stoppers
    /*
    if (!is_undef(wood_width))
    {
        translate([wall_thickness+wood_width,wall_thickness+wood_width, 0])
            hull()
            {
                _l = side_length-wall_thickness-wood_width;
                cubepp([wall_thickness, _l, bottom_thickness+stopper_height], mod_list=[round_edges(r=wall_thickness/2)]);
                cubepp([_l, wall_thickness, bottom_thickness+stopper_height], mod_list=[round_edges(r=wall_thickness/2)]);
            }
    }
    */

}

outer_try_square(wall_thickness=4, bottom_thickness=3, side_length=100, stopper_height=20, wood_width=41);