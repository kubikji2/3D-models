include<inverted-template.scad>

include<../../../lib/solidpp/solidpp.scad>


// children 0 -- shape
// children 1 -- plank
module plank_holder(bottom_thickness, wall_thickness, wall_height, stopper_width, drill_d = drm_drill_d, drill_l=20, guide_diameter=drm_d)
{
    // main shape
    difference()
    {
        union()
        {
            __child_flattener_with_minkowski(diameter=guide_diameter+2*stopper_width+drill_d, height=bottom_thickness)
                children(0);

            __child_flattener_with_minkowski(diameter=2*wall_thickness+drill_d, height=bottom_thickness+drill_l)
                children(0);
            __child_flattener_with_minkowski(diameter=2*wall_thickness, height=bottom_thickness+drill_l)    
                children(1);
        }

        // hole for the drill
        translate([0,0,-drill_l])
            __child_flattener_with_minkowski(diameter=2*drill_d, height=2*drill_l)
                children(0);        

        // hole for the plank
        translate([0,0,-bottom_thickness])
            scale([1,1,10])
                children(1);
    }

}

