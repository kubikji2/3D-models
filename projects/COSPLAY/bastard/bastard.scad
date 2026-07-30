$fn = $preview ? 36 : 180;
sf_mi = 0.94;
sf = 0.85;
eps = 0.01;
tol = 0.3;

use<belt-hook-holder.scad>

use<sights.scad>

use<burst-selector.scad>

include<screw-data.scad>

module ammo()
{
    // STATUS: -NONE-
    // Nothing to be done here
    scale([sf,sf,sf]) %import("import/Ammo.stl");
}


module barrel_old()
{
    // STATUS: DONE -- if scale is fixed
    // all model based solely on the scale of the whole model
    %scale([sf,sf,sf]) import("import/Barrel.stl");
    difference()
    {
        cylinder(d=30,h=235);
        cylinder(d=7.9,h=100);
    }
    
}

//barrel_old();


module barrel_band()
{
    // STATUS: -NONE-
    // not sure what this is, but probably obsolate as band will be added directly
    scale([sf,sf,sf]) %import("import/Barrel_Band.stl");
}


module magazine_old()
{
    sc_b = 1;
    sc = 1;
    // STATUS: OBSOLETE
    // re-modeled from scratch
    scale([sc_b,sc_b,sc]) import("import/Magazine.stl");
    // 7.62x39
    //% rotate([90,0,0]) import("import/tmp_bullet.STL");
    //%ammo();
}



// 7.62 dimensions
// neck of bullet diameter with tolerance
n_d = 8.7;
// outer diameter with tolerance
o_d = 11.5;
// inner diameter with tolerance
i_d = 9.7;
// bullet neck to butt height
b2n_h = 32;
// bullet butt height
b_h = 1;
// bullet neck height
n_h = 2;

// box dimenstions
// wall thickness
t = 2;
// height
h = 36;
// bullet chamber size (depth of magazine minus wall thickness)
d = sqrt(0.75*o_d*o_d)+o_d;
// bullet chamber lenght (width of magazine minus wall thickness)
// note: bullet is for 2*15 bullets
l = 15.5*o_d;


module bullet_hole()
{
    // Hole for single bullet used for modeling the magazine
       
    // under_butt
    translate([0,0,-b_h]) %cylinder(d=o_d,h=b_h);
    // butt hole - cylinder
    translate([0,0,-eps]) cylinder(d=i_d,h=b_h+2*eps);
    // main body hole
    difference()
    {
        translate([0,0,b_h+b2n_h/2+eps])
            cube([o_d+(2*eps),o_d+(2*eps),b2n_h+2*eps], center=true);
        translate([0,-o_d/2,b_h+b2n_h+o_d/4])
            rotate([45,0,0]) cube([2*o_d,2*o_d,o_d], center = true);
    }
    // neck support
    translate([0,0,b_h+b2n_h/2-eps])
        cylinder(h=b2n_h,d=n_d+2*eps);
    // upper cut
    translate([0,0,b_h+b2n_h+n_h+h/2-eps])
        cube([o_d+2*eps,o_d+2*eps,h+2*eps], center=true);
    // cutting the half of support
    translate([-o_d/2-eps,0,-eps])
        cube([o_d+2*eps,o_d/2,h+2*eps]);
    // bullet hole cut
    translate([-o_d/3,-o_d/2-o_d/3,h/6])
        cube([o_d/1.5,o_d/1.5,h/2]);
    
}

//bullet_hole();

//magazine body dimensions
m_H = h;
m_D = d + 2*t;
m_L = l + 2*t;

module magazine()
{   
    // STATUS: SECOND ITERATION
    // newly re-modeled magazine for 7.62x39 bullets
    translate([-m_L/2,-m_D/2,0])
    difference()
    {
        // main body
        cube([m_L,m_D,m_H]);
        
        translate([t+o_d/2,t+o_d/2,0])
        for(i=[0:14])
        {
            translate([o_d*i,0,0]) bullet_hole();
        }
        
        
        translate([t+o_d,t+d-o_d/2,0])
        for(i=[0:14])
        {
            translate([o_d*i,0,0]) rotate([0,0,180]) bullet_hole();
        }    
        
        
    }    
    
    //translate([m_L,0,0]) %magazine_old();
    //translate([0,m_D,0]) %magazine_old();
}

//magazine();

ymi_off = 6;

///////////////////////////
//                       //
//   MAGAZINE INSERTOR   //
//                       //
///////////////////////////
module magazine_insertor()
{
    // STATUS: FIRST ITERATION DONE
    // Part of bastard used for insering magazine
    
    // basic offset of the magazine insertor
    x_off = 31.2;
    y_off = 22.5;
    z_off = 15.5+0.5;
    translate([x_off, y_off, z_off]) rotate([90,0,-90])
        scale([sf_mi,sf_mi,sf_mi]) import("import/Magazine_Well.stl");
    
    // bullet height with offset
    blt_h = 58;
    // butt offset
    b_off = 2;
    // offset for magazine to run smoothly
    m_off = 0.25;
    
    // x dimension of insertor body
    i_x = blt_h+2*t+2*m_off;
    // y dimension of insertor body
    i_y = 48;
    // z dimension of insertor body
    i_z = d+4*t+2*m_off-0.25; 
    
    //translate([0,0,t+m_off-blt_h/2])
    /*
    translate([i_x-t-m_off-b_off,0,m_D/2+t+m_off])
        rotate([-90,0,90]) %import("../new_files/magazine_new_test.stl");
    */
    
    //translate([-i_x/2,-i_y/2,-i_z/2])
    difference()
    {
        union()
        {
   
            x_cmp1 = 7.8;
            x_cmp2 = 4;
            translate([-x_cmp1,0,0])
            // main body
            cube([i_x+x_cmp1+x_cmp2, i_y, i_z]);
            
            // front hole cover
            xs = 1.9+0.9;
            ys_off = 0;
            zs_off = 0.5;
            translate([i_x+x_cmp2,ys_off,0]) cube([xs,i_y-2*ys_off,i_z-2*zs_off+1.2]);
            
            // back hole cover dimensions
            xb = 4.4;
            yb = i_y-2*ys_off;
            zb = 28;
            xb_off = -5-xb;
            yb_off = 0;
            zb_off = 0;
            translate([xb_off,yb_off,zb_off]) cube([xb,yb,zb]);
            
            // side hole cover
            xsi = i_x+x_cmp1+x_cmp2+2;
            ysi = 2.7;
            zsi = 2;
            xsi_off = -x_cmp1;
            ysi_off = 0;
            zsi_off = i_z-1;
            translate([xsi_off,ysi_off,zsi_off]) cube([xsi,ysi,zsi]);
            
            // side front cover
            xsf = 2;
            ysf = 1;
            zsf = i_z+2;
            xsf_off = i_x+x_cmp2;
            ysf_off = 0;
            zsf_off = 0;
            translate([xsf_off,ysf_off,zsf_off]) cube([xsf,ysf,zsf]);
            
            
        }       
        // cut for empty magazine
        x1 = m_H+2*m_off;
        y1 = i_y+2*eps;
        z1 = m_D+2*m_off;
        translate([i_x-x1-t-b_off,-eps,t]) cube([x1,y1,z1]);
        
        // cut for full magazine
        x2 = blt_h+2*m_off;
        y2 = i_y-t+2*eps;
        z2 = d+2*m_off;
        translate([i_x-x2-t,-eps,t+t]) cube([x2,y2,z2]);
       
        // pre barrel connector
        mcx_off = -20;
        mcy_off = 30;
        mcz_off = 20;
        translate([mcx_off,mcy_off,mcz_off]) rotate([0,0,90]) connector_hole();
        translate([mcx_off,mcy_off,mcz_off-13]) rotate([0,0,90]) connector_hole();
        
    }  
    
}

//magazine_insertor();


// main body extention
// this part is added to both cut the handle and also help it support it
mbe_y_off_n = 43.5;
mbe_x = 33.6;
mbe_y = 200+mbe_y_off_n;
mbe_z = 23.1;
mbe_x_off = -mbe_x+6.5;
mbe_y_off = -mbe_y_off_n-5;
mbe_z_off = 13;

module main_body_support()
{
    
    diff = 4;
// upper part

    translate([0,-mbe_y_off_n,0])
    scale([1,mbe_y/10,1])
    {
        translate([0,mbe_y_off_n+10,0])
        difference()
        {
            scale([sf,sf,sf]) import("import/Plain_Main_Body_cutted.stl");
            // upper cut
            translate([-mbe_y_off_n-mbe_y/2,-mbe_y,mbe_z+mbe_z_off])
                cube([mbe_y,mbe_y,2*mbe_z]);
            //lower back cut
            translate([ -mbe_y_off_n-mbe_y/2,
                        -mbe_y-mbe_y_off_n-10,
                         mbe_z_off])
                cube([mbe_y,mbe_y,2*mbe_z]);
            //lower front cut
            translate([-mbe_y_off_n-mbe_y/2,-mbe_y_off_n-0.19,mbe_z_off])
                cube([mbe_y,mbe_y,2*mbe_z]);
                       
        }
               
    }

}

// lower cylidric staff on the bottom of the gun
module lower_cylinder()
{
    diff = 4;
    d_i = 30;
    d_o = 35;
    h = 22;
    translate([0,0,13.6])
    difference()
    {
        // main body
        translate([-10.2,-17.5,8.5]) rotate([90,0,0])
        hull()
        {
            cylinder(d=d_o,h=h);
            translate([0,0,diff]) cylinder(d=d_i,h=h);
        }
        // cutting plane
        translate([-50,-50,0]) cube([100,100,50]);
        // connecting pillar
        
        translate([-12,-25,0])
        {
            translate([0,0,-c_l/4]) rotate([-90,0,0]) connector_hole();
            translate([0,-3*diff,-c_l/4]) rotate([-90,0,0]) connector_hole();
        }
        
    }
}

//translate([0,0,-5]) lower_cylinder();

//main_body_support();

// connectors
// connector diameter
c_d = 7;
// connector length
c_l = 20;

// connector
module connector_hole()
{
    rotate([90,0,0]) cylinder(d=c_d,h=c_l);
}

module connector_part()
{
    cylinder(d=c_d-tol,h=c_l-4*tol);
    
}

//connector_part();




// NOTE: zaver is made of the four cyliders wrapped using
// cock hole diamater of zever
ckh_d = 7;
// lower (bigger) length of the cylinder
ckh_L = 27;
// vertival distance of the cylinder centers
ckh_dist = 18.5;
// length of the upper cylinder
// offset of the cock hole cut
ckh_L_off = 1;

// the convex hull operation.
// x coord of the most right point in the hole of zaver
ckh_x = -49.75+ckh_L;
// y coord of the most front position of zaver
ckh_y1 = -44.5;
// y coord of the most back position of zaver
ckh_y2 = -178;
// distance from the most front part of zaver to the most back one
ckh_y = ckh_y1-ckh_y2+ckh_d;
// horizontal alignement of zaver
ckh_z = 48;
// right and left offset of the upper part
ckh_xr = 5.5;
ckh_xl = 5.5;

// cock lever front and back positions
ck_f = 0;
ck_b = 0;


module cock_hole()
{
    t_off = 0;
    // inner cut
    hull()
    {
        // LOWER parts
        // the most front position of cokckstick
        translate([ckh_x,ckh_y1+t_off,ckh_z]) rotate([0,90,0])
            cylinder(d=ckh_d, h=ckh_L);
        // the most rear position of cokckstick
        translate([ckh_x,ckh_y2,ckh_z]) rotate([0,90,0])
            cylinder(d=ckh_d, h=ckh_L);
        
        // UPPER parts
        // the upper cut pars of cock hole
        translate([ckh_x+ckh_xr,ckh_y1+ckh_d/2,ckh_z+ckh_dist])
            rotate([90,90,0]) cylinder(d=1,h=ckh_y);
        translate([ckh_x+(ckh_L-ckh_xl),ckh_y1+ckh_d/2,ckh_z+ckh_dist])
            rotate([90,90,0]) cylinder(d=1,h=ckh_y);
        
    }
    // cut for cockhole, only lower part
    hull()
    {
        h = ckh_L + ckh_L_off;
        // the most front position of cokckstick
        translate([ckh_x,ckh_y1+t_off,ckh_z]) rotate([0,90,0])
            cylinder(d=ckh_d, h=h);
        // the most rear position of cokckstick
        translate([ckh_x,ckh_y2,ckh_z]) rotate([0,90,0])
            cylinder(d=ckh_d, h=h);
        
    }
}
//cock_hole();

// connectors between main body and handle
cmb2h_x_off = -11;
cmb2h_y1_off = -140;
cmb2h_y2_off = -170;
cmb2h_z_off = mbe_z_off-c_l/2;

// bolts between main body and the secondary handle
// inner bolt diameter
b_d = 8;
// bolt head and nut thickness
b_t = 5;
// outer bold diameter
b_D = 16;
// bold length
b_l = 2*mbe_x;
b_x_off = -2*b_l/3;
b_y1_off = 50;
b_y2_off = 180;
b_z_off = mbe_z_off+mbe_z/2+2;

module bolt()
{
    
    l = 45 + 2*b_t;
    d = b_d - 2*tol;
    // main part
    cylinder(d=d,h=l);
    // head
    cylinder(d=b_D,h=b_t,$fn=6);
    
}

//bolt();

module nut()
{
    difference()
    {
        cylinder(d=b_D, h=b_t, $fn=6);
        translate([0,0,-eps]) cylinder(d=b_d-2*tol, h=b_t+2*eps);
    }
}

//translate([20,0,0]) nut();



module cock_lever()
{
    scale([sf,sf,sf]) import("import/Main_Body_reloader.stl");
}


cp_a = ckh_d-tol;
cp_xoff = 0.5;
module cock_cover()
{
     
    cp_x = 5-tol;
    cp_y = 65-ckh_d/2;
    cp_z = cp_a;
    // main frame
    translate([cp_a-cp_x-cp_xoff,0,0])cube([cp_x,cp_y,cp_z]);
    translate([cp_a-cp_x-cp_xoff-tol,65-ckh_d/2,ckh_d/2]) rotate([0,90,0]) cylinder(d=ckh_d,h=5);
    
    
}

module cock_part()
{
    // cock part
    translate([ckh_x+ckh_L-cp_a,ckh_y1-65,ckh_z-ckh_d/2+tol]) cock_cover();
    // front part
    zwt = 5;
    h = ckh_L-tol-cp_xoff;
    //
    swt = 5;
    // main support
    ads_xo = ckh_x;
    ads_yo = ckh_y1-swt/2;
    ads_zo = ckh_z-2;
    
    difference()
    {
        translate([ads_xo,ads_yo,ads_zo])
        hull()
        {
            
            // cube
            //translate([tol-cp_xoff+tol,-swt/2,-swt/2+tol+1]) cube([h,swt,swt]);
            translate([tol-cp_xoff+tol,-ckh_d/2+swt/2,ckh_d/2-swt/2+tol+1])
                rotate([0,90,0]) cylinder(h=h,d=ckh_d);
                //cube([h,swt,swt]);
            // upper cylinder
            translate([ckh_xr+1,swt/2, ckh_dist+1+tol])
                rotate([90,0,0]) cylinder(d=1,h=swt);
            translate([(ckh_L-ckh_xl-1),swt/2, ckh_dist+1+tol])
                rotate([90,0,0]) cylinder(d=1,h=swt);
        }
        // hole for the parts
        hfp_x = mbe_x_off+mbe_x/2;
        hfp_y = ads_yo+2.5+eps;
        hfp_z = mbe_z_off + 40;
        // hole for screw
        translate([hfp_x, hfp_y, hfp_z])
            rotate([90,0,0]) cylinder(d=10+tol,h=10+2*eps);
    }
    
    // front part
    difference()
    {
        ads_yo = ckh_y1-swt/2-45;
        translate([ads_xo,ads_yo,ads_zo])
        hull()
        {
            
            // cube
            translate([tol-cp_xoff+tol,-swt/2,-swt/2+tol+1]) cube([h,swt,swt]);
            // upper cylinder
            translate([ckh_xr+1,swt/2, ckh_dist+1+tol])
                rotate([90,0,0]) cylinder(d=1,h=swt);
            translate([(ckh_L-ckh_xl-1),swt/2, ckh_dist+1+tol])
                rotate([90,0,0]) cylinder(d=1,h=swt);
        }
        // hole for the parts
        hfp_x = mbe_x_off+mbe_x/2;
        hfp_y = ads_yo+2.5+eps;
        hfp_z = mbe_z_off + 40;
        // hole for screw
        translate([hfp_x, hfp_y, hfp_z])
            rotate([90,0,0]) cylinder(d=10+tol,h=5+2*eps);
    }
    
    //cover
    hull()
    {
        translate([ckh_x+(ckh_L-ckh_xl)-0.5,ckh_y1,ckh_z+ckh_dist-0.5])
            rotate([90,90,0]) cylinder(d=1,h=65);

        cp_x = 2-tol;
        cp_y = 65;
        cp_z = 4;
        // main frame
        translate([ckh_x+ckh_L-cp_a-0.5,ckh_y1-65,ckh_z-ckh_d/2+tol-3])
            translate([cp_a-cp_x,0,6]) cube([cp_x,cp_y,cp_z]);
        
    }
     
    // cock_lever
    difference()
    {
        cock_lever();
        translate([ckh_x+ckh_L-cp_a/2,ckh_y1-62+1,ckh_z-ckh_d/2+tol-cp_a]) 
            cube([5*cp_a,cp_a,cp_a]);
        translate([ckh_x+ckh_L-cp_a/2,ckh_y1-62+1,ckh_z-ckh_d/2+tol+cp_a]) 
            cube([cp_a,cp_a,cp_a]);
    }
    
}

//cock_part();

module main_body()
{
    // just a show of the main body
    //%scale([sf,sf,sf]) import("import/Main_Body.stl");



// back part with reciever
    // back part cutting plane
    bp_cp_z_base = mbe_z_off+0.6;
    // z size of the reciever
    bp_z = 56.5;
    // z position of the cutting plane 
    bp_cp_z = bp_z/2;
    
    // back part y dimension
    bp_y = 0;
    // back part y offset
    bp_y_off = 0;
        
    // height of connectors for upper and lower part
    bp_c_h = 2;
    // diameter
    bp_c_d = 5;
    
    
  // lower part
    %translate([0,-4.2,0])
    difference()
    {
        //front part of main body
        scale([sf,sf,sf])
            render(20)
                import("import/Plain_Main_Body_cutted.stl");
        
        // connectors for middle part
        // hole for left connector
        translate([0,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        // hole for right connector
        translate([-mbe_z+2,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        
        // connectors for the handle
        translate([cmb2h_x_off,cmb2h_y1_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
        translate([cmb2h_x_off,cmb2h_y2_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
        
        // cutting upper part a_ = 200;
        translate([-a/2,-a,bp_cp_z_base+bp_cp_z])
            cube([a,a,a]);
        
        // hole for stock
        hfs_d = b_d; // diameter is the same as any other bolts
        hfs_x = mbe_x_off;
        hfs_y = -182+hfs_d/2;
        hfs_z = bp_cp_z_base + bp_cp_z - hfs_d;
        translate([hfs_x,hfs_y,hfs_z]) rotate([0,90,0])
            cylinder(h=mbe_x,d=hfs_d);
        
        // hole for strip screw
        hfss_y = hfs_y + 35;
        translate([hfs_x,hfss_y,hfs_z]) rotate([0,90,0])
            cylinder(h=mbe_x,d=hfs_d);
            
        // hole of the burst switcher
        bsw_x = 23;
        bsw_y = 27;
        bsw_z = 20;
        bsw_t = 5;
        bsw_x_off = -bsw_x+mbe_x_off+bsw_x+bsw_t;
        bsw_y_off = -bsw_y-48-5;
        bsw_z_off = mbe_z_off+bp_cp_z-bsw_z+1;
        
        ms_d = 3.5;
        
        translate([bsw_x_off,bsw_y_off,bsw_z_off])
        {
            cube([bsw_x,bsw_y,bsw_z]);
            
            swh_x = -bsw_t+eps;
            swh_y = bsw_y/2;
            swh_z = bsw_z-1.5*ms_d;
            // hole for screw
            translate([swh_x,swh_y,swh_z])
            rotate([0,90,0])
            {
                cylinder(h=bsw_t+eps,d=ms_d+2+2*tol);
                
                // magnet holes
                l1_off = 8;
                l2_off = 4;
                a_off = 30;
                translate([0,0,bsw_t-1.1])
                for(i=[-1:1])
                {
                    rotate([0,0,a_off*i]) translate([l1_off,0,0])
                        cylinder(h=1.1,d=3.3);
                    rotate([0,0,a_off*i])
                        translate([l1_off+l2_off,0,0])
                            cylinder(h=1.1,d=3.3);
                }
            }
            
            
            
        }
                
    }
    
    // connectors for the lower and upper part
    bpc_l = mbe_x_off+bp_c_d*1.5;
    bpc_r = mbe_x_off+31-bp_c_d;
    bpc_f = -46-bp_c_d/2;
    bpc_fm = bpc_f - 40;
    bpc_b = bpc_f-140+bp_c_d/2;
    bpc_bm = bpc_b + 40;
    
    %union()
    {
        // front
        translate([bpc_l,bpc_f,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        translate([bpc_r,bpc_f,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        // middle front
        translate([bpc_l,bpc_fm,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        translate([bpc_r,bpc_fm,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        // middle back
        translate([bpc_l,bpc_bm,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        translate([bpc_r,bpc_bm,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        // back
        translate([bpc_l,bpc_b,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        translate([bpc_r,bpc_b,bp_cp_z_base+bp_cp_z])
            cylinder(h=bp_c_h-tol, d=bp_c_d-tol);
        
        // the hook holder
        hh_x = mbe_x_off+0.5;
        hh_y = -182+17+45;
        hh_z = bp_cp_z_base + bp_cp_z-14;
        translate([hh_x,hh_y,hh_z]) rotate([0,-90,0])
            belt_hook_holder();
    }
    
    //# translate([-10,-175,bp_cp_z_base]) cube([10,10,bp_z]);
    
    // upper part
    %translate([0,-4.2,0])
    difference()
    {
        //front part of main body
        scale([sf,sf,sf])
            render(10)
                import("import/Plain_Main_Body_cutted.stl");
        
        // connectors for middle part
        // hole for left connector
        translate([0,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        // hole for right connector
        translate([-mbe_z+2,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        
        // cutting cock hole
        cock_hole();
        
        // connectors for the handle
        translate([cmb2h_x_off,cmb2h_y1_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
        translate([cmb2h_x_off,cmb2h_y2_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
        
        // cutting upper part a_ = 200;
        translate([-a/2,-a,bp_cp_z_base+bp_cp_z-a])
        cube([a,a,a]);
        
        // lower connectors
        translate([0,4.2,-eps])
        union()
        {
            // front
            translate([bpc_l,bpc_f,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            translate([bpc_r,bpc_f,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            // middle front
            translate([bpc_l,bpc_fm,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            translate([bpc_r,bpc_fm,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            // middle back
            translate([bpc_l,bpc_bm,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            translate([bpc_r,bpc_bm,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            // back
            translate([bpc_l,bpc_b,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
            translate([bpc_r,bpc_b,bp_cp_z_base+bp_cp_z])
                cylinder(h=bp_c_h, d=bp_c_d);
        }
        
        // hole for unjamming handle
        // diameter of unjamming handle hole
        //ujh_d = 10+2*tol;
        ujh_d = 10+tol; // updated version
        // length of unjamming handle hole
        ujh_l = 6;
        
        ujh_x = mbe_x_off+mbe_x/2;
        ujh_y = -181.4;
        ujh_z = mbe_z_off+ujh_d/2 + 35;
        
        translate([ujh_x,ujh_y,ujh_z]) rotate([90,0,0]) cylinder(h=ujh_l, d=ujh_d);
        
        // correction for top part saddle
        tps_y = 78;
        tps_xo = mbe_x_off;
        tps_yo = -58.25-tps_y;
        tps_zo = mbe_z_off+bp_z-1.5;
        translate([tps_xo,tps_yo,tps_zo])
            cube([50,tps_y,10]);
        
        // hole for the reciever accessories bolt
        msc_d = ms_d;
        msc_h = 20;
        msc_H = mn_t+0.5;
        msc_D = mh_d;
        msc_x = mbe_x_off+mbe_x/2;
        msc_y = -34.6;
        msc_z = mbe_z_off + 40;
        // hole for screw
        translate([msc_x, msc_y, msc_z])
            rotate([90,0,0]) cylinder(d=msc_d,h=msc_h);
            
        // access hole on the bottom of this part
        ah_t = 5;
        ah_x = mbe_x-2*ah_t;
        ah_y = 21;
        ah_z = 9.5;
        ah_xo = mbe_x_off+ah_t;
        ah_yo = ujh_y;
        ah_zo = bp_cp_z_base+bp_z/2-eps;
        difference()
        {
            translate([ah_xo, ah_yo, ah_zo])
                cube([ah_x, ah_y, ah_z]);
            translate([0,4.2,0])
            {
                translate([bpc_l,bpc_b,bp_cp_z_base+bp_cp_z])
                    cylinder(h=bp_c_h+2, d=bp_c_d+2);
                translate([bpc_r,bpc_b,bp_cp_z_base+bp_cp_z])
                    cylinder(h=bp_c_h+2, d=bp_c_d+2);
            }
        }
    
    }
    %
    union()
    {
        sig_x = mbe_x_off+mbe_x/2;
        sig_y = -155;
        sig_z = mbe_z_off + bp_z+0.45;
        translate([sig_x,sig_y,sig_z]) rotate([0,0,180])
            sight_connectors(tol=tol);
        // additional support for the unjamming handle bolt       
        difference()
        {
            // main support
            ads_xo = ckh_x;
            ads_yo = ckh_y2+21-5;
            ads_zo = ckh_z-2;
            translate([ads_xo,ads_yo,ads_zo])
            hull()
            {
                zwt = 5;
                h = ckh_L-zwt;
                //
                swt = 5;
                // cube
                translate([0,-swt/2,-swt/2]) cube([h,swt,swt]);
                // upper cylinder
                translate([ckh_xr,swt/2, ckh_dist+2+tol])
                    rotate([90,0,0]) cylinder(d=1,h=swt);
                translate([(ckh_L-ckh_xl-zwt),swt/2, ckh_dist+2+tol])
                    rotate([90,0,0]) cylinder(d=1,h=swt);
            }
            // hole for the parts
            hfp_x = mbe_x_off+mbe_x/2;
            hfp_y = ads_yo+2.5+eps;
            hfp_z = mbe_z_off + 40;
            // hole for screw
            translate([hfp_x, hfp_y, hfp_z])
                rotate([90,0,0]) cylinder(d=10+tol,h=5+2*eps);
         }
    }
    
    // TODO unjamming handle
    
    // TODO hook
    /*
    sh_D = 10;
    sh_d = 2;
    sh_H = 4;
    
    translate([mbe_x_off+0.5,-150,mbe_z_off+33.1825])
    rotate([0,-90,0])
    difference()
    {
        rotate([0,0,30])cylinder(h=sh_H,d=sh_D,$fn=6);
        translate([-sh_D/2,0,sh_H-sh_d]) #rotate([0,90,0]) cylinder(h=sh_D, d=sh_d);
    }
    */
    
    
    
// MIDDLE PART
    y_off = 35.5;
    a = 200;
    
// magazine well middle part

    // adding magazine insertor
    xmi_off = -38.5;
    ymi_off = 25.85;
    zmi_off = 36.75;
    difference()
    {
        translate([xmi_off,ymi_off,zmi_off])
            rotate([0,0,-90]) magazine_insertor();
        //cutting hole for screw holding cock-lever part in the upper reciever
        msc_d = ms_d;
        msc_h = 20;
        msc_H = mn_t+0.5;
        msc_D = mh_d;
        msc_x = mbe_x_off+mbe_x/2;
        msc_y = -34.6;
        msc_z = mbe_z_off + 40;
        // hole for screw
        translate([msc_x, msc_y, msc_z])
            rotate([90,0,0]) cylinder(d=msc_d,h=msc_h);
        // hole for bolt head
        translate([msc_x, msc_y+75, msc_z])
            rotate([90,0,0]) cylinder(d=msc_D,h=msc_H+75);
        
    }
    
    // lower part
    // cutting holes into the lower support
    
    difference()
    {
        // main body support
        translate([0,-eps,0]) main_body_support();        
        // hole for left connector
        translate([0,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        // hole for right connector
        translate([-mbe_z+2,-mbe_y_off_n+c_l/2,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        
        // cutting the most front part
        translate([-a/2,y_off,-a/2]) cube([a,a,a]);
        
        // cutting holes for front part
        translate([0,+c_l/2+y_off,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
        // hole for right connector
        translate([-mbe_z+2,+c_l/2+y_off,mbe_z_off+mbe_z/2+c_d/2]) connector_hole();
      
        // cut for that strange thing below gun
        translate([-12,-25, 21])
        {
            translate([0,0,-c_l/2]) rotate([-90,0,0]) connector_hole();
            translate([0,-12,-c_l/2]) rotate([-90,0,0]) connector_hole();
        }
        
                
    }


// front related stuff   

// pre-barell with cooler and strips
    pb_rx = -90;
    pb_ry = 0;
    pb_rz = 0;
    pb_tx = pb_D/2-26.75;
    pb_ty = 35.5;
    pb_tz = pb_D/2+pb_bz_off+36-pb_bz_off;
    
    %difference()
    {
        translate([pb_tx,pb_ty,pb_tz]) rotate([pb_rx,pb_ry,pb_rz])
            pre_barell();
        
        // middle part connector
        mcx_off = pb_tx+1.75;
        mcy_off = pb_ty+c_l/2;
        mcz_off = pb_tz+4.25;
        translate([mcx_off,mcy_off,mcz_off]) rotate([0,0,0]) connector_hole();
        translate([mcx_off,mcy_off,mcz_off-13]) rotate([0,0,0]) connector_hole();
        
    }
    
    // barrel cooler holder connectors
    con_d = pb_sh_d;        
    con_h = pb_sh_h;
    con_off = (pbh_t - con_d)/2;
    con_tx = pb_D/2-con_off+tol/2;
    con_ty = pbh_f_off+con_off+con_d/2;
    con_tz = pb_D/2+pb_bz_off+tol;
    
// front support part
    %difference()
    {
        // main body support
        translate([0,-eps,0]) main_body_support();
        
        // main body upper cut
        translate([ -mbe_y_off_n-mbe_y/2,
                    0,
                    mbe_z+mbe_z_off-pb_bz_off])
            cube([mbe_y,mbe_y,2*mbe_z]);
        
        // main body hole for left connector
        translate([ 0,
                    -mbe_y_off_n+c_l/2,
                    mbe_z_off+mbe_z/2+c_d/2])
            connector_hole();
        
        // hole for right connector
        translate([ -mbe_z+2,
                    -mbe_y_off_n+c_l/2,
                    mbe_z_off+mbe_z/2+c_d/2])
            connector_hole();
        
        
        // cutting holes for bolts in secondary handle
        translate([b_x_off,b_y1_off,b_z_off]) rotate([0,90,0])
            cylinder(d=b_d,h=b_l);
        translate([b_x_off,b_y2_off,b_z_off]) rotate([0,90,0])
            cylinder(d=b_d,h=b_l);
        
        // cutting the most front part
        translate([-a/2,y_off-a+2*eps,-a/2]) cube([a,a,a]);
        
        // cutting holes for front part
        translate([0,+c_l/2+y_off,mbe_z_off+mbe_z/2+c_d/2])
            connector_hole();
        // hole for right connector
        translate([-mbe_z+2,+c_l/2+y_off,mbe_z_off+mbe_z/2+c_d/2])
            connector_hole();
                
    }
    
    
    // front part connector the barrel
    ctx_off = pb_tx;
    ctx_r = con_tx;
    ctx_l = -con_tx;
    cty = pb_ty+con_ty;
    ctz = pb_tz-con_tz;
    
    // front part upper connectors
    %union()
    {
        // first left hole
        translate([ctx_off+ctx_l,cty,ctz]) cylinder(d=con_d,h=con_h);
        // first right hole
        translate([ctx_off+ctx_r,cty,ctz]) cylinder(d=con_d,h=con_h);
        
        // second left hole
        translate([ctx_off+ctx_l,cty+pb_sh2-pbh_f_off,ctz])
            cylinder(d=con_d,h=con_h);
        // second right hole
        translate([ctx_off+ctx_r,cty+pb_sh2-pbh_f_off,ctz])
            cylinder(d=con_d,h=con_h);
            
            
        // third left hole
        translate([ctx_off+ctx_l,cty+pb_sh3-pbh_f_off,ctz])
            cylinder(d=con_d,h=con_h);
        // third right hole
        translate([ctx_off+ctx_r,cty+pb_sh3-pbh_f_off,ctz])
            cylinder(d=con_d,h=con_h);
    }

// barrel
    b_rx = pb_rx;
    b_ry = pb_ry;
    b_rz = pb_rz;
    b_tx = pb_tx;
    b_ty = pb_ty+pb_H+pb_h+10;
    b_tz = pb_tz;
    %translate([b_tx,b_ty,b_tz]) rotate([b_rx,b_ry,b_rz])
        barell();
    
    
    
}

//main_body();

module hand_guard()
{
    //STATUS: READY TO TEST
    // secondaryhandle
    difference()
    {
        // handle
        //scale([sf,sf,sf]) import("import/Main_Body_handle.stl");    
        scale([sf,sf,sf])
            translate([0,22.5,2.5])
                import("import/secondary-handle.stl");    
        
        // main body cut
        translate([ mbe_x_off-tol,
                    mbe_y_off_n-8,
                    mbe_z_off-4*tol+1.5])
            cube([mbe_x+2*tol,mbe_y-83,2*mbe_z]);
        
        // upper part cut
        translate([ mbe_x_off-mbe_x/2,
                    mbe_y_off+mbe_y_off_n,
                    mbe_z_off+mbe_z-1])
            cube([2*mbe_x+2*tol,mbe_y,2*mbe_z-1]);
        
        // horizontal bolts
        translate([b_x_off,b_y1_off,b_z_off])
            rotate([0,90,0])
                cylinder(d=b_d,h=b_l);
        translate([b_x_off,b_y2_off,b_z_off])
            rotate([0,90,0])
                cylinder(d=b_d,h=b_l);
            
    }
    
}

//%hand_guard();

h_x = 0;
h_y = 0;
h_z = 0;
h_x_off = -11;
h_y_off = -165;
h_z_off = mbe_z_off;

t_x_off = -11;
t_y_off = -103;
t_z_off = mbe_z_off;

module grip()
{
    // STATUS: READY to test
    difference()
    {
        // handle
        translate([h_x_off, h_y_off, h_z_off]) rotate([0,180,0]) 
            scale([sf,sf,sf]) import("import/Pistol_Grip_without_Trigger_.stl");
        // trigger cut
        translate([t_x_off, t_y_off, t_z_off+eps]) rotate([0,180,0])
            scale([sf,sf,sf]) import("import/Pistol_Finger_Protection_cut.stl");
        // connectors
        translate([cmb2h_x_off,cmb2h_y1_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
        translate([cmb2h_x_off,cmb2h_y2_off,cmb2h_z_off])
            cylinder(h=c_l,d=c_d);
    }
}

//%grip();

module trigger()
{
    // Trigger with finger coverage
    // STATUS: READY to test
    translate([t_x_off, t_y_off, t_z_off+eps])
    rotate([0,180,0])
    {
        scale([sf,sf,sf]) import("import/Pistol_Finger_Protection.stl");
        scale([sf,sf,sf]) import("import/Trigger.stl");
    }
    
}

//%trigger();

/*
mi_x_ro =-40;
mi_y_ro = 25;
mi_z_ro = mbe_z_off+mbe_z+2;
translate([mi_x_ro,mi_y_ro,mi_z_ro]) rotate([0,0,-90]) magazine_insertor();
*/

module reciever(){
    // OBSOLATE
    %scale([0.8*sf,0.8*sf,0.8*sf]) import("import/Receiver.stl");
}




pb_D = 33;
// smaller diameter
// e.g. barell diameter
pb_d = 7.62+2*5;
pb_H = 157;
pb_h = 15;

// pre-barell barrel z offset
pb_bz_off = 2;

// wall thickness
pb_wt = 1.5;

// strip holder offset 1
pb_sh1 = 0;
pb_sh3 = 130+6.5;
pb_sh2 = 65+6.5;

// strip holder connector diameter
pb_sh_d = 5;
pb_sh_h = 4;

module pre_barell()
{
    
    difference()
    {   

        // main body
        hull()
        {
            c_h = 2;
            cylinder(h=pb_H,d=pb_D);
            translate([0,0,pb_H+pb_h-c_h]) cylinder(h=c_h,d=pb_d);
        }

        
        
        //cut inner hole
        translate([0,0,pbh_t]) cylinder(h=pb_H-2*pbh_t,d=pb_D-2/pb_wt);
                
        ct_d = 10;
        ct_off = 2;
        
        // cooler holes
        for(i=[0:6])
        {
            // first holes
            translate([0,0,pbh_t+2*pbh_f_off+ct_off])
                rotate([90,0,30+60*i]) cylinder(h=pb_D,d=ct_d);
            // second holes
            translate([0,0,pbh_t+3*pbh_f_off+ct_off+ct_d])
                rotate([90,0,0+60*i]) cylinder(h=pb_D,d=ct_d);
            // third holes
            translate([0,0,pbh_t+4*pbh_f_off+ct_off+2*ct_d])
                rotate([90,0,30+60*i]) cylinder(h=pb_D,d=ct_d);
            
            // another part
            // first holes
            translate([0,0,pbh_t+2*pbh_f_off+ct_off+65])
                rotate([90,0,30+60*i]) cylinder(h=pb_D,d=ct_d);
            // second holes
            translate([0,0,pbh_t+3*pbh_f_off+ct_d+ct_off+65])
                rotate([90,0,0+60*i]) cylinder(h=pb_D,d=ct_d);
            // third holes
            translate([0,0,pbh_t+4*pbh_f_off+2*ct_d+ct_off+65])
                rotate([90,0,30+60*i]) cylinder(h=pb_D,d=ct_d);
        }
        
        // front hole for barell
        // interface h
        i_h = pb_H+pb_h-c_l/2;
        translate([0,0,i_h-c_l/4]) rotate([-90,0,0]) connector_hole();
        // a small hole for better stability
        translate([0,0,i_h+c_l/4+eps]) cylinder(h=c_l/2,d=0.75*pb_d);
              
        
    }
    
    difference()
    {
        // middle barrel
        cylinder(h=pb_H,d=pb_d);
        i_h = pb_H+pb_h-c_l/2;
        translate([0,0,i_h-c_l/4]) rotate([-90,0,0]) connector_hole();
        
    }
    
    
    // back barell holder
    %translate([0,0,pb_sh1]) back_pre_barell_holder();

    // middle barell holder
    %translate([0,0,pb_sh2]) pre_barell_holder();

    // front barell holder
    %translate([0,0,pb_sh3]) front_pre_barell_holder();
   
}

//pre_barell();


// pre-barell-holder thickness
pbh_t = 15;

module pre_barell_holder()
{
    hx = pb_D;
    hy = pb_D/2 + pb_bz_off + tol;
    hz = pbh_t;
    
    difference()
    {
        // body
        union()
        {
            // lower part
            translate([-hx/2,0,0]) cube([hx,hy,hz]);
            
            // stripes for holding barell
            hull()
            {
                // stripe on the top part
                d = hx+2*pb_wt;
                cylinder(d=d,h=hz);   
                // strip corners
                h = hx+2*pb_wt;
                rotate([0,90,0]) translate([-pbh_t/2,d/4,-h/2])
                    cylinder(h=h,d=pbh_t);
            }
            
            // adding rivet heads
            // left rivet head
            translate([-hx/2+pb_wt/2,hz/2,hz/2]) sphere(d=hz/2);
            // right rivet head
            translate([hx/2-pb_wt/2,hz/2,hz/2]) sphere(d=hz/2);
        }
        
        // holes for barel cooler
        translate([0,0,-hz/2]) cylinder(h=2*hz,d=pb_D+2*tol);
        
        
        // connecting holes
        con_d = pb_sh_d+tol;        
        con_h = pb_sh_h+2*tol;
        con_off = (pbh_t - con_d)/2;
        con_tx = pb_D/2-con_off;
        con_ty = pb_D/2+pb_bz_off+tol+eps;
        con_tz = con_off+con_d/2;
        // left hole
        translate([con_tx,con_ty,con_tz]) rotate([90,0,0])         
            cylinder(d=con_d,h=con_h);
        // right hole
        translate([-con_tx,con_ty,con_tz]) rotate([90,0,0])         
            cylinder(d=con_d,h=con_h);
    }
    
}
//pre_barell_holder();

pbh_f_off = 6.5;

// first pre barrel holder including small metal plate
module back_pre_barell_holder()
{
    
    // basic pre barel holder
    translate([0,0,pbh_f_off]) pre_barell_holder();
    // additional metal plate
    pbhfx = pb_D;
    pbhfy = pb_bz_off+tol;
    translate([-pbhfx/2,pbhfx/2+tol,tol])cube([pbhfx,pbhfy-tol,pbh_f_off-tol]);
    
}

// strap loop diameter 
sl_d = 3;
// front sight interface
fs_a = 2;
module front_pre_barell_holder()
{
    difference()
    {
        union()
        {
            pre_barell_holder(); 
            hull()
            {
                rotate([0,0,200]) translate([pb_D/2,0,0])
                    cylinder(h=pbh_t,d=sl_d+2*pb_wt);
                cylinder(h=pbh_t,d=pb_D+2*pb_wt);
            }
        }
        
        hull()
        {
            // strip loop holder differnce
            rotate([0,0,200]) translate([pb_D/2+tol,0,-eps])
                cylinder(h=pbh_t+2*eps,d=sl_d);
            // pre-barrel hole
            translate([0,0,-eps])
                cylinder(h=pbh_t+2*eps,d=pb_D+2*tol);
        }
        
        // front sight hole
        a = fs_a + 2*tol;
        l = pb_D;
        translate([-a/2,-l,pbh_t/2-a/2]) cube([a,l,a]);
        
    }
            
}


module sights()
{
    hull()
    {
        a = fs_a + tol;
        translate([-a/2, -a/2, 0]) cube([a, a, pb_wt]);
        translate([0, 0, 3.5*pb_wt]) sphere(d=1);
    }
}
//sights();

// barell parameters
bar_l = 150;
bar_D = pb_d;
bar_d = 7.62;
module barell()
{
    difference()
    {
        union()
        {
            cylinder(h=bar_l,d=bar_D);
            translate([0,0,-c_l/4]) cylinder(h=c_l/4,d=0.75*pb_d-tol);
        }
        translate([0,0,10+eps]) cylinder(h=bar_l-10, d=bar_d);
        translate([0,0,c_l/4]) rotate([90,0,0])  connector_hole();
    }
   
}

//barell();

// barrel diameter
brl_d = pb_d;

//pre_barell_holder();

//pre_barell();


