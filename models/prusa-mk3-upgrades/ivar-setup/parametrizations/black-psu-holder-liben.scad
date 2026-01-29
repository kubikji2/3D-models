use<../black-psu-holder.scad>

$fn=$preview?36:144;

is_front = true;

if (is_front)
{
    black_psu_front_holder(
        length=15,
        wall_thickness = 3,
        mounting_wall_thickness = 4,
        screw_offset = 3,
        screw_standard = "LUXPZ",
        screw_diameter = 3,
        screw_length = 20);
}
else
{
    black_psu_back_holder(
        length=20,
        wall_thickness = 3,
        mounting_wall_thickness = 4,
        screw_offset = 3,
        screw_standard = "LUXPZ",
        screw_diameter = 3,
        screw_length = 20);
}
