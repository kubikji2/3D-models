include<../lib/solidpp/solidpp.scad>


module clip_on_rod_interface(   rod_diameter,
                                height,
                                wall_thickness,
                                insert_gauge,
                                clearance=0.5)
{
    linear_extrude(height)
    {
        offset(r=wall_thickness/2)
            offset(r=-wall_thickness/2)
                difference()
                {
                    circlepp(d=rod_diameter+2*wall_thickness);
                    circlepp(d=rod_diameter-2*clearance);
                    squarepp([rod_diameter, insert_gauge-2*clearance], align="X");
                }
    }

}


//$fs = $preview ? 0.1 : 0.01;
//$fa = $preview ? 5 : 1;
//clip_on_rod_interface(rod_diameter=20, height=10, wall_thickness=4, insert_gauge=16);