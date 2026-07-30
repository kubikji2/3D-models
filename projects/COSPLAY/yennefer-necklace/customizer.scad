use<yennefer-necklace.scad>

part_name = "cover"; // ["cover", "body"]

if (part_name == "cover")
{
    cover();
} else if (part_name == "body")
{
    necklace();
}
