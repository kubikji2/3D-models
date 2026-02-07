use<mk3s-rpi-cover-model.scad>
use<mk3s-rpi-spacer.scad>


$fs = $preview ? 0.25 : 0.1;
$fa = $preview ? 10 : 5;

part_name = "cover"; // ["cover", "frame"] 


if (part_name=="cover")
{
    cover();
}
else if (part_name=="frame")
{
    rpi_zero_frame();
}