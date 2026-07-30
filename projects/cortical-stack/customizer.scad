use<cortical-stack.scad>

part_name = "body-top"; //["body-top", "body-bottom", "electronics-top", "electronics-bottom"]

if (part_name=="body-top")
{
    main(true);
}
else if (part_name == "body-bottom")
{
    main(false);
}
else if (part_name == "electronics-top")
{
    electronics_top();
}
else if (part_name == "electronics-bottom")
{
    electronics_bottom();
}