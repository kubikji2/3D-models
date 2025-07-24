include<../../../lib/solidpp/solidpp.scad>

module wall_anchor_spacer(width, height, thickness, diameter)
{

    difference()
    {
        // main shape
        cubepp([width, thickness, height], align="");
        
        // circular hole
        cylinderpp(d=diameter, h=2*thickness, zet="y", align="");
    }
}