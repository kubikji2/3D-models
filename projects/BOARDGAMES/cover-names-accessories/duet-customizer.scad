use<duet-accesories.scad>


$fn = $preview ? 36 : 120;

part_name = "organizer"; // ["organizer", "box_cover"]

if (part_name == "organizer")
{
    organizer();
}
else if (part_name == "box_cover")
{
    box_cover();
}
