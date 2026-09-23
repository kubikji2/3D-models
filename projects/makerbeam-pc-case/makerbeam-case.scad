use<makerbeam-prefabs-models.scad>

include<makerbeam-corner-parameters.scad>
include<makerbeam-constants.scad>

use<makerbeam-corner-model.scad>
use<makerbeam-double-corner-model.scad>

// for c in s
// __solidpp__is_c_in_s(c,s)
include<../../lib/solidpp/utils/solidpp_utils.scad>

function c_in_s(c,s) = __solidpp__is_c_in_s(c=c, s=s);

function is_beam_active(side1, side2, walls, forced_walls) =
    c_in_s(side1, walls) && c_in_s(side2, walls) || 
        c_in_s(side1, forced_walls) ||
            c_in_s(side2, forced_walls);

function is_corner_active(side1, side2, side3, walls, forced_walls) =
    c_in_s(side1, walls) && c_in_s(side2, walls) && c_in_s(side3, walls) || 
        c_in_s(side1, forced_walls) ||
            c_in_s(side2, forced_walls) ||
                c_in_s(side3, forced_walls);

module _active_corner(has_double_corners)
{
    render(10)
    if(has_double_corners)
    {
        makerbeam_double_corner();

    }
    else
    {
        makerbeam_corner();

    }
}

module makerbeam_case(size,
    walls="xyzXYZ",
    forced_walls="",
    has_corners=true,
    has_double_corners=false)
{

    _has_corners = has_corners;

    _x = size.x;
    _y = size.y;
    _z = size.z;
    _off = (_has_corners ? mbc_wt : 0 );

    _X = size.x + 2*_off;
    _Y = size.y + 2*_off;
    _Z = size.z + 2*_off;

    // edges
    // lower segment (horizontal)
    // ... front, down
    if (is_beam_active("y", "z", walls, forced_walls))
        translate([_off,0,0])
            makerbeam_prefab(length=_x, align="xYZ", zet="x");
    // ... left, down
    if (is_beam_active("x", "z", walls, forced_walls))
        translate([0,_off,0])
            makerbeam_prefab(length=_y, align="XyZ", zet="y");
    // ... back, down
    if (is_beam_active("Y", "z", walls, forced_walls))
        translate([_off,_Y,0])
            makerbeam_prefab(length=_x, align="xyZ", zet="x");
    // ... right, down
    if (is_beam_active("X", "z", walls, forced_walls))
        translate([_X,_off,0])
            makerbeam_prefab(length=_y, align="xyZ", zet="y");


    // middle segment (vertical)
    // ... left, front
    if (is_beam_active("x", "y", walls, forced_walls))
        translate([0,0,_off])
            makerbeam_prefab(length=_z, align="XYz", zet="z");
    
    // ... left, back
    if (is_beam_active("x", "Y", walls, forced_walls))
        translate([0,_Y,_off])
            makerbeam_prefab(length=_z, align="Xyz", zet="z");

    // ... right, front
    if (is_beam_active("X", "y", walls, forced_walls))
        translate([_X,0,_off])
            makerbeam_prefab(length=_z, align="xYz", zet="z");

    // ... right, back
    if (is_beam_active("X", "y", walls, forced_walls))
        translate([_X,_Y,_off])
            makerbeam_prefab(length=_z, align="xyz", zet="z");


    // upper segment (horizontal)
    // ... front, up
    if (is_beam_active("y", "Z", walls, forced_walls))
        translate([_off,0,_Z])
            makerbeam_prefab(length=_x, align="xYz", zet="x");
    // ... left, up
    if (is_beam_active("x", "Z", walls, forced_walls))
        translate([0,_off,_Z])
            makerbeam_prefab(length=_y, align="Xyz", zet="y");
    // ... back, up
    if (is_beam_active("Y", "Z", walls, forced_walls))
        translate([_off,_Y,_Z])
            makerbeam_prefab(length=_x, align="xyz", zet="x");
    // ... right, up
    if (is_beam_active("X", "Z", walls, forced_walls))
        translate([_X,_off,_Z])
            makerbeam_prefab(length=_y, align="xyz", zet="y");

    color("gray")
    {
        // bottom left front
        if (is_corner_active("x", "y", "z", walls, forced_walls))
            translate([-mb1010_a/2,-mb1010_a/2,-mb1010_a/2])
                _active_corner(has_double_corners);
        
        // bottom right front
        if (is_corner_active("X", "y", "z", walls, forced_walls))
            translate([_X+mb1010_a/2,-mb1010_a/2,-mb1010_a/2])
                rotate([0,0,90])
                    _active_corner(has_double_corners);
        
        // bottom right back
        if (is_corner_active("x", "Y", "z", walls, forced_walls))
            translate([-mb1010_a/2,_Y+mb1010_a/2,-mb1010_a/2])
                rotate([0,0,270])
                    _active_corner(has_double_corners);

        // bottom right back
        if (is_corner_active("X", "Y", "z", walls, forced_walls))
            translate([_X+mb1010_a/2,_Y+mb1010_a/2,-mb1010_a/2])
                rotate([0,0,180])
                    _active_corner(has_double_corners);
        
        // top left front
        if (is_corner_active("x", "y", "Z", walls, forced_walls))
            translate([-mb1010_a/2,-mb1010_a/2,_Z+mb1010_a/2])
                rotate([0,90,0])
                    _active_corner(has_double_corners);
        
        // top right front
        if (is_corner_active("X", "y", "Z", walls, forced_walls))
            translate([_X+mb1010_a/2,-mb1010_a/2,_Z+mb1010_a/2])
                rotate([0,90,90])
                    _active_corner(has_double_corners);
        
        // top right back
        if (is_corner_active("x", "Y", "Z", walls, forced_walls))
            translate([-mb1010_a/2,_Y+mb1010_a/2,_Z+mb1010_a/2])
                rotate([0,90,270])
                    _active_corner(has_double_corners);

        // top right back
        if (is_corner_active("X", "Y", "Z", walls, forced_walls))
            translate([_X+mb1010_a/2,_Y+mb1010_a/2,_Z+mb1010_a/2])
                rotate([0,90,180])
                    _active_corner(has_double_corners);
        


    }



}
