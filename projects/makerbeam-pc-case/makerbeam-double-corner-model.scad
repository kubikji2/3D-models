// master requirements
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// makerbeam model and hole
use<makerbeam-model.scad>

// makerbeam dimensions
include<makerbeam-constants.scad>

// this module parameteres
include<makerbeam-corner-parameters.scad>


module makerbeam_double_corner(
    clearance=0.1,
    bolt_clearance=0.2
    )
{
    // core dimensions
    _cz = 2*mbc_wt+2*mbc_overlap+mb1010_a;
    _ca = 2*mbc_wt + mb1010_a;

    _off = mbc_wt+mb1010_a/2;

    // horizonal params
    _ha = mbc_wt + mb1010_a;
    _hz = 2*mbc_wt + mb1010_a;

    render()    
    difference()
    {
        // vertical hole, x and y horizontal holes
        makerbeam_interface_hole(
            length=2*_cz, 
            clearance=clearance,
            has_inner_interface=false,
            align="")
            //translate([0,0,0])
            makerbeam_interface_hole(
                length=2*mbc_overlap,
                tf=[_off,0,0],
                clearance=clearance,
                align="x", zet="x",
                has_inner_interface=false)
                makerbeam_interface_hole(
                    length=2*mbc_overlap,
                    tf=[0,_off,0],
                    clearance=clearance,
                    align="y", zet="y",
                    has_inner_interface=false)
                    union()
                    {
                        // core
                        cubepp( [_ca,_ca,_cz],
                                align="",
                                mod_list=[bevel_edges(mbc_wt)]);
                        // x-axis
                        translate([0,-mb1010_a/2-mbc_wt,0])
                            cubepp([mb1010_a/2+_ha,_ca, _hz],
                                    align="xy",
                                    mod_list=[bevel_edges(mbc_wt)]);
                        // y-axis
                        translate([-mb1010_a/2-mbc_wt,0,0])
                            cubepp([_ca, mb1010_a/2+_ha, _hz],
                                    align="xy",
                                    mod_list=[bevel_edges(mbc_wt)]);
                        // xz-plane reinforcement
                        mirrorpp([-1,1,0],true)
                        difference()
                        {
                            //%hull()
                            //{
                            //    translate([-_ca/2,-_ca/2,0])
                            //        cubepp( [_ca,2*mbc_wt,_cz],
                            //                align="xy",
                            //                mod_list=[bevel_edges(mbc_wt, axes="xyz")]);
                            //    translate([_ca/2+mbc_overlap,-_ca/2,0])
                            //        cubepp( [2*mbc_wt,2*mbc_wt,_hz],
                            //                align="Xy",
                            //                mod_list=[bevel_edges(mbc_wt, axes="xyz")]);
                            //}

                            hull()
                            {
                                translate([-_ca/2,-_ca/2,0])
                                    cubepp( [_ca-mbc_wt,2*mbc_wt,_cz],
                                            align="xy");
                                translate([_ca/2+mbc_overlap,-_ca/2,0])
                                    cubepp( [2*mbc_wt,2*mbc_wt,_hz],
                                            align="Xy",
                                            mod_list=[bevel_edges(mbc_wt, axes="xz")]);
                            }

                            // cut inner hole
                            translate([-mb1010_a/2,-mb1010_a/2,0])
                                cubepp([_ca+mbc_overlap,_ca+mbc_overlap,_cz], align="xy");
                            
                            // cut edge
                            translate([-mb1010_a/2,-_ca/2,0])
                                rotate([0,0,45])
                                    cubepp([mb1010_a,mb1010_a,_cz], align="X")
                                        coordinate_frame();
                        }

                    }
        
        // case inner hole
        translate([mb1010_a/2,mb1010_a/2,0])
            cubepp( [_ca,_ca,_cz],
                    align="xy",
                    mod_list=[bevel_edges(mbc_wt)]);
        
        // case polishing inner hole, i.e. removing the floating internal interface
        translate([mb1010_iw/2,mb1010_iw/2,0])
            cubepp( [mbc_overlap+2*mbc_wt+4*mb1010_id,mbc_overlap+2*mbc_wt+4*mb1010_id,mb1010_a],
                    align="xy",
                    mod_list=[bevel_edges(mbc_wt+2*mb1010_id, axes="xy")]);
        

        // x-axis countersing bolt hole
        translate([mb1010_a/2,0,0])
            rotate([0,-90,0])
                bolt_hole(  standard=mbc_horizontal_bolt_standard,
                            descriptor=mbc_bolt_descriptor,
                            align="t",
                            clearance=bolt_clearance,
                            hh_off=2*mb1010_a);


        // y-axis countersing bolt hole
        translate([0,mb1010_a/2,0])
            rotate([90,0,0])
                bolt_hole(  standard=mbc_horizontal_bolt_standard,
                            descriptor=mbc_bolt_descriptor,
                            align="t",
                            clearance=bolt_clearance,
                            hh_off=2*mb1010_a);
        
        // removing vertical makerbeam inner interface
        _mii = mb1010_a/2 + mb1010_iw/2+clearance;
        translate([-mb1010_iw/2,-mb1010_iw/2,0])
            cubepp([_mii, _mii, 2*_cz], align="xy");
        
        // holes for the bolt and nuts
        mirrorpp([-1,1,0], true)
            mirrorpp([0,0,1], true)
                translate([mb1010_a/2,0,mb1010_a/2+mbc_overlap/2])
                {
                    // bolt shaft
                    cylinderpp( d=mb1010_bolt_d+2*bolt_clearance,
                                h=mb1010_bolt_l,
                                zet="x",
                                align="x");
                    // nut hole
                    _nd = 2*bolt_clearance+get_nut_diameter(d=mb1010_bolt_d,standard=mbc_anchoring_nut_standard);
                    _nh = 2*bolt_clearance+get_nut_height(d=mb1010_bolt_d,standard=mbc_anchoring_nut_standard);
                    translate([mb1010_bolt_l+bolt_clearance,0,0])
                        cylinderpp(d=_nd,h=_nh,align="X",zet="x");

                    // bolt driver hole
                    cylinderpp(d=2*bolt_clearance+mb1010_bolt_driver,h=2*mb1010_a,zet="x", align="X");

                }

    }


}


use<makerbeam-corner-model.scad>

$fn = $preview ? 36 : 120;
//%makerbeam_corner();

makerbeam_double_corner();