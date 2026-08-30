// METRIC GEAR
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//    Written by Gerald Guy Lafreniere (aka spingoogL). Journeyman Red Seal Machinist.
//    Turned into module by Jiri TrueKvant Kubik (AI assistant was used to fix function arguments).

//////////////////////////////////////////////
/////   START OF FUNCTION DEFINITIONS    /////
//////////////////////////////////////////////

// Low budget function to rotate points around [0,0]
function __hbhg__rotate_points_on_origin(pt_list, angle) = [for (pt = pt_list)
    let(
        _polar_pt = __hbhg__get_polar_from_coordinate(pt),
        _new_angle = angle + _polar_pt[1],
        _new_pt = __hbhg__get_coordinate_from_polar([_polar_pt[0], _new_angle])
    )
    [_new_pt[0], _new_pt[1]]
];

// Low budget function to mirror points along the X axis. Simply inverts Y.
function __hbhg__mirror_points_on_x_axis(pt_list) = [for (pt = pt_list)
    [pt[0], -pt[1]]
];

function __hbhg__get_minor_involute_radius(rr, bcr) =
    (rr >= bcr) ? rr : bcr;

function __hbhg__involute_func(start_ang, end_ang, res, bc, bcr) = [for (ia = [start_ang : res : end_ang]) 
    let (
        _s = (bc * PI) * (ia / 360),
        _xc = bcr * cos(ia),
        _x = _xc + (_s * sin(ia)),
        _yc = bcr * sin(ia),
        _y = _yc - (_s * cos(ia))
    )
    [_x, _y] 
];

function __hbhg__involute_func_reverse(start_ang, end_ang, res, bc, bcr) = [for (ia = [start_ang : -res : end_ang]) 
    let (
        _s = (bc * PI) * (ia / 360),
        _xc = bcr * cos(ia),
        _x = _xc + (_s * sin(ia)),
        _yc = bcr * sin(ia),
        _y = _yc - (_s * cos(ia))
    )
    [_x, _y] 
];

function __hbhg__get_involute_coordinate_at_radius(rad, bcr, bc) =  
    let (
        _ang = __hbhg__get_involute_angle_at_radius(rad, bcr),
        _pt = __hbhg__get_involute_coordinate_at_angle(_ang, bcr, bc)
    )
    [_pt[0], _pt[1]];

// This defines a point where a line interscts the involute profile.
function __hbhg__get_involute_coordinate_at_angle(ang, bcr, bc) = 
    let(
        _s = (bc * PI) * (ang / 360),
        _xc = bcr * cos(ang),
        _x = _xc + (_s * sin(ang)),
        _yc = bcr * sin(ang),
        _y = _yc - (_s * cos(ang))
    )
    [_x, _y];

function __hbhg__get_involute_angle_at_radius(rad, bcr) = 
    (360 * (sqrt(max(0, pow(rad, 2) - pow(bcr, 2))))) / (2 * PI * bcr);

// Low budget
function __hbhg__get_polar_from_coordinate(pt) =
    let(
        _x = pt[0],
        _y = pt[1],
        _r = sqrt(pow(_x, 2) + pow(_y, 2)),
        _a = atan2(_y, _x) // atan2 is safer for 360 degree rotation
    )
    [_r, _a];

// Low budget
function __hbhg__get_coordinate_from_polar(ppt) =
    let(
        _x = cos(ppt[1]) * ppt[0],
        _y = sin(ppt[1]) * ppt[0]
    )
    [_x, _y];

////////////////////////////////////////////
/////   END OF FUNCTION DEFINITIONS    /////
////////////////////////////////////////////

// SUPPORT MODULES

module __hbhg__tooth_profile(tooth_profile_pts){
    polygon(tooth_profile_pts);
}

// Copy and rotate points to complete 2D gear profile.
module __hbhg__tooth_form(n, tooth_profile_pts){
    for (i = [0 : n-1]){
        rotate(i * 360 / n, [0, 0, 1])
        __hbhg__tooth_profile(tooth_profile_pts);
    }
}

// MAIN MODULE
module herringbone_helical_gear(
    // DEFINE THESE FOR THE GEAR PROFILE.
    metric_module = 1.5,
    number_of_teeth = 42, // Integer as big as your CPU can handle, but smaller than 4 may not work.
    pressure_angle = 20,
    helix_angle = -30, // Positive number for LeftHand, Negative number for RightHand
    angular_resolution = 1, // 1 works good, smaller gives higher resolution.
    width = 10, // width = Thickness of gear
    layer_thickness = 1, // measured in mm
    back_lash = 0.01, // Multiplied by the circular pitch to add clearance at the Pitch Diameter.
    is_verbose = false 
)
{
    ////////////////////////////////
    /////    START GEAR INFO   /////
    ////////////////////////////////    

    _m = metric_module; // Smaller value indicates a smaller tooth profile, must be same for two gears to mesh.
    _m_str = str("\nMODULE:\t\t", _m);
    _n = number_of_teeth; // Used to determine arc size at root and crest of gear.
    _n_str = str("\t\tNUMBER OF TEETH:\t", _n);
    _pa = pressure_angle; // 0<90. Standards are 14.5, 20, 25 degrees.
    _pa_str = str("\nPRESSURE ANGLE:\t", _pa);
    _ha = helix_angle; // Value is needed to calculate corrected circular pitch
    _ha_str = str("\t\tHELIX ANGLE:\t\t", _ha);
    _res = angular_resolution;   // How many points will define the full involute profile.
    _bl = back_lash;
    _res_str = str("\nRESOLUTION:\t\t", _res);
    _pi = 3.141592654;
    
    // Circular Pitch, Corrected Circular Pitch
    _cp = _pi * _m;
    _ccp = _pi * _m / cos(_ha); // corrected cp
    _cp_str = str("\nCircluarPitch:\t\t", _cp);
    _ccp_str = str("\t\tCorrectedCP:\t", _ccp);

    // Pitch Diameter
    _pd = (_n * _ccp) / _pi;
    _pdr = _pd / 2;
    _pd_str = str("\nPitch Diameter:\t\t", _pd);
    _pdr_str = str("\t\tPitch Radius:\t", _pdr);

    // Outside Diameter
    _od = _pd + _m + _m;
    _odr = _od / 2;
    _od_str = str("\nOutside Diameter:\t", _od);
    _odr_str = str("\t\tOD Radius:\t", _odr);

    // Addendum
    _a = _cp / _pi;
    _a_str = str("\nAddendum:\t\t", _a);

    // Dedendum
    _d = (_cp / 20) + _a;
    _d_str = str("\t\tDedendum:\t", _d);

    // Clearance
    _cl = _cp / 20;
    _cl_str = str("\nClearance:\t\t", _cl);
    
    // Whole Depth
    _wd = _a + _d;
    _wd_str = str("\t\tWhole Depth:\t", _wd);

    // Chordal (corrected) addendum
    _ca = ((1 - cos(90 / _n)) * (_pd / 2)) + _a;
    _ca_str = str("\nChordal Addendum:\t", _ca);

    // Chordal thickness
    _ct = sin(90 / _n) * _pd;
    _ct_str = str("\t\tChordal Thickness:  ", _ct);

    // Base Circle
    _bc = _pd * cos(_pa);
    _bc_str = str("\nBase Circle Diameter:\t", _bc);
    _bcr = _bc / 2;
    _bcr_str = str("\t\tBase Circle Radius:  ", _bcr);

    // Root Diameter, and Root Radius
    _rd = _pd - _d - _d;
    _rd_str = str("\nRoot Diameter:\t\t", _rd);
    _rr = _rd / 2;
    _rr_str = str("\t\tRoot Radius:\t", _rr);

    // Minor Diameter ( without clearance )
    _md = _pd - _a - _a;
    _md_str = str("\nMinor Diameter:\t\t", _md);
    _mdr = _md / 2;
    _mdr_str = str("\t\tMinor Radius:\t", _mdr);
    
    // Tooth Thickness
    _tt = _cp / 2;
    _tt_str = str("\nTooth Thickness(arc):\t", _tt);
    
    // Tooth Angles
    _ta = 360 / _n;
    _ta_str = str("\nTooth Angle:\t", _ta);
    _tta = _ta / 2;
    _tta_str = str("\t\tTooth Thickness Angle:\t", _tta);

    _gear_info = str(
        "---GEAR INFORMATION---\"",
        "\n---------- USER DEFINED ----------",
        _m_str, _n_str, _pa_str, _ha_str, _res_str,
        "\n---------- CALCULATED ----------",
        _cp_str, _ccp_str, _pd_str, _pdr_str, _od_str, _odr_str,
        _a_str, _d_str, _cl_str, _wd_str, _ca_str, _ct_str,
        _bc_str, _bcr_str, _rd_str, _rr_str, _md_str, _mdr_str,
        _tt_str, _pdr_str, _ta_str, _tta_str,
        "\n----------\n");
    if (is_verbose)
        echo(_gear_info);

    /////////////////////////////////////////////
    /////   START OF INVOLUTE GENERATION    /////
    /////////////////////////////////////////////

    // Set Values based on whether the Base Circle is larger than the clearance point.
    // Define Involute Angle at the theoretical root of the profile.
    _ia_root = _bcr > _pdr - _a ? 0 : __hbhg__get_involute_angle_at_radius(_pdr - _a, _bcr);

    // Define the Clearance Point.  Either on the X axis or in the Involute Profile
    _clearance_pt = _bcr > _pdr - _a ? [_pdr - _a, 0] : __hbhg__get_involute_coordinate_at_angle(_ia_root, _bcr, _bc);

    // Find Involute Angle at OD. 
    _ia_major = __hbhg__get_involute_angle_at_radius(_odr, _bcr);

    // PointList that defines Flank A of tooth form.
    _inv_pts_a = __hbhg__involute_func_reverse(_ia_major, _ia_root, _res, _bc, _bcr);

    // PointList that defines Flank B of tooth form.
    _inv_pts_b = __hbhg__involute_func(_ia_root, _ia_major, _res, _bc, _bcr);

    // Add Bevel point in Clearance zone at root.
    _bevel_pt = [_clearance_pt[0] - _cl, _clearance_pt[1] - _cl];

    // Define OD point
    _od_pt = __hbhg__get_involute_coordinate_at_radius(_odr, _bcr, _bc);

    // Add bevel point to end of Involute form A.
    _flank_pts_a = concat([[_od_pt[0] + (2 * _wd), 0]], [[_od_pt[0] + (2 * _wd), _od_pt[1]]], _inv_pts_a, [_clearance_pt], [_bevel_pt]);

    // Add bevel point to start of Involute form B, and OD point to end.
    _flank_pts_b = concat([_bevel_pt], [_clearance_pt], _inv_pts_b, [_od_pt], [[_od_pt[0] + (2 * _wd), _od_pt[1]]]);

    // Define Pitch Diameter Point
    _pitch_pt = __hbhg__get_involute_coordinate_at_radius(_pdr, _bcr, _bc);

    // Get Polar Coordinate at Pitch Diameter
    _pitch_ppt = __hbhg__get_polar_from_coordinate(_pitch_pt);

    // Rotate FlankPTsA, compensate for start angle
    _rot_flank_pts_a = __hbhg__rotate_points_on_origin(_flank_pts_a, ((_tta * _bl) + _tta / 2) - _pitch_ppt[1]);

    // Rotate FlankPTsB
    _rot_flank_pts_b = __hbhg__rotate_points_on_origin(_flank_pts_b, ((_tta * _bl) + _tta / 2) - _pitch_ppt[1]);

    // Mirror RotFlankPTsB
    _mir_rot_flank_pts_b = __hbhg__mirror_points_on_x_axis(_rot_flank_pts_b);

    // Combine flank profiles
    _tooth_profile_pts = concat(_rot_flank_pts_a, _mir_rot_flank_pts_b);

    // Calculation for the helix twist angle across half the width (for herringbone)
    _twisted_angle = 360 * ((tan(_ha) * (width / 2)) / (_pdr * _pi));
    _sliced = (width / 2) / layer_thickness;

    ///////////////////////////////////////////////////////
    //////////  THIS IS THE DRAWING OF THE GEAR  //////////
    ///////////////////////////////////////////////////////
    translate([0, 0, width / 2])
        union(){
            // Top Half
            difference(){
                cylinder(h = width / 2, r = _odr, $fn=120);
                linear_extrude(height = width / 2 + 0.1, twist = _twisted_angle, center = false, slices = _sliced, convexity = 10)
                    __hbhg__tooth_form(_n, _tooth_profile_pts);
            }
            
            // Bottom Half
            mirror([0, 0, 1])
            difference(){
                cylinder(h = width / 2, r = _odr, $fn=120);
                linear_extrude(height = width / 2 + 0.1, twist = _twisted_angle, center = false, slices = _sliced, convexity = 10)
                    __hbhg__tooth_form(_n, _tooth_profile_pts);
            }
        }
}

// EXAMPLE CALL
//herringbone_helical_gear(
//    metric_module = 2,
//    number_of_teeth = 30,
//    helix_angle = 25,
//    width = 15,
//    is_verbose = true
//);