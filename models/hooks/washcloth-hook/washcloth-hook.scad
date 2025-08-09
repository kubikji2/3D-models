include<../../../lib/solidpp/solidpp.scad>

hole_pattern_r = 13;
hole_partern_offet = 6;
hole_thickness = 4;


module through_hole_stopper(h, edge_bevel=0)
{
    _h = edge_bevel+h;
    translate([0,0,-edge_bevel])
    intersection()
    {
        // left hole
        translate([-hole_partern_offet/2,0,0])
            cylinderpp( r=hole_pattern_r,
                        h=_h,
                        align="xz",
                        mod_list=[bevel_bases(bevel=edge_bevel)]);
        
        // right hole
        translate([hole_partern_offet/2,0,0])
            cylinderpp( r=hole_pattern_r,
                        h=_h,
                        align="Xz",
                        mod_list=[bevel_bases(bevel=edge_bevel)]);
        
        // middle
        cylinderpp( d=hole_pattern_r,
                    h=_h,
                    align="z",
                    mod_list=[bevel_bases(bevel=edge_bevel)]);

        // cut bottom
        translate([0,0,edge_bevel])
            cylinderpp(r=hole_pattern_r, h=_h);

    }
}

// hook parameters
hook_body_width = 13;
hook_body_thickness = hole_partern_offet;
hook_shaft_length = 25;
hook_bevel_length = 5;
hook_width = 12;
hook_stopper = 3; 


module washcloth_hook(stopper_thickness=3, edge_bevel=1.5)
{
    // top part
    translate([0,0,hole_thickness])
        through_hole_stopper(h=stopper_thickness, edge_bevel=edge_bevel);
    
    // middle in-hole connecter
    cylinderpp(d=hole_partern_offet,h=hole_thickness);

    // hook itself
    pairwise_hull()
    {
        cubepp([hook_body_thickness,
                hook_body_width,
                hook_body_thickness],
                align="Z",
                mod_list=[bevel_edges(edge_bevel,axes="xy")]);

        translate([0,0,-hook_shaft_length-hook_body_thickness/2])
            cylinderpp( d=hook_body_thickness,
                        h=hook_body_width,
                        zet="y",
                        mod_list=[bevel_bases(edge_bevel)]);
        
        translate([ hook_bevel_length,
                    0,
                    -hook_shaft_length-hook_body_thickness/2-hook_bevel_length])
            cylinderpp( d=hook_body_thickness,
                        h=hook_body_width,
                        zet="y",
                        mod_list=[bevel_bases(edge_bevel)]);
        
        translate([ hook_width+hook_body_thickness-hook_bevel_length,
                    0,
                    -hook_shaft_length-hook_body_thickness/2-hook_bevel_length])
            cylinderpp( d=hook_body_thickness,
                        h=hook_body_width,
                        zet="y",
                        mod_list=[bevel_bases(edge_bevel)]);
        
        translate([ hook_width+hook_body_thickness,
                    0,
                    -hook_shaft_length-hook_body_thickness/2])
            cylinderpp( d=hook_body_thickness,
                        h=hook_body_width,
                        zet="y",
                        mod_list=[bevel_bases(edge_bevel)]);
        
        translate([ hook_width+hook_body_thickness,
                    0,
                    -hook_shaft_length-hook_body_thickness/2+hook_stopper])
            cylinderpp( d=hook_body_thickness,
                        h=hook_body_width,
                        zet="y",
                        mod_list=[bevel_bases(edge_bevel)]);
    }

    //#translate([hook_body_thickness/2,0,0])
    //    cubepp([hook_width, hook_body_width, hook_shaft_length], align="xZ");
}

$fa = 5;
$fs = $preview ? 0.1 : 0.01;
washcloth_hook();

