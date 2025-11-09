use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// serration
use<../../utils/circular-serration.scad>

// odroid model
include<odroid-h4-nas-constants.scad>
use<odroid-h4-model.scad>

// hdd
include<hdd-constants.scad>
use<hdd-models.scad>


///////////////
// Interface //
///////////////

// interface plate
module interface_plate(clearance=0.2)
{
    difference()
    {
        // baseplate
        cubepp( [H4_NAS_A, H4_NAS_A, H4_NAS_WT],
                align="z",
                mod_list=[round_edges(d=H4_NAS_INTERFACE_OFF)]);
        
        // corner holes
        mirrorpp([1,0,0],true)
            mirrorpp([0,1,0],true)
                translate([ H4_NAS_A/2-H4_NAS_INTERFACE_OFF/2,
                            H4_NAS_A/2-H4_NAS_INTERFACE_OFF/2,
                            0])
                    cylinderpp(d=H4_NAS_INTERFACE_ROD_D+2*clearance, h=3*H4_NAS_WT,align="");
    }
}


/////////////////////////
// ODROID compartement //
/////////////////////////

module odroid_mount_holes(clearance=0.2)
{
    difference()
    {
        // main shape
        translate([0,0,clearance])
            cylinderpp( d=H4_PCB_MP_DIAMETER+2*clearance,
                        h=H4_NAS_ODR_BOLT_OFFSET+3*clearance,
                        align="Z");
        // serration
        circular_serration( radius=H4_PCB_MP_DIAMETER/2+clearance,
                            height=H4_NAS_ODR_BOLT_OFFSET+2*clearance,
                            n_serration=16,
                            serration_bottom_d=3*clearance,
                            serration_top_d=2*clearance,
                            z_align="Z",
                            $fn=12);
    }
}


module odroid_compartement(clearance=0.2)
{

    difference()
    {
        union()
        {
            // base plate
            interface_plate(clearance=clearance);
            
            // spacers
            translate([0,H4_NAS_ODR_WT-H4_NAS_INTERFACE_OFF,H4_NAS_WT])
                translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
                    replicate_pcb_holes()
                        {
                            cylinderpp( d=H4_PCB_MP_CLEARED_DIAMETER,
                                        h=H4_PCB_BOTTOM_MINIMAL_CLEARANCE);
                            // base transition
                            difference()
                            {
                                cylinderpp( d=H4_PCB_MP_CLEARED_DIAMETER+2*H4_NAS_ODR_TRANSIOTION_D,
                                            h=H4_NAS_ODR_TRANSIOTION_D);
                                
                                translate([0,0,H4_NAS_ODR_TRANSIOTION_D])
                                    toruspp(   t=2*H4_NAS_ODR_TRANSIOTION_D,
                                                d=H4_PCB_MP_CLEARED_DIAMETER);
                            }   
                        }
            

            
        }

        // mount holes
        translate([ 0,
                    H4_NAS_ODR_WT-H4_NAS_INTERFACE_OFF,
                    H4_PCB_BOTTOM_MINIMAL_CLEARANCE+H4_NAS_WT])
        {
            pcb_visual();

            %translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
                port_holes();

            translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
                replicate_pcb_holes()
                    odroid_mount_holes();

        }

        
        //coordinate_frame();
        
        // hole for cables
        translate([-H4_PCB_A/2,0,0])
            cubepp( [H4_NAS_ODR_CH_W,H4_NAS_ODR_CH_L,3*H4_NAS_WT],
                    align="x",
                    mod_list=[round_edges(d=H4_NAS_ODR_CH_W)]);

    }
}


//////////////////////////
// HDD bay compartement //
//////////////////////////

// empty wall
module hdd_bay_non_mounting_wall(clearance=0.2)
{
    difference()
    {
        // intial shape
        cubepp([2*H4_NAS_HB_WT,
                HDD_X+2*clearance+2*H4_NAS_HB_WT,
                HDD_Y+2*clearance],
                align="z",
                mod_list=[round_edges(r=H4_NAS_HB_WT)]);

        // cutting half of the cube
        cubepp([2*H4_NAS_HB_WT,
                HDD_X+2*clearance+2*H4_NAS_HB_WT,
                3*HDD_Y+2*clearance],
                align="X");

        // removing part for cooling
        translate([0,0,H4_NAS_HB_RF_W])
            cubepp([3*H4_NAS_HB_WT,
                    HDD_X+2*clearance-2*H4_NAS_HB_RF_W-2*H4_NAS_HB_WT,
                    HDD_Y+2*clearance-2*H4_NAS_HB_RF_W],
                    align="z",
                    mod_list=[round_edges(r=H4_NAS_HB_RF_R, axes="yz")]);

    }
}

// hdd fastener
module hdd_fastener_hole(clearance=0.2)
{   
    rotate([-90,0,0])
        translate([0,0,-H4_NAS_HB_BOLT_OFFSET])
            bolt_hole(  standard=H4_NAS_HB_BOLT_STANDARD,
                        descriptor=H4_NAS_HB_BOLT_DESCRIPTOR,
                        clearance=clearance);
}

// holes for a single HDD
module hdd_slot_holes(clearance=0.2, wide_holes=false)
{
    translate([0,0,clearance])
    {
        //coordinate_frame();
        //%cubepp([HDD_Z,HDD_X,HDD_Y], align="xYz");

        // lower cut
        _w = (wide_holes ? 2 : 1) * (H4_NAS_HB_SPACING - (HDD_MP_S_Z+H4_NAS_HB_RF_W) -(H4_NAS_HB_SPACING-HDD_Z)/2);
        _h1 = HDD_MP_S1_X-H4_NAS_HB_RF_W-(H4_NAS_HB_RF_W)/2;
        translate([HDD_MP_S_Z+H4_NAS_HB_RF_W,0,H4_NAS_HB_RF_W])
            cubepp( [_w, 3*H4_NAS_HB_WT, _h1],
                    align="xz",
                    mod_list=[round_edges(d=min(_h1, 2*H4_NAS_HB_RF_R), axes="xz")]);
        // second cut
        _h2 = HDD_MP_S2_X-HDD_MP_S1_X-H4_NAS_HB_RF_W;
        translate([HDD_MP_S_Z+H4_NAS_HB_RF_W,0,H4_NAS_HB_RF_W+_h1+H4_NAS_HB_RF_W])
            cubepp( [_w, 3*H4_NAS_HB_WT, _h2],
                    align="xz",
                    mod_list=[round_edges(d=min(_h2, 2*H4_NAS_HB_RF_R), axes="xz")]);
        
        // third cut
        _h3 = HDD_MP_S3_X-HDD_MP_S2_X-H4_NAS_HB_RF_W;
        translate([HDD_MP_S_Z+H4_NAS_HB_RF_W,0,H4_NAS_HB_RF_W+_h1+H4_NAS_HB_RF_W+_h2+H4_NAS_HB_RF_W])
            cubepp( [_w, 3*H4_NAS_HB_WT, _h3],
                    align="xz",
                    mod_list=[round_edges(d=min(_h3, 2*H4_NAS_HB_RF_R), axes="xz")]);

        // top cut
        _h4 = HDD_Y-HDD_MP_S3_X-H4_NAS_HB_RF_W-(H4_NAS_HB_RF_W)/2;
        translate([ HDD_MP_S_Z+H4_NAS_HB_RF_W,
                    0,
                    H4_NAS_HB_RF_W+_h1+H4_NAS_HB_RF_W+_h2+H4_NAS_HB_RF_W+_h3+H4_NAS_HB_RF_W])
            cubepp( [_w, 3*H4_NAS_HB_WT, _h4],
                    align="xz",
                    mod_list=[round_edges(d=min(_h4, 2*H4_NAS_HB_RF_R), axes="xz")]);


        // add fasteners hole
        translate([0,-HDD_X/2-clearance,0])
            replicate_hdd_holes()
                hdd_fastener_hole(clearance=clearance);
        

    }

}

// a single wall for mounting hdds
module hdd_bay_mounting_wall(clearance=0.2)
{
    // hdd offset within the dedicated slot
    hdd_off = (H4_NAS_HB_SPACING-HDD_Z)/2;

    //coordinate_frame();
        
    difference()
    {
        cubepp([4*H4_NAS_HB_SPACING, H4_NAS_HB_WT, HDD_Y+2*clearance]);

        // TODO add middle hole

        // indivual hdd slots
        for (i=[0:3])
        {
            translate([i*H4_NAS_HB_SPACING+hdd_off,0,0])
            {
                if (i < 2)
                    translate([H4_NAS_HB_SPACING-2*hdd_off,0,0])
                        mirrorpp([1,0,0])
                            hdd_slot_holes( clearance=clearance);
                else
                    hdd_slot_holes(clearance=clearance,
                                    wide_holes=2==1);
                        

            }
        }
    }

    

}

// the HDD bay core
module hdd_core(clearance=0.2)
{
    // front and back wall
    mirrorpp([1,0,0], true)
        translate([2*H4_NAS_HB_SPACING,0,0])
            hdd_bay_non_mounting_wall(clearance);
    

    // side walls
    mirrorpp([0,1,0], true)
        translate([-2*H4_NAS_HB_SPACING,HDD_X/2+clearance,0])
            hdd_bay_mounting_wall(clearance);
}



module hdd_compartement(clearance=0.2)
{
    // lower plate
    interface_plate();

    // hdd bay
    translate([0,0,H4_NAS_WT])
        hdd_core(clearance=clearance);

    // reinforcements
    mirrorpp([0,1,0], true)
        translate([0,0,H4_NAS_WT])
            translate([0,H4_NAS_HB_WT+HDD_X/2+clearance,0])
                //coordinate_frame()
                difference()
                {
                    cubepp([4*H4_NAS_HB_SPACING,
                            H4_NAS_HB_RF_R-clearance,
                            H4_NAS_HB_RF_R], align="yz");
                    translate([0,H4_NAS_HB_RF_R,0])
                        cylinderpp( r=H4_NAS_HB_RF_R,
                                    h=5*H4_NAS_HB_SPACING,
                                    align="z",
                                    zet="x");
                };

}


//module odrioid_h4_nas(clearance=0.2)
//{
//    hdd_compartement(clearance=clearance);
//}




$fs = 0.1;
$fa = 5;

odroid_compartement(clearance=0.2);

//hdd_compartement(clearance=0.2);