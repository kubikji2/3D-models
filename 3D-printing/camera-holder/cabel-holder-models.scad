use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<cabel-holder-parameters.scad>


module velcro_cabel_holder(
    wt = 2,
    velcro_width = 13,
    velcro_thickness = 1.5,
    velcro_wt = 1.5,
    velcro_interface_lenght = 5)
{

    _hd = get_screw_head_diameter(
            standard=cabel_holder_screw_standard,
            descriptor=cabel_holder_screw_descriptor);
    _y = max(2*wt + _hd,2*velcro_wt+velcro_width);
    _x = 2*velcro_interface_lenght + _hd + 2*wt;

    difference()
    {
        union()
        {
            cubepp( [_x,_y,cabel_holder_h],
                    align="z",
                    mod_list=[round_edges(r=wt, axes="xy")]);
            
            // vecro interface
            intersection()
            {
                _vx = 2*velcro_thickness+velcro_interface_lenght;
                _vz = velcro_thickness+velcro_wt;
                mirrorpp([1,0,0], true)
                    translate([_x/2-_vx,0,cabel_holder_h])
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
                cubepp( [_x,_y, cabel_holder_h+_vz],
                    align="z",
                    mod_list=[round_edges(r=wt, axes="xy")]);
            }
        
        }

        // screw hole
        translate([0,0,cabel_holder_h])
            screw_hole(
                standard=cabel_holder_screw_standard,
                descriptor=cabel_holder_screw_descriptor,
                align="t",
                hh_off=velcro_thickness+velcro_wt);
    }



}

$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;

velcro_cabel_holder();