sf = 0.85;
$fn = $preview ? 36 : 180;
eps = 0.01;
tol = 0.1;

module sight_base()
{
    //%scale([sf,sf,sf]) translate([0,0,0]) import("PIX_sights.stl");
    scale([sf,sf,sf])
        translate([0,0,0])
            render(10)
                import("import/base-sights.stl");
}

sig_ch = 1;

module sight_plate()
{
    a = 11;
    b = 1.25;
    c = 14;
    
    d = 5;
    e = 5;
    
    f = 6;
    difference()
    {
        translate([-a/2,-b/2,sig_ch])cube([a,b,c]);
        translate([-d/2,-b/2-eps,sig_ch+(c-e)]) cube([d,b+2*eps,e+eps]);
        
        //translate([-f,-b/2,sig_ch+c-])rotate([0,90,0]) cylinder(h=b,d=1);
                
    }   
    
}



module sight_connectors(tol=0)
{
    a = 2-tol;
    x_off = 2;
    y_off = 10;
    y_off2 = 15;
    translate([x_off,y_off+y_off2,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    translate([x_off,-y_off,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    translate([-x_off,y_off+y_off2,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    translate([-x_off,-y_off,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    
    translate([x_off,5,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    translate([-x_off,5,0]) translate([-a/2,-a/2,0])
        cube([a,a,sig_ch-tol]);
    
}

module sights()
{
    difference()
    {
        sight_base();
        translate([0,-5,-eps]) sight_connectors();
    }
    translate([0,19,0]) sight_plate();
}

//sights();