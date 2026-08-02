
module tail(d = 1.5)
{
    difference()
    {
        translate([0,0,-8]) render(10) import("import/tail.stl");
        rotate([0,-90,0]) translate([3,5,-1]) cylinder(d=d,h=10);
        rotate([0,-90,0]) translate([3,-5,-1]) cylinder(d=d,h=10);
        rotate([0,-90,0]) translate([8,5,-1]) cylinder(d=d,h=10);
        rotate([0,-90,0]) translate([8,-5,-1]) cylinder(d=d,h=10);
        rotate([0,-90,0]) translate([13,5,-1]) cylinder(d=d,h=10);
        rotate([0,-90,0]) translate([13,-5,-1]) cylinder(d=d,h=10);
       
    }
}
