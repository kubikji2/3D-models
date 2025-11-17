// create an icosahedron by intersecting 3 orthogonal golden-ratio rectangles
// based on:
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Commented_Example_Projects#Icosahedron
module icosahedron(edge_length) {
    st=0.0001;  // microscopic sheet thickness
    phi=0.5*(sqrt(5)+1); // golden ratio
    // aligning sides
    a = phi/2; // horizontal
    b = phi/2-0.5; // vertical
    c = sqrt(a*a+b*b);
    alpha = acos(a/c); //-21
    
    rotate([-alpha,0,0])
    hull()
    {
        cube([edge_length*phi, edge_length, st], true);
        rotate([90,90,0]) cube([edge_length*phi, edge_length, st], true);
        rotate([90,0,90]) cube([edge_length*phi, edge_length, st], true);
    }
}

// display the 3 internal sheets alongside the icosahedron
//edge=10;
//phi=0.5*(sqrt(5)+1);
//union() {
//   cube([edge*phi, edge, 0.01], true);
//   rotate([90,90,0]) cube([edge*phi, edge, 0.01], true);
//   rotate([90,0,90]) cube([edge*phi, edge, 0.01], true);
//}
//
//%icosahedron(10);
