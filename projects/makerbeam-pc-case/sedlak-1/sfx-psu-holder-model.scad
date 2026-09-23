use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// available space
include<hdd-slot-parameters.scad>

// makerbeam
use<../makerbeam-model.scad>
include<../makerbeam-constants.scad>

// makerbeam mountpoints
use<../makerbeam-plate.scad>


// psu dimensions
include<sfx-psu-specs.scad>

// parameter
include<sfx-psu-holder-parameters.scad>

module sfx_psu_holder(
    makerbeam_clearance = 0.1,
    bolt_clearance = 0.2
)
{
    _fz = hdds_total_z+2*mb1010_n;
        
    difference()
    {
        // main frame including cuts
        makerbeam_interface_hole(2*sfx_psu_x,
            tf=[0,0,hdds_total_z/2+mb1010_a/2],
            clearance=makerbeam_clearance, align="y", zet="x")
            makerbeam_interface_hole(2*sfx_psu_x,
                tf=[0,0,-(hdds_total_z/2+mb1010_a/2)],
                clearance=makerbeam_clearance, align="y", zet="x")
                cubepp([sfx_psu_x,mb1010_a,_fz], align="y");

        // inner cutouts
        //_cb_x = (hdds_total_z-sfx_psu_mnt_G)/2;
        //_cb_z = (sfx_psu_x-sfx_psu_mnt_g)/2;
       

        difference()
        {
            _cx = sfx_psu_x-2*sph_wt;
            //_cx = sfx_psu_mnt_g;
            _cy = 2*mb1010_a + 2*sph_bevel;
            //_cz = hdds_total_z-2*sph_wt;
            _cz = sfx_psu_mnt_G;
            
            //__cx = sfx_psu_mnt_g-2*sph_wt;
            //__cz = sfx_psu_mnt_G-2*sph_wt;
            
            // middle cutout
            union()
            {
                //cubepp([__cx,_cy,__cz], align="", mod_list=[bevel_edges(sph_bevel, axes="xz")]);                
                cubepp([_cx,_cy,_cz], align="y", mod_list=[bevel_edges(sph_bevel, axes="xyz")]);
            }

            _mnt_d = sph_bolt_d+2*sph_wt;

            // corners mounting
            mirrorpp([1,0,0], true)
                mirrorpp([0,0,1], true)
                    translate([sfx_psu_mnt_g/2, 0, sfx_psu_mnt_G/2])
                        cylinderpp(d=_mnt_d, h=sph_bolt_l, align="y", zet="y");

            // middle mounting
            translate([0, 0, -sfx_psu_mnt_G/2])
                cylinderpp(d=_mnt_d, h=sph_bolt_l, align="y", zet="y");


        }


        // psu interface mountpoints
        mirrorpp([1,0,0], true)
            mirrorpp([0,0,1], true)
                translate([sfx_psu_mnt_g/2, -sph_bolt_off, sfx_psu_mnt_G/2])
                    rotate([-90,0,0])
                        bolt_hole(  standard=sph_bolt_standard,
                                    descriptor=sph_bolt_descriptor,
                                    clearance=bolt_clearance,
                                    hh_off=mb1010_a);

        translate([0, 0, -sfx_psu_mnt_G/2])
            rotate([-90,0,0])
                bolt_hole(  standard=sph_bolt_standard,
                            descriptor=sph_bolt_descriptor,
                            clearance=bolt_clearance,
                            hh_off=mb1010_a);
        

        // makerbeam mountpoints
        mirrorpp([1,0,0], true)
            mirrorpp([0,0,1], true)
                translate([sfx_psu_x/4,mb1010_a/2,-hdds_total_z/2])
                    rotate([0,0,180])
                        rotate([-90,0,0])
                            makerbeam_anchoring_interface();


        
    }


}

$fn=$preview ? 36 : 72;
sfx_psu_holder();