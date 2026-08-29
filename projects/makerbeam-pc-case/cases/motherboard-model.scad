

include<../../../lib/solidpp/solidpp.scad>


module motherboard(x,y)
{
    cubepp([x,y,2]);
    // io shield
    cubepp([158.75,5,44.45]);
}