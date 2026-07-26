use<camera-holder-model.scad>
use<camera-interface-model.scad>


electronics_compartment();

align_from_shell_to_interface_center()
align_to_shell_origin()
rotate([180,0,0])
    camera_interface();