// essentials
use<../../../../../lib/solidpp/solidpp.scad>
use<../../../../../lib/deez-nuts/deez-nuts.scad>

include<barrel-jack-connector-parameters.scad>

module barrel_jack_connector_hole(clearance=0.2)
{

    _d = bjc_d+2*clearance;
    // convert to the hexagonal holes
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#:~:text=20%2C20%2C10%2C%24fn%3D4)%3B-,undersized%20holes,-Using%20cylinder()%20with
    _D = _d/cos(180/6);
    cylinderpp(d=_d,h=bjc_l,align="x",zet="x");
    
    rotate([90,0,0])
    {
        // first hex ring
        translate([bjc_front_space-clearance,0,0])
            cylinderpp($fn=6,d=_D,h=bjc_front_thickness+2*clearance, align="x", zet="x");
        // second hex ring
        translate([bjc_front_space+bjc_front_thickness+bjc_middle_space-clearance,0,0])
            cylinderpp($fn=6,d=_D,h=bjc_middle_thickness+2*clearance, align="x", zet="x");
        translate([bjc_front_space+bjc_front_thickness+bjc_middle_space+bjc_middle_thickness+bjc_back_space-clearance,0,0])
            cylinderpp($fn=6,d=_D,h=bjc_back_thickness+2*clearance, align="x", zet="x");
    
    }
}

//barrel_jack_connector_hole();