$fn = 180;
module pilot(h_l=1,h_m=11,h_u=3,d=1)
{
    translate([0,0,h_l]) cylinder(h=h_m,d=d);
    translate([0,0,h_l+h_m]) cylinder(h=h_u, d1=d,d2=0);
}

module cutter(points)
{
    for(i = [0 : len(points)-2])
    {
        t1 = [points[i][0],points[i][1],0];
        t2 = [points[i+1][0], points[i+1][1],0];
        
        // cutting part            
        hull()
        {
            translate(t1) pilot();
            translate(t2) pilot();
        }
        
        // supportins pars
        
        hull()
        {
            translate(t1) cylinder(h=1,d=1.5);
            translate(t2) cylinder(h=1,d=1.5);
        }
        
    }
}

module mouth()
{
    points =
    [
    [-15,11],
    [-12,3],    
    [-7,4],
    [-3,0],
    [0,2],
    [3,0],
    [7,4],
    [12,3],
    [15,11],
    [9,6.5],
    [7,8.5],
    [3,4.5],
    [0,7.5],
    [-3,4.5],
    [-7,8.5],
    [-9,6.5],
    [-15,11]
    ];
    
    cutter(points);
    
}

module nose()
{
    points=
    [
    [2.5,0],
    [0,4],
    [-2.5,0],
    [2.5,0]
    ];
    
    cutter(points);
}

module eye()
{
    points=
    [
    [5,0],
    [0,8],
    [-5,0],
    [5,0]
    ];
    
    cutter(points);
}


module connections()
{
    // mouth - eye
    // left
    hull()
    {
        translate([-15,11,0]) cylinder(h=1,d=1.5);
        translate([-17,17,0]) cylinder(h=1,d=1.5);
    }
    
    // mouth - eye
    // right
    hull()
    {
        translate([15,11,0]) cylinder(h=1,d=1.5);
        translate([17,17,0]) cylinder(h=1,d=1.5);
    }
    
    // mouth - nose
    hull()
    {
        translate([0,7,0]) cylinder(h=1,d=1.5);
        translate([0,13,0]) cylinder(h=1,d=1.5);
    }
    
    // eye - nose
    // right
    hull()
    {
        translate([7,17,0]) cylinder(h=1,d=1.5);
        translate([2.5,13,0]) cylinder(h=1,d=1.5);
    }
    
    // eye - nose
    // left
    hull()
    {
        translate([-7,17,0]) cylinder(h=1,d=1.5);
        translate([-2.5,13,0]) cylinder(h=1,d=1.5);
    }
    
    // eye - eye
    hull()
    {
        translate([12,25]) cylinder(h=1,d=1.5);
        translate([-12,25]) cylinder(h=1,d=1.5);
        
    }
    
    
}

module face()
{
    mouth();
    translate([0,13,0]) nose();
    translate([12,17,0]) eye();
    translate([-12,17,0]) eye();
    //connections();
}



face();
//pilot();
