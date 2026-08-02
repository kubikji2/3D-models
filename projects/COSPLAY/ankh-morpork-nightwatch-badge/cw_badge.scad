// base badge
color([0.75,0.45,0.2])
    //scale([1.25,1.25,1.0])
    import("import/am_cw_badge.stl");


// badge number
%translate([0,-45,-2])
linear_extrude(height = 3) {
    text( "177",
          font = "Arial:style=Bold", 
          size = 11, 
          valign = "center", halign = "center"
        );
}   
