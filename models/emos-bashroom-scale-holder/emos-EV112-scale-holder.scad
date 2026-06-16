include<../../lib/solidpp/solidpp.scad>
include<emos-EV112-dimensions.scad>


module emos_ev112_holder_silhouette_2d(_x,_z,wt,leg_clearance)
{
    offset(wt)
        offset(-wt)
            hull()
            {
                translate([0,_z])
                    squarepp([_x,wt+EV112_PLATE_T+wt], align="Y");
                            
                //squarepp([_x-2*EV112_LEG_E,wt], align="y");
            }
    translate([0,_z])
        squarepp([_x,wt], align="Y");
}

module emos_ev112_holder_slit(_x, _y, _z, _x_clr, _y_clr, _z_clr, wt, clearance, leg_clearance)
{
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
    //hull()
    //{
    //    translate([0,_z-wt-EV112_PLATE_T-EV112_PLATE_E,wt-clearance])
    //        cubepp( [_x_clr-2*(EV112_PLATE_E),leg_clearance,2*_y],
    //                align="zY",
    //                mod_list=[round_edges(r=EV112_R, axes="xz")]);
    //    translate([0,wt-clearance,wt-clearance])
    //        cubepp( [_x_clr-2*EV112_LEG_E+2*leg_clearance,leg_clearance,2*_y],
    //                align="zy",
    //                mod_list=[round_edges(r=EV112_R, axes="xz")]);    
    //}
}

module support(h, l, wt, connection_w = 0.4)
{
    
    translate([0,wt/2,0])
    hull()
    {
        cubepp([wt, l, 0.1], align="yz");
        cubepp([wt, 0.1, h], align="yz");
    }

    difference()
    {
        cubepp( [wt, wt, h],
                align="yz",
                mod_list=[bevel_edges((wt-connection_w)/2, axes="xy")]);
        translate([0,wt/2,0])
            cubepp([2*wt, wt, 3*h], align="y");
    }
}

module emos_ev112_holder(
    wt = 4,
    clearance = 0.5,
    leg_clearance = 2,
    transition_length = 20,
)
{
    _x = EV112_X + 2*wt;
    _y = EV112_Y + 2*wt;
    _z = EV112_Z + 2*wt;

    _x_clr = EV112_X + 2*clearance;
    _y_clr = EV112_Y + 2*clearance;
    _z_clr = EV112_Z + 2*clearance;


    difference()
    {
        union()
        {
            linear_extrude(_y)
                emos_ev112_holder_silhouette_2d(_x,_z,wt,leg_clearance);
                

        }

        emos_ev112_holder_slit(_x, _y, _z, _x_clr, _y_clr, _z_clr, wt, clearance, leg_clearance);

        // lower plane hole
        translate([0,0,_y/4])
            cubepp([EV112_X/2, 3*wt, EV112_Y],
                    align="z",
                    mod_list=[round_edges(r=EV112_R, axes="xz")] );

        // protrusion slide hole
        translate([0,_z-wt,_y/2-EV112_PROTRUSION_D/2-clearance])
            cubepp( [EV112_PROTRUSION_D+2*clearance, EV112_PROTRUSION_H+clearance, _y],
                    align="zy",
                    mod_list=[round_edges(d=EV112_PROTRUSION_D+2*clearance, axes="xz")]);

        // transition
        translate([0,0,_y+transition_length])
        {
            _eps = 1;

            // top transition
            hull()
            {
                intersection()
                {
                    linear_extrude(_eps)
                        emos_ev112_holder_silhouette_2d(_x,_z,wt,leg_clearance);
                    translate([0,_z-wt-EV112_PLATE_T-clearance,0])
                        cubepp([_x,_z,_y], align="yz");
                }
                // top slit for plane
                translate([0,_z-wt+clearance,-2*transition_length])
                    cubepp( [_x_clr,EV112_PLATE_T+2*clearance, _eps],
                            align="zY");
            }

            // bottm transiton
            hull()
            {
                intersection()
                {
                    linear_extrude(_eps)
                        emos_ev112_holder_silhouette_2d(_x,_z,wt,leg_clearance);
                    translate([0,-wt-EV112_PLATE_T-clearance,0])
                        cubepp([_x,_z,_y], align="yz");
                }

                translate([0,0,-2*transition_length])
                union()
                {
                    // transition
                    translate([0,_z-wt-clearance-EV112_PLATE_T,0])
                        cubepp( [_x_clr-2*(EV112_PLATE_E),EV112_TRANSITION_H+2*clearance,2*_y],
                                align="zY");

                    // leg cuts
                    hull()
                    {
                        translate([0,_z-wt-EV112_PLATE_T-EV112_PLATE_E,0])
                            cubepp( [_x_clr-2*(EV112_PLATE_E),leg_clearance,2*_y],
                                    align="zY");
                        translate([0,wt-clearance,0])
                            cubepp( [_x_clr-2*EV112_LEG_E+2*leg_clearance,leg_clearance,2*_y],
                                    align="zy");    
                    }
                }
            }
        }
        
    }

}

$fn = $preview ? 36 : 144;
emos_ev112_holder();


translate([0,EV112_Z+2*4,0])
{
    support(h=EV112_Y, l=EV112_Y/4, wt=4);
    translate([-EV112_X/3,0,0])
        support(h=EV112_Y, l=EV112_Y/4, wt=4);
    translate([EV112_X/3,0,0])
        support(h=EV112_Y, l=EV112_Y/4, wt=4);
}