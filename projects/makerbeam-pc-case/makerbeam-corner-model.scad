// master requirements
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// makerbeam model and hole
use<makerbeam-model.scad>

// makerbeam dimensions
include<makerbeam-constants.scad>

// this module parameteres
include<makerbeam-corner-parameters.scad>


module __makerbeam_corner_core(_off)
{

    hull()
    {
        translate([mb1010_a/2,-_off,-_off])
            cubepp([mbc_wt,mbc_wt+mb1010_a,mbc_wt+mb1010_a]);
                                
        translate([-_off,mb1010_a/2,-_off])
            cubepp([mbc_wt+mb1010_a,mbc_wt,mbc_wt+mb1010_a]);
        
        translate([-_off,-_off,mb1010_a/2])
            cubepp([mbc_wt+mb1010_a,mbc_wt+mb1010_a,mbc_wt]);
    }
}

module makerbeam_corner(
    clearance=0.1,
    bolt_clearance=0.2
    )
{
    
    _off = mbc_wt+mb1010_a/2;
    _b_off = mb1010_a/2; 

    // x beam
    translate([_off,0,0])
        %makerbeam(length=20, align="x", zet="x");
    
    // y-beam
    translate([0,_off,0])
        %makerbeam(length=20, align="y", zet="y");
    
    // z-beam
    translate([0,0,_off])
        %makerbeam(length=20, align="z", zet="z");
    

    // mastercube
    render(10)
    difference()
    {
        __a = mbc_wt+mb1010_a+mbc_wt+mbc_overlap;
        __off = mbc_wt + mb1010_a/2;

        //translate([0,0,0])
        makerbeam_interface_hole(
            length=2*mbc_overlap,
            tf=[_off,0,0],
            clearance=clearance,
            align="x", zet="x",
            has_inner_interface=false)
            makerbeam_interface_hole(
                length=2*mbc_overlap,
                tf=[0,_off,0],
                clearance=clearance,
                align="y", zet="y",
                has_inner_interface=false)
                makerbeam_interface_hole(
                    length=2*mbc_overlap,
                    tf=[0,0,_off],
                    clearance=clearance,
                    align="z", zet="z",
                    has_inner_interface=false)
                    {
                        //translate([-__off,-__off,-__off])
                        //    cubepp([__a,__a,__a], align="xyz");
                        
                        // wall hull
                        pairwise_hull()
                        {
                            translate([mb1010_a/2,-_off,-_off])
                                cubepp([mbc_wt+mbc_overlap,mbc_wt+mb1010_a,mbc_wt+mb1010_a]);
                            
                            translate([-_off,mb1010_a/2,-_off])
                                cubepp([mbc_wt+mb1010_a,mbc_wt+mbc_overlap,mbc_wt+mb1010_a]);
                            
                            translate([-_off,-_off,mb1010_a/2])
                                cubepp([mbc_wt+mb1010_a,mbc_wt+mb1010_a,mbc_wt+mbc_overlap]);
                        
                            translate([mb1010_a/2,-_off,-_off])
                                cubepp([mbc_wt+mbc_overlap,mbc_wt+mb1010_a,mbc_wt+mb1010_a]);
                        }

                        // core hull
                        __makerbeam_corner_core(_off);


                    }
                    

        // removing "cube" ...  
        _wall_off = mbc_wt;
        difference()
        {
            union()
            {
                // ... x-axis
                translate([-__off+_wall_off,mb1010_a/2,mb1010_a/2])
                    cubepp([__a,__a,__a], align="xyz");
                
                // ... y-axis
                translate([mb1010_a/2,-__off+_wall_off,mb1010_a/2])
                    cubepp([__a,__a,__a], align="xyz");
                
                // ... z-axis
                translate([mb1010_a/2,mb1010_a/2,-__off+_wall_off])
                    cubepp([__a,__a,__a], align="xyz");
            }
            __makerbeam_corner_core(_off);
        }

        // removing the interface ...
        // ... x-axis
        translate([__off,-mb1010_ca/2,-mb1010_ca/2])
            cubepp([3*__a,__a,__a], align="xyz");
        
        // ... y-axis
        translate([-mb1010_ca/2,__off,-mb1010_ca/2])
            cubepp([__a,3*__a,__a], align="xyz");
        
        // ... z-axis
        translate([-mb1010_ca/2,-mb1010_ca/2,__off])
            cubepp([__a,__a,3*__a], align="xyz");
        
        // bolt holes ...
        // ... x-axis
        rotate([0,-90,0])
            translate([0,0,-_b_off])
                bolt_hole( standard=mbc_bolt_standard,
                            descriptor=mbc_bolt_descriptor,
                            hh_off=__a,
                            align="m",
                            clearance=bolt_clearance);
        // ... y-axis
        rotate([90,0,0])
            translate([0,0,-_b_off])
                bolt_hole( standard=mbc_bolt_standard,
                            descriptor=mbc_bolt_descriptor,
                            hh_off=__a,
                            align="m",
                            clearance=bolt_clearance);
        // ... z-axis
        rotate([180,0,0])
            translate([0,0,-_b_off])
                bolt_hole( standard=mbc_bolt_standard,
                            descriptor=mbc_bolt_descriptor,
                            hh_off=__a,
                            align="m",
                            clearance=bolt_clearance);

        //translate([-_off,-_off,-_off])
        //    cubepp([mb1010_a+mbc_wt,mb1010_a+mbc_wt,mb1010_a+mbc_wt]);



    }
    
    //makerbeam_interface_hole(length=10, clearance=clearance);
    //makerbeam_interface_hole(length=10, clearance=clearance);


}

$fn = $preview ? 36 : 120;
makerbeam_corner();