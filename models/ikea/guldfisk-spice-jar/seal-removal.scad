include<../../../lib/solidpp/solidpp.scad>

inner_diameter = 27;
outer_diameter = 34;

teeth_depth = 2.5;

height = 15;

n_teeth = (outer_diameter*3.14)/teeth_depth;

module tooth()
{
    render(1)
    difference()
    {
        cubepp( [teeth_depth, outer_diameter, teeth_depth],
                align="xyz");
        rotate([0,-45,0])
            cubepp( [2*teeth_depth, outer_diameter, 2*teeth_depth],
                align="xyz");

    }
}

handle_diameter = 20;
handle_offset = 10;
handle_thickness = 5;
handle_transition_d = 7;

module seal_removal()
{
    
    difference()
    {
        tubepp(d=inner_diameter, D=outer_diameter, h=height);    

        for(i=[0:n_teeth])
        {
            translate([-teeth_depth/2,0,0])
            rotate([0,0,i*(360/n_teeth)])
                tooth();
        }
    
    }

    // handle
    translate([0,0,height])
    hull()
    {
        cylinderpp(d=outer_diameter, h=handle_thickness);
        mirrorpp([1,0,0], true)
            translate([handle_offset+outer_diameter/2,0,0])
                cylinderpp(d=handle_diameter, h=handle_thickness);
    }

    // handle transition
    translate([0,0,height])
        difference()
        {
            cylinderpp( d=inner_diameter+1,
                        h=handle_transition_d,
                        align="Z");
            cylinderpp( d=inner_diameter,
                        h=3*handle_transition_d,
                        mod_list=[round_bases(r=handle_transition_d)],
                        align="Z");
        }

}

$fa = 5;
$fs = $preview ? 0.5 : 0.01;
seal_removal();