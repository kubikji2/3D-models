use<glue-on-hook.scad>


$fn = $preview ? 36 : 120;

interface_gauge = 26;
interface_length = 30;
interface_width = 20;
interface_latch = 2;

glue_on_hook(   wall_thickness=2,
                //interface_length=interface_length,
                //interface_gauge=interface_gauge,
                interface_width=interface_width,
                //interface_latch=2,
                groove_width=25,
                groove_depth=20,
                groove_height=interface_width,
                groove_cut=7,
                tip_height=5,
                bevel=0.5,
                from_top_to_groove=25);
