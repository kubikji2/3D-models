use<empire-coaster.scad>

$fn = $preview ? 36 : 120;


layer_name = "base"; // ["base", "logo", "full"]

if (layer_name == "base")
{
    base();
}
else if (layer_name == "logo")
{
    decor();
}
else if (layer_name == "full")
{
    coaster();
}
