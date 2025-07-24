include<hook.scad>

$fs = 0.1;
$fa = 5;


towel_hook( wall_thickness=3,
            interface_length=15,
            interface_gauge=6,
            interface_width=20,
            groove_width=20,
            groove_depth=15,
            groove_height=10,
            groove_cut=5,
            from_top_to_groove=25);

%cube([6,15,20]);