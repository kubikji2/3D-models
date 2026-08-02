
module left_wing(d=2)
{
        
    difference()
    {
        translate([-35,-125,0]) resize([220,70,3]) import("import/SCALED_left_wing.stl");
        translate([5,10+2,0]) cylinder(h=10,d=d, center=true);
        translate([5,20+2,0]) cylinder(h=10,d=d, center=true);
        translate([5,40+2,0]) cylinder(h=10,d=d, center=true);
        translate([5,50+2,0]) cylinder(h=10,d=d, center=true);
        translate([0,0,1]) cube([10,70,10]);
    }

    difference()
    {
        translate([10,2,1]) cube([2,60,10]);
        translate([10,5+2,7]) rotate([0,90,0]) cylinder(h=10,d=d, center=true);
        translate([10,35+2,7]) rotate([0,90,0]) cylinder(h=10,d=d, center=true);
        translate([10,25+2,7]) rotate([0,90,0]) cylinder(h=10,d=d, center=true);
        translate([10,55+2,7]) rotate([0,90,0]) cylinder(h=10,d=d, center=true);
    }

}

