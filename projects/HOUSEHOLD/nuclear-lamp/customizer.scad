use<nuke-base.scad>

part_name = "cover"; // ["cover", "lamp-post"]

$fn = $preview ? 36 : 120;


if (part_name == "cover")
{
    chocolate_cover();
}
else if (part_name == "lamp-post")
{
    lamp_post();
}