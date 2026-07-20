use<../../lib/solidpp/solidpp.scad>

module solder_spool(shaft_diameter, shaft_height,
                    flange_thickness, flange_diameter,
                    wall_thickness, inner_hole_diameter,
                    solder_hole_diameter)
{

    total_h = flange_thickness + shaft_height + flange_thickness;

    // top flange
    translate([0,0,flange_thickness+shaft_height])
        tubepp(D=flange_diameter, d=shaft_diameter, h=flange_thickness);


    // middle part
    difference()
    {
        union()
        {
            tubepp(d=inner_hole_diameter,t=wall_thickness, h=total_h);

            tubepp(D=shaft_diameter,t=wall_thickness, h=total_h);
        }

        if (shaft_diameter > inner_hole_diameter + 4 * wall_thickness)
        {
            // shaft shell with solder hole   
            translate([shaft_diameter/2,0,flange_thickness]) 
                cylinderpp( d=solder_hole_diameter,
                            h=3*wall_thickness,
                            zet="x",
                            align="z");
        }
    
    }

    // bottom flange
    difference()
    {
        tubepp(D=flange_diameter, d=shaft_diameter, h=flange_thickness);

        if (shaft_diameter <= inner_hole_diameter + 4 * wall_thickness)
        {
            translate([0,0,-solder_hole_diameter])
                tubepp(d=shaft_diameter,t=solder_hole_diameter, h=2*solder_hole_diameter);
            translate([shaft_diameter/2,0,0])
                cylinderpp(d=solder_hole_diameter, h=3*flange_thickness, align="x");

        }

    }
}