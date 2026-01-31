include<../../lib/solidpp/solidpp.scad>



module hole_clearance_tester(   base_diameter,
                                height,
                                min_clearance,
                                max_clearance,
                                clearance_increment,
                                wall_thickness)
{
    n_holes = (max_clearance - min_clearance)/clearance_increment + 1;

    _x = n_holes*(base_diameter+wall_thickness) + wall_thickness;
    _y = max(base_diameter+wall_thickness, height) + wall_thickness;
    _z = wall_thickness + base_diameter + wall_thickness + height;

    difference()
    {
        cube([_x,_y,_z]);

        // hortizontals holes
        for(i=[0:n_holes-1])
        {
            _t = [wall_thickness+i*(wall_thickness+base_diameter), 0, wall_thickness+base_diameter/2];
            _d = base_diameter + i*clearance_increment + min_clearance;
            translate(_t)
                cylinderpp(h=2*height, d=_d, zet="y", align = "x");
        }

        // vertical holes
        for(i=[0:n_holes-1])
        {
            _t = [wall_thickness+i*(wall_thickness+base_diameter), wall_thickness,_z];
            _d = base_diameter + i*clearance_increment + min_clearance;

            translate(_t)
                cylinderpp(h=2*height, d=_d, align = "xy");
        }

        // labels
        for(i=[0:n_holes-1])
        {   
            _td = 0.5;
            _t = [wall_thickness+i*(wall_thickness+base_diameter)+base_diameter/2, _td, wall_thickness+base_diameter + height/2 + ( i % 2 == 0 ? wall_thickness : 0)];
            _clrn = min_clearance + i*clearance_increment;
            translate(_t)
                rotate([90,0,0])
                    linear_extrude(2*_td)
                        text(str(_clrn), halign="center", valign="center", size=base_diameter);
        }
    }

}