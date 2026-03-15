use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<work-area-parameters.scad>

include<sliding-rod-holder-parameters.scad>

module basic_work_area(clearance=0.2)
{

    _H = srh_bottom_interface_h;
    _A = srh_bottom_int_a-2*clearance;
    _a = _A - wa_rb_t;

    _h = (_H - wa_rb_n*wa_rb_t)/(wa_rb_n+1);

    cubepp([_A,_A,_h], align="z");

    for (i=[0:wa_rb_n-1])
    {
        _z = _h + i*(_h + wa_rb_t);
        translate([0,0,_z])
        {
            cubepp([_a,_a,wa_rb_t],align="z");
            translate([0,0,,wa_rb_t])
                cubepp([_A,_A,_h],align="z");

        }
    }

}

basic_work_area();
