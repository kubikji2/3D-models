use<hearth-toothpick.scad>
use<hearth-earrings.scad>

$fn = $preview ? 36 : 180;

part_name = "earring"; // ["earring", "advanced-earring", "toothpick"]

if (part_name == "earring")
{
    ear_ring();
}
else if (part_name == "advanced-earring")
{
    adv_ear_ring();
}
else if (part_name == "toothpick")
{
    heart_pick();
}