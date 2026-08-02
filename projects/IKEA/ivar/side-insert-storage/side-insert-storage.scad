use<../../../../lib/solidpp/solidpp.scad>

include<../ivar-dimensions.scad>



module ivar_insert(
    wt,
    height,
    pocket_height = 0,
    back_wall_offset = 0)
{
    x = ivar_legs_gauge;
    y = ivar_leg_w+back_wall_offset;
    z = height;

    // main shape
    difference()
    {
        cubepp( [x,y,z],
                align="Yz"//, mod_list=[round_corners(r=0*wt)]
                );

        translate([0,wt,0])
            cubepp( [x,y,z]+[-2*wt, 0, 2*z],
                    align="Y"
                    );
    }

    if (pocket_height > 0)
    {
        // front wall
        cubepp([x, y, wt], align="Yz");

        // bottom
        cubepp([x, wt, pocket_height], align="Yz");
    }
}

