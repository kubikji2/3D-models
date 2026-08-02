use<left-wing.scad>
use<right-wing.scad>
use<tail.scad>

part_name = "left-wing"; // ["left-wing", "right-wing", "tail"]

$fn= $preview ? 36 : 120;

if (part_name == "left-wing")
{
    left_wing();
}
else if (part_name == "right-wing")
{
    right_wing();
}
else if (part_name == "tail")
{
    tail();
}