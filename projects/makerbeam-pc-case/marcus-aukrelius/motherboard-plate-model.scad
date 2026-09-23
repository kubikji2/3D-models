
// motherboard-related parameters
use<../pc-parts/micro-atx-models.scad>
include<../pc-parts/micro-atx-parameters.scad>
use<mougol-x99-model.scad>
include<mougol-x99-parameters.scad>

// case related
include<marcus-aukrelius-parameters.scad>

// makerbeam related
include<../makerbeam-constants.scad>
include<../makerbeam-corner-parameters.scad>
include<../makerbeam-plate.scad>

// adding split
use<../lightning-crack.scad>

module motherboard_plate()
{

    _mb_x = ma_mbl_x + 2*mbc_wt;
    _mb_y = ma_mbl_y + 2*mbc_wt;

    _mb_x_off = _mb_x-mougol_x99_x-mbc_wt;
    _mb_y_off = _mb_y-mougol_x99_y;

    //echo(_mb_x_off);    

    _z = mb1010_a;


    difference()
    {
    union()
        {
            
            // baseplate holes
            _xX_holes_positions = [ ma_anchoring_offset,
                                    _mb_x/2-ma_anchoring_offset,
                                    _mb_x/2+ma_anchoring_offset,
                                    _mb_x-ma_anchoring_offset];
            _yY_holes_positions = [ ma_anchoring_offset,
                                    _mb_y/2,
                                    _mb_y-ma_anchoring_offset];
            // baseplate
            makerbeam_plate(_mb_x, _mb_y, align="xyz",
                xX_holes_positions=_xX_holes_positions,
                yY_holes_positions=_yY_holes_positions);

            // adding mockup and the mountpoints
            translate([_mb_x_off,_mb_y_off,_z+ma_mountpoints_h])
            {
            
                //%uatx_mockup(x=mougol_x99_x,y=mougol_x99_y, z=mougol_x99_z);
                %mougol_x99_motherboard();

                mougol_x99_replicate_to_mount_points()
                    uatx_mountpoint(h=ma_mountpoints_h, bolt_l=ma_mountpoints_bolt_l);
            }
        }

        // holes for the mountpoints including the baseplate
        translate([_mb_x_off,_mb_y_off,_z+ma_mountpoints_h])
            mougol_x99_replicate_to_mount_points()
                uatx_mountpoint_hole(h=ma_mountpoints_h, bolt_l=ma_mountpoints_bolt_l);

        // lightning weld crack front-back
        translate([_mb_x/2,0,_z/2])
            if ($preview)
                render(20)
                    lightning_crack(h=_z, l=_mb_y);
                    
            else
                lightning_crack(h=_z, l=_mb_y);
        

        // left-right
        translate([0,_mb_y/2,_z/2])
            rotate([0,0,-90])
            if ($preview)
                render(20)
                    lightning_crack(h=_z, l=_mb_y);
                    
            else
                lightning_crack(h=_z, l=_mb_y);
    }
    

}


motherboard_plate();