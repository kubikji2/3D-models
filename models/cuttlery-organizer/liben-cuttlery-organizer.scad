include<cuttlery-organizer.scad>

$fn=$preview ? 36 : 144;

length = 243;
tea_spoon_length = 143;

fastener_offset = 4;
bolt_length = 18;

clearance = 0.15;

// knives, forks, spoons
//cuttlery_segment(   width = 60,
//                    height = 30,
//                    length = 243,
//                    wall_thickness = 1.5, 
//                    fastener_d = 3,
//                    bolt_standard = "DIN84A",
//                    bolt_length = 18,
//                    nut_standard = "DIN562",
//                    fastener_offset = 4,
//                    has_left_interface=true,
//                    has_right_interface=true,
//                    clearance=0.15);


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

difference()
{
    union()
    {
        // tea spoons
        translate([30,tea_spoon_length/2,0])
        cuttlery_segment(
            width = 60,
            height = 30,
            length = tea_spoon_length,
            wall_thickness = 1.5, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15);


        // handles
        translate([60+240/2,tea_spoon_length/2,0])
        %cuttlery_segment(
            width = 240,
            height = 30,
            length = tea_spoon_length,
            wall_thickness = 1.5, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15,
            rounding_diameter=60);


        // knives
        translate([150,tea_spoon_length+50,0])
        %cuttlery_segment(
            width = 300,
            height = 30,
            length = 100,
            wall_thickness = 1.5, 
            fastener_d = 3,
            bolt_standard = "DIN84A",
            bolt_length = bolt_length,
            nut_standard = "DIN562",
            fastener_offset = fastener_offset,
            has_left_interface=false,
            has_right_interface=false,
            clearance=0.15,
            rounding_diameter=60);


    }

    // left lower
    #translate([0, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // left upper
    #translate([0, length-bolt_length, fastener_offset])
        rotate([0,0,45])
            liben_fastener_pair();

    // middle lower
    #translate([60, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();
    
    // middle upper
    #translate([60, tea_spoon_length-bolt_length, fastener_offset])
        rotate([0,0,-45])
            liben_fastener_pair();

    // right lower
    #translate([300, bolt_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // right upper
    #translate([300, length-bolt_length, fastener_offset])
        rotate([0,0,45])
            liben_fastener_pair();

    // middle left
    #translate([bolt_length, tea_spoon_length, fastener_offset])
        rotate([0,0,135])
            liben_fastener_pair();

    // middle right
    #translate([300-bolt_length, tea_spoon_length, fastener_offset])
        rotate([0,0,-135])
            liben_fastener_pair();
}