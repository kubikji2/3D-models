$fn = $preview ? 36 : 90;

card_size = 50;
card_height = 45;
wt = 3;
tol = 0.2;
eps = 0.01;

module cover()
{
    difference()
    {
        _X = 2*card_size+5*wt+2*tol;
        _H = card_height + tol + 2*wt;
        _x = 2*card_size+2*tol+3*wt;
        _h = wt+card_height+tol;
        cube([_X,_X,_H]);
        // inner cut
        translate([tol+wt,tol+wt,-eps])
            cube([_x,_x,_h]);
        // text
        translate([_X/2,_X/2+10,_H-0.6+eps])
            linear_extrude(0.6)
                text("Karty proti", size = 12,
                    font = "Arial:style=Bold",
                    halign="center", valign="center");
        translate([_X/2,_X/2-10,_H-0.6+eps])
            linear_extrude(0.6)
                text("lidskosti", size = 12,
                    font = "Arial:style=Bold",
                    halign="center", valign="center");
        
        translate([0,_X,_h])
            rotate([180,0,0])
                rubber_band();
    }
}

//cover();

module guts()
{
    A = 5*wt+2*tol + 2*card_size;
    // lower part with text
    difference()
    {
        cube([A,A,wt]);
        translate([A/2,A/2+10,0.6-eps])
        rotate([0,180,0])
            linear_extrude(0.6)
                text("Karty proti", size = 12,
                    font = "Arial:style=Bold",
                    halign="center", valign="center");
        translate([A/2,A/2-10,0.6-eps])
        rotate([0,180,0])
            linear_extrude(0.6)
                text("lidskosti", size = 12,
                    font = "Arial:style=Bold",
                    halign="center", valign="center");
        rubber_band();
    }
    
    // inner holder
    translate([wt+tol,wt+tol,wt])
        difference()
    {
        // main cube
        a = 3*wt+2*card_size;
        h = card_height;
        cube([a,a,h]);
        
        // main cube cuts
        offs = [wt,2*wt+card_size];
        for(x_o = offs)
        {
            for(y_o = offs)
            {
                translate([x_o,y_o,0])
                    cube([card_size, card_size, card_height+eps]);
                
                _d = card_size/3;
                translate([card_size/2+x_o,a+eps,_d/2])
                hull()
                {
                    rotate([90,0,0])
                        cylinder(d=_d,h=a+2*eps);
                    translate([0,0,card_height])
                        rotate([90,0,0])
                            cylinder(d=_d,h=a+2*eps);
                }
                translate([-eps,card_size/2+x_o,_d/2])
                hull()
                {
                    rotate([90,0,90])
                        cylinder(d=_d,h=a+2*eps);
                    translate([0,0,card_height])
                        rotate([90,0,90])
                            cylinder(d=_d,h=a+2*eps);
                }
            }
               
        }           
    }
    
      
}

//guts();

module rubber_band()
{
    A = 5*wt+2*tol + 2*card_size;
    h = 5;
    translate([-2*h/3,A/2,h/3]) 
        rotate([0,135,0])
            cylinder(d=h,h=2*h);
    translate([A+2*h/3,A/2,h/3]) 
        rotate([0,135,180])
            cylinder(d=h,h=2*h);
    
    translate([A/2,-2*h/3,h/3]) 
        rotate([135,0,180])
            cylinder(d=h,h=2*h);
    translate([A/2,A+2*h/3,h/3]) 
        rotate([135,0,0])
            cylinder(d=h,h=2*h);
}