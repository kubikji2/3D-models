include<../../lib/deez-nuts/deez-nuts.scad>
include<../../lib/solidpp/solidpp.scad>


module shelf_interface(shelf_thickness, wall_thickness, leg_length, interface_length)
{
    // shelf thickness interface
    hull()
    {
        cylinderpp(d=wall_thickness, h=leg_length, align="XYz");
        translate([0,shelf_thickness,0])
            cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
    }

    // length interface
    translate([0,shelf_thickness,0])
    hull()
    {
        cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
        translate([interface_length,0,0])
            cylinderpp(d=wall_thickness, h=leg_length, align="Xyz");
    }
}

module leg_segment( length,
                    height,
                    leg_thickness,
                    hole_width,
                    hole_height,
                    connectors_diameter,
                    screw_diameter,
                    interface_thickness,
                    interface_length,
                    shelf_thickness)
{

    difference()
    {
        union()
        {
            // main shape
            
            // interface
            shelf_interface(shelf_thickness=shelf_thickness,
                            wall_thickness=interface_thickness,
                            leg_length=length,
                            interface_length=interface_length);
        }

    }
}


//shelf_interface(shelf_thickness=12,
//                wall_thickness=5,
//                leg_length=200,
//                interface_length=20);

leg_segment(length=200,
            height=250,
            leg_thickness=10,
            hole_width=180,
            hole_height=220,
            connectors_diameter=3,
            screw_diameter=3,
            interface_thickness=5,
            interface_length=20,
            shelf_thickness=12);

%cubepp([20,12,200]);