include<hook.scad>
use<double-hook.scad>

$fs = 0.1;
$fa = 5;


// towel_hook( wall_thickness=5,
//             interface_length=15,
//             interface_gauge=6,
//             interface_width=20,
//             groove_width=30,
//             groove_depth=20,
//             groove_height=20,
//             groove_cut=7,
//             tip_height=10,
//             bevel=1.5,
//             from_top_to_groove=25);

//%cube([6,15,20]);


towel_double_hook(  wall_thickness=5,
                    interface_length=15,
                    interface_gauge=6,
                    interface_width=20,
                    groove_width=30,
                    groove_depth=20,
                    groove_height=20,
                    groove_cut=7,
                    tip_height=10,
                    bevel=1.5,
                    from_top_to_groove=25);

%cubepp([6,15,20], align="Y");