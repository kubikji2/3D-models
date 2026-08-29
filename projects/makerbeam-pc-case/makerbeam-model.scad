use<../../lib/solidpp/solidpp.scad>

include<makerbeam-constants.scad>

// for cylinder utils
include<../../lib/solidpp/utils/__cylinderpp_utils.scad>


module makerbeam_interface_hole(length, clearance, align="z", zet="z", has_inner_interface=true)
{
    _a = mb1010_a+2*clearance;

    _size = [_a,_a, length];
    
    // create 
    _compensated_size = __solidpp__cylinderpp__check_params(d=mb1010_a,h=length, zet=zet)[__CYLINDERPP_UTILS__size_idx];

    // get alignment offset
    _o = __solidpp__produce_offset_from_align_and_center(
            _size=_compensated_size,
            align=align,
            center=false,
            solidpp_name="makerbeam",
            def_align="xyz");

    // get rotation
    _rot = __solidpp__get_rotation_from_zet(zet,[0,0,0]);

    difference()
    {
        children();

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
                        translate([mb1010_ca/2+clearance,0,0])
                            cubepp([_a,mb1010_cw-2*clearance, 3*length], align="x");
                        // inner
                        if (has_inner_interface)
                            translate([mb1010_a/2-mb1010_n,0,0])
                                cubepp([_a,mb1010_id-2*clearance, 3*length], align="x");
                        
                    }
        }

    }

}



module makerbeam(length, align="", zet="")
{

    _size = [mb1010_a, mb1010_a, length];
    
    // create 
    _compensated_size = __solidpp__cylinderpp__check_params(d=mb1010_a,h=length, zet=zet)[__CYLINDERPP_UTILS__size_idx];
    //echo(_compensated_size);

    // get alignment offset
    _o = __solidpp__produce_offset_from_align_and_center(
            _size=_compensated_size,
            align=align,
            center=false,
            solidpp_name="makerbeam",
            def_align="xyz");
    //echo(_o);

    // get rotation
    _rot = __solidpp__get_rotation_from_zet(zet,[0,0,0]);
    //echo(_rot);

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

