
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

height = 1;
width = 1.0;


path2_0_points = [[-63.166600,17.290140],[62.393400,17.770140],[-0.606600,80.400140],[-63.166600,17.290140]];
path2_1_points = [[113.893400,-33.279860],[69.993400,-33.449860],[69.793400,10.420140],[113.893400,-33.279860]];
path2_2_points = [[-114.216600,-34.159860],[-70.416600,-33.989860],[-70.606600,9.810140],[-114.216600,-34.159860]];
path2_3_points = [[160.106600,-80.400140],[70.087790,-80.356915],[69.993400,-40.899860],[121.393400,-40.699860],[160.106600,-80.400140]];
path2_4_points = [[-160.106600,-80.399860],[-70.259801,-80.397182],[-70.396600,-41.439860],[-121.646600,-41.639860],[-160.106600,-80.399860]];
path2_5_points = [[-0.206600,-43.459860],[34.399010,-80.384908],[62.693400,-80.338911],[62.393400,10.310140],[36.893400,10.210140],[37.093400,-45.399860],[-0.306600,-7.559860],[-37.506600,-45.679860],[-37.706600,9.930140],[-63.126600,9.830140],[-62.813938,-80.360599],[-34.593290,-80.394650],[-0.206600,-43.459860]];

module poly_path2(h, w, res=4)  {
  scale([profile_scale, -profile_scale, 1])
  union()  {
    linear_extrude(height=h)
      polygon(path2_0_points);
    linear_extrude(height=h)
      polygon(path2_1_points);
    linear_extrude(height=h)
      polygon(path2_2_points);
    linear_extrude(height=h)
      polygon(path2_3_points);
    linear_extrude(height=h)
      polygon(path2_4_points);
    linear_extrude(height=h)
      polygon(path2_5_points);
  }
}

// The shapes
poly_path2(height, width);
