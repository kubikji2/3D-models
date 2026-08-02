
// Module names are of the form poly_<inkscape-path-id>().
// As a result you can associate a polygon in this OpenSCAD program with the
//  corresponding SVG element in the Inkscape document by looking for 
//  the XML element with the attribute id="inkscape-path-id".

// Paths have their own variables so they can be imported and used 
//  in polygon(points) structures in other programs.
// The NN_points is the list of all polygon XY vertices. 
// There may be an NN_paths variable as well. If it exists then it 
//  defines the nested paths. Both must be used in the 
//  polygon(points, paths) variant of the command.

profile_scale = 25.4/90; //made in inkscape in mm

// helper functions to determine the X,Y dimensions of the profiles
function min_x(shape_points) = min([ for (x = shape_points) min(x[0])]);
function max_x(shape_points) = max([ for (x = shape_points) max(x[0])]);
function min_y(shape_points) = min([ for (x = shape_points) min(x[1])]);
function max_y(shape_points) = max([ for (x = shape_points) max(x[1])]);

height = 2;
width = 1.0;


rect1031_0_points = [[467.000000,472.999998],[519.000000,472.999998],[519.000000,518.999998],[467.000000,518.999998],[467.000000,472.999998]];

module poly_rect1031(h, w, res=4)  {
  scale([profile_scale, -profile_scale, 1])
  union()  {
    linear_extrude(height=h)
      polygon(rect1031_0_points);
  }
}

path45872_0_points = [[-113.787110,-475.841799],[-434.361328,-475.734377],[-204.457030,21.238278],[-395.763672,21.238278],[-395.763672,234.410158],[-105.841800,234.410158],[3.853520,471.535158],[116.312500,234.410158],[403.630860,234.410158],[403.630860,21.238278],[217.412110,21.238278],[453.101560,-475.718752],[127.023440,-475.791018],[3.992190,-194.794922],[-113.787110,-475.841799],[-113.787110,-475.841799]];

module poly_path45872(h, w, res=4)  {
  scale([profile_scale, -profile_scale, 1])
  union()  {
    linear_extrude(height=h)
      polygon(path45872_0_points);
  }
}

rect1033_0_points = [[-519.000000,-518.999998],[-473.000000,-518.999998],[-473.000000,-468.999998],[-519.000000,-468.999998],[-519.000000,-518.999998]];

module poly_rect1033(h, w, res=4)  {
  scale([profile_scale, -profile_scale, 1])
  union()  {
    linear_extrude(height=h)
      polygon(rect1033_0_points);
  }
}

// The shapes
poly_rect1031(height, width);
poly_path45872(height, width);
poly_rect1033(height, width);
