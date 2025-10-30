use<../lib/solidpp/solidpp.scad>
use<../lib/deez-nuts/deez-nuts.scad>


module washer_to_nut_transition(washer_diameter, nut_side_to_side, step_height=0.2)
{

    intersection()
    {
        cylinderpp(d=washer_diameter, h=3*step_height);

        union()
        {
            //_a = (nut_side_to_side/2)/sin(60);
            
            // lower
            cubepp([nut_side_to_side, washer_diameter, step_height], align="");
            
            // middle
            translate([0, 0, step_height])
            intersection()
            {
                rotate([0, 0, 60])
                    cubepp([nut_side_to_side, washer_diameter, step_height], align="");
                // lower
                cubepp([nut_side_to_side, washer_diameter, step_height], align="");
            }

            /*
            // top
            translate([0, 0, 2*step_height])
            intersection()
            {
                // middle
                intersection()
                {
                    rotate([0,0,30])
                        cubepp([_a, washer_diameter, step_height], align="");
                    cubepp([nut_side_to_side, washer_diameter, step_height], align="");
                }

                rotate([0, 0, -30])
                    cubepp([_a, washer_diameter, step_height], align="");

            }
            */

        }
    }

}

//washer_to_nut_transition(30, 15.9);
//
//rotate([0,0,30])
//    #basic_nut(d=15.9, h=5);