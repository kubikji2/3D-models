
module cylinder4(h = 1.5, d = 1.5){
    difference(){    
        cylinder(h=h,d=d);
        translate([-0.5*d,-0.5*d,-0.5*h]) cube([d,0.5*d,2*h]);
        translate([-0.5*d,-0.5*d,-0.5*h]) cube([0.5*d,d,2*h]);
    }
}

module handle(t=1, h=1.5, w=2, l=4, off=2){
    translate([0,off,0]){
        cube([w,t,h]);
        translate([w,t,0]) rotate([0,0,-90]) cylinder4(h=h,d=2*t);
        translate([w,t,0]) cube([t,l,h]);
        translate([w,t+l,0]) cylinder4(h=h,d=2*t);
        translate([0,t+l,0]) cube([w,t,h]);
   }
}

module glass_line(d = 1.5, h = 3, l = 10){
    hull(){
        cylinder(d=d,h=h);
        translate([0,l,-0.25*h]) cylinder(d=d,h=h);
    }
}

module glass_body(d = 1.5, h = 1.5, w = 7, l = 12,){
    hull(){
        translate([-0.5*w,0,0]) cylinder(d=d,h=h);
        translate([0.5*w,0,0]) cylinder(d=d,h=h);
        translate([-0.5*w,l,0]) cylinder(d=d,h=h);
        translate([0.5*w,l,0]) cylinder(d=d,h=h);
    }
}

module foam(h=1.5){
    cylinder(d=3,h=1.5);
    translate([1.5,-1,0]) cylinder(d=3,h=1.5);
    difference(){
        
    }
}


module glass(){

    difference(){
        translate([0,-1,0]) glass_body();
        translate([0,0,0]) glass_line();
        translate([-2.5,0,0]) glass_line();
        translate([+2.5,0,0]) glass_line();
    }
    
    translate([3.5,0,0]) handle();
    
    translate([-0.5*8.5,12,0]) #foam();
}

$fn=250;

glass();

//cylinder4();