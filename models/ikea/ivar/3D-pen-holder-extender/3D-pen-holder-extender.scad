use<../../../../lib/solidpp/solidpp.scad>

use<../../../../utils/circular-serration.scad>

module holder_extender(
    pen_d = 40,
    wt = 3,
    holder_interface_d = 28.5,
    holder_interface_l = 8,
    holder_wire_t = 2.5,
    extension_l = 45,
    n_holes = 8,
    transition_bevel = 1,
    clearance = 0.2
)
{
    _spiral_D = holder_interface_d+2*holder_wire_t+2*clearance;

    // holder interface funnel
    difference()
    {
        intersection()
        {
            tubepp( d=_spiral_D,
                    t=wt,
                    h=holder_interface_l+wt);
            cylinderpp(d=_spiral_D+2*wt,
                        h=(holder_interface_l+wt),
                        mod_list=[bevel_bases(bevel_top=transition_bevel)]);            
        }
        
        translate([0,0,-0.1])
            cylinderpp( d1=_spiral_D+2*transition_bevel+0.2,
                        d2=_spiral_D,
                        h=transition_bevel+0.1);
    }
    //intersection()
    //{
    //    tubepp( D=holder_interface_d,
    //            t=wt,
    //            h=holder_interface_l+wt);
    //    cylinderpp( d=holder_interface_d,
    //                h=2*(holder_interface_l+wt),
    //                mod_list=[bevel_bases(1)]);
    //}

    translate([0,0,holder_interface_l+wt])
        difference()
        {
            union()
            {
                // outer shape
                cylinderpp(d1=holder_interface_d+2*wt, d2=pen_d+2*wt, h=extension_l+wt);

                // holder interface stopper
                _wt = max(holder_wire_t, wt);
                tubepp( d=holder_interface_d,
                        D=_spiral_D+2*wt-2*transition_bevel,
                        h=wt,
                        align="Z");
            }

            // inner funel
            _eps = 0.1;
            translate([0,0,-_eps])
                cylinderpp( d1=holder_interface_d,
                            d2=pen_d,
                            h=extension_l+wt+2*_eps);

            // entry bevel
            _decrement = 2*wt*(pen_d-holder_interface_d)/(extension_l);
            translate([0,0,extension_l-wt])
                cylinderpp(d1=pen_d-_decrement,d2=pen_d+2*wt,h=2*wt);
            
            // hole cuts
            if (n_holes > 0)
            for(i=[0:n_holes])
            translate([0,0,wt])
                rotate([0,0,i*(360/n_holes)])
                cubepp( [pen_d+2*wt,wt,extension_l-3*wt],
                        align="xz",
                        mod_list=[round_edges(d=wt, axes="yz")]);
    }

    // serration
    translate([0,0,transition_bevel])
        circular_serration( radius=_spiral_D/2,
                            height=wt+holder_interface_l-transition_bevel,
                            n_serration=180,
                            serration_bottom_d=0,
                            serration_top_d=2*clearance,
                            z_align="z");



}

$fs = 0.1;
$fa = 2;
holder_extender();