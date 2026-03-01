use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<cable-holder-parameters.scad>


module velcro_cable_holder(
    wt = 2,
    velcro_width = 13,
    velcro_thickness = 1.5,
    velcro_wt = 1.5,
    velcro_interface_lenght = 5)
{

    _hd = get_screw_head_diameter(
            standard=cable_holder_screw_standard,
            descriptor=cable_holder_screw_descriptor);
    _y = max(2*wt + _hd,2*velcro_wt+velcro_width);
    _x = 2*velcro_interface_lenght + _hd + 2*wt;

    difference()
    {
        union()
        {
            cubepp( [_x,_y,cable_holder_h],
                    align="z",
                    mod_list=[round_edges(r=wt, axes="xy")]);
            
            // vecro interface
            intersection()
            {
                _vx = 2*velcro_thickness+velcro_interface_lenght;
                _vz = velcro_thickness+velcro_wt;
                mirrorpp([1,0,0], true)
                    translate([_x/2-_vx,0,cable_holder_h])
                    {
                        
                        //coordinate_frame();
                        difference()
                        {

                            
                            union()
                            {
                                cubepp([_vx,
                                        2*velcro_wt+velcro_width,
                                        _vz], align="xz",
                                        mod_list=[round_edges(r=velcro_wt, axes="yz")]);
                                cubepp([_vx,
                                        2*velcro_wt+velcro_width,
                                        velcro_thickness], align="xz");
                            
                            }
                            // hole for the velcro  
                            //coordinate_frame()
                            cubepp([_vx, velcro_width, velcro_thickness], align="xz");

                            // smooth transition (fillets)
                            translate([_vx/2,0,0])
                                mirrorpp([1,0,0], true)
                                    translate([_vx/2,0,0])
                                    {
                                        cylinderpp(r=velcro_thickness, h=2*_y, align="z", zet="y");
                                        translate([0,0,velcro_thickness])
                                            cubepp([2*velcro_thickness, 2*_y, _vz], align="z");
                                    }
                        }
                    }
                // make sure that velcro interfece does not go outside of bounding volume
                cubepp( [_x,_y, cable_holder_h+_vz],
                    align="z",
                    mod_list=[round_edges(r=wt, axes="xy")]);
            }
        
        }

        // screw hole
        translate([0,0,cable_holder_h])
            screw_hole(
                standard=cable_holder_screw_standard,
                descriptor=cable_holder_screw_descriptor,
                align="t",
                hh_off=velcro_thickness+velcro_wt);
    }



}

module hook_cable_holder(wt=2, cable_diameter=5, cable_wt=2, cable_hook_off=2)
{

    _hd = get_screw_head_diameter(
            standard=cable_holder_screw_standard,
            descriptor=cable_holder_screw_descriptor);
    _y = 2*wt + _hd;
    _x = _hd + 4*cable_wt + 2*cable_diameter;

    difference()
    {
        cubepp( [_x,_y,cable_holder_h],
                align="z",
                mod_list=[round_edges(r=wt,axes="xy")]);
        
        // screw hole
        translate([0,0,cable_holder_h])
            screw_hole(
                standard=cable_holder_screw_standard,
                descriptor=cable_holder_screw_descriptor,
                align="t");
    }

    mirrorpp([1,0,0], true)
        translate([_hd/2+0.2,0,cable_holder_h])
        {
            // shaft
            cubepp([cable_wt,_y,cable_diameter+cable_hook_off], align="xz");
            
            // hook
            translate([0,0,cable_diameter+cable_hook_off])
            difference()
            {
                tubepp(d=cable_diameter, t=cable_wt, h=_y, zet="y", align="x");
                translate([cable_wt, 0,0])
                    cubepp([cable_diameter+2*cable_wt, 2*_y, cable_diameter+cable_hook_off], align="xZ");
            } 
    
            // hook offset
            translate([cable_diameter+cable_wt,0,cable_diameter+cable_hook_off])
                cubepp([cable_wt, _y, cable_hook_off], align="xZ");
            
        }
    


}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

hook_cable_holder();