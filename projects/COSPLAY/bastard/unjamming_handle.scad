sf = 0.85;
$fn = $preview ? 36 : 180;
eps = 0.01;
tol = 0.1;

include<screw-data.scad>;

//scale([sf,sf,sf]) translate([0,0,-10])5 %import("PIX_Unjamming_Handle.stl");

// bolts between main body and the secondary handle
// inner bolt diameter
ujh_bd = 10;
// bolt head thickness
ujh_bt = 5;
// nut thickness
ujh_nt = 6;
// outer bold diameter
ujh_bD = 20;

ujh_r = 16;
ujh_h = 13;
ujh_cr = 2;


module unjamming_handle()
{
    difference()
    {
        // main body
        hull()
        {
            ujh_diff = 2;
            cylinder(r=ujh_r,h=ujh_h-ujh_diff);
            translate([0,0,ujh_h-ujh_diff]) cylinder(r=ujh_r-ujh_cr/2);
        }
        // side cuts 
        samples = 24;
        for(i=[0:samples])
        {
            rotate([0,0,i*(360/samples)])
                translate([ujh_r,0,-eps])
                    cylinder(d=ujh_cr,h=ujh_h+2*eps);
        }
        
        // hole for screw
        translate([0,0,-eps]) cylinder(d=ujh_bd,h=2*eps+ujh_h);
        
        // hole for nut
        translate([0,0,ujh_h-2]) cylinder(h=ujh_bt, d=ujh_bD+2*tol, $fn=6);
        
    }
}

unjamming_handle();

module unjamming_nut()
{
    difference()
    {
        // nut shape
        cylinder(h=ujh_nt, d=ujh_bD, $fn=6);
        // hole in the middle
        translate([0,0,-eps]) cylinder(h=ujh_nt+2*eps, d=ujh_bd);
        // hole for the tightening bolt
        l = sqrt((3/4)*(ujh_bD/2)*(ujh_bD/2))+mn_t/2;
        translate([0,l+eps,ujh_nt/2]) rotate([90,0,0])
            cylinder(d=ms_d,h=2*l+2*eps);
        // tightening bolt head
        translate([0,l+eps,ujh_nt/2]) rotate([90,0,0])
            cylinder(d=mh_d,h=mn_t);
        // tightening nut
        translate([0,-l-eps+mn_t,ujh_nt/2]) rotate([90,0,0])
            cylinder(d=mn_d+2*tol,h=mn_t,$fn=6);
        
        
    }
    
}

translate([0,30,0]) unjamming_nut();


module unjamming_screw()
{
    d = ujh_bd - 2*tol;
    h = ujh_h + 2*ujh_bt + 25 + 6;
    h = 88;
    // bolt head
    cylinder(h=ujh_bt, d=ujh_bD, $fn=6);    
    // body
    difference()
    {
        cylinder(d=d,h=h);
        // hole for tightening bolt
        translate([0,d/2+eps,50]) rotate([90,0,0])
            cylinder(h=d+2*eps,d=ms_d);
        // hole for the inner shaft
        translate([0,0,h-20+eps]) cylinder(d=5,h=20);
    }
    
}

translate([0,-35,0]) unjamming_screw();