include<cuttlery-organizer.scad>

$fn=$preview?36:144;

cuttlery_segment(   width = 60,
                    height = 30,
                    length = 243,
                    wall_thickness = 1.5, 
                    fastener_d = 3,
                    bolt_standard = "DIN84A",
                    bolt_length = 18,
                    nut_standard = "DIN562",
                    fastener_offset = 4,
                    has_left_interface=true,
                    has_right_interface=true,
                    clearance=0.15);