include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>


module corner_brace(wall_thickness, length, height, screw_diameter, screw_holes_at, reinforcements_at, has_cuts=true, extended_screw_holes_at=[])
{
    difference()
    {
        // main shape
        union()
        {
            cubepp([wall_thickness, length, height]);
            cubepp([length, wall_thickness, height]);
        }

        // add holes
        mirrorpp([-1,1,0], true)
        for (i=[0:len(screw_holes_at)-1])
        {
            _d = is_list(screw_diameter) ? screw_diameter[i] : screw_diameter;
            _descriptor = str("M", _d, "x", 2*wall_thickness);
            translate([screw_holes_at[i],wall_thickness,height/2])
                rotate([-90,0,0])
                    screw_hole(descriptor=_descriptor, standard="LUXPZ", align="t");
        }

        // add extended holes
        if (len(extended_screw_holes_at) > 0)
            //mirrorpp([-1,1,0], true)
                for (i=[0:len(extended_screw_holes_at)-1])
                {
                    _d = is_list(screw_diameter) ? screw_diameter[i] : screw_diameter;
                    _descriptor = str("M", _d, "x", 2*wall_thickness);
                    
                    // right part
                        translate([extended_screw_holes_at[i]-screw_diameter/2,wall_thickness,height/2])
                            rotate([-90,0,0])
                                screw_hole(descriptor=_descriptor, standard="LUXPZ", align="t");
                    // left part
                    translate([extended_screw_holes_at[i]+screw_diameter/2,wall_thickness,height/2])
                        rotate([-90,0,0])
                            screw_hole(descriptor=_descriptor, standard="LUXPZ", align="t");
                    // connector
                    render(10)
                    translate([extended_screw_holes_at[i],wall_thickness,height/2])
                        rotate([0,90,0])
                            translate([0,0,-screw_diameter/2])
                                linear_extrude(screw_diameter)
                                    projection()
                                        rotate([-90,0,0])
                                            screw_hole(descriptor=_descriptor, standard="LUXPZ", align="t");
                }               

        // add bevel
        if(has_cuts)
        {
            // x-axis bevel
            translate([length, 0, 0])
                rotate([0,0,45])
                    cubepp([2*wall_thickness, 2*wall_thickness, 3*height], align="xy");
            
            // y-axis bevel
            translate([0, length, 0])
                rotate([0,0,-45])
                    cubepp([2*wall_thickness, 2*wall_thickness, 3*height], align="xy");
            
            // origin bevel
            translate([0,0,0])
                rotate([0,0,45])
                    cubepp([sqrt(2)*wall_thickness, sqrt(2)*wall_thickness, 3*height], align="");
        }
    }

    // add reinforcement
    if (!is_undef(reinforcements_at))
        for (i=[0:len(reinforcements_at)-1])
        {
            hull()
            {
                translate([reinforcements_at[i], 0, 0])
                    cylinderpp(d=wall_thickness, h=height, align="yz");
                translate([0, reinforcements_at[i], 0])
                    cylinderpp(d=wall_thickness, h=height, align="xz");
            }
        }
}

$fa = 5;
$fs = 0.1;

//corner_brace(wall_thickness=4, length=36, height=18, screw_holes_at=[27], screw_diameter=3, reinforcements_at=[20]);

corner_brace(wall_thickness=4, length=72, height=18, screw_holes_at=[32, 60], extended_screw_holes_at=[32], screw_diameter=3, reinforcements_at=[22]);