use<hook-with-latch.scad>

$fn = $preview ? 36 : 120;

interface_gauge = 26;
interface_length = 30;
interface_width = 25;
interface_latch = 2;

towel_hook_with_latch(  wall_thickness=2,
                        interface_length=interface_length,
                        interface_gauge=interface_gauge,
                        interface_width=interface_width,
                        interface_latch=2,
                        groove_width=25,
                        groove_depth=20,
                        groove_height=interface_width,
                        groove_cut=7,
                        tip_height=5,
                        bevel=0.5,
                        from_top_to_groove=25);

%cubepp([interface_gauge,interface_length,interface_width/2]);
%cubepp([interface_latch,interface_length,interface_width]);



use<../towel-hook/double-hook.scad>
%towel_double_hook(  wall_thickness=5,
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