use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

include<hdd-2p5-case-parameters.scad>

// HDD 2.5 inch parameters
include<../pc-parts/hdd-2p5inch-constants.scad>

// makerbeam and makerbeam corners
include<../makerbeam-corner-parameters.scad>
include<../makerbeam-constants.scad>
include<../makerbeam-model.scad>
use<../makerbeam-plate.scad>


module hdd_2p5_case_level_interface(
    _level_y,
    _level_wt,
    stack_clearance,
    h,
    _level_corner_cut)
{
    translate([0,_level_y/2,h-stack_clearance])
        intersection()
        {
            translate([0,0,-stack_clearance])
                cubepp([hc_x,_level_y,2*h], align="z", mod_list=[bevel_edges(_level_corner_cut, axes="xy")]);
            
            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                    translate([hc_x/2,_level_y/2,0])
                    {

                        cubepp([2*_level_wt-2*stack_clearance,_level_wt,h], align="",
                            mod_list=[bevel_edges(_level_wt/2,axes="yz")]);
                        rotate([0,0,90])
                            cubepp([2*_level_wt-2*stack_clearance,_level_wt,h], align="",
                                mod_list=[bevel_edges(_level_wt/2,axes="yz")]);
                    }
        }
}

module hdd_2p5_case_level_interface_hole(
    _level_y,
    _level_wt,
    stack_clearance,
    h)
{
    translate([0,_level_y/2,0])
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([hc_x/2,_level_y/2,0])
                {

                    cubepp([2*_level_wt,_level_wt+2*stack_clearance,h], align="",
                        mod_list=[bevel_edges(_level_wt/2,axes="yz")]);
                    rotate([0,0,90])
                        cubepp([2*_level_wt,_level_wt+2*stack_clearance,h], align="",
                            mod_list=[bevel_edges(_level_wt/2,axes="yz")]);
                }
}

module hdd_2p5_case_level(h,
    hdd_clearance = 0.2,
    hdd_bolt_offset = 0.5,
    bolt_clearance = 0.2,
    stack_clearance = 0.2,
    makerbeam_clearance=0.1,
    has_top=false,
    )
{
    // hdd dimensions
    _hdd_x = HDD_2p5_X+2*hdd_clearance;
    _hdd_y = HDD_2p5_Y+2*hdd_clearance;
    _hdd_z = h-hc_bt;

    _level_wt = (hc_x-HDD_2p5_X)/2;
    _level_y = HDD_2p5_Y+2*hdd_clearance+_level_wt;
    _level_corner_cut = mbc_wt+stack_clearance;

    // main shape
    difference()
    {
        cubepp( [hc_x,_level_y,h-hdd_clearance],
                align="yz",
                mod_list=[bevel_edges(_level_corner_cut, axes="xy")]);

        // cut for hdd
        translate([0,_level_wt,hc_bt])
            cubepp([_hdd_x,2*_hdd_y,h], align="yz");

        // bottom hole
        translate([0,_level_y/2,0])
            cubepp([_hdd_x-2*hc_border_off,
                    _hdd_y-2*hc_border_off,
                    3*h], align="",
                    mod_list=[round_edges(r=hc_border_r, axes="xy")]);

        // hdd holes
        translate([0,_level_wt,hc_bt+hdd_clearance+HDD_2p5_MP_S_Z])
            mirrorpp([1,0,0], true)
                translate([HDD_2p5_X/2-HDD_2p5_MP_MAX_DP+hdd_bolt_offset,0,0])
                {
                    // holes S1
                    translate([0,HDD_2p5_MP_S1_X,0])
                        rotate([0,90,0])
                            bolt_hole(  standard=hc_hdd_bolt_standard,
                                        descriptor=hc_hdd_bolt_descriptor,
                                        clearance=bolt_clearance,
                                        hh_off=HDD_2p5_X-_hdd_x+hc_hdd_bolt_l);
                    // holes S2
                    translate([0,HDD_2p5_MP_S2_X,0])
                        rotate([0,90,0])
                            bolt_hole(  standard=hc_hdd_bolt_standard,
                                        descriptor=hc_hdd_bolt_descriptor,
                                        clearance=bolt_clearance,
                                        hh_off=HDD_2p5_X-_hdd_x+hc_hdd_bolt_l);                    
            }
        
        // vent_holes
        _vent_h = h-2*hc_bt;
        _vent_compartment_l = (HDD_2p5_MP_S2_X-HDD_2p5_MP_S1_X)- 2*hc_vent_wt;
        _vent_l = (_vent_compartment_l-2*hc_vent_spacing)/3;
        _y_off = _level_wt+HDD_2p5_MP_S1_X+hc_vent_wt;
        translate([0,_y_off,hc_bt])
            for(i=[0:2])
                translate([0,i*(hc_vent_spacing+_vent_l)])
                    cubepp([2*hc_x,_vent_l,_vent_h],
                            align="yz",
                            mod_list=[round_edges(d=_vent_h, axes="yz")]);
        // manipulation cuts
        mirrorpp([1,0,0], true)
            translate([hc_x/2-(_level_wt-hc_vent_wt),_y_off,hc_bt])
                cubepp([2*_level_wt,_vent_compartment_l,3*h],
                        align="xy",
                        mod_list=[round_edges(d=_vent_h, axes="xy")]);

        // interface hole
        hdd_2p5_case_level_interface_hole(
            _level_y=_level_y,
            _level_wt=_level_wt,
            stack_clearance=stack_clearance,
            h=h);

    }

    // interface
    hdd_2p5_case_level_interface(
            _level_y=_level_y,
            _level_wt=_level_wt,
            stack_clearance=stack_clearance,
            h=h,
            _level_corner_cut=_level_corner_cut);


    if (has_top)
    translate([0,0,h+stack_clearance])
    {
        difference()
        {

            union()
            {
                translate([-mb1010_n/2,-mb1010_n,mb1010_a/2])
                    cubepp([hc_x+mb1010_n,_level_y+mb1010_n,mb1010_iw-2*makerbeam_clearance],
                            align="y",
                            mod_list=[bevel_edges(_level_corner_cut+2*mb1010_n, axes="xy")]);
                cubepp([hc_x,_level_y,mb1010_a],
                        align="yz",
                        mod_list=[bevel_edges(_level_corner_cut, axes="xy")]);

            }
            // inerface hole
            hdd_2p5_case_level_interface_hole(
                _level_y=_level_y,
                _level_wt=_level_wt,
                stack_clearance=stack_clearance,
                h=h);
            

            // mounts to the makerbeam
            translate([0,0,mb1010_a/2])
                rotate([180,0,0])
                    makerbeam_anchoring_interface();

            translate([-hc_x/2,_level_y/4,mb1010_a/2])
                rotate([180,0,-90])
                    makerbeam_anchoring_interface();

            translate([-hc_x/2,3*_level_y/4,mb1010_a/2])
                rotate([180,0,-90])
                    makerbeam_anchoring_interface();
            
            // top middle cut
            translate([0,_level_wt,0])
                cubepp([HDD_2p5_X,HDD_2p5_Y-_level_wt,3*h], align="y", mod_list=[round_edges(mb1010_a,axes="xy")]);


        }
    }
    
    
}


module hdd_2p5_case(hdds_count=4)
{

    //%cubepp([hc_x, hc_y, hc_z], align="zY");

    _level_h = hc_z/hdds_count;

    for(i=[0:hdds_count-1])
        translate([0,0,i*_level_h])
            hdd_2p5_case_level(_level_h, has_top=i==3);
    



}


$fn = $preview ? 36 : 72;
hdd_2p5_case();