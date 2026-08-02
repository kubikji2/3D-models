$fn=180;

module base()
{
    difference()
    {
        cylinder(d=90,h=2);
        //rotate([0,90,0])
        translate([0,0,-0.01])
            for (i=[0:8])
            {
                rotate([0,0,i*45]) translate([35,0,0]) cylinder(d=3.3, h=1.1);
                rotate([0,0,i*45]) translate([20,0,0]) cylinder(d=3.3, h=1.1);
            }
   }
}

module logo()
{
    resize([90,90,2]) import("import/logo_final_nt.stl");
}

module coaster()
{
    color([0.3,0.3,0.3]) base();
    color("white") translate([0,0,2]) logo();
}

coaster();
