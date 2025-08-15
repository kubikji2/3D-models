include<../../../lib/solidpp/solidpp.scad>


rotation_clearance = 0.5;
rotation_stopper = 2;
rotation_depth = 1;

wall_thickness = 2;

inner_diameter = 51.25;
outer_diameter = inner_diameter+4*wall_thickness+2*rotation_depth+2*rotation_clearance;// 63;
inner_depth = 42;
outer_height = 46;

groove_depth = 1;
groove_width = 5;
groove_length = 40;
groove_count = 40;

module rotation_cut()
{
    rotate_extrude()
        translate([inner_diameter/2+wall_thickness,0])
            //hull()
            {
                _h = outer_height-2*rotation_stopper-2*rotation_depth; 
                // bottom stopper
                translate([rotation_depth,0])
                    squarepp([rotation_clearance,rotation_stopper]);
                // lower connector
                hull()
                {
                    translate([rotation_depth, rotation_stopper])
                        squarepp([rotation_clearance, 0.01], align="xY");
                    translate([0, rotation_stopper+rotation_depth])
                        squarepp([rotation_clearance, 0.01], align="xy");    
                }
                // middle section
                translate([0,rotation_stopper+rotation_depth])
                    squarepp([rotation_clearance, _h]);
                // upper connector
                hull()
                {
                    translate([0, _h+rotation_stopper+rotation_depth])
                        squarepp([rotation_clearance, 0.01], align="xy");    
                    translate([rotation_depth, _h+rotation_stopper+rotation_depth+rotation_depth])
                        squarepp([rotation_clearance, 0.01], align="xY");
                }
                // top stopper
                translate([rotation_depth,outer_height-rotation_stopper])
                    squarepp([rotation_clearance, rotation_stopper]);
            }
}

module leg_cover(clearance=0.1)
{
    difference()
    {
        union()
        {
            // main shape
            cylinderpp( d=outer_diameter,
                        h=outer_height,
                        mod_list=[round_bases(wall_thickness)]);

            // groovers
            intersection()
            {
                cylinderpp(d=outer_diameter+2*groove_depth, h=outer_height);
                union()
                    for(i=[0:groove_count/2])
                    {
                        rotate([0,0,i*(360/(groove_count/2))])
                        translate([0,0,(outer_height-groove_length)/2])
                            cubepp([outer_diameter+2*groove_depth,
                                    groove_width,
                                    groove_length],
                                    align="z",
                                    mod_list=[bevel_edges(groove_depth, axes="xz")]);
                    }
            }

        }
        
        // cut for rotation
        rotation_cut();
        
        // middle cut
        translate([0,0,outer_height-inner_depth])
            cylinderpp(h=outer_height, d=inner_diameter+2*clearance); 
    
    }
}

$fa = 5;
$fs = $preview ? 0.1 : 0.01;

leg_cover();