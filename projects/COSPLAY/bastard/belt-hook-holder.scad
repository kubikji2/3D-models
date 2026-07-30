$fn = $preview ? 36 : 180;
eps = 0.01;
// distance between cylinders
bhh_l = 20;
// thickness of the part
bhh_t = 2;
// diameter of the loop for belt holders
bhh_d = 3;
// radius of the cylinders
bhh_r = 8;

bhh_bd = 5;

module belt_hook_holder()
{
    difference()
    {
        union()
        {
            hull()
            {
                translate([0,bhh_l/2,0]) cylinder(r=bhh_r,h=bhh_t);
                translate([0,-bhh_l/2,0]) cylinder(r=bhh_r,h=bhh_t);
            }
            d=bhh_d+2*bhh_t;
            translate([-bhh_r,0,bhh_d-bhh_t]) rotate([0,90,0]) cylinder(d=d,h=2*bhh_r);
            
            
            off_z = -1;
            off_y = bhh_l/2;
            r = bhh_bd;
            translate([0,off_y,off_z]) sphere(r=r);
            translate([0,-off_y,off_z]) sphere(r=r);
        }
        
        // lower cut
        a = 50;
        translate([-a/2,-a/2,-a]) cube([a,a,a]);
        
        // hole for the loop
        translate([-bhh_r-eps,0,bhh_d/2]) rotate([0,90,0]) cylinder(d=bhh_d,h=2*bhh_r+2*eps);
        
        //
        translate([-eps-bhh_r,-bhh_d/2,-eps])
            cube([2*bhh_r+2*eps,bhh_d,bhh_d/2]);
    }
}