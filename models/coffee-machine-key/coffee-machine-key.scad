$fn = $preview ? 36 : 72;
nothing=0.01;
//use </home/nevim/Documents/openSCAD/solidpp/solidpp.scad>
use <../../lib/solidpp/solidpp.scad>

module head(width, handleWidth, size){

	difference(){
		union(){
			translate([-size/2,0,0])
			cylinderpp(zet="y", align="X", r=size, h=handleWidth);
			translate([size/2,0,0])
			cylinderpp(zet="y", align="x", r=size, h=handleWidth);
			cubepp([width, handleWidth, 2*size], align="Z");
			cubepp([3*size, handleWidth, size], align="Z");
		}

		cylinderpp(zet="y", d=size, h=handleWidth, align="");
	}
}

module key(){
	depth = 7.5;
	width = 10;
	size = 7.5; //radius of the lobes

	prismWidth = width/cos(30);

	//rotate([0,0,30])
    cylinderpp($fn=6, [prismWidth,prismWidth,depth], align="Z");

	translate([0,0, 2*size])
	difference(){
		hull()
			head(width, width, size);
		difference(){
			translate([0,0,-size/2])
			cubepp([3*size, width+nothing, 3*size/2], align="z");
			head(width, width+nothing,size);

		}
        translate([-size/2-2*size,0,0])
            rotate([0,0,45])
                cylinderpp(d=3, h=3*width,align="", zet="y");
	}
}

key();