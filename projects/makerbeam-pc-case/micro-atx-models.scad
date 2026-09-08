include<micro-atx-parameters.scad>

// master requirements
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>


module uatx_replicate_to_mount_points(
    b_hole=true,
    c_hole=true,
    f_hole=true,
    h_hole=true,
    j_hole=true,
    l_hole=true,
    m_hole=true,
    r_hole=true,
    s_hole=true)
{

    __has_hole = [  b_hole,
                    c_hole,
                    f_hole,
                    h_hole,
                    j_hole,
                    l_hole,
                    m_hole,
                    r_hole,
                    s_hole];
    
    __hole_positions = [    uatx_b_hole_pos,
                            uatx_c_hole_pos,
                            uatx_f_hole_pos,
                            uatx_h_hole_pos,
                            uatx_j_hole_pos,
                            uatx_l_hole_pos,
                            uatx_m_hole_pos,
                            uatx_r_hole_pos,
                            uatx_s_hole_pos];


    for (idx=[0:len(__has_hole)-1])
    {
        if (__has_hole[idx])
            translate([__hole_positions[idx].x,__hole_positions[idx].y,0])
                children();
    }
}


module uatx_mountpoint(h, bolt_l, d = 10, bolt_d = 3, transition = undef, align_top=true)
{
    // asserts
    assert(h >= uatx_mountpoint_h_min, str("'h' must be grater or equal to ", uatx_mountpoint_h_min));
    assert(d <= uatx_mountpoint_d_max, str("'d' must smaller or equal to ", uatx_mountpoint_d_max));

    _wt = (d - bolt_d)/2;

    _transition = is_undef(transition) ? _wt  : transition;

    difference()
    {
        union()
        {
            cylinderpp(d=d, h=h, align = align_top ? "Z" : "z");

            translate(align_top ? [0,0,-h] :[0,0,0])
                cylinderpp(d=d+2*_transition, h=_transition, align="z");
        }

        // hole
        uatx_mountpoint_hole(h=h, bolt_l=bolt_l, align_top=align_top);

        // donut cut
        translate(align_top ? [0,0,-(h-_transition)] :[0,0,_transition])
            toruspp(d=d, D=d+4*_transition, align="");
    }
}

module uatx_mountpoint_hole(h,
    bolt_l,
    bolt_d = 3,
    bolt_clearance = 0.2,
    heat_insert_d = 4.5,
    heat_insert_d_shrink = 0.3,
    heat_insert_d_h = 8,
    align_top=true)
{

    // offset to get desired align    
    _z_off = align_top ? -bolt_l : h-bolt_l;

    translate([0,0,_z_off])
    {
        cylinderpp(d=bolt_d+2*bolt_clearance, h=bolt_l+2*bolt_clearance, align="z");

        //_z_off = 0;
        translate([0,0,bolt_l-heat_insert_d_h])
            cylinderpp(d=heat_insert_d-2*heat_insert_d_shrink,  h=heat_insert_d_h, align="z");
        translate([0,0,bolt_l])
            cylinderpp(d2=heat_insert_d+2*bolt_clearance,d1=heat_insert_d-2*heat_insert_d_shrink,h=2*(heat_insert_d_shrink+bolt_clearance), align="Z");
    }

}

module uatx_mockup(x, y, z=3, has_io_shield=true, io_shield_t=3)
{

    uatx_align_board_to_xyz(x,y)
    {
        uatx_align_to_board_b(x,y)
            cubepp([x,y,z], align="xyz");
        
        if (has_io_shield)
            translate([0,b_hole_top_edge_offset,0])
                uatx_io_shield_hole(t=io_shield_t);
    }
}


module uatx_io_shield_hole(t=10)
{
    translate([uatx_io_shield_from_b_x, 0, uatx_io_shield_from_top_z])
        cubepp([uatx_io_shield_x,t,uatx_io_shield_z], align="xyz");
}

module uatx_align_board_to_xyz(x,y)
{
    translate([b_hole_left_edge_offset,(y-b_hole_top_edge_offset),0])
        children();
}

module uatx_align_to_board_b(x,y)
{
    translate([-b_hole_left_edge_offset,-(y-b_hole_top_edge_offset),0])
        children();
}



//$fn = 36;
//micro_atx_mountpoint(h=8, bolt_l=10);
