use<side-insert-storage.scad>

use<../../../../lib/deez-nuts/deez-nuts.scad>


include<../ivar-dimensions.scad>

lbn_wt = 3;
lbn_h = 185;
lbn_pocket_height = 90;
lbn_back_wall_offset = 15;

lbn_screw_d = 3;
lbn_screw_l = 20;
lbn_screw_descriptor = str("M",lbn_screw_d,"x",lbn_screw_l);
lbn_screw_standard = "LUXPZ";


module lbn_screw_hole()
{
    rotate([0,90,0])
        screw_hole(standard=lbn_screw_standard,
                    descriptor=lbn_screw_descriptor,
                    align="t");
}

module bottom_storage()
{
    difference()
    {
        union()
        {
            ivar_insert(
                wt=lbn_wt,
                height=lbn_h,
                pocket_height = lbn_pocket_height,
                back_wall_offset = lbn_back_wall_offset);

            // inner partitioning
        
        }
        
        screw_off = ivar_leg_w/2;
        
        // middle screws
        mirrorpp([1,0,0], true)
            translate([-(ivar_legs_gauge/2-lbn_wt),-screw_off,lbn_pocket_height])
                lbn_screw_hole();

        // top screws
        mirrorpp([1,0,0], true)
            translate([-(ivar_legs_gauge/2-lbn_wt),-screw_off,lbn_h-screw_off])
                lbn_screw_hole();
    }
}

bottom_storage();

module middle_storage()
{

}