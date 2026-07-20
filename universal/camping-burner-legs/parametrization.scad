use<camping-burner-holder.scad>

// CUSTOMIZABLE PARAMETERS

// [mm] clearance for joints, bolts, nuts and pressure bottle borders
clearance = 0.3; // [0:0.05:0.5]

// [mm] inner piece radius
core_piece_radius = 30; // [20:30]

// [mm] arm length
arm_length = 65; // [25:5:120]

// is arm tepered toward the end?
is_arm_light = false;

// what pieces are shown
what_to_show = "all"; //["all","arm","center"]

// just fn
$fn = $preview ? 30 : 60;

core_piece(
    arm_length=arm_length,
    core_piece_radius=core_piece_radius,
    clearance=clearance,
    is_arm_light=is_arm_light,
    add_arms=true);

// MAIN
//if (what_to_show=="all")
//{
//    core_piece(add_arms=true); 
//}
//else if (what_to_show=="center")
//{
//    core_piece(add_arms=false);
//}
//else
//{
//    arm();
//}
