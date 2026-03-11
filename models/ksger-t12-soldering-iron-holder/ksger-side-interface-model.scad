use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<ksger-side-interface-parameters.scad>


module t12_back_bolt_hole_pair()
{
    _x_off = (t12_x-t12_mnt_gauge_x)/2;
    translate([_x_off,0,t12_z/2])
        mirrorpp([0,0,1], true)
        translate([0,0,-t12_mnt_gauge_z/2])
            rotate([90,0,0])
                bolt_hole(  descriptor=t12_si_mnt_bolt_descriptor,
                            standard=t12_si_mnt_bolt_standard,
                            align="m");
}

module t12_slide_interface_end_plate(has_fill=false)
{
    _x_off = (t12_x-t12_mnt_gauge_x)/2;
    _z_off = (t12_z-t12_mnt_gauge_z)/2;
    _hh = get_bolt_head_diameter(descriptor=t12_si_mnt_bolt_descriptor,
                            standard=t12_si_mnt_bolt_standard);
    translate([0,0,t12_z/2])
        union()
        {
            if(has_fill)
            {
                translate([0,0,-t12_mnt_gauge_z/2])
                   cubepp([_x_off+(_hh)/2,t12_si_bt,t12_mnt_gauge_z]);
            }

            _inner_z = _z_off;//_hh/2;
            mirrorpp([0,0,1], true)
                translate([0,0,t12_mnt_gauge_z/2])
                    intersection()
                    {
                        translate([-_hh/2,0,-_inner_z])
                            cubepp([_hh+_x_off,t12_si_bt,_inner_z+_z_off],
                                    align="xyz",
                                    mod_list=[round_edges(r=_hh/2, axes="xz")]);
                        translate([0,0,_z_off])
                            cubepp([_hh/2 + _x_off, 3*t12_si_bt, _inner_z + _z_off], align="xZ");
                        
                    }
        }
}


module t12_side_interface(clearance=0.2)
{

    //_ends_wt = 0;
    
    _y = t12_y + 2*clearance + 2*t12_si_bt; 

    // top
    difference()
    {
        t12_slide_interface_end_plate(has_fill=true);
        t12_back_bolt_hole_pair();
    }

    // middle
    intersection()
    {
        translate([t12_si_wt,0,0])
            cubepp([2*t12_si_wt,_y,t12_z],
                    align="Xyz",
                    mod_list=[round_edges(r=t12_si_wt, axes="xy")]);
        
        cubepp([2*t12_si_wt,_y,t12_z],
                align="Xyz");
    }
    
    // back
    translate([0,_y,t12_z])
    rotate([180,0,0])
    difference()
    {
        t12_slide_interface_end_plate(has_fill=false);
        t12_back_bolt_hole_pair();
    }

}


//$fa = $preview ? 10 : 5;
//$fs = $preview ? 0.1: 0.05;
//t12_side_interface();