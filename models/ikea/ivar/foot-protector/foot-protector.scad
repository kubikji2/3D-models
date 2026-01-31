use<../../../../lib/deez-nuts/deez-nuts.scad>
use<../../../../lib/solidpp/solidpp.scad>

ivar_clearance = 0.1;
ivar_leg_w = 43.5;
ivar_leg_d = 31.5;

module ivar_foot_protector( bottom_thickness,
                            wall_thickness,
                            height)
{

    difference()
    {
        _x = ivar_leg_w + 2*wall_thickness;
        _y = ivar_leg_d + 2*wall_thickness;
        _z = height + bottom_thickness;
        // base shape
        cubepp([_x,_y,_z], mod_list = [round_edges(bottom_thickness)]);

        // cut 
        translate([wall_thickness-ivar_clearance,wall_thickness-ivar_clearance,bottom_thickness])
            cubepp([ivar_leg_w + 2*ivar_clearance, ivar_leg_d + 2*ivar_clearance, _z]);

    }
}
