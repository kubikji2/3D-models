$fn = $preview ? 36 : 120;
// bigger version
//color("silver") scale([0.7,0.7,0.7]) import("stargate.stl");
//color([0.4,0.4,0.99]) cylinder(d=94.7,h=3);

// smaller version
sc = 0.755;
color("silver") scale([0.5,0.5,0.7]) import("import/stargate.stl");
color([0.4,0.4,0.99]) scale([sc,sc,1]) import("import/event-horizon.stl");
//color([0.4,0.4,0.99]) cylinder(d=67.6,h=3);