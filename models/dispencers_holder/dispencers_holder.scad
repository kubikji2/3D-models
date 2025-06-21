include<../../lib/solidpp/solidpp.scad>

$fn = $preview ? 36 : 144;

function sum(vec) = vec * [for(i = [1 : len(vec)]) 1];

function partial_sum(vec, limit) = limit < 1 ? 0 : sum([for(i=[0:limit-1]) vec[i]]);

module dispencers_holder(   compartment_depth,
                            compartments_widths,
                            stopper_height,
                            wall_thickness,
                            bottom_thickness,
                            spacer_height,
                            spacer_depth)
{

    _width = sum(compartments_widths) + wall_thickness*(1+len(compartments_widths));
    _height = spacer_height + bottom_thickness + stopper_height;
    _depth = compartment_depth + 2*wall_thickness;

    difference()
    {
        // main geometry
        cubepp([_width, _depth, _height],
                mod_list=[round_edges(r=wall_thickness, axes="xy")]);
        
        // cut out the spacer
        translate([0,-spacer_depth, -0.01])
            cubepp( [3*_width, _depth, spacer_height+0.01],
                    align="yz");

        // cut out the arch into the spacer
        translate([0,_depth-wall_thickness,0])
            cylinderpp([3*_width, spacer_depth-2*wall_thickness, 2*spacer_height],
                        zet="x",
                        align="Y");

        // compartements
        for (i = [0:len(compartments_widths)-1])
        {
            _offset = wall_thickness + partial_sum(compartments_widths, i) + i*wall_thickness;
            _size = compartments_widths[i];
            //echo(i, _offset, _size);

            // compartement holes
            translate([_offset, wall_thickness, _height])
                cubepp([_size, compartment_depth, 2*stopper_height], align="xy");
            
            // water outlet
            translate([_offset,wall_thickness/2, spacer_height+bottom_thickness])
                cubepp([_size, 2*wall_thickness, stopper_height/2], align="xz");
        }

    }

}

dispencers_holder(  compartment_depth=71,
                    compartments_widths = [71,71,100],
                    stopper_height = 10,
                    wall_thickness = 3,
                    bottom_thickness = 3,
                    spacer_height = 8.3,
                    spacer_depth = 51
                    );
