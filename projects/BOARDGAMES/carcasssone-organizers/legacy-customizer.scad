use<carcassonne-legacy-organizers.scad>

part_name = "card_compartement";// ["card_compartement", "card_separator", "figure_compartement", "figure_storage", "section_filler"]

$fn = $preview ? 36 : 120;

if (part_name == "card_compartement")
{
    card_compartement();
}
else if (part_name == "card_separator")
{
    card_separator();
}
else if (part_name == "figure_compartement")
{
    figure_compartement();
}
else if (part_name == "figure_storage")
{
    figure_storage();
}
else if (part_name == "section_filler")
{
    section_filler();
}