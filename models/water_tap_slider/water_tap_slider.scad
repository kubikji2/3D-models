include<../../lib/solidpp/solidpp.scad>

module tap_slider(  tap_diameter,
                    wall_thickness,
                    pin_diameter,
                    pin_offset,
                    slider_height)
{

    difference()
    {
        // main shape
        tubepp(d=tap_diameter, t=wall_thickness, h=slider_height);

        // hole for pin
        translate([0,0,pin_offset])
        {
            cylinderpp(d=pin_diameter, h=tap_diameter, zet="x", align="x");
            cubepp([tap_diameter, pin_diameter, slider_height], align="xz");
        }

        // cut hole
        cubepp([tap_diameter,0.5,2*slider_height], align="x");

    }

    // handle
    difference()
    {
        hull()
        {
            // main body
            cylinderpp(d=tap_diameter+2*wall_thickness, h=slider_height);
            
            // handle
            translate([0,0,slider_height/2])
                cylinderpp(d=tap_diameter, h=wall_thickness, align="X");
        }
        
        // inner cut
        cylinderpp(d=tap_diameter+wall_thickness, h=3*slider_height, align="");

        cubepp([tap_diameter+2*wall_thickness,
                2*tap_diameter+4*wall_thickness,
                3*slider_height],
                align="x");

        // lower torus
        _td = tap_diameter+2*wall_thickness;
        _tt = slider_height-wall_thickness;
        toruspp(d=_td, t=_tt);
        
        tubepp( d=_td+_tt,
                t=tap_diameter,
                h=slider_height/2-wall_thickness/2);
        // upper torus
        translate([0,0,slider_height])
        {
            toruspp(d=_td, t=_tt);
            tubepp( d=_td+_tt,
                t=tap_diameter,
                h=slider_height/2-wall_thickness/2,
                align="Z");
        }
    }
}

$fn = $preview ? 36 : 144;

tap_slider( tap_diameter=28,
            wall_thickness=3,
            pin_diameter=13,
            pin_offset=7+13/2,
            slider_height=20);