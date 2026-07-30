use<bastard.scad>
//use<belt-hook-holder.scad>
use<burst-selector.scad>
use<reciever-accessories.scad>
use<sights.scad>

part_name = "body";//["magazine", "main_body_support", "lower_cylinder", "connector", "bolt", "nut", "cock_part", "cock_lever_holder", "inner_shaft", "body", "hand_guard", "grip", "trigger", "pre_barell", "pre_barell_holder", "front_pre_barell_holder", "back_pre_barell_holder", "sights", "barell", "burst_selector", "burst_selector_lever"]

if (part_name=="magazine")
{
    magazine();
}
else if (part_name == "magazine_insertor")
{
    magazine_insertor();
}
else if (part_name == "main_body_support")
{
    main_body_support();
}
else if (part_name == "lower_cylinder")
{
    lower_cylinder();
}
else if (part_name == "connector")
{
    connector_part();
}
else if (part_name == "bolt")
{
    bolt();
}
else if (part_name == "nut")
{
    nut();
}
else if (part_name == "cock_part")
{
    cock_part();
}
else if (part_name == "cock_lever_holder")
{
    cock_lever_holder();
}
else if (part_name == "inner_shaft")
{
    inner_shaft();
}
else if (part_name == "body")
{
    main_body();
}
else if (part_name == "hand_guard")
{
    hand_guard();
}
else if (part_name == "grip")
{
    grip();
}
else if (part_name == "trigger")
{
    trigger();
}
else if (part_name == "pre_barell")
{
    pre_barell();
}
else if (part_name == "pre_barell_holder")
{
    pre_barell_holder();
}
else if (part_name == "back_pre_barell_holder")
{
    back_pre_barell_holder();
}
else if (part_name == "front_pre_barell_holder")
{
    front_pre_barell_holder();
}
else if (part_name == "sights")
{
    sights();
}
else if (part_name == "barell")
{
    barell();
}
//else if (part_name == "belt_hook_holder")
//{
//    belt_hook_holder();
//}
else if(part_name == "burst_selector")
{
    burst_selector();
}
else if (part_name == "burst_selector_lever")
{
    burst_selector_lever();
}
else if (part_name == "sights")
{
    sights();
}