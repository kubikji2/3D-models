use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

include<charger-dimensions.scad>
include<../bed-planks-dimensions.scad>

module flexing_horizontal_plank_interface(  wt,
                                    flexible_stopper_length,
                                    fixed_stopper_length)
{
    _H = AG_Y + 2*wt;
    // plank
    %cubepp([VERTICAL_PLANK_W, VERTICAL_PLANK_T, _H], align="yz");

    // 1. plank interface flexible
    pairwise_hull()
    {
        // fixed stopper
        translate([-VERTICAL_PLANK_W/2+fixed_stopper_length-wt,VERTICAL_PLANK_T-1,0])
            cylinderpp(d=wt, h=_H,align="Xyz");
        // left upper
        translate([-VERTICAL_PLANK_W/2,VERTICAL_PLANK_T,0])
            cylinderpp(d=wt, h=_H,align="Xyz");
        
        // left
        translate([-VERTICAL_PLANK_W/2,0,0])
            cylinderpp(d=wt, h=_H,align="XYz");
        // right
        translate([VERTICAL_PLANK_W/2,0,0])
            cylinderpp(d=wt, h=_H,align="xYz");

        // right upper
        translate([VERTICAL_PLANK_W/2,VERTICAL_PLANK_T,0])
            cylinderpp(d=wt, h=_H,align="xyz");
        // flexible stopper
        translate([VERTICAL_PLANK_W/2-flexible_stopper_length,VERTICAL_PLANK_T-0.25,0])
            cylinderpp(d=wt, h=_H,align="xyz");

    }
}

module plank_interface_fastener_interface(  wt=2,
                                            thickness=5,
                                            bolt_l=10, 
                                            fasterner_d=3,
                                            bolt_standard="DIN84A",
                                            nut_standard="DIN934")
{
    _h = bolt_l+wt;
    _t = thickness;
    difference()
    {
        intersection()
        {
            translate([0,0,-_t])
                cubepp([2*_t,2*_h,3*_t], align="z", mod_list=[bevel_edges(_t, axes="xz")]);
            cubepp([_t,_h,2*_t], align="x");
        }

        translate([_t/2,_h/2,_t/2])
            rotate([90,0,0])
            {
                nut_hole(  d=fasterner_d,
                            standard=nut_standard);
                bolt_hole(  descriptor=str("M", fasterner_d, "x", bolt_l),
                            standard=bolt_standard,
                            hh_off=bolt_l);
            }
        
    }

}

module horizontal_plank_interface(wt)
{   
    _H = AG_Y + 2*wt;
    //translate([0,wt,0])
    //    cubepp([VERTICAL_PLANK_W, VERTICAL_PLANK_T, _H], align="yz");
    
    difference()
    {
        union()
        {
            // main shape
            cubepp([VERTICAL_PLANK_W+2*wt,
                    VERTICAL_PLANK_T+2*wt,
                    _H],
                    align="yz",
                    mod_list=[bevel_edges(wt,axes="xy")]);
            // interface
            _hi = 7;
            translate([0,VERTICAL_PLANK_T/2+wt,_H/2])
            mirrorpp([0,0,1], true)
                mirrorpp([1,0,0], true)
                    translate([VERTICAL_PLANK_W/2+wt,0,_H/2-_hi])
                        plank_interface_fastener_interface(wt=wt, thickness=_hi);
        }
        // inner cut
        translate([0,wt,0])
            cubepp([VERTICAL_PLANK_W,VERTICAL_PLANK_T, 3*_H], align="y");
        
        // horizontal cut
        translate([0,(VERTICAL_PLANK_T+2*wt)/2,0])
            cubepp([2*VERTICAL_PLANK_W,0.65,3*_H], align="");
    }

}

module charger_holder(wt=3)
{
    _h = AG_Y;
    _H = _h + 2*wt;

    //%translate([0,wt,wt])
    //    cubepp([AG_X,AG_Z,AG_Y], align="Yz");

    difference()
    {
        // main shape
        translate([0,wt,0])
            cubepp( [AG_X+2*wt,AG_Z+wt,_H],
                    align="Yz",
                    mod_list=[bevel_edges(wt,axes="xy")]);
        // inner hole
        translate([0,wt,wt])
            cubepp( [AG_X,AG_Z,_h],
                    align="Yz");
        // port access
        translate([0,0,0])
            cubepp( [AG_X-2*AG_OFF, AG_Z-wt, 3*_H],
                    align="Y");
        // front port hole
        translate([0,0,_H-wt])
            cubepp( [AG_X-2*AG_OFF+2*wt, AG_Z-wt, 3*wt],
                    align="Yz",
                    mod_list=[bevel_edges(wt, axes="xz")]);
        
        // back port hole
        translate([0,0,wt])
            cubepp( [AG_X-2*AG_OFF+2*wt, AG_Z-wt, 3*wt],
                    align="YZ",
                    mod_list=[bevel_edges(wt, axes="xz")]);
        
        // bottom cooling hole 
        translate([0,-AG_Z,_H/2])
            cubepp( [AG_X-2*AG_OFF, 3*wt, AG_Y-2*wt],
                    align="",
                    mod_list=[bevel_edges(AG_OFF, axes="xz")]);   
    }
}



module bed_charger_holder(wt = 3)
{

    difference()
    {
        union()
        {
            // 1. plank interface
            //flexing_horizontal_plank_interface(wt=wt, flexible_stopper_length=5, fixed_stopper_length=20);
            horizontal_plank_interface(wt=wt);

            // 2. charger holder
            charger_holder(wt=wt);
    
        }

        // insertion hole
        translate([0,wt,wt])
            cubepp([AG_X, AG_Z, AG_Y], align="Yz");
    }
    

}

$fs = $preview ? 0.25 : 0.1;
$fa = $preview ? 10 : 5;

bed_charger_holder();