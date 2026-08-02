module heart(h=2,a=20,t=1,s1=1,s2=1)
{
    cube([a,a,h]);
    translate([a,t*(a/2),0]) scale([s1,s2,1]) cylinder(h=h,d=a);
    translate([t*(a/2),a,0]) scale([s2,s1,1]) cylinder(h=h,d=a);
}

module bond(a=1, length=10){
    hull(){
        cylinder(d=a,h=a,center=true);
        translate([length,0,0]) cylinder(d=a,h=a,center=true);
    }
}

module _recursiveBond(a,length,counter,iterations,angle){
    if(counter < iterations){
        translate([length,0,0]) rotate([0,0,angle]) _recursiveBond(a,length,counter+1,iterations,angle);
        bond(a,length);
    }
}


module cyclohexan(a=1,length=10){
    _recursiveBond(a,length,0,6,-60);
}

module hearth_cycle_earring(a=1.5,l=7)
{
    translate([0,13,0.5*a])
    rotate([0,0,-30]){
    cyclohexan(a=a,length=l);
    b_l = 0.75*l;
    #rotate([0,0,120])  
    difference(){
        union(){
            bond(a,b_l);
            translate([b_l,0,0]) cylinder(r=a,h=a,center=true);
        }
        translate([b_l,0,0]) cylinder(r=0.5*a,h=2*a,center=true);
    }
    }
     
    h_A = 0.95*l;
    //h_a = 0.75*h_A;
    h_a = h_A-1.5*a;
    h_off = 0.6*(h_A-h_a);
    h_h = a;
    //translate([])
    rotate([0,0,45])
    difference()
    {
        heart(a=h_A,s1=0.9,h=h_h);
        translate([h_off,h_off,-0.01]) heart(a=h_a,s1=1,h=h_h+0.02);
    }
    
    
    
}

//%import("Earring_hearth.stl");

$fn = $preview ? 36 : 180;

hearth_cycle_earring();