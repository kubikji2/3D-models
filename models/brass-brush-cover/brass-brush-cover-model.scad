include<../../lib/solidpp/solidpp.scad>

// length of plastic part of brush head
PLASTIC_LENGTH = 45; // []
// thickness of plastic part of brush head
PLASTIC_THICKNESS = 6.5; // []
// width of plastic part of brush head
PLASTIC_WIDTH = 12.5; // []
// height of brush wires
WIRES_HEIGHT = 14; // []
// width of brush wires
WIRES_WIDTH = 9; // []
// thickness of the cover walls
COVER_WALL_THICKNESS = 2; // [] 
// how much th cover corners are cut
COVER_CORNER_BEVEL = 4; // []

module brass_brush_cover(plastic_length, plastic_thickness, plastic_width, wires_height, wires_width, cover_wall_thickness, cover_corner_bevel, clearance=0.2)
{
    // computing dimensions
    cover_x = plastic_length + cover_wall_thickness;
    cover_y = max(wires_width, plastic_width) + 2*cover_wall_thickness;
    cover_z = wires_height + plastic_thickness + 2*cover_wall_thickness;
    cover_size = [cover_x, cover_y, cover_z];
    
    difference()
    {
        // main shape
        _align = "xz";
        _mods = [bevel_corners(cover_corner_bevel)];
        render(4)
        cubepp(cover_size, align=_align, mod_list=_mods);

        translate([-clearance, 0, 0])
        {
            // plastic hole
            translate([0,0,cover_wall_thickness])
                cubepp([plastic_length+2*clearance, plastic_width+2*clearance, plastic_thickness+2*clearance], align=_align);    
            
            // wires hole
            translate([0,0,cover_wall_thickness+plastic_thickness])        
                hull()
                {
                    _size = [plastic_length+2*clearance, wires_width+2*clearance, wires_height+clearance]; 
                    cubepp(_size, align=_align);
                    
                    transform_to_spp(_size,align=_align, pos="xZ")
                        cubepp([plastic_length+2*clearance, plastic_width, 0.001],align=_align);
                }    
        }

    }

}


brass_brush_cover(  plastic_length       = PLASTIC_LENGTH,
                    plastic_thickness    = PLASTIC_THICKNESS,
                    plastic_width        = PLASTIC_WIDTH,
                    wires_height         = WIRES_HEIGHT,
                    wires_width          = WIRES_WIDTH,
                    cover_wall_thickness = COVER_WALL_THICKNESS,
                    cover_corner_bevel   = COVER_CORNER_BEVEL);