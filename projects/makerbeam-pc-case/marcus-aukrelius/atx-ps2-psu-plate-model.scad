use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// makerbeam
use<../makerbeam-model.scad>
include<../makerbeam-constants.scad>
include<../makerbeam-corner-parameters.scad>

// makerbeam mountpoints
use<../makerbeam-plate.scad>

// psu dimensions
include<../pc-parts/atx-ps2-psu-specs.scad>

// parameter
include<atx-ps2-psu-plate-parameters.scad>

// case dimensions
include<marcus-aukrelius-parameters.scad>

module __atx_ps2_psu__replicate_at_mountpoints()
{
    translate([atx_ps2_psu_mnt_off,0,-atx_ps2_psu_mnt_off])
    {
        // top right
        children();
        // top left
        translate([atx_ps2_psu_mnt_gx,0,0])
            children();
        // bottom left
        translate([atx_ps2_psu_mnt_Gx,0,-atx_ps2_psu_mnt_gz])
            children();
        // bottom right
        translate([0,0,-atx_ps2_psu_mnt_Gz])
            children();
    }

}


module atx_ps2_psu_holder(
    makerbeam_clearance = 0.1,
    bolt_clearance = 0.2,
)
{
    available_height = ma_mbl_z+2*mbc_wt;
    _fz = available_height+2*mb1010_n;

    _x_alignement_offset = -(available_height-atx_ps2_psu_z)/2;
        
    difference()
    {
        // main frame including cuts
        makerbeam_interface_hole(2*atx_ps2_psu_x,
            tf=[0,0,available_height/2+mb1010_a/2],
            clearance=makerbeam_clearance, align="y", zet="x")
            makerbeam_interface_hole(2*atx_ps2_psu_x,
                tf=[0,0,-(available_height/2+mb1010_a/2)],
                clearance=makerbeam_clearance, align="y", zet="x")
                cubepp([atx_ps2_psu_x,mb1010_a,_fz], align="y");

        translate([0,0,_x_alignement_offset])
        difference()
        {
            _cx = atx_ps2_psu_x-2*sph_wt;
            //_cx = atx_ps2_psu_mnt_g;
            _cy = 2*mb1010_a + 2*sph_bevel;
            //_cz = available_height-2*sph_wt;
            _cz = atx_ps2_psu_mnt_Gz;
                        
            // middle cutout
            union()
            {
                cubepp([_cx,_cy,_cz], align="y", mod_list=[bevel_edges(sph_bevel, axes="xyz")]);
            }

            _mnt_d = sph_bolt_d+2*sph_wt;

            // mounting studs           
            translate([-atx_ps2_psu_x/2, 0, atx_ps2_psu_z/2])
                __atx_ps2_psu__replicate_at_mountpoints()
                    cylinderpp(d=_mnt_d, h=sph_bolt_l, align="y", zet="y");


        }

        // psu interface mounting points
        translate([-atx_ps2_psu_x/2, 0, atx_ps2_psu_z/2+_x_alignement_offset])
            __atx_ps2_psu__replicate_at_mountpoints()
                translate([0, -sph_bolt_off, 0])
                    rotate([-90,0,0])
                        bolt_hole(  standard=sph_bolt_standard,
                                    descriptor=sph_bolt_descriptor,
                                    clearance=bolt_clearance,
                                    hh_off=mb1010_a);

        // makerbeam mounting points
        // ... bottom row
        mirrorpp([1,0,0], true)
            translate([atx_ps2_psu_x/4,mb1010_a/2,-available_height/2])
                rotate([0,0,180])
                    rotate([-90,0,0])
                        makerbeam_anchoring_interface();
    
        // top row
        mirrorpp([1,0,0], true)
            translate([atx_ps2_psu_x/4,mb1010_a/2,available_height/2])
                rotate([0,0,180])
                    rotate([90,0,0])
                        makerbeam_anchoring_interface();

    }

}

$fn=$preview ? 36 : 72;
atx_ps2_psu_holder();