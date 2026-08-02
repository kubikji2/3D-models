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
 /*
radiation();
bottom();
border();

*/

module radiation_coaster(radiation_diameter = 85, radiation_height = 2, radiation_ration = 0.70, radiation_inner_ratio = 0.2,  lower_plate_height = 2, border_thickness = 3, border_offset = 2, border_height = 2){
    
    radiation(radiation_diameter, radiation_height, radiation_ration, radiation_inner_ratio);
    
    bottom(lower_plate_height, radiation_diameter, border_thickness + border_offset);
    border(border_height, radiation_diameter, border_thickness, border_offset);

    
}

$fn=$preview ? 36 : 120;
radiation_coaster();
