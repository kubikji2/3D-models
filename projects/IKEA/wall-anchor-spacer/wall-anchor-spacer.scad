include<../../../lib/solidpp/solidpp.scad>

module wall_anchor_spacer(  width,
                            height,
                            thickness,
                            diameter,
                            height_off=undef, 
                            width_off=undef,
                            rounding_radius=2)
{

    difference()
    {
        // main shape
        cubepp([width, thickness, height],
                align="",
                mod_list=[round_edges(axes="xz", r=rounding_radius)]);
        
        // circular hole
        _width_off = is_undef(width_off) ? -diameter/2 : -width/2 + width_off;
        _height_off = is_undef(height_off) ? -diameter/2 : -height/2 + height_off;
        translate([_width_off, 0, _height_off])
            cylinderpp(d=diameter, h=2*thickness, zet="y", align="xz");
    }
}