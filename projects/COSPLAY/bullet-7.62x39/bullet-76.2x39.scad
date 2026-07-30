$fn = 180;

module ammo()
{
    translate([-11.3/2,11.3/2,0]) rotate([90,0,0]) import("import/Ak_47_bullet_7.62X39mm.STL");
}


module ammo_holed()
{
    difference()
    {
        ammo();
        // primer: 0,55118 cm diam, 0,24638 cm height
        translate([0,0,-0.1]) cylinder(d=5.5,h=2.5);
    }
}

module primer()
{
    d = 1;
    D = 5.5-d-0.3;
    H = 2.5-d/2-0.75;
        
    difference()
    {
        minkowski()
        {
            cylinder(h=H,d=D);
            sphere(d=d);
        }
        translate([0,0,-5]) cylinder(h=5,d=20);
    }
    //%cylinder(h=2.5-0.5,d=5.5);
}

//primer();
//ammo_holed();
