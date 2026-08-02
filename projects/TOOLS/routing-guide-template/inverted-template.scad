
// Dremel cutting guide parameter
drm_d = 60;
drm_h = 6;
drm_drill_d = 3.2;


module __child_flattener(height)
{
    linear_extrude(height)
        projection(cut=true)
            children();
}

module __child_flattener_with_minkowski(height, diameter)
{
    minkowski()
    {
        __child_flattener(height/2)
            children();
        cylinder(h=height/2, d=diameter);
    }
}


module inverted_template(bottom_thickness, stopper_width, stopper_height=drm_h, drill_d = drm_drill_d, guide_diameter=drm_d, shape_bounding_box=undef)
{
    difference()
    {
        // main shape 
        if (is_undef(shape_bounding_box))
        {
            __child_flattener_with_minkowski(height=stopper_height+bottom_thickness, diameter=guide_diameter+2*stopper_width+drill_d)
                children();
        }
        else
        {
            // TODO custom shapes based on the `shape_boinding_box`
        }
        
        // inverse template for the guide
        translate([0,0,bottom_thickness])
            __child_flattener_with_minkowski(height=stopper_height+bottom_thickness, diameter=guide_diameter+drill_d)
                children();

        // drill bit hole
        translate([0,0,-bottom_thickness])
            __child_flattener_with_minkowski(height=stopper_height+bottom_thickness, diameter=2*drill_d)
                children();
    }


}
