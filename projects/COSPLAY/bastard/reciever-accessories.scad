include<screw-data.scad>;
eps = 0.1;
tol = 0.3;
n_tol = 0.1;
$fn = $preview ? 36 : 180;

module cock_lever_holder(d=10, l=85,a=5,b=5, _tol = 0.1)
{
    
    difference()
    {
        //base shape
        cylinder(d=d-tol,h=l);
        // hole for the inner cylinder
        d2=d/2;
        translate([0,0,l-20+eps]) cylinder(d=d2,h=20);
        // hole for the merkur screw
        translate([0,0,-eps]) cylinder(d=ms_d,h=a+b+mn_t);
        // hole for inserting nut
        // nut hole
        translate([mn_d/2,0,a]) cylinder(d=mn_d+_tol,h=mn_t+_tol,$fn=6);
        hull()
        {
            translate([0,0,a]) cylinder(d=mn_d+_tol,h=mn_t,$fn=6);
            translate([0,0,a]) cylinder(d=ms_d+_tol,h=a+mn_t);
        }
        
    }
    
    translate([-(d/2-ms_d/2)/2-0.2*d-_tol,-0.3*d,a+mn_t+_tol])
        cube([0.2*d,0.6*d,l/2]);
    translate([(d/2-ms_d/2)/2+_tol,-0.3*d,a+mn_t+_tol])
        cube([0.2*d,0.6*d,l/2]);
}

//cock_lever_holder();

//translate([0,-20,0]) cock_lever_holder(_tol=0.2);

module inner_shaft()
{
    cylinder(h=40,d=4.75);
}

//translate([0,20,0]) inner_shaft();
