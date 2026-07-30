use<sgc-coaster.scad>

part_name="base"; // ["base", "cut"]

if (part_name == "base")
{
    base();
}
else if (part_name == "cut")
{
    cut();
}
