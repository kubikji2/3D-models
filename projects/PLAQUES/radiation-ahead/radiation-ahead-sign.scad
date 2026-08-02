module branch(height,diameter,out_rat){
    difference(){
        cylinder(h=height, d=diameter);
        translate([0, 0, -height/2])
        {
            translate([0,-diameter,])cube([diameter,2*diameter,2*height]);
            rotate([0,0,120]) translate([0, -diameter,0]) cube([diameter,2*diameter,2*height]);
            cylinder(h=2*height, d=(1-out_rat)*diameter);
        }
    }
}

module radiation(diameter = 95, height = 2, out_rat = 0.25, in_rat = 0.2){

    branch(height,diameter,out_rat);
    rotate([0,0,120]) branch(height,diameter,out_rat);
    rotate([0,0,240]) branch(height,diameter,out_rat);
    
    cylinder(d = in_rat*diameter, height);
    
}

module bottom(height = 2,diameter=95,border_rad=5){
   translate([0,0,-height]) cylinder(d=diameter+2*(border_rad), height);
}
module border(height = 2,diameter=95,border=3,border_offset=2){
        difference(){
            cylinder(d=diameter+2*(border+border_offset), height);
            cylinder(d=diameter+2*(border_offset), 3*height, center=true);
            }
    
}

module radiation_logo(radiation_diameter = 90, radiation_heign = 3, radiation_ration = 0.75, radiation_inner_ratio = 0.2,  lower_plate_heigh = 2, border_thickness = 3, border_offset = 2, border_heigh = 2){
    
    
    rotate([0,0,90]) radiation(radiation_diameter, radiation_heign, radiation_ration, radiation_inner_ratio);
    
    border(border_heigh, radiation_diameter, border_thickness, border_offset);
    
    
}

module radiation_ahead_sign(){
    $fn=$preview ? 36 : 120;
        minkowski(){
        translate([5,5,0]) cube([100,140,1]);
        cylinder(d=5,h=0.5);
        }


    translate([25+(110-50)/2,145-50,0]) radiation_logo(radiation_heign=3, border_heigh = 3);
    translate([55,0,0]){
    linear_extrude(height = 3) {
        translate([0,25,0]) scale([1,1.75,1]) text("RADIATION", font = "Consolas:style=Regular",size = 11, halign="center");
        //translate([7.5,40,0]) text("MAGIOACTIVITY", font = "Coder's Crux:style=Regular",size = 10);
        translate([0,5,0]) scale([1,1.75,1]) text("AHEAD", font =  "Consolas:style=Regular", size = 10,halign="center");
        }
    }
}
    
radiation_ahead_sign(); 

// % cube([100,150,3]);