use<mooncake.scad>

part_name = "body"; // ["body","eyes"]

if (part_name == "body")
{
    body();
}
else if (part_name == "eyes")
{
    eyes();
}