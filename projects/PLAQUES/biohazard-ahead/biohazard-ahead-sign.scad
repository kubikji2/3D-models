A = 1;
B = 3.5;
C = 4;
D = 6;
E = 11;
F = 15;
G = 21;
H = 30;

eps = 0.01;

$fn=$preview ? 36 : 120;

module body_part(scale=1, height=1){
    difference(){
        translate([scale*E,0,0]) cylinder(d=scale*H,h=height);
        translate([scale*(G+C/2),0,0]) translate([0,-scale*(C/2),-height/2]) cube([scale*C,scale*C,2*height]);
    }
}

module body_holes(scale=1, height=1)
{
    rotate([0,0,90]) translate([scale*F,0,0]) cylinder(d=scale*G,h=height+eps);
    rotate([0,0,210]) translate([scale*F,0,0]) cylinder(d=scale*G,h=height+eps);
    rotate([0,0,330]) translate([scale*F,0,0]) cylinder(d=scale*G,h=height+eps);
}

module body_core(scale=1,height=1){
    rotate([0,0,90]) body_part(scale,height);
    rotate([0,0,210]) body_part(scale,height);
    rotate([0,0,330]) body_part(scale,height);
}

module body(scale=1,height=1){
    difference(){
        body_core(scale,height);
        translate([0,0,-height/2])
            body_holes(scale,2*height);
    }
}

module inner_hole(scale=1,height=1){
    cylinder(d=scale*D,h=height);
    for(i=[90,210,330]){
        rotate([0,0,i-90]) translate([-scale*(A/2),0,0]) cube([scale*A,scale*D,height+2*eps]);
    }
}

module inner_ring(scale=1,height=1){
    outer=scale*(E-A+B);
    inner=scale*(E-A);
    difference(){
        cylinder(r=outer,h=height);
        translate([0,0,-height/2])
            cylinder(r=inner,h=2*height);
    }
}

module inner_ring_holes(scale=1,height=1){
    for(i=[90,210,330]){
        rotate([0,0,i]) translate([scale*F,0,0]) cylinder(d=scale*(G-2*A),h=height+eps);
    }
}

module middle_part(scale=1,height=1)
{
    difference()
    {
        inner_ring(scale,height);
        difference()
        {
            inner_ring(scale,height);
            inner_ring_holes(scale, height);
        }
    }
}

module biohazard_sign(scale=1, height=1)
{
    difference()
    {
        body(scale,height);
        translate([0,0,-height/2])
            inner_hole(scale, 2*height);
    }
    middle_part(scale,height);
}

module border(height = 5, diam=95,border=3)
{
    difference()
    {
        cylinder(d=diam, height);
        translate([0,0,-height/2])
            cylinder(d=diam-2*(border), 2*height);
    }
    
}

module biohazard_symbol()
{
    color("black") border(height=3,diam=95);
    color("black") biohazard_sign(scale=1.7, height=3);
    //color("grey") cylinder(h=1.5, d=95);
}

module biohazard_ahead_sign(){
    $fn=250;
        minkowski(){
        translate([5,5,0]) cube([100,140,1]);
        cylinder(d=5,h=0.5);
        }


    translate([25+(110-50)/2,145-50,0]) biohazard_symbol();
    translate([55,0,0]){
    linear_extrude(height = 3) {
        translate([0,25,0]) scale([1,1.75,1]) text("BIOHAZARD", font = "Consolas:style=Regular",size = 11, halign="center");
        //translate([7.5,40,0]) text("MAGIOACTIVITY", font = "Coder's Crux:style=Regular",size = 10);
        translate([0,5,0]) scale([1,1.75,1]) text("AHEAD", font =  "Consolas:style=Regular", size = 10,halign="center");
        }
    }
}
    
biohazard_ahead_sign(); 

