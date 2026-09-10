// master requirements
use<../../lib/solidpp/solidpp.scad>

// makerbeam dimensions
include<makerbeam-constants.scad>

// corners
include<makerbeam-corner-parameters.scad>


module makerbeam_plate(x,y,t=10, corner_clearance=0.2, align="xyz")
{
    _b = mbc_wt + corner_clearance;
    cubepp([x,y,t], align=align, mod_list=[bevel_edges(bevel=_b, axes="xy")]);

}
 