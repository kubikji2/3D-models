use<../../lib/solidpp/solidpp.scad>

include<makerbeam-constants.scad>

// for cylinder utils
//include<../../lib/solidpp/utils/__cylinderpp_utils.scad>

// bounding box of the beam along 'zet' (the nominal beam, without clearance)
function makerbeam_bbox(a, length, zet) =
    zet == "x" || zet == "X" ? [length, a, a] :
    zet == "y" || zet == "Y" ? [a, length, a] :
                               [a, a, length];


module makerbeam_interface_hole(length, clearance, tf=[0,0,0], align="z", zet="z", has_inner_interface=true)
{
    _a = mb1010_a+2*clearance;

    // get alignment offset
    // '-> pos="" is the box centre, so only the offset from 'align' is left
    _o = get_translation_to_spp(
            size=makerbeam_bbox(mb1010_a, length, zet),
            align=is_undef(align) ? "xyz" : align,
            pos="");

    // get rotation
    _rot = __solidpp__get_rotation_from_zet(zet, [0,0,0]);

    difference()
    {
        children();

        translate(tf)
        translate(_o)
        rotate(_rot)
        translate([0,0,-length/2]) // align to the center
        difference()
        {
            // main shape
            translate([0,0,-clearance])
                cubepp([_a,_a, length+clearance], align="z");
            
            mirrorpp([1,1,0], true)
                mirrorpp([-1,1,0], true)
                    {
                        // outer interface
                        translate([mb1010_a/2-mb1010_n,0,0])
                            cubepp([_a,mb1010_id-2*clearance, 3*length], align="x");
                        
                        // inner
                        if (has_inner_interface)
                            translate([mb1010_ca/2+clearance,0,0])
                                cubepp([_a,mb1010_cw-2*clearance, 3*length], align="x");
                        
                    }
        }

    }

}



module makerbeam(length, align="", zet="")
{

    _size = [mb1010_a, mb1010_a, length];
    
    // get alignment offset
    // '-> pos="" is the box centre, so only the offset from 'align' is left
    _o = get_translation_to_spp(
            size=makerbeam_bbox(mb1010_a, length, zet),
            align=is_undef(align) ? "xyz" : align,
            pos="");

    // get rotation
    _rot = __solidpp__get_rotation_from_zet(zet, [0,0,0]);

    translate(_o)
    rotate(_rot)
    translate([0,0,-length/2]) // align to the center
    {
        cubepp([mb1010_ca, mb1010_ca, length], align="z");

        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
            {
                // V-shape on the edge
                translate([mb1010_a/2,mb1010_a/2,0])
                    mirrorpp([1,-1,0], true)
                        cubepp([mb1010_wa,mb1010_n,length], align="XYz");
                // diagonal connection
                hull()
                {
                    // core
                    translate([mb1010_ca/2,mb1010_ca/2,0])
                        cubepp([(mb1010_ca-mb1010_cw)/2,(mb1010_ca-mb1010_cw)/2, length], align="XYz");
                    
                    // edge
                    translate([mb1010_a/2,mb1010_a/2,0])
                        cubepp([mb1010_n,mb1010_n,length], align="XYz");
                    
                }
            }
    }
}

