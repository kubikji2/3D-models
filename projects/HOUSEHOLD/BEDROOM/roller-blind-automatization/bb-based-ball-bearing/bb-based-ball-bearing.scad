use<../../../../../lib/solidpp/solidpp.scad>


function get_bb_based_ball_bearing_gauge(bb_count, bb_gap=0.5, bb_diameter=6) = 
    bb_diameter/(sin(180/bb_count)) + bb_gap/(2*3.141592);

    

module bb_based_ball_bearing_hole(
    bb_count = 15,
    insertion_z_offset = 10,
    insertion_clearance = 0.2,
    bb_clearance = 0.2,
    bb_gap = 0.5,
    bb_diameter = 6,
)
{

    _bb_d = bb_diameter + 2*bb_clearance;

    // (x)    (x)
    //  |      |
    //  +------+
    // center to center distance
    bb_gauge = get_bb_based_ball_bearing_gauge(bb_count=bb_count, bb_gap=bb_gap, bb_diameter=bb_diameter);

    toruspp(D=bb_gauge+_bb_d, d=bb_gauge-_bb_d);

    // insertion
    translate([bb_gauge/2,0,0])
        cylinderpp(d=bb_diameter+2*insertion_clearance, h=insertion_z_offset);
    

}

