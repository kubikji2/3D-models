include<../../lib/solidpp/solidpp.scad>

module leg_interface(   leg_side,
                        interface_height,
                        interface_width,
                        interface_depth,
                        clearance=0.1)
{
    mirrorpp([-1,1,0], true)
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([-leg_side/2, -leg_side/4, 0])
                    hull()
                    {
                        cubepp([interface_depth, interface_width, interface_height/2], align="xz");
                        cubepp([0.01, 3*interface_width, interface_height], align="xz");
                    }
}


