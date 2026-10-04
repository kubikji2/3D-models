// essentials
use<../../../../../lib/solidpp/solidpp.scad>
use<../../../../../lib/deez-nuts/deez-nuts.scad>

include<smd-step-down-parameters.scad>

module smd_step_down_slot(
    wt=1.6,
    clearance=0.1,
    clip_space=1)
{

    _w = smdsd_w + 2*wt;
    _h = smdsd_h + wt;
    _t = smdsd_t + 2*wt;

    __w = smdsd_w + 2*clearance;
    __h = smdsd_h + 2*clearance;
    __t = smdsd_t + 2*clearance;

    %translate([0,0,wt])
        cubepp([smdsd_w,smdsd_t,smdsd_h],align="z");

    _wt = sqrt(2)*wt;

    difference()
    {

        union()
        {
            cubepp([_w,_t,_h],align="z");
            
            translate([0,_t/2,_h])
            hull()
            {   
                _cw = __w-2*wt-2*clip_space; 
                cubepp([_cw,wt+smdsd_t,wt], align="Yz");                
                cubepp([_cw,wt,wt+wt], align="Yz");
            }
        }
        // pcb cut
        translate([0,0,wt-clearance])
            cubepp([__w,__t,__h],align="z");

        // components top cut
        translate([0,-_t/2+wt,wt-clearance+smdsd_slot_h])
            cubepp([__w,_t,__h],align="Yz");

        // component bottom cut
        translate([-__w/2+smdsd_slot_w_left,0,wt-clearance])
            cubepp([__w-smdsd_slot_w_left-smdsd_slot_w_right,_t,__h],align="xYz");

        mirrorpp([1,0,0], true)
            translate([__w/2-wt,0,_h/2])
                cubepp(
                    [clip_space, _t, _h],
                    align="Xyz",
                    mod_list=[round_edges(d=clip_space,axes="xz")]);
    }


}


$fn=$preview ? 36 : 72;

cubepp([22,20,1.6],align="z");
smd_step_down_slot();