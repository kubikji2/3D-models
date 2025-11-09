use<../../utils/tight-insert-interface.scad>

use<../../lib/solidpp/solidpp.scad>

PART_INTRFACE_W = 4;
PART_INTRFACE_T = 3;
PART_INTRFACE_WT = 2;
PART_INTRFACE_HOOK = 0.75;
PART_INTRFACE_R = 1;

module interface(   is_cap,
                    width,
                    height,
                    plateau_width,
                    bt,
                    interface_plate_d,
                    clearance=0.2)
{
    if (is_cap)
    {
        translate([0,0,PART_INTRFACE_WT+clearance])
            intersection()
            {
                cubepp([width, PART_INTRFACE_W, PART_INTRFACE_T-clearance], align="z");
                cylinderpp(d=width+clearance,h=3*PART_INTRFACE_T, align="");
            }
    }
    else
    {

        
        // base
        cylinderpp( d=interface_plate_d,
                    h=PART_INTRFACE_WT,
                    align="z");
        
        intersection()
        {
            union()
            { 
                // interface hooks
                translate([0,0,PART_INTRFACE_WT])
                    difference()
                    {
                        
                        union()
                        {
                            cubepp([width,
                                    PART_INTRFACE_W+2*clearance+2*PART_INTRFACE_WT,
                                    PART_INTRFACE_T+2*clearance+PART_INTRFACE_WT],
                                    align="z");
                            
                            // rounding
                            mirrorpp([0,1,0], true)
                                translate([0,-PART_INTRFACE_W/2-PART_INTRFACE_WT-clearance,0])
                                    difference()
                                    {
                                        cubepp([width, PART_INTRFACE_R, PART_INTRFACE_R], align="Yz");
                                        cylinderpp(r=PART_INTRFACE_R, h=3*width, zet="x", align="Yz");
                                    }
                        }


                        // middle hole
                        cubepp([width,
                                PART_INTRFACE_W+2*clearance,
                                PART_INTRFACE_T+2*clearance],
                                align="z");

                        // hooks hole
                        translate([0,0,PART_INTRFACE_T+2*clearance])
                            scale([1,1,PART_INTRFACE_WT/PART_INTRFACE_HOOK])
                                cubepp([3*width, 
                                        PART_INTRFACE_W+2*clearance,
                                        3*PART_INTRFACE_HOOK],
                                        align="z",
                                        mod_list=[bevel_edges(bevel=PART_INTRFACE_HOOK)]);
                        // splitting
                        mirrorpp([1,0,0], true)
                        translate([width/6,0,0])
                            cubepp( [1, width, 3*width],
                                    align="z",
                                    mod_list=[round_edges(d=1, axes="xz")]);
                }




            }

            // masking to the hole shape
            cap_shape(  height=height,
                        width=width-2*clearance,
                        plateau_width=plateau_width);
            
        }
    }
}


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


module cap_shape(   height,
                    width,
                    plateau_width)
{
    rotate_extrude()
        cap_2d( height=height,
                width=width,
                plateau_width=plateau_width);
}


module showel_interface(interface_diameter,
                        interface_delta_diameter,
                        interface_height,
                        interface_thickness,
                        interface_bevel,
                        cap_height,
                        cap_width,
                        cap_plateau_width,
                        cap_wt,
                        cap_bt
)
{

    // 1. interface to the shovel
    tight_insert_interface( diameter=interface_diameter,
                            delta_diameter=-interface_delta_diameter,
                            height=interface_height,
                            wall_thickness=interface_thickness,
                            bevel_bottom=interface_bevel,
                            rounding_top=interface_thickness,
                            segments_count=8,
                            align="Z");
    
    // 2. interfacce with the cap
    interface(  is_cap=false,  
                width=cap_width-2*cap_wt,
                height=cap_height-cap_bt,
                plateau_width=cap_plateau_width,
                interface_plate_d = interface_diameter-2*interface_delta_diameter);



}


module cap( height,
            width,
            plateau_width,
            wt,
            bt,
            interface_plate_d,
            clearance=0.2)
{

    difference()
    {
        cap_shape(  height=height,
                    width=width,
                    plateau_width=plateau_width);
        
        cap_shape(  height=height-bt,
                    width=width-2*wt,
                    plateau_width=plateau_width);
        
        // interface hole
        translate([0,0,-clearance])
            cylinderpp( d=interface_plate_d+2*clearance,
                        h=PART_INTRFACE_WT+2*clearance,
                        align="z");

    }


    // interface
    interface(  is_cap=true,  
                width=width-2*wt,
                height=height-bt,
                plateau_width=plateau_width,
                interface_plate_d=interface_plate_d);

}



module garden_shovel_cap(   is_cap                   = false,
                            cap_height               = 16,
                            cap_width                = 32,
                            cap_plateau_width        = 15,
                            cap_wt                   = 2,
                            cap_bt                   = 2,
                            interface_diameter       = 31,
                            interface_delta_diameter = 1,
                            interface_height         = 12,
                            interface_thickness      = 2,
                            interface_bevel          = 2)
{   
    // 1. top cap   
    if (is_cap)
    {
        cap(height        = cap_height,
            width         = cap_width,
            plateau_width = cap_plateau_width,
            wt            = cap_wt,
            bt            = cap_bt,
            interface_plate_d = interface_diameter-2*interface_delta_diameter);
    }
    else
    {
        showel_interface(   interface_diameter       = interface_diameter,
                            interface_delta_diameter = interface_delta_diameter,
                            interface_height         = interface_height,
                            interface_thickness      = interface_thickness,
                            interface_bevel          = interface_bevel,
                            cap_height        = cap_height,
                            cap_width         = cap_width,
                            cap_plateau_width = cap_plateau_width,
                            cap_wt            = cap_wt,
                            cap_bt            = cap_bt);    
    }

}


module shovel_cap_single(   cap_height               = 16,
                            cap_width                = 32,
                            cap_plateau_width        = 15,
                            cap_wt                   = 2,
                            cap_bt                   = 2,
                            interface_diameter       = 31,
                            interface_delta_diameter = 1,
                            interface_height         = 12,
                            interface_thickness      = 2,
                            interface_bevel          = 2)
{
    cap_shape(  height        = cap_height,
                width         = cap_width,
                plateau_width = cap_plateau_width);
    
    tight_insert_interface( diameter       = interface_diameter,
                            delta_diameter = -interface_delta_diameter,
                            height         = interface_height,
                            wall_thickness = interface_thickness,
                            bevel_bottom   = interface_bevel,
                            rounding_top   = interface_thickness,
                            segments_count = 8,
                            align          = "Z");
    
}


$fs = $preview ? 0.1 : 0.05;
$fa = $preview ? 5 : 1;

shovel_cap_single();
