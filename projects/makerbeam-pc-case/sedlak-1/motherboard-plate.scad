// motherboard
include<gigabyte-ga-b85m-hd3-parameters.scad>
use<gigabyte-ga-b85m-hd3-model.scad>

// plate
use<../makerbeam-plate.scad>

// makerbeam
include<../makerbeam-constants.scad>

// makerbeam corner
include<../makerbeam-corner-parameters.scad>


// sedlak dimensions
include<sedlak-1-parameters.scad>

// motherboard mockup
use<../micro-atx-models.scad>

// adding split
use<../lightning-crack.scad>

module sedlak_motherboard_plate()
{

    _mb_x = sedlak1_mbl_x + 2*mbc_wt;
    _mb_y = sedlak1_mbl_y + 2*mbc_wt;

    _mb_x_off = 10;
    _mb_y_off = _mb_y-bg_ga_b85_hd3_y;

    _z = mb1010_a;

    difference()
    {
        union()
        {
            
            // baseplate
            makerbeam_plate(_mb_x, _mb_y, align="xyz");

            // adding mockup and the mountpoints
            translate([_mb_x_off,_mb_y_off,_z+sedlak1_mountpoints_h])
            {
            
                %uatx_mockup(x=bg_ga_b85_hd3_x,y=bg_ga_b85_hd3_y, z=bg_ga_b85_hd3_z);

                bg_ga_b85_hd3_replicate_to_mount_points()
                    uatx_mountpoint(h=sedlak1_mountpoints_h, bolt_l=sedlak1_mountpoints_bolt_l);
            }
        }

        // holes for the mountpoints including the baseplate
        translate([_mb_x_off,_mb_y_off,_z+sedlak1_mountpoints_h])
            bg_ga_b85_hd3_replicate_to_mount_points()
                uatx_mountpoint_hole(h=sedlak1_mountpoints_h, bolt_l=sedlak1_mountpoints_bolt_l);

        // lightning
        render(20)
            translate([_mb_x/2,0,_z/2])
                lightning_crack(h=_z, l=_mb_y);

    }

}

$fn=36;
sedlak_motherboard_plate();