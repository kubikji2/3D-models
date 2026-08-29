use<makerbeam-prefabs-models.scad>

// for c in s
// __solidpp__is_c_in_s(c,s)
include<../../lib/solidpp/utils/solidpp_utils.scad>

function c_in_s(c,s) = __solidpp__is_c_in_s(c=c, s=s);

function is_beam_active(side1, side2, walls, forced_walls) =
    c_in_s(side1, walls) && c_in_s(side2, walls) || 
        c_in_s(side1, forced_walls) ||
            c_in_s(side2, forced_walls);

module makerbeam_case(size, walls="xyzXYZ", forced_walls="")
{

    _x = size.x;
    _y = size.y;
    _z = size.z;

    // edges
    // lower segment (horizontal)
    // ... front, down
    if (is_beam_active("y", "z", walls, forced_walls))
        makerbeam_prefab(length=_x, align="xYZ", zet="x");
    // ... left, down
    if (is_beam_active("x", "z", walls, forced_walls))
        makerbeam_prefab(length=_y, align="XyZ", zet="y");
    // ... back, down
    if (is_beam_active("Y", "z", walls, forced_walls))
        translate([0,_y,0])
            makerbeam_prefab(length=_x, align="xyZ", zet="x");
    // ... right, down
    if (is_beam_active("X", "z", walls, forced_walls))
        translate([_x,0,0])
            makerbeam_prefab(length=_y, align="xyZ", zet="y");


    // middle segment (vertical)
    // ... left, front
    if (is_beam_active("x", "y", walls, forced_walls))
        makerbeam_prefab(length=_z, align="XYz", zet="z");
    
    // ... left, back
    if (is_beam_active("x", "Y", walls, forced_walls))
        translate([0,_y,0])
            makerbeam_prefab(length=_z, align="Xyz", zet="z");

    // ... right, front
    if (is_beam_active("X", "y", walls, forced_walls))
        translate([_x,0,0])
            makerbeam_prefab(length=_z, align="xYz", zet="z");

    // ... right, back
    if (is_beam_active("X", "y", walls, forced_walls))
        translate([_x,_y,0])
            makerbeam_prefab(length=_z, align="xyz", zet="z");


    // upper segment (horizontal)
    // ... front, up
    if (is_beam_active("y", "Z", walls, forced_walls))
        translate([0,0,_z])
            makerbeam_prefab(length=_x, align="xYz", zet="x");
    // ... left, up
    if (is_beam_active("x", "Z", walls, forced_walls))
        translate([0,0,_z])
            makerbeam_prefab(length=_y, align="Xyz", zet="y");
    // ... back, up
    if (is_beam_active("Y", "Z", walls, forced_walls))
        translate([0,_y,_z])
            makerbeam_prefab(length=_x, align="xyz", zet="x");
    // ... right, up
    if (is_beam_active("X", "Z", walls, forced_walls))
        translate([_x,0,_z])
            makerbeam_prefab(length=_y, align="xyz", zet="y");
}
