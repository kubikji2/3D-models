use<card-box.scad>

part_name = "base"; // ["base", "cover"]

if (part_name == "base")
{
    guts();
}
else if (part_name == "cover")
{
    cover();
}