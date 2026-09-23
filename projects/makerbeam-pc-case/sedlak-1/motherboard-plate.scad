use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

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

// expansion board
include<sedlak-1-expansion-board-parameters.scad>

// motherboard mockup
use<../pc-parts/micro-atx-models.scad>

// adding split
use<../lightning-crack.scad>



module sedlak_motherboard_plate()
{

    _mb_x = sedlak1_mbl_x + 2*mbc_wt;
    _mb_y = sedlak1_mbl_y + 2*mbc_wt;

    //_mb_interface_x = _mb_x+2*mb1010_wa;
    //_mb_interface_x = _mb_y+2*mb1010_wa;

    _mb_x_off = _mb_x-bg_ga_b85_hd3_x-mbc_wt;
    _mb_y_off = _mb_y-bg_ga_b85_hd3_y;

    //echo(_mb_x_off);    

    _z = mb1010_a;

    difference()
    {
        union()
        {
            
            // baseplate holes
            _xX_holes_positions = [ sedlak1_anchoring_offset,
                                    _mb_x/2-sedlak1_anchoring_offset,
                                    _mb_x/2+sedlak1_anchoring_offset,
                                    _mb_x-sedlak1_anchoring_offset];
            _yY_holes_positions = [ sedlak1_anchoring_offset,
                                    _mb_y/2,
                                    _mb_y-sedlak1_anchoring_offset];
            // baseplate
            makerbeam_plate(_mb_x, _mb_y, align="xyz",
                xX_holes_positions=_xX_holes_positions,
                yY_holes_positions=_yY_holes_positions);

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

        // lightning weld crack
        translate([_mb_x/2,0,_z/2])
            if ($preview)
                render(20)
                    lightning_crack(h=_z, l=_mb_y);
            else
                lightning_crack(h=_z, l=_mb_y);
            
        // cable holes
        _ch_w = sedlak1_cable_hole_w;
        //_ch_off = (_mb_y_off-_ch_w)/2;
        _ch_off = _mb_y_off-_ch_w;
        _ch_l = _mb_x/2-2*_ch_off;
        // power cable and SATA cable holes
        translate([_mb_x-_ch_off, _ch_off, 0])
            cubepp([_ch_l, _ch_w, 3*_z], align="Xy", mod_list=[round_edges(d=_ch_w, axes="xy")]);
        
        // SAS cables
        translate([_ch_off, _ch_off, 0])
            cubepp([_ch_l, _ch_w, 3*_z], align="xy", mod_list=[round_edges(d=_ch_w, axes="xy")]);


        // expansion board
        _eb_x_off=(_mb_x_off-s1eb_mountpoints_x_gauge)+s1eb_mountpoints_x_gauge/2-5;
        _eb_y_off=_mb_y_off+bg_ga_b85_hd3_y/2;
        translate([_eb_x_off,_eb_y_off,_z])
        {
            mirrorpp([1,0,0], true)
            {
                // fuurther
                mirrorpp([0,1,0], true)
                    translate([s1eb_mountpoints_x_gauge/2,s1eb_mountpoints_y_gauge+s1eb_mountpoints_y_gauge/2,0])
                        uatx_mountpoint_hole(h=0, bolt_l=mb1010_a);    

                // closer
                mirrorpp([0,1,0], true)
                    translate([s1eb_mountpoints_x_gauge/2,s1eb_mountpoints_y_gauge/2,0])
                        uatx_mountpoint_hole(h=0, bolt_l=2*mb1010_a);
                
                // middle
                //translate([s1eb_mountpoints_x_gauge/2,0,0])
                //    uatx_mountpoint_hole(h=0, bolt_l=mb1010_a);    

            }

        }

    }

}

$fn=36;
sedlak_motherboard_plate();