sf = 0.85;
$fn = $preview ? 36 : 180;
eps = 0.01;
tol = 0.1;

mn_d = 6.75;
mn_t = 3;
ms_d = 3.5;

bs_t = 4;
bs_r = 6;
bs_a = 5;

module ear(a=bs_a, r=bs_r, t=bs_t)
{
    translate([-r,-2*r,-t/2]) cylinder(h=t,r=r);
    translate([-a,-2*r,-t/2]) cube([a,2*r,t]);
    
}


module burst_selector()
{
    difference()
    {
        union()
        {
            rotate([0,90,90]) ear();
            rotate([0,90,-90]) ear();
            rotate([0,0,30])cylinder(h=bs_a,d=2*bs_t+ms_d);
        }
        
        // hole for the screw
        translate([0,0,-eps]) cylinder(h=bs_a+2*eps,d=ms_d);
        
        // hole for nut
        //translate([0,0,-eps]) cylinder(h=mn_t,d=mn_d, $fn=6);
        translate([0,0,bs_a-2]) cylinder(h=mn_t,d=mn_d);
        
        difference()
        {
            // cylinder
            translate([0,0,-eps])
                cylinder(h=1,d=bs_a+2+tol);
            // cube
            translate([-(ms_d+4)/2-eps,-0.5,0])
            cube([ms_d+4+2*eps,1,1]);
        }
    }
    
}

//burst_selector();

module burst_selector_lever()
{
    h = 1.1+1;
    d = 3.3+2;
    difference()
    {
        union()
        {
            hull()
            {
                cylinder(h=h,d=1+mn_d);
                translate([12,0,0]) cylinder(h=h,d=d);   
            }
            translate([0,0,h]) cylinder(d=ms_d+2,h=6);
        }
        
        // closer magnet hole
        translate([8,0,1+eps]) cylinder(h=1.1,d=3.3);
        // further magnet hole
        translate([12,0,1+eps]) cylinder(h=1.1,d=3.3);
        // hole for nut
        translate([0,0,-eps]) cylinder(h=h/2,d=mn_d, $fn=6);
        // hole for screw
        cylinder(h=10,d=ms_d);
        // hole for correct orientation
        translate([-0.5-tol,-(ms_d+2)/2-eps,h+5+eps])
            cube([1+2*tol,ms_d+2+2*eps,1]);
    }
}

//translate([30,0,0]) burst_selector_lever();
