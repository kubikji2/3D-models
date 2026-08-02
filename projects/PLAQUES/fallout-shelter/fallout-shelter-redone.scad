eps = 0.01;
module sign()
{
    translate([-50.45,-11.9,0])
        render(20)
            import("import/fallout-shelter.stl");
}

module text()
{
    
    difference()
    {
        sign();
        // upper cut
        translate([0,33,-eps]) cube([150,200,10]);
        // lower cut
        translate([0,0,-eps]) cube([150,13,10]);
        // left cut
        
    }
}

module inverse_text()
{
    difference()
    {
        translate([7.5,13.5,1]) cube([135,18,4]);
        translate([0,0,0]) text();
        cube([200,200,10*eps]);
    }
}

module signNoText()
{
    sign();
    translate([7.5,7.5,0]) cube([135,25,5]);
}

module redone_sign()
{
    difference()
    {
        signNoText();
        translate([0,-5,eps]) inverse_text();
       
    }
}

//import("Fallout_Shelter.stl");
//text();
//signNoText();
scale([0.75,0.75,0.5]) redone_sign();
//inverse_text();