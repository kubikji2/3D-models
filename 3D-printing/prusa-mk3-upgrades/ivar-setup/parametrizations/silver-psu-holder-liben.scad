use<../silver-psu-holder.scad>
$fn=$preview?36:144;

is_front = true;

if (is_front)
{
    silver_psu_holder_front(
        number_of_interfaces = 3,
        wall_thickness = 3,
        mounting_wall_thickness = 4,
        interface_height = 2,
        screw_offset = 3,
        screw_standard = "LUXPZ",
        screw_diameter = 3,
        screw_length = 20);
}
else
{
    silver_psu_holder_back(
        number_of_interfaces = 3,
        wall_thickness = 3,
        mounting_wall_thickness = 4,
        interface_height = 2,
        screw_offset = 3,
        screw_standard = "LUXPZ",
        screw_diameter = 3,
        screw_length = 20);
}