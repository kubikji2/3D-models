include<cuttlery-organizer.scad>

$fn=$preview ? 36 : 144;

drawer_width = 1000;
drawer_length = 243;
organizer_height = 30;
wall_thickness = 1.5;

fastener_offset = 4;
bolt_length = 18;

module liben_fastener_pair()
{
    fastener_pair(
        fastener_d = 3,
        bolt_standard = "DIN84A",
        bolt_length = bolt_length,
        nut_standard = "DIN562",
        clearance = clearance
    );
}

clearance = 0.15;

// shape
#%cubepp([drawer_width,drawer_length,0.1]);

// knives, forks, spoons
basic_cuttlery_width = 60;

///*
for (i=[0:2])
{
    %translate([basic_cuttlery_width/2+i*basic_cuttlery_width,drawer_length/2,0])
        cuttlery_segment(   width = basic_cuttlery_width,
                            height = organizer_height,
                            length = drawer_length,
                            wall_thickness = wall_thickness, 
                            fastener_d = 3,
                            bolt_standard = "DIN84A",
                            bolt_length = 18,
                            nut_standard = "DIN562",
                            fastener_offset = 4,
                            has_left_interface=true,
                            has_right_interface=true,
                            clearance=0.15);
}
//*/

// knives, chopsticks, small spoons
tea_spoon_length = 143+30;
tea_spoon_width = basic_cuttlery_width;

chop_sticks_length = 250;
chop_sticks_width = tea_spoon_length;

knives_length = tea_spoon_width+chop_sticks_length;
knives_width = drawer_length-tea_spoon_length;
//echo(knives_length);



translate([3*basic_cuttlery_width,0,0])
difference()
{
    union()
    {
        // tea spoons
        %translate([30,tea_spoon_length/2,0])
        cuttlery_segment(
            width = tea_spoon_width,
            height = organizer_height,
            length = tea_spoon_length,
            wall_thickness = wall_thickness, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15);


        // chop_stics
        %translate([tea_spoon_width+chop_sticks_length/2,chop_sticks_width/2,0])
        {
        cuttlery_segment(
            width = chop_sticks_length,
            height = organizer_height,
            length = chop_sticks_width,
            wall_thickness = wall_thickness, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15,
            rounding_diameter=basic_cuttlery_width);

            cubepp([chop_sticks_length, wall_thickness, organizer_height], align="z");

        }
        //%translate([tea_spoon_width+chop_sticks_length/2,chop_sticks_width+chop_sticks_width/2,0])
        //cuttlery_segment(
        //    width = chop_sticks_length,
        //    height = organizer_height,
        //    length = chop_sticks_width,
        //    wall_thickness = 1.5, 
        //    fastener_d = 3,
        //    bolt_standard = "DIN84A",
        //    bolt_length = bolt_length,
        //    nut_standard = "DIN562",
        //    fastener_offset = fastener_offset,
        //    has_left_interface=false,
        //    has_right_interface=false,
        //    clearance=0.15,
        //    rounding_diameter=60);

        // long knives
        translate([knives_length/2,tea_spoon_length+knives_width/2,0])
        cuttlery_segment(
            width = knives_length,
            height = 30,
            length = knives_width,
            wall_thickness = wall_thickness, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15,
            rounding_diameter=basic_cuttlery_width);

    }

    // left lower
    #translate([0, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // left upper
    #translate([0, drawer_length-bolt_length, fastener_offset])
        rotate([0,0,45])
            liben_fastener_pair();

    // middle lower
    #translate([tea_spoon_width, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();
    
    // middle upper
    %#translate([tea_spoon_width, tea_spoon_length-bolt_length, fastener_offset])
        rotate([0,0,-45])
            liben_fastener_pair();

    // right lower
    #translate([tea_spoon_width+chop_sticks_length, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // right upper
    #translate([tea_spoon_width+chop_sticks_length, drawer_length-bolt_length, fastener_offset])
        rotate([0,0,45])
            liben_fastener_pair();

    // middle left
    #translate([bolt_length, tea_spoon_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // middle right
    #translate([tea_spoon_width+chop_sticks_length-bolt_length, tea_spoon_length, fastener_offset])
        rotate([0,0,-135])
            liben_fastener_pair();
}


misc_length = 330;
misc_width = drawer_length/2;

// short knives
short_knives_width = drawer_width-4*basic_cuttlery_width-knives_length-misc_length;
//echo(short_knives_width);


translate([3*basic_cuttlery_width+knives_length,0,0])
{

    // cuttlery misc
    %translate([basic_cuttlery_width/2,drawer_length/2,0])
        cuttlery_segment(   width = basic_cuttlery_width,
                            height = organizer_height,
                            length = drawer_length,
                            wall_thickness = wall_thickness, 
                            fastener_d = 3,
                            bolt_standard = "DIN84A",
                            bolt_length = 18,
                            nut_standard = "DIN562",
                            fastener_offset = 4,
                            has_left_interface=true,
                            has_right_interface=true,
                            clearance=0.15);

    // short knives
    %translate([basic_cuttlery_width+short_knives_width/2,drawer_length/2,0])
        cuttlery_segment(   width = short_knives_width,
                            height = organizer_height,
                            length = drawer_length,
                            wall_thickness = wall_thickness, 
                            fastener_d = 3,
                            bolt_standard = "DIN84A",
                            bolt_length = 18,
                            nut_standard = "DIN562",
                            fastener_offset = 4,
                            has_left_interface=true,
                            has_right_interface=true,
                            clearance=0.15,
                            rounding_diameter=basic_cuttlery_width);
    // misc top
    translate([basic_cuttlery_width+short_knives_width,0,0])
    difference()
    {
        union()
        {
            %translate([misc_length/2,misc_width/2,0])
                cuttlery_segment(   width = misc_length,
                                    height = organizer_height,
                                    length = misc_width,
                                    wall_thickness = wall_thickness, 
                                    fastener_d = 3,
                                    bolt_standard = "DIN84A",
                                    bolt_length = 18,
                                    nut_standard = "DIN562",
                                    fastener_offset = 4,
                                    has_left_interface=false,
                                    has_right_interface=false,
                                    clearance=0.15,
                                    rounding_diameter=basic_cuttlery_width);
        
            // misc bottom
            %translate([misc_length/2,misc_width+misc_width/2,0])
                cuttlery_segment(   width = misc_length,
                                    height = organizer_height,
                                    length = misc_width,
                                    wall_thickness = wall_thickness, 
                                    fastener_d = 3,
                                    bolt_standard = "DIN84A",
                                    bolt_length = 18,
                                    nut_standard = "DIN562",
                                    fastener_offset = 4,
                                    has_left_interface=false,
                                    has_right_interface=false,
                                    clearance=0.15,
                                    rounding_diameter=basic_cuttlery_width);
        
        }

        // left lower
        #translate([0, bolt_length, fastener_offset])
            rotate([0,0,135])
                liben_fastener_pair();

        // left upper
        #translate([0, drawer_length-bolt_length, fastener_offset])
            rotate([0,0,45])
                liben_fastener_pair();

        // right lower
        #translate([misc_length, bolt_length, fastener_offset])
            rotate([0,0,135])
                liben_fastener_pair();

        // right upper
        #translate([misc_length, drawer_length-bolt_length, fastener_offset])
            rotate([0,0,45])
                liben_fastener_pair();

        // left middle
        #translate([bolt_length, misc_width, fastener_offset])
            rotate([0,0,135])
                liben_fastener_pair();

        // right middle
        #translate([misc_length-bolt_length, misc_width, fastener_offset])
            rotate([0,0,-135])
                liben_fastener_pair();

    }

}