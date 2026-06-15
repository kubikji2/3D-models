include<../../lib/solidpp/solidpp.scad>
include<emos-EV112-dimensions.scad>


module emos_ev112_holder(
    wt = 4,
    clearance = 0.5,
    leg_clearance = 2
)
{
    _x = EV112_X + 2*wt;
    _y = EV112_Y + 2*wt;
    _z = EV112_Z + 2*wt;

    _x_clr = EV112_X + 2*clearance;
    _y_clr = EV112_Y + 2*clearance;
    _z_clr = EV112_Z + 2*clearance;


    intersection()
    {
        difference()
        {
            cubepp([_x, _z, _y], align="zy");
            
            // top slit for plane
            translate([0,_z-wt+clearance,wt-clearance])
                cubepp( [_x_clr,EV112_PLATE_T+2*clearance,2*_y],
                        align="zY",
                        mod_list=[round_edges(r=EV112_R, axes="xz")]);
            // transition
            translate([0,_z-wt-clearance-EV112_PLATE_T,wt-clearance])
                cubepp( [_x_clr-2*(EV112_PLATE_E),EV112_TRANSITION_H+2*clearance,2*_y],
                        align="zY",
                        mod_list=[round_edges(r=EV112_R, axes="xz")]);

            // leg cuts
            hull()
            {
                translate([0,_z-wt-EV112_PLATE_T-EV112_PLATE_E,wt-clearance])
                    cubepp( [_x_clr-2*(EV112_PLATE_E),leg_clearance,2*_y],
                            align="zY",
                            mod_list=[round_edges(r=EV112_R, axes="xz")]);
                translate([0,wt-clearance,wt-clearance])
                    cubepp( [_x_clr-2*EV112_LEG_E+2*leg_clearance,leg_clearance,2*_y],
                            align="zy",
                            mod_list=[round_edges(r=EV112_R, axes="xz")]);    
            }

            // lower plane hole
            translate([0,0,_y/4])
            cubepp([EV112_X/2, 3*wt, EV112_Y],
                    align="z",
                    mod_list=[round_edges(r=EV112_R, axes="xz")] );

            // protrusion slide hole
            translate([0,_z-wt,_y/4])
                cubepp( [EV112_PROTRUSION_D+2*clearance, EV112_PROTRUSION_H+clearance, _y],
                        align="zy",
                        mod_list=[round_edges(d=EV112_PROTRUSION_D+2*clearance, axes="xz")]);


            
        }

        union()
        {
            minkowski()
            {
                hull()
                {
                    translate([0,_z-wt-EV112_PLATE_T-EV112_PLATE_E])
                        cubepp( [_x_clr-2*(EV112_PLATE_E),leg_clearance,2*_y],
                                align="zY");
                    translate([0,wt-clearance])
                        cubepp( [_x_clr-2*EV112_LEG_E+2*leg_clearance,leg_clearance,2*_y],
                                align="zy");
                }
                cylinder(r=wt,h=1,$fn=16);
            }
            translate([0,_z-wt-EV112_PLATE_T-EV112_PLATE_E-leg_clearance-wt])
                cubepp( [_x,_z,_y],
                        align="yz",
                        mod_list=[bevel_edges(bevel=wt, axes="xy")]);
        }
    }

}

$fn = $preview ? 36 : 144;
emos_ev112_holder();