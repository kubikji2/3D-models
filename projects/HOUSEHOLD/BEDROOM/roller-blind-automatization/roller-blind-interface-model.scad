include<roller-blind-interface-constants.scad>
use<../../../../lib/solidpp/solidpp.scad>

include<ball-chain-wheel-parameters.scad>


module roller_blind_interface(length, interface_offset=0, clearance=0.1)
{

    _rbi_stopper_hole_w = rbi_stopper_hole_w+2*clearance;
    _rbi_stopper_d = rbi_stopper_d-2*clearance;
    _rbi_d = rbi_d-2*clearance;
    _rbi_fin_w = rbi_fin_w-2*clearance;
    _rbi_fin_h = rbi_fin_h-clearance;

    // interface
    translate([0,0,interface_offset])
        difference()
        {
            cylinderpp(d=_rbi_stopper_d, h=rbi_stopper_w);
            difference()
            {
                for(i=[0:rbi_fin_count-1])
                    rotate([0,0,i*(360/rbi_fin_count)])
                        cubepp([_rbi_stopper_hole_w, rbi_stopper_d, 3*rbi_stopper_w], align="y");
                cylinderpp(d=_rbi_stopper_d-2*rbi_stopper_h, h=3*rbi_stopper_w, align="");
            }
        }

    // stopper
    difference()
    {
        cylinderpp(d=_rbi_d, h=rbi_stopper_w+rbi_stopper_h+interface_offset);
        
        difference()
        {
            for(i=[0:rbi_fin_count-1])
                rotate([0,0,i*(360/rbi_fin_count)])
                    translate([0,0,-_rbi_stopper_hole_w/2])
                    cubepp([_rbi_stopper_hole_w,
                            rbi_stopper_d,
                            (_rbi_stopper_hole_w+rbi_stopper_h)+interface_offset],
                            align="yz",
                            mod_list=[round_edges(d=_rbi_stopper_hole_w,axes="xz")]);
            cylinderpp( d=rbi_stopper_d-2*clearance-2*rbi_stopper_h,
                        h=rbi_stopper_w+rbi_stopper_h+interface_offset,
                        align="z");

        }
    }

    // fins area with variable lenth
    translate([0,0,rbi_stopper_w+rbi_stopper_h+interface_offset])
    {
        cylinderpp(d=_rbi_d,h=length-interface_offset);
        
        for(i=[0:rbi_fin_count-1])
            rotate([0,0,i*(360/rbi_fin_count)])
                translate([0,0,0])
                    hull()
                    {
                        cubepp([0.1,_rbi_d/2, length-interface_offset],align="yz");
                        cubepp([_rbi_fin_w,_rbi_d/2, length-rbi_fin_slope_l-interface_offset],align="yz");
                        cubepp([0.01,_rbi_d/2+rbi_fin_h, length-rbi_fin_slope_l-interface_offset],align="yz");
                        
                    }
        
    
    }



}

module roller_blind_interface_piece(clearance=0.2)
{

    _h = rbi_piece_h;
    _rbi_pieve_inner_h = rbi_pieve_inner_h - clearance;

    _rbi_spring_h = rbi_spring_h + clearance;
    //_bc_rbsi_D = bc_rbsi_D + 2*clearance;
    _bc_rbi_d = bc_rbi_d + 2*clearance;

    _rbi_axis_clip_stopper_d = rbi_axis_clip_stopper_d + 2*clearance;
    _rbi_axis_d = rbi_axis_d + 2*clearance;
    _bc_rbsi_h = bc_rbsi_h + clearance;
    
    
    difference()
    {
        roller_blind_interface(_h, interface_offset=10);

        difference()
        {
            // main shape
            cut([0,rbi_wedge_angle])
                cylinderpp(d=rbi_d-2*rbi_wt, h=_rbi_pieve_inner_h, align="z");
            
            translate([0,0,_rbi_spring_h])
                tubepp(d=_rbi_axis_d, D=_bc_rbi_d-2*clearance, h=_h, align="z");
    
        }

        // inner cut for the spring meachanism piece
        cylinderpp(d=_bc_rbi_d, h=_rbi_spring_h);

        // inner slide-in cut for the axis
        cylinderpp(d=_rbi_axis_d, h=_bc_rbsi_h, align="z");

        // hole for the axis (shown in the are of the stopper)
        cylinderpp(d=_rbi_axis_clip_stopper_d,h=3*_h, align="");

        // axis hole above the stopper
        translate([0,0,rbi_axis_clip_stopper_h+_bc_rbsi_h])
            cylinderpp(d=rbi_d-2*rbi_wt, h=_h, align="z");

    }
}


$fn=$preview ? 36 : 120;
roller_blind_interface_piece();


//difference()
//{
//    roller_blind_interface(20);
//
//    cylinderpp(d=rbi_d-5,h=3*20, align="");
//
//}