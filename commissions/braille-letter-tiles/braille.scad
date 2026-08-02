$fn = $preview ? 36 : 120;

module braille_char(arr,d=5,a=6,b=4,r=3,h=1,H=2)
{
    x = a+2*d+2*b-2*r;
    y = 2*a+2*b+3*d-2*r;
    
    //base frame
    translate([r,r,0])
    color([0.25,0.25,0.25]) hull()
    {
        cylinder(r=r,h=H);
        translate([x,0,0]) cylinder(r=r,h=H);
        translate([x,y,0]) cylinder(r=r,h=H);
        translate([0,y,0]) cylinder(r=r,h=H);
    }
    
    //cube([x+2*r,y+2*r,H]);
    
    off_x = d/2 + b;
    off_y = d/2 + b + 2*a + 2*d;
    //pins
    color([0.9,0.9,0.9])
    for(y_=[0:2])
    { 
        for(x_=[0:1])
        {
            index = 2*y_ + x_;
            if(arr[index] > 0)
            {
                //echo(index);
                translate([off_x + x_*(a+d),off_y-y_*(a+d),H]) cylinder(d=d,h=h);
            }
        }
    }
}

// A 
braille_char(arr=[1,0,0,0,0,0]);
// H
translate([30,0,0]) braille_char(arr=[1,0,1,1,0,0]);
// O
translate([60,0,0]) braille_char(arr=[1,0,0,1,1,0]);
// J
translate([90,0,0]) braille_char(arr=[0,1,1,1,0,0]);    