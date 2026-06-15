use<../../../../lib/solidpp/solidpp.scad>


include<../ivar-dimensions.scad>

module power_adapter_holder(
    wt,
    adapter_x,
    adapter_y,
    adapter_z,
    adapter_stopper,
    adapter_clearance = 0.5,
    hook_clearance = 0.5,
    hook_width = 20
)
{
    

    _x = adapter_x + 2*adapter_clearance;
    _y = adapter_y + 2*adapter_clearance;
    _z = adapter_z + 2*adapter_clearance;

    _X = _x + 2*wt;
    _Y = _y + 2*wt;
    _Z = _z + 2*wt;

    __x = _x - 2*adapter_stopper;
    __y = _y - 2*adapter_stopper;
    __z = _z - 2*adapter_stopper;

    difference()
    {
        cubepp([_X, _Y, _Z],align="Yz");

        // top-down insert
        translate([0,-wt,wt])
            cubepp([_x, _y, _Z], align="Yz");
        
        // front hole
        //translate([0,-wt,wt+adapter_stopper])
        //    cubepp([__x, _Y, __z], align="Yz");
        
        // cable holes
        translate([0,-wt-adapter_stopper,wt+adapter_stopper])
            cubepp([2*_X,__y,_Z], align="Yz");        

    }

    // hook
    mirrorpp([1,0,0], true)
    translate([_X/2,0,_Z])
        pairwise_hull()
        {
            cylinderpp(d=wt, h=hook_width, zet="x", align="XYZ");
            translate([0,ivar_legs_reinforcement_t+hook_clearance,0])
                cylinderpp(d=wt, h=hook_width, zet="x", align="XyZ");
            translate([0,ivar_legs_reinforcement_t-hook_clearance,-ivar_legs_reinforcement_h-hook_clearance])
                cylinderpp(d=wt, h=hook_width, zet="x", align="XyZ");
            translate([0,ivar_legs_reinforcement_t-hook_clearance-wt,-ivar_legs_reinforcement_h-hook_clearance])
                cylinderpp(d=wt, h=hook_width, zet="x", align="XyZ");
        }

}