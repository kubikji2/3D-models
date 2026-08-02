$fn = $preview ? 36 : 120;

module hole(depth=3, a=20,d=25,off=1)
{
    side = a + off;
    diam = d + off;
    cube([side,side,depth],center=true);
    cylinder(d=diam,h=depth,center=true);
}

module block()
{
    x_off = 15;
    y_off = 15;
    z_off = 3.51;
    difference()
    {
        cube([150,30,5]);
        for(i=[0:4])            
        {
            translate([30*i+x_off,y_off,z_off]) hole();
        }
            
    }
}

block();