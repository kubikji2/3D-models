use<../../utils/tight-insert-interface.scad>

use<../../lib/solidpp/solidpp.scad>


module cap_2d(  height,
                width,
                plateau_width)
{
    // outer ellipse
    translate([plateau_width/2, 0])
        difference()
        {   
            circlepp([width-plateau_width, 2*height]);
            squarepp([width, height], align="Y");
            squarepp([width, 2*height], align="X");
        }
    
    // plateau
    squarepp([plateau_width/2, height]);
}


module cap( height,
            width,
            plateau_width,
            wt,
            bt)
{

    difference()
    {
        rotate_extrude()
            cap_2d( height=height,
                    width=width,
                    plateau_width=plateau_width);
        
        rotate_extrude()
            cap_2d( height=height-bt,
                    width=width-2*wt,
                    plateau_width=plateau_width);
    }
}


module garden_shovel_cap(   cap_height               = 16,
                            cap_width                = 32,
                            cap_plateau_width        = 15,
                            cap_wt                   = 3,
                            cap_bt                   = 2,
                            interface_diameter       = 30,
                            interface_delta_diameter = 1,
                            interface_height         = 12,
                            interface_thickness      = 2,
                            interface_bevel          = 2)
{   
    // 1. top cap   
    cap(height        = cap_height,
        width         = cap_width,
        plateau_width = cap_plateau_width,
        wt            = cap_wt,
        bt            = cap_bt);
    
    // 2. interface to the shovel
    tight_insert_interface( diameter=interface_diameter,
                            delta_diameter=-interface_delta_diameter,
                            height=interface_height,
                            wall_thickness=interface_thickness,
                            bevel_bottom=interface_bevel,
                            align="Z");


}

$fs = $preview ? 0.1 : 0.01;
$fa = $preview ? 5 : 1;

garden_shovel_cap();
