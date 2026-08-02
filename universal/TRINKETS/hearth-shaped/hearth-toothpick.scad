use<hearth.scad>

module heart_pick(a=14,h=2.5,l=55,t=4)
{
    //%cube([20,20,2]);
    difference()
    {
        heart(a=a,s1=0.9,h=h);
        translate([1.1,1.1,1.75]) heart(a=a-2, s1=1,h=h);
        translate([1.1,1.1,-1.75]) heart(a=a-2,s1=1,h=h);
    }
    
    c=0.65*h;
    
    d=0.3*h;
    
    translate([1.2,1.2,0.5*h])
    rotate([90,0,-45])
    hull()
    {
        #translate([c,0,0]) cylinder(d=0.25,h=l);
        #translate([0,d,0.5]) cylinder(d=0.25,h=l-0.5);
        #translate([-c,0,0]) cylinder(d=0.25,h=l);
        #translate([0,-d,0.5]) cylinder(d=0.25,h=l-0.5);
        translate([0,0,1.1*l]) sphere(d=0.25);
    }
}
