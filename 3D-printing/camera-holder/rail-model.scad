include<rail-parameters.scad>

use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

module rail_shape(height, clearance=0.1)
{
    _points = [ [clearance,                                 rail_neck_w/2],
                [rail_neck_h,                       rail_neck_w/2],
                [rail_neck_h+ri_hook_d,             rail_neck_w/2+ri_hook_l],
                [rail_neck_h+ri_hook_d+ri_hook_h,   rail_neck_w/2+ri_hook_l],
                [rail_neck_h+ri_hook_d+ri_hook_h,   -(rail_neck_w/2+ri_hook_l)],
                [rail_neck_h+ri_hook_d,             -(rail_neck_w/2+ri_hook_l)],
                [rail_neck_h,                       -rail_neck_w/2],
                [clearance,                                 -rail_neck_w/2]];
    linear_extrude(height)
        offset(delta=clearance)    
            polygon(_points);


}

module rail()
{
    difference()
    {

        rail_shape(rail_length, clearance=0);

        // lower screw
        translate([(rail_neck_h+ri_hook_d+ri_hook_h),0,rail_neck_w/2+ri_hook_l])
            rotate([0,90,0])
                screw_hole( standard=rail_screw_standard,
                            descriptor=rail_screw_descriptor,
                            align="t");
        
        // upper screw
        translate([(rail_neck_h+ri_hook_d+ri_hook_h),0,rail_length-(rail_neck_w/2+ri_hook_l)])
            rotate([0,90,0])
                screw_hole( standard=rail_screw_standard,
                            descriptor=rail_screw_descriptor,
                            align="t");
    }
}

rail();

//%rail_shape(height=rail_length, clearance=0.25);
