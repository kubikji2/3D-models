

module heart(h=2,a=20,t=1,s1=1,s2=1)
{
    cube([a,a,h]);
    translate([a,t*(a/2),0]) scale([s1,s2,1]) cylinder(h=h,d=a);
    translate([t*(a/2),a,0]) scale([s2,s1,1]) cylinder(h=h,d=a);
}

