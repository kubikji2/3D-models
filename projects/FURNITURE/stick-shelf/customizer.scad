use<stick-shelf-models.scad>


part_name = "side-joint"; // ["side-joint", "corner-joint", "t-joint", "x-joint", "shelf-joint"]


if (part_name=="side-joint")
{
    multipixel();
}
else if (part_name=="corner-joint")
{
    corner();
}
else if (part_name=="t-joint")
{
    t_joint();
}
else if (part_name=="x-joint")
{
    x_joint();
} else if (part_name=="shelf-joint")
{
    shelf_joint();
}



