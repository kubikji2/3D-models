// essentials
use<../../../../../lib/solidpp/solidpp.scad>
use<../../../../../lib/deez-nuts/deez-nuts.scad>

include<esp32-c6-parameters.scad>

module usb_c_hole(length,
clearance=0.2)
{

    translate([0,clearance,-clearance])
        cubepp([e32c6_usbc_w+2*clearance,
                e32c6_usbc_h+2*clearance,
                length+2*clearance],
                align="Yz",
                mod_list=[round_edges(d=e32c6_usbc_h, axes="xy")]);

}

module esp32_holder_usbc_hole(length, pcb_clearance=0.2)
{
    translate([0,-e32c6_t/2+pcb_clearance,0])
        usb_c_hole(length=length);
}

module esp32_holder(
    wt=1.6,
    clearance=0.1,
    clip_space=1)
{

    _w = e32c6_w + 2*wt;
    _h = e32c6_h + wt;
    _t = e32c6_t + 2*wt;

    __w = e32c6_w + 2*clearance;
    __h = e32c6_h + 2*clearance;
    __t = e32c6_t + 2*clearance;

    %translate([0,0,wt])
        cubepp([e32c6_w,e32c6_t,e32c6_h],align="z");

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
                cubepp([_cw,wt+e32c6_t,wt], align="Yz");                
                cubepp([_cw,wt,wt+wt], align="Yz");
            }
        }
        // pcb cut
        translate([0,0,wt-clearance])
            cubepp([__w,__t,__h],align="z");

        // components cut
        translate([0,-_t/2+wt,wt-clearance])
            cubepp([__w-2*e32c6_slide_w,_t,__h],align="Yz");

        // cut for the clip
        mirrorpp([1,0,0], true)
            translate([__w/2-wt,0,wt+_h/3])
                cubepp(
                    [clip_space, _t, _h],
                    align="Xyz",
                    mod_list=[round_edges(d=clip_space,axes="xz")]);

        // usb c hole
        esp32_holder_usbc_hole(length=wt, pcb_clearance=clearance);

        // battery contacts 
        translate([0,e32c6_t/2,wt+e32c6_battery_hole_h_off])
            cubepp([e32c6_battery_hole_w,2*wt,e32c6_battery_hole_h], align="yz");
    }


}


$fn=$preview ? 36 : 72;

difference()
{
    union()
    {
        cubepp([22,20,1.6],align="z");
        esp32_holder();
    }
    esp32_holder_usbc_hole(10);
}