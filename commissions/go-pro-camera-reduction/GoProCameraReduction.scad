//std params
$fn = $preview ? 36 : 180;
tol = 0.1;
eps = 0.01;

// disk parameters
d_D = 32;
d_h = 5;
d_a = 15;
d_H = 10;

// camera nut diameter
cn_d = 8;
cn_h = 8.55;

// tightening bold parameters
tb_d = 5.5;
tb_D = 15;
tb_z = 15+tb_d/2;
tb_x = d_a/2-tb_d/2;
tb_t = 3;
tb_s = 3.1;

// nut parameters
tn_t = 3.5;
tn_d = 9;
tn_D = 12;

module go_pro_reduction()
{
    // lower part
    difference()
    {
        hull()
        {
            cylinder(d=d_D,h=d_h);
            c_off = -d_a/2;
            translate([c_off, c_off,0]) cube([d_a,d_a,d_H]);
        }
        translate([0,0,-eps])cylinder(d=cn_d,h=cn_h);
    }
    
    y_off = -tb_s-tb_t/2;
    translate([tb_x,y_off,tb_z])
    {
        difference()
        {
            hull()
            {
                rotate([90,0,0])cylinder(d=tb_D, h=tb_t);
                translate([-d_a+tb_d/2,-tb_t,-tb_D/2-1])
                    cube([d_a,tb_t,1]);
            }
            rotate([90,0,0])
            translate([0,0,-eps]) cylinder(d=tb_d,h=tb_t+2*eps);
        }
    }
    translate([tb_x,y_off+tb_s+tb_t,tb_z])
    {
        difference()
        {
            hull()
            {
                rotate([90,0,0])cylinder(d=tb_D, h=tb_t);
                translate([-d_a+tb_d/2,-tb_t,-tb_D/2-1])
                    cube([d_a,tb_t,1]);
            }
            rotate([90,0,0])
            translate([0,0,-eps]) cylinder(d=tb_d,h=tb_t+2*eps);
        }
    }
    
    translate([tb_x,y_off+2*(tb_s+tb_t),tb_z])
    {
        difference()
        {
            hull()
            {
                rotate([90,0,0])cylinder(d=tb_D, h=tb_t);
                translate([-d_a+tb_d/2,-tb_t,-tb_D/2-1])
                    cube([d_a,tb_t,1]);
            }
            rotate([90,0,0]) translate([0,0,-eps])
                cylinder(d=tb_d,h=tb_t+2*eps);
        }
    }
    
    translate([tb_x,y_off+2*(tb_s+tb_t)+tb_t,tb_z])
    {
        difference()
        {
            hull()
            {
                translate([0,-tb_t,0]) rotate([90,0,0])
                    cylinder(d=tb_D, h=tb_t);
                rotate([90,0,0])
                    cylinder(d=tn_D, h=tn_t);
            }
            rotate([90,0,0]) translate([0,0,-eps])
                cylinder(d=tn_d,h=tn_t+2*eps, $fn=6);
            
            rotate([90,0,0]) translate([0,0,tb_t+eps])
                cylinder(d=tb_d,h=tb_t+2*eps);
        }
    }

                
        
}

go_pro_reduction();