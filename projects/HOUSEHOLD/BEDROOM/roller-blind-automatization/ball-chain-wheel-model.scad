include<ball-chain-wheel-parameters.scad>
use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>


module ball_chain_wheel(
    clearance=0.2,
    fastener_clearance=0.2,
    ball_clearance=0.3,
    tightening_d=3)
{
    _h = bc_ball_d+2*bc_wt;

    difference()
    {
        // main shape
        cylinderpp(d=bc_wheel_outer_d,h=_h);

        // ball holes
        translate([0,0,_h/2])
        for (i=[0:bc_whell_ball_count-1])
        {
            rotate([0,0,i*(360/bc_whell_ball_count)])
            {
                _z_off = i%2 == 0 ? _h : -_h;
                translate([bc_wheel_inner_d/2-clearance,0,0])
                {
                    hull()
                    {
                        translate([0,0,_z_off])
                            spherepp(d=bc_ball_d+2*clearance, align="x");
                        spherepp(d=bc_ball_d+2*clearance, align="x");
                    }
                    
                    hull()
                    {
                        translate([(bc_ball_d+2*clearance)/2,0,0])
                            cylinderpp( d1=bc_ball_d+2*clearance,
                                        d2=_h,
                                        h=bc_ball_d/2,
                                        zet="x",
                                        align="x");

                        translate([(bc_ball_d+2*clearance)/2,0,_z_off])
                            cylinderpp( d1=bc_ball_d+2*clearance,
                                        d2=_h,
                                        h=bc_ball_d/2,
                                        zet="x",
                                        align="x");
                    }
                }

                
            }
        }

        // thread hole
        translate([0,0,_h/2])
            tubepp(d=bc_wheel_inner_d+bc_ball_d/2, D=2*bc_wheel_outer_d, h=bc_thread_w,align="");
    }

}


module nema17_ball_wheel(
    clearance=0.2,
    fastener_clearance=0.2,
    ball_clearance=0.3,
    tightening_d=3)
{

    _h = bc_ball_d+2*bc_wt;

    difference()
    {
        // ball shain wheel
        ball_chain_wheel(
            clearance=clearance,
            fastener_clearance=fastener_clearance,
            ball_clearance=ball_clearance,
            tightening_d=tightening_d
        );

        // shaft
        cylinderpp(d=bc_shaft_d+2*clearance, h=3*_h, align="");

        // bolt and nut
        _hd = get_bolt_head_diameter(bc_shaft_bolt_descriptor, bc_shaft_bolt_standard);
        _hh = get_bolt_head_height(bc_shaft_bolt_descriptor, bc_shaft_bolt_standard);

        translate([bc_shaft_d/2-bc_shaft_tightening_offset,0,_h/2])
        {
            rotate([0,90,0])
                bolt_hole(bc_shaft_bolt_descriptor, bc_shaft_bolt_standard, clearance=fastener_clearance);

            translate([bc_shaft_tightening_offset,0,0])
                rotate([0,-90,0])
                    nut_hole(  d=bc_shaft_fastener_d,
                                standard=bc_shaft_nut_standard,
                                clearance=fastener_clearance,
                                align="t",
                                s_off=_h);

            translate([bc_shaft_bolt_l,0,-(_hd+2*fastener_clearance)/2])
                cubepp([_hh+bc_shaft_bolt_l, _hd+2*fastener_clearance, 2*_h], align="xz", mod_list=[round_edges(d=_hd+2*clearance, axes="yz")]);
        }

        // tightening hole
        translate([bc_shaft_d/2 - bc_shaft_tightening_offset + _hh + bc_shaft_bolt_l,0,_h/2])
            cylinderpp(d=tightening_d+2*clearance, h=bc_wheel_outer_d, zet="x", align="x");
    }
}


module roller_blind_ball_wheel(
    clearance=0.2,
    fastener_clearance=0.2,
    ball_clearance=0.3,
    tightening_d=3)
{

    _bc_rbi_d = bc_rbi_d + 2*clearance; 
    _bc_rbi_edge_d = bc_rbi_edge_d + 2*clearance;
    _bc_rbi_edge_D = bc_rbi_edge_D + 2*clearance; 
    _bc_rbi_h = bc_rbi_h + clearance;

    _h = bc_ball_d+2*bc_wt;

    difference()
    {
        // ball shain wheel
        ball_chain_wheel(
            clearance=clearance,
            fastener_clearance=fastener_clearance,
            ball_clearance=ball_clearance,
            tightening_d=tightening_d
        );

        // interface
        // ... edge
        cylinderpp(d1=_bc_rbi_edge_D,d2=_bc_rbi_edge_d,h=bc_rbi_edge_h, align="z");
        // hole
        cylinderpp(d=_bc_rbi_edge_d,h=_bc_rbi_h, align="z");

        // ... hole through
        cylinderpp(d=_bc_rbi_d, h=3*_h, align="");
    }   

}

$fn = $preview ? 36 : 120;

//nema17_ball_wheel();

roller_blind_ball_wheel();