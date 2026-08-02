eps = 0.01;

module feet()
{
    translate([-100,-104.5,0])
    {
        import("spare_foot_front_1.stl");
        translate([30,0,0])
            import("spare_foot_front_2.stl");
        translate([60,0,0])
            import("spare_foot_rear_left.stl");
        translate([90,0,0])
            import("spare_foot_rear_right.stl");
    }
}

//feet();

// reduction parameters
x_i = 5.5;
x_o = 8;
y_i = 8.8;
y_o = 10.8;
z_i = 1.5;
z_o = 4;


module block()
{
    cube([x_o,y_i/2,z_o]);
    
    translate([0,y_o/2,0])
    hull()
    {
        translate([0,-1,0])
            cube([x_o,1,z_o]);
        translate([0,0,(z_o-z_i)/2])
            cube([x_o,(y_o-y_i)/2,z_i]);
    }
}

module reduction()
{
    difference()
    {
        _x = (x_o-x_i)/2;
        _y = (y_o-y_i)/2;
        _z = (z_o-z_i)/2;
        
        block();
        // left cut
        hull()
        {
            translate([-1,0,0])
                cube([1,y_o,z_o]);
            translate([0,0,_z])
                cube([_x,y_o,z_i]);            
        }
        
        // right cut
        hull()
        {
            translate([x_o,0,0])
                cube([1,y_o,z_o]);
            translate([x_o-_x,0,_z])
                cube([_x,y_o,z_i]);   
        }
        
        // lower cut
        hull()
        {
            translate([0,-1,0])
                cube([x_o,1,z_o]);
            translate([0,0,_z])
                cube([x_o,_y,z_i]);
            
        }
        
    }
}

//reduction();


module ending()
{
    difference()
    {
        reduction();
        translate([-eps,-eps,-eps])
            cube([x_o+2*eps,4,z_o+2*eps]);
    }
    translate([-2,4,0])
        cube([x_o+4,1,z_o]);
}

//ending();

