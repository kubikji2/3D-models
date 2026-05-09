include<micro-atx-parameters.scad>


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

