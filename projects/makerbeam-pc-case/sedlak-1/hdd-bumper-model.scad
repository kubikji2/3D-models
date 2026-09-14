use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

include<hdd-constants.scad>

include<hdd-bumper-parameters.scad>

use<hdd-models.scad>

module hdd_bumper(width=HDD_Z, clearance=hddb_clearance)
{

    _x = width+2*hddb_wt;
    _y = HDD_Y+2*hddb_wt;
    _z = hddb_wt+hddb_height;

    difference()
    {
        cubepp([_x, _y, _z], mod_list = [round_edges(r=hddb_rounding, axes="xyz")]);

        // cut for the hdd
        translate([hddb_wt-hddb_clearance,
                    hddb_wt-hddb_clearance,
                    hddb_wt-hddb_clearance])
            cubepp([    width+2*hddb_clearance,
                        HDD_Y+2*hddb_clearance,
                        hddb_height+2*hddb_clearance], align="xyz");

        // mount holes
        translate([0,0,HDD_X/2+hddb_wt])
        rotate([-90,0,0])
        translate([hddb_wt,0,hddb_wt])
        #replicate_hdd_mountpoint()
            //coordinate_frame()
                translate([0,0,hddb_bolt_offset])
                    bolt_hole(  standard=hddb_bolt_standard,
                                descriptor=hddb_bolt_descriptor,
                                clearance=hddb_bolt_clearance,
                                align="m",
                                hh_off=hddb_wt);

        // remove material
        _rm_x = _x - 4* hddb_wt;
        translate([2*hddb_wt,hddb_wt,0])
        {
            // BEGIN -> HOLE 1
            translate([0,hddb_wt,0])
                cubepp([_rm_x, HDD_MP_S1_X-2*hddb_wt, 3*hddb_wt],
                        align="xy",
                        mod_list=[round_edges(r=hddb_rounding, axes="xy")]);
            // HOLE 1 -> 2
            translate([0,HDD_MP_S1_X+hddb_wt,0])
                cubepp([_rm_x, HDD_MP_S2_X-HDD_MP_S1_X-2*hddb_wt, 3*hddb_wt],
                        align="xy",
                        mod_list=[round_edges(r=hddb_rounding, axes="xy")]);
            // HOLE 2 -> 3
            translate([0,HDD_MP_S2_X+hddb_wt,0])
                cubepp([_rm_x, HDD_MP_S3_X-HDD_MP_S2_X-2*hddb_wt, 3*hddb_wt],
                        align="xy",
                        mod_list=[round_edges(r=hddb_rounding, axes="xy")]);
            // HOLE 3 -> END
            translate([0,HDD_MP_S3_X+hddb_wt,0])
                cubepp([_rm_x, HDD_Y-HDD_MP_S3_X-2*hddb_wt, 3*hddb_wt],
                        align="xy",
                        mod_list=[round_edges(r=hddb_rounding, axes="xy")]);
        }

    }

}

$fn = $preview ? 36 : 120;
hdd_bumper();