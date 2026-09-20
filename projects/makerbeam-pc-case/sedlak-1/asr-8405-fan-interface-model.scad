// essentials
use<../../../lib/solidpp/solidpp.scad>
use<../../../lib/deez-nuts/deez-nuts.scad>

// parameters
include<asr-8405-fan-interface-parameters.scad>

module asr8405_fan_interface(
    pin_clearance  = 0.1,
    bolt_clearance = 0.2,
    snap_offset    = 0.6,
)
{

    difference()
    {
        // main shape
        cylinderpp(d=asr8405_interface_d,h=asr8405_interface_h);
        
        // bolt
        translate([0,0,asr8405_pin_head_h+asr8405_interface_bt])
            rotate([180,0,0])
                bolt_hole(  descriptor=asr8405_bolt_descriptor,
                            standard=asr8405_bolt_standard,
                            clearance=bolt_clearance,
                            align="t");
                
        // bolt snap hole
        _hd = get_bolt_head_diameter(   descriptor=asr8405_bolt_descriptor,
                                        standard=asr8405_bolt_standard)+2*bolt_clearance;
        _hh = get_bolt_head_height(   descriptor=asr8405_bolt_descriptor,
                                        standard=asr8405_bolt_standard);

        translate([0,0,asr8405_pin_head_h+asr8405_interface_bt])
        {
            // head
            hull()
            {
                cylinderpp(d1=_hd, d2=asr8405_bolt_d-2*snap_offset, h=_hh+2*bolt_clearance, align="z");
                
                translate([_hd,0,0])
                    cylinderpp(d1=_hd, d2=asr8405_bolt_d, h=_hh+2*bolt_clearance, align="z");
            }
            // shaft
            hull()
            {
                cylinderpp(d=_hd,h=bolt_clearance, align="Z");
                
                translate([asr8405_interface_d,0,0])
                    cylinderpp(d=_hd,h=bolt_clearance, align="Z");
            }
        }

        // pin head
        translate([0,0,asr8405_interface_bt-pin_clearance])
            cylinderpp(d=asr8405_pin_head_d+2*pin_clearance, h=asr8405_pin_head_h+2*pin_clearance);

        // pin head entrance
        translate([0,0,asr8405_interface_bt-pin_clearance])
            hull()
            {
                cylinderpp( d=asr8405_pin_head_d-2*snap_offset,
                            h=asr8405_pin_head_h+2*pin_clearance);
                translate([asr8405_pin_head_d,0,0])
                    cylinderpp( d=asr8405_pin_head_d,
                                h=asr8405_pin_head_h+2*pin_clearance);
            }


        // pin shaft
        cylinderpp(d=asr8405_pin_shaft_d+2*bolt_clearance,h=2*asr8405_interface_bt,align="");

        // pin entrance
        hull()
        {
            cylinderpp(d=asr8405_pin_shaft_d-2*snap_offset,h=2*asr8405_interface_bt,align="");
            translate([asr8405_pin_head_d,0,0])
                cylinderpp( d=asr8405_pin_shaft_d+2*pin_clearance,
                            h=asr8405_pin_head_h+2*pin_clearance);
        }

    }

}

$fn = $preview ? 36:120;
asr8405_fan_interface();