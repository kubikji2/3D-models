use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>


include<hdd-slot-parameters.scad>
include<hdd-constants.scad>

// makerbeam model and hole
use<../makerbeam-model.scad>
// makerbeam dimensions
include<../makerbeam-constants.scad>
// corner parameters
include<../makerbeam-corner-parameters.scad>

module hdd_slot_plates(_x,_y, bolt_clearance, is_top=true, clearance=0.1)
{
    difference()
    {
        // main shape
        makerbeam_interface_hole(
            length=2*_x,
            tf=[0,-_y/2,is_top ? hdds_bt : -hdds_bt],
            clearance=clearance,
            align=str("y",is_top ? "z" : "Z"), zet="x",
            has_inner_interface=false)
            makerbeam_interface_hole(
                        length=2*_x,
                        tf=[0,_y/2,is_top ? hdds_bt : -hdds_bt],
                        clearance=clearance,
                        align=str("Y",is_top ? "z" : "Z"), zet="x",
                        has_inner_interface=false)
                union()
                {
                    cubepp([_x,_y,hdds_bt], align=is_top ? "z" : "Z");

                    mirrorpp([0,1,0], true)
                        translate([0,_y/2,0])
                            cubepp([_x,mb1010_a,mb1010_wa+hdds_bt], align=str("Y",is_top ? "z" : "Z"));
                }
        _mnt_x = is_top ? 0 : _x/2 - mb1010_a/2;
        _mnt_y = _y/2 - mb1010_a/2;

        _nh = 2*bolt_clearance+get_nut_height(d=mb1010_bolt_d,standard=hdds_anchoring_nut_standard);
        //_nd = 2*bolt_clearance+get_nut_diameter(d=mb1010_bolt_d,standard=hdds_anchoring_nut_standard);
        
        //mounting holes
        mirrorpp([0,1,0], true)
            mirrorpp([1,0,0], true)
                translate([_mnt_x,_mnt_y,0])
                {
                    cylinderpp(d=mb1010_bolt_d+2*bolt_clearance, h=3*hdds_bt, align="");
                    translate([0,0,is_top ? -bolt_clearance : bolt_clearance])
                        cylinderpp(d=8+2*clearance, h=_nh, align=is_top ? "z" : "Z");
                }
    }

}

module hdd_lower_plate(_x,_y, bolt_clearance, clearance=0.1)
{
    difference()
    {
        // main shape
        makerbeam_interface_hole(
            length=2*_x,
            tf=[0,-_y/2,0],
            clearance=clearance,
            align="YZ", zet="x",
            has_inner_interface=false)
            makerbeam_interface_hole(
                        length=2*_x,
                        tf=[0,_y/2, 0],
                        clearance=clearance,
                        align="yZ", zet="x",
                        has_inner_interface=false)
                union()
                {
                    cubepp([_x,_y,mb1010_a], align="Z");

                    mirrorpp([0,1,0], true)
                        translate([0,_y/2-hdds_bt,0])
                            cubepp([_x,hdds_bt+mb1010_wa,mb1010_a], align="yZ");
                }
        _mnt_x = _x/2 - mb1010_a/2;
        _mnt_y = _y/2;

        _nh = 2*bolt_clearance+get_nut_height(d=mb1010_bolt_d,standard=hdds_anchoring_nut_standard);
        _nd = 2*bolt_clearance+get_nut_diameter(d=mb1010_bolt_d,standard=hdds_anchoring_nut_standard);
        
        // mounting holes
        mirrorpp([0,1,0], true)
            mirrorpp([1,0,0], true)
                translate([_mnt_x,_mnt_y,-mb1010_a/2])
                rotate([90,0,0])
                {
                    // shaft hole
                    cylinderpp(d=mb1010_bolt_d+2*bolt_clearance, h=3*hdds_bt, align="");
                    
                    // nut hole
                    translate([0,0,mb1010_bolt_l-bolt_clearance-_nh])
                        cylinderpp(d=_nd+2*clearance, h=_nh+mb1010_bolt_l, align="z");
                    
                    // tightening hole
                    translate([0,0,mb1010_bolt_l-bolt_clearance-_nh])
                    difference()
                    {
                        _h = hdds_wrench_h+mb1010_bolt_l+hdds_wrench_clearance;
                        _d = hdds_wrench_d+hdds_wrench_clearance;
                        union()
                        {
                            cylinderpp(h=_h, d=_d);
                            rotate([0,0,-30])
                                cubepp([_d,_d,_h],align="Yz");
                            rotate([0,0,45])
                                cubepp([_d,_d,_h],align="Yz");
                            //cubepp([_d,_d,_h],align="xz");

                        }
                        //translate([0,_nd/2+clearance,0])
                        //    cubepp([2*_d, 2*_h, 2*_d], align="y");
                    }                  

                }
    }
}

module hdds_hinge(
    _x,
    _z,
    bolt_clearance,
    show_inner=true,
    show_outer=true)
{

    _W = _x/2 - 2*hdds_hinge_axis_clearance;
    _w = _x/4;
    _d = _z - 2*hdds_hinge_axis_clearance;


    difference()
    {
        union()
        {
            // middle section
            if(show_inner)
            {
                cubepp([_W,_d,_d], align="");
                // extension for better printing -- no idea why there is 0.3 mm
                cubepp([_W,_d+hdds_hinge_axis_clearance,_z/2+0.3], align="zY");
                
                translate([0,-hdds_hinge_axis_clearance,0])
                    cylinderpp(d=_d, h=_W, zet="x", align="Y");
            }

            // borders
            if(show_outer)
            mirrorpp([1,0,0], true)
            translate([_x/4,0,0])
            {
                translate([0,-hdds_hinge_axis_clearance,0])
                    cubepp([_w,_d,_d/2+hdds_hinge_axis_clearance], align="xYZ");
                translate([0,-hdds_hinge_axis_clearance,0])
                    cylinderpp(d=_d, h=_w, zet="x", align="xY");
            }
        }

        // axis hole
        _nh = get_nut_height(d=hdds_hinge_axis_d,
                            standard=hdds_hinge_axis_nut_standard);
        translate([-_nh/2,-_z/2,0])
        {
            translate([-hdds_hinge_axis_bolt_l/2,0,0])
            rotate([0,90,0])
            bolt_hole(  standard=hdds_hinge_axis_bolt_standard,
                        descriptor=hdds_hinge_axis_bolt_descriptor,
                        hh_off=hdds_hinge_axis_bolt_l,
                        clearance=bolt_clearance);

            translate([-hdds_hinge_axis_bolt_l/2,0,0])
            rotate([0,90,0])
                nut_hole(   d=hdds_hinge_axis_d,
                            standard=hdds_hinge_axis_nut_standard,
                            clearance=bolt_clearance,
                            h_off=hdds_hinge_axis_bolt_l);
            
        }
        
    }
    

}

module hdds_connector_pair(s_off, h_off, bolt_clearance)
{
    translate([0,0,-hdds_connectors_bolt_l/2])
    {
        nut_hole(   d=hdds_connectors_d,
                    standard=hdds_connectors_nut_standard,
                    clearance=bolt_clearance,
                    s_off=s_off);
        
        bolt_hole(  standard=hdds_connectors_bolt_standard,
                    descriptor=hdds_connectors_bolt_descriptor,
                    clearance=bolt_clearance,
                    hh_off = h_off);
        
        // hole for removing the nut
        _nh = get_nut_height( d=hdds_connectors_d,
                            standard=hdds_connectors_nut_standard);
        translate([0,0,_nh/2])
            cylinderpp(d=hdds_connectors_d,h=s_off,zet="x", align="X");

    }
}


module hdds_plate_connector_pair(s_off, h_off, bolt_clearance)
{
    
    bolt_hole(  standard=hdds_cut_plane_connectors_bolt_standard,
                descriptor=hdds_cut_plane_connectors_bolt_descriptor,
                clearance=bolt_clearance,
                hh_off = h_off);

    translate([0,0,hdds_cut_plane_connectors_bolt_l_off])
        nut_hole(   d=hdds_connectors_d,
                    standard=hdds_connectors_nut_standard,
                    clearance=bolt_clearance,
                    s_off=s_off);

}

module hdd_slot(
    bolt_clearance = 0.2,
    length = 200,
    //corners_wt = 3,
    is_support_blocker=false,
    show_gate=true,
    show_frame=true
)
{
    
    // define how much length is added by the corners
    corners_wt = mbc_wt;

    // y-gauge
    _yg = length+2*corners_wt;
    _x = hdds_inner_x+2*hdds_wt;
    _y = _yg+2*mb1010_a;
    _z = hdds_inner_z+2*hdds_bt;

    //%translate([0,0,hdds_bt])
    //    cubepp([hdds_inner_x,_y,hdds_total_z], align="");
    
    // space between aluminium extrusions
    //echo(_yg);
    //translate([0,0,-hdds_inner_z/2])
    //    %#cubepp([100, _yg, 10], align="Z");
    
    // hdd shape
    //cubepp([hdds_inner_x,hdds_inner_y,hdds_inner_z], align="");
    
    // top plate
    //translate([0,0,hdds_inner_z/2])
    //    hdd_slot_plates(_x,_y,bolt_clearance,is_top=true);


    _top_z = hdds_total_z-hdds_inner_z;

    // hdd cage
    _y_cage_off = (_yg-(hdds_inner_y+hdds_wt))/2-hdds_offset;
    _y_cage = hdds_inner_y+hdds_wt;

    // gate
    _gz = hdds_inner_z-hdds_sliding_clearance;
    _gfy = _yg - 2*hdds_offset-_y_cage; // flap y dimension

    difference()
    {
        if (!is_support_blocker)
        union()
        {   
            if (show_frame)
            {
                // bottom plate
                translate([0,0,-hdds_inner_z/2])
                    hdd_lower_plate(_x,length+2*corners_wt,bolt_clearance);

                // cage shape
                translate([0,_y_cage_off,0])
                    translate([0,0,hdds_bt/2])
                        cubepp([_x,_y_cage,hdds_total_z+hdds_bt], align="");
            }
            
            // gate
            translate([0,-_y_cage/2+_y_cage_off,hdds_inner_z/2 + _top_z/2])
                difference()
                {
                    union()
                    {
                        // hinge
                        hdds_hinge( _z=_top_z,
                                    _x=_x,
                                    bolt_clearance=bolt_clearance,
                                    show_inner=show_frame,
                                    show_outer=show_gate);

                        if (show_gate)
                        {
                            // gate
                            translate([0,-hdds_hinge_axis_clearance,-_top_z/2])
                                cubepp([_x,_top_z-2*hdds_hinge_axis_clearance,_gz], align="YZ");

                            // interface
                            translate([0,-hdds_hinge_axis_clearance,-hdds_inner_z-_top_z/2+hdds_hinge_axis_clearance])
                                cubepp([_x,_gfy,_top_z], align="zY", mod_list=[bevel_edges(hdds_wt+hddb_wt,axes="xy")]);
                        }
                    }

                    // left-right bevel
                    translate([0,-hdds_wt,-_top_z/2])
                        cubepp([2*_x,2*_gfy,_gz-hdds_bt],
                                align="YZ",
                                mod_list=[bevel_edges(_top_z-hdds_wt, axes="yz")]);

                    // front-back bevel
                    translate([-hddb_wt/2,hdds_wt,-_top_z/2-hdds_bt])
                        cubepp([hdds_inner_x-hddb_wt,2*(_top_z+_gfy),hdds_inner_z-2*hdds_bt],
                                align="Z", mod_list=[bevel_edges(hdds_wt,axes="xz")]);
                    
                }
            
        }


        // cage holes
        if (!is_support_blocker)
        translate([0,_y_cage_off,0])
        {
            // inner hole
            translate([0,-_y_cage/2,0])
                cubepp([hdds_inner_x,_y_cage-hdds_wt,hdds_inner_z], align="y");

            // front-back hole
            translate([0,hdds_wt,0])
                cubepp([hdds_inner_x,_y_cage,hdds_inner_z-4*hdds_bt],
                        align="", mod_list=[bevel_edges(hdds_wt,axes="xz")]);

            // left-right-hole
            mirrorpp([0,1,0], true)
                translate([0,hdds_bt/2+hddb_wt,0])
                    cubepp([2*hdds_inner_x,(_y_cage-2*hdds_bt-hdds_bt-4*hddb_wt)/2,hdds_inner_z-4*hdds_bt],
                            align="y", mod_list=[bevel_edges(hdds_wt,axes="yz")]);
        }


        // connection hole positioning
        _x_coff = hdds_inner_x/2 - hdds_bt; 
        _y_coff = hdds_inner_y/2 - hdds_bt;
        _y_connectors_off = _y_coff - 2*hdds_bt;

        // gate hole
        union()
        {
            translate([0,-_y_cage/2+_y_cage_off-_gfy/2,-hdds_inner_z/2+hdds_bt])
            {
                // mounting
                cylinderpp(d=hdds_connectors_d+2*bolt_clearance, h=2*(hdds_bt+mb1010_a), align="");
                
                // nut and nut removal hole
                translate([0,0,-hdds_bt-mb1010_a/2])
                {
                    // nut insertion hole
                    nut_hole(   d=hdds_connectors_d,
                                standard=hdds_connectors_nut_standard,
                                clearance=bolt_clearance,
                                s_off=_x,
                                align="m");
                    // adding hole to remove the nut if needed
                    cylinderpp(d=hdds_connectors_d,h=_x,zet="x", align="X");
                }
            }

            // connection hole
            translate([0,_y_cage_off,0])
            {
                // bottom connectors
                translate([0,0,-hdds_inner_z/2-mb1010_a])
                {
                    /*
                    translate([_x_coff,_y_coff,0])
                        hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);

                    translate([-_x_coff,-_y_coff,0])
                        rotate([0,0,180])
                            hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);
                    */
                    mirrorpp([0,1,0], true)
                        translate([0,_y_connectors_off,0])
                            hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);

                }

                // top connectors
                translate([0,0,-hdds_inner_z/2+hdds_total_z])
                {
                    intersection()
                    {
                        /*
                        translate([_x_coff,_y_coff,0])
                            hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);

                        translate([-_x_coff,-_y_coff,0])
                            rotate([0,0,180])
                                hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);
                        */

                        // nut and bolt hole
                        mirrorpp([0,1,0], true)
                            translate([0,_y_connectors_off,0])
                                hdds_connector_pair(s_off=_x, h_off=mb1010_a, bolt_clearance=bolt_clearance);


                        // cut cube to remove holes from the side panels
                        //coordinate_frame()
                        cubepp([hdds_inner_x, _y_cage, 3*_top_z], align="");
                    }
                }   
            }
        }

        // cut planes
        if (!show_gate)
        translate([0,_y_cage_off,0])
            mirrorpp([1,0,0], true)
                translate([hdds_inner_x/2,0,0])
                {
                    __y = _y_cage+2*hdds_wt+2*hdds_cut_plane_t;
                    __y_top = 2*_y_connectors_off-2*hdds_bt;

                    // middle cut
                    translate([0,-hdds_wt,-hdds_inner_z/2+_top_z/2])
                        cubepp([hdds_cut_plane_t, __y-2*hdds_wt, 2*hdds_inner_z], align="X");
                    
                    // side cuts
                    //mirrorpp([0,1,0],true)
                    
                    // front side cut
                    translate([0,-__y_top/2,0])
                        cubepp([hdds_cut_plane_t,(__y-__y_top)/2, 2*hdds_inner_z], align="XY");
                    
                    // back side cut
                    translate([0,__y_top/2,0])
                        cubepp([hdds_cut_plane_t,(__y-__y_top)/2-2*hdds_wt, 2*hdds_inner_z], align="Xy");
                    
                    // front side flip
                    translate([-hdds_cut_plane_t,-__y/2,0])
                        rotate([0,0,-hdds_cut_plane_angle])
                            cubepp([hdds_cut_plane_t, _y_cage, 2*hdds_total_z], align="Xy");

                    // back side flip
                    translate([-hdds_cut_plane_t,__y/2-2*hdds_wt-hdds_cut_plane_t,0])
                        rotate([0,0,90+hdds_cut_plane_angle])
                            cubepp([hdds_cut_plane_t, _y_cage, 2*hdds_total_z], align="XY");
                

                    // top flip
                    translate([0,0,hdds_inner_z/2+_top_z/2])
                    {
                        rotate([0,hdds_cut_plane_angle,0])
                        {
                            // wedge
                            cubepp([__y_top,__y_top,hdds_cut_plane_t],align="xZ");
                            // sides
                            mirrorpp([0,1,0], true)
                                translate([0,__y_top/2,-hdds_cut_plane_t])
                                    cubepp([__y_top,hdds_cut_plane_t,__y_top], align="xyz");
                        }
                        mirrorpp([0,1,0], true)
                            translate([0,__y_top/2,0])
                                cubepp([__y_top,hdds_cut_plane_t,__y_top], align="xyz");
                    }

                    // back flip
                    translate([0,_y_cage/2-hdds_wt,0])
                    {
                        difference()
                        {
                            union()
                            {
                                // top flap
                                translate([0,0,hdds_inner_z/2+_top_z/2])
                                    rotate([-hdds_cut_plane_angle,0])
                                        cubepp([2*hdds_inner_x, _y_cage, hdds_cut_plane_t], align="yz");

                                // bottom flap
                                translate([0,0,-hdds_inner_z/2-hdds_wt])
                                    rotate([hdds_cut_plane_angle,0])
                                        cubepp([2*hdds_inner_x, _y_cage, hdds_cut_plane_t], align="yZ");

                            }

                            // restriction the sides
                            translate([-hdds_cut_plane_t,0,0])
                                rotate([0,0,90+hdds_cut_plane_angle])
                                    cubepp([_y_cage, _y_cage, 2*hdds_total_z], align="XY");

                        }

                        // back cut
                        _z_bc =  hdds_inner_z+_top_z/2+hdds_wt;
                        _z_bc_off = _top_z/2-hdds_wt;
                        translate([0,0,_z_bc_off/2])
                            cubepp([hdds_inner_x,hdds_cut_plane_t,_z_bc], align="Xy");

                    }
                }

        // mount
        _84a_hh = get_bolt_head_height(standard=hdds_cut_plane_connectors_bolt_standard, descriptor=hdds_cut_plane_connectors_bolt_descriptor); 
        translate([0,_y_cage_off,0])
            mirrorpp([1,0,0], true)
            {
                // top holes
                mirrorpp([0,1,0], true)
                    translate([_x/2-hdds_cut_plane_connectors_bolt_l-_84a_hh,_y_coff,hdds_inner_z/2+_top_z/2])
                        rotate([180,0,0])
                            rotate([0,90,0]) 
                                hdds_plate_connector_pair(bolt_clearance=bolt_clearance, s_off=_top_z, h_off=hdds_wt);
                // bottom holes
                mirrorpp([0,1,0], true)
                    translate([_x/2-hdds_cut_plane_connectors_bolt_l-_84a_hh,_y_coff,-hdds_inner_z/2-mb1010_a/2])
                        rotate([0,90,0]) 
                            hdds_plate_connector_pair(bolt_clearance=bolt_clearance, s_off=_top_z, h_off=hdds_wt);
                
                // middle bottom holes
                translate([_x/2-hdds_cut_plane_connectors_bolt_l-_84a_hh,0,-hdds_inner_z/2-mb1010_a/2])
                    rotate([0,90,0]) 
                        hdds_plate_connector_pair(bolt_clearance=bolt_clearance, s_off=_top_z, h_off=hdds_wt);
            }
    }
    


}

$fn = $preview ? 36 : 72;
hdd_slot(show_frame=true, show_gate=false);
hdd_slot(show_frame=false, show_gate=true);
//hdd_slot(is_support_blocker=true, bolt_clearance=0.5);