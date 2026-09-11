use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>


include<hdd-slot-parameters.scad>
include<hdd-constants.scad>


// makerbeam model and hole
use<../makerbeam-model.scad>

// makerbeam dimensions
include<../makerbeam-constants.scad>

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

module hdd_slot(
    bolt_clearance = 0.2,
    length = 200,
    corners_wt = 5
)
{

    _x = hdds_inner_x+2*hdds_wt;
    _y = length+2*corners_wt+2*mb1010_a;
    _z = hdds_inner_z+2*hdds_bt;

    // bottom plate
    translate([0,0,-hdds_inner_z/2])
        hdd_slot_plates(_x,_y,bolt_clearance,is_top=false);
    
    // top plate
    translate([0,0,hdds_inner_z/2])
        hdd_slot_plates(_x,_y,bolt_clearance,is_top=true);

    // hdd cage
    _y_cage_off = -20;
    _y_cage = hdds_inner_y+hdds_wt;
    translate([0,_y_cage_off,0])
        difference()
        {

            // hdd shape
            %cubepp([hdds_inner_x,hdds_inner_y,hdds_inner_z], align="");

            // mcage shape
            cubepp([_x,_y_cage,_z], align="");

            // inner hole
            translate([0,-hdds_wt,0])
                cubepp([hdds_inner_x,_y_cage,hdds_inner_z], align="");

            // front-back hole
            translate([0,hdds_wt,0])
                cubepp([hdds_inner_x,_y_cage,hdds_inner_z-2*hdds_bt],
                        align="", mod_list=[bevel_edges(hdds_wt,axes="xz")]);
            
            // left-right-hole
            mirrorpp([0,1,0], true)
                translate([0,hdds_bt/2,0])
                    cubepp([2*hdds_inner_x,(_y_cage-2*hdds_bt-hdds_bt)/2,hdds_inner_z-2*hdds_bt],
                            align="y", mod_list=[bevel_edges(hdds_wt,axes="yz")]);
            

        }    

}

$fn = $preview ? 36 : 72;
hdd_slot();