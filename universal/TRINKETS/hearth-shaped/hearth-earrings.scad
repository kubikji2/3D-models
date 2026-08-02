use<hearth.scad>

module hole(r=1,R=2)
{
    difference()
    {
        cylinder(r=R,h=2);
        translate([0,0,-1]) cylinder(r=r,h=4);
    }
    
}

module ear_ring(a = 20)
{
    difference()
    {
        heart(a=a);
        translate([a,a,-1]) cylinder(r=1,h=4);
        //#translate([-a,-a,-1]) cylinder(r=a/1.5,h=4);
    }
    
    translate([a,a,0]) hole();
}

module adv_ear_ring(a=15)
{
    eps = 0.01;
    eps_2 = eps/2;

    difference()
    {
        heart(a=a,t=0.9,s1=0.9,s2=0.9);
        translate([1,1,-eps_2]) heart(a=a-2,s1=1,s2=0.9,t=0.9,h=2+eps);
        translate([a,a,-1]) cylinder(r=1,h=4);
        //#translate([-a,-a,-1]) cylinder(r=a/1.5,h=4);
    }
    
    translate([a,a,0]) hole();
    
    translate([a-2.25,a-2.25,0])cube([1.5,1.5,2]);
    
    
    c_h = sqrt(a*a+a*a)-2;
    
    translate([2,2,0])
    difference(){
        m_a = a-4;
        m_a_m = m_a - 2;
        //m_am = 
        heart(a=m_a,t=0.9,s1=1.1,s2=0.9);
        translate([0.9*(m_a)+eps_2,0.9*(m_a)+eps_2,-eps_2])
            cube([0.1*(m_a)+eps,0.1*(m_a)+eps,2+eps]);
        translate([1,1,-eps_2])
            heart(a=m_a_m,t=0.9,s1=1.1,s2=0.9,h=2+eps);
    }
    rotate([0,-90,-135]) translate([1,0,0.5]) cylinder(r=0.5,h=c_h);

}