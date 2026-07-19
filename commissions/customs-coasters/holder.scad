include<../../lib/solidpp/solidpp.scad>


module holder(
    coaster_d=95,
    coaster_h=3,
    coaster_count=6,
    coaster_clearnace=1,
    bottom_extension=5,
    wt=3,
    bt=3)
{

    _D = 2*wt + 2*coaster_clearnace + coaster_d;
    _H = 2*wt + 2*coaster_clearnace + coaster_count*coaster_h;

    _d = _D - 2*wt;
    _h = _H - 2*wt;
    
    _dd = _d - 2*coaster_clearnace -2*wt;

    difference()
    {

        union()
        {
            translate([0,0,bt])
                cylinderpp(d=_D, h=_H, zet="x", align="z");
            cubepp([_H,_D,_D/2+bt], align="z");

            // bottom layer support
            cubepp( [_H+2*wt+2*bottom_extension,_D,bt],
                    align="z",
                    mod_list=[round_edges(r=wt)]);
            
            // bottom transitions
            mirrorpp([1,0,0], true)
                translate([_H/2,0,bt])
                    difference()
                    {
                        cubepp([wt,_D,wt],align="xz");
                        translate([wt,0,0])
                            cylinderpp(r=wt,h=2*_D, align="z", zet="y");
                    }

        }

        // cut off the top part
        translate([0,0,bt+_D/2])
            cubepp([2*_h,2*_D,_D], align="z");

        // cut off inner space
        translate([0,0,bt])
            cylinderpp(d=_d, h=_h, align="z", zet="x");

        // add bevels
        translate([0,0,bt+_D-_dd])
            cylinderpp(d=_dd, h=2*_H, align="z", zet="x");
    }

}

$fn=$preview ? 36 : 144;

holder();
