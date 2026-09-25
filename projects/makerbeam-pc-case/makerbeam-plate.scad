// essentials
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// makerbeam dimensions
include<makerbeam-constants.scad>

// corners
include<makerbeam-corner-parameters.scad>

module makerbeam_anchoring_interface(
    anchoring_nut_standard="DIN934",
    bolt_clearance=0.2,
    wrench_d = 9,
    wrench_h = 3,
    wrench_clearance=0.5,
    min_angle = -45,
    max_angle = 45
)
{       
    _nh = 2*bolt_clearance+get_nut_height(d=mb1010_bolt_d,standard=anchoring_nut_standard);
    _nd = 2*bolt_clearance+get_nut_diameter(d=mb1010_bolt_d,standard=anchoring_nut_standard);
    
    // mounting holes
    //translate([0,0,-mb1010_a/2])
        rotate([90,0,0])
        {
            // shaft hole
            cylinderpp(d=mb1010_bolt_d+2*bolt_clearance, h=2*mb1010_bolt_l, align="");
            
            // nut hole
            translate([0,0,mb1010_bolt_l-bolt_clearance-_nh])
                cylinderpp(d=_nd+2*bolt_clearance, h=_nh+mb1010_bolt_l, align="z");
            
            // tightening hole
            translate([0,0,mb1010_bolt_l-bolt_clearance-_nh])
            difference()
            {
                _h = wrench_h+mb1010_bolt_l+wrench_clearance;
                _d = wrench_d+wrench_clearance;
                union()
                {
                    cylinderpp(h=_h, d=_d);
                    rotate([0,0,min_angle])
                        cubepp([_d,_d+tan(abs(min_angle))*_d,_h],align="Yz");
                    rotate([0,0,max_angle])
                        cubepp([_d,_d+tan(abs(max_angle))*_d,_h],align="Yz");
                    
                }
            }                  

        }

}

//makerbeam_anchoring_interface();

module makerbeam_plate(x, y, t=mb1010_a,
    corner_clearance=0.3,
    makerbeam_clearance=0.1,
    align="xyz",
    xX_holes_positions = undef,
    yY_holes_positions = undef,
)
{

    _b = mbc_wt + corner_clearance;
    
    // slot interface
    _x = x-2*makerbeam_clearance;
    _y = y-2*makerbeam_clearance;
    _z = mb1010_iw-2*makerbeam_clearance; 

        
    difference()
    {
        union()
        {
            cubepp([_x,_y,t], align=align, mod_list=[bevel_edges(bevel=_b, axes="xy")]);
            
            transform_to_spp(size=[_x,_y,t], align=align, pos="") 
                cubepp( [_x+2*mb1010_n,_y+2*mb1010_n,_z],
                        align="",
                        mod_list=[bevel_edges(bevel=_b+2*mb1010_n, axes="xy")]);
        }
        

        // xX holes
        transform_to_spp(size=[_x,_y,t], align=align, pos="x")
            mirrorpp([0,1,0],true)
                translate([0,-_y/2,0])
                    for(pos=xX_holes_positions)
                        translate([pos,0,0])
                            rotate([0,0,180])
                                makerbeam_anchoring_interface();
    
        // yY holes
        transform_to_spp(size=[_x,_y,t], align=align, pos="y")
            mirrorpp([1,0,0],true)
                translate([_x/2,0,0])
                    for(pos=yY_holes_positions)
                        translate([0,pos,0])
                            rotate([0,0,-90])
                                makerbeam_anchoring_interface();
                    
    
    }
    
}
 