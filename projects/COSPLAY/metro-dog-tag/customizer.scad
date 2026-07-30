use<order-tag.scad>


is_layered = false;

clr = "black"; //["black", "silver", "red"]


if (is_layered)
{
    dog_tag_additive_no_text();
}
else
{
    dog_tag_multicolor(clr=clr);
}