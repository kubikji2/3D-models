use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

// serration
use<../../utils/circular-serration.scad>
// stencils
use<../../utils/stencils.scad>
// 20-sided object
use<../../utils/icosahedron.scad>


// odroid model
include<odroid-h4-nas-constants.scad>
use<odroid-h4-model.scad>

// hdd
include<hdd-constants.scad>
use<hdd-models.scad>

// fans
include<cooling-fan-constants.scad>

// connectors
include<connectors-constants.scad>

///////////////
// Interface //
///////////////

module replicate_at_interface()
{
    mirrorpp([1,0,0],true)
        mirrorpp([0,1,0],true)
            translate([ H4_NAS_INTERFACE_ROD_G/2,
                        H4_NAS_INTERFACE_ROD_G/2,
                        0])
                children();
}

module interace_holes(  h,
                        z_align="",
                        clearance=H4_NAS_INTERFACE_ROD_CLEARANCE)
{
    // corner holes
    replicate_at_interface()
        cylinderpp( d=H4_NAS_INTERFACE_ROD_D+2*clearance,
                    h=h,
                    align=z_align);
    
}


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
        interace_holes(h=3*H4_NAS_WT, z_align="", clearance=H4_NAS_INTERFACE_ROD_CLEARANCE);
    }
}

// interface foot
module interface_foot()
{
    difference()
    {
        // main shape
        cylinderpp( d=H4_NAS_INTERFACE_FOOT_D,
                    h=H4_NAS_INTERFACE_FOOT_H,
                    align="z",
                    mod_list=[bevel_bases(bevel_top=(H4_NAS_INTERFACE_FOOT_D-H4_NAS_INTERFACE_OFF)/2)]);
        
        // rod hole
        _d = H4_NAS_INTERFACE_ROD_D + 2*H4_NAS_INTERFACE_ROD_CLEARANCE;
        translate([0,0,H4_NAS_INTERFACE_FOOT_MIN_WALL])
            cylinderpp(d=_d, h=H4_NAS_INTERFACE_FOOT_H, align="z");

        // nut hole
        translate([0,0,2*H4_NAS_INTERFACE_FOOT_H/3])
            nut_hole(   d=H4_NAS_INTERFACE_ROD_D,
                        standard=H4_NAS_INTERFACE_NUT_STANDARD,
                        align="m");
        
        //_nut_h = get_nut_height(d=H4_NAS_INTERFACE_ROD_D, standard=H4_NAS_INTERFACE_NUT_STANDARD);
        //cubepp([10,10,10]);
        //%translate([0,0,2*H4_NAS_INTERFACE_FOOT_H/3-_nut_h/2])
        //    cylinderpp(d=H4_NAS_INTERFACE_FOOT_D,h=H4_NAS_INTERFACE_FOOT_H/3+_nut_h/2);
        //echo(H4_NAS_INTERFACE_FOOT_H/3+_nut_h/2);
    }
}

// interface head
module interface_head()
{
    difference()
    {
        // main shape
        icosahedron(H4_NAS_INTERFACE_HEAD_EDGE);

        // rod hole
        _d = H4_NAS_INTERFACE_ROD_D + 2*H4_NAS_INTERFACE_ROD_CLEARANCE;
        translate([0,0,-H4_NAS_INTERFACE_HEAD_EDGE/2])
            cylinderpp(d=_d, h=1.5*H4_NAS_INTERFACE_HEAD_EDGE, align="z");
        
        // nut hole
        nut_hole(   d=H4_NAS_INTERFACE_ROD_D,
                    standard=H4_NAS_INTERFACE_NUT_STANDARD,
                    align="m");
        //%cylinderpp(d=H4_NAS_INTERFACE_FOOT_D,h=H4_NAS_INTERFACE_OFF);
        //_h = (0.5*(sqrt(5)+1))*H4_NAS_INTERFACE_HEAD_EDGE/2;
        //echo(_h+get_nut_height(d=H4_NAS_INTERFACE_ROD_D, standard=H4_NAS_INTERFACE_NUT_STANDARD));
        //%cylinderpp(d=5,h=_h, align="z");
        //cubepp([10,10,10]);
    }
}


///////////
// SHELL //
///////////
module nas_parametric_shell(height, has_top=true)
{
    difference()
    {
        union()
        {
            // basic shell shape
            difference()
            {
                // shell
                cubepp([H4_NAS_A,
                        H4_NAS_A,
                        height],
                        align="z",
                        mod_list=[round_edges(d=H4_NAS_INTERFACE_OFF)]);

                // inner cut
                translate([0,0,-H4_NAS_WT])
                cubepp([H4_NAS_A-2*H4_NAS_WT,
                        H4_NAS_A-2*H4_NAS_WT,
                        height+(has_top ? 0 : 2*H4_NAS_WT)],
                        align="z",
                        mod_list=[round_edges(d=H4_NAS_INTERFACE_OFF-H4_NAS_WT)]);                
            }
            // add corner spacers for rod
            replicate_at_interface()
                cylinderpp( d=H4_NAS_INTERFACE_OFF,
                            h=height,
                            align="z");
        }

        // interface rod holes
        interace_holes(h=3*height);
    }

}

module nas_parametric_shell_pattern_holes(  area_h,
                                            hexagon_d)
{

    // pattern dimensions
    pattern_y = deez_nutz_polygon_width_to_circumscribed_diameter(hexagon_d);
    pattern_x = hexagon_d;
    
    // number of pattern in x (vertical) direction
    n_pattern_x = floor(area_h/pattern_x);
    n_pattern_y = floor(H4_PCB_A/pattern_y);

    // offset to center the pattern
    pattern_offset_x = (area_h-n_pattern_x*pattern_x)/2;
    pattern_offset_y = (H4_PCB_A-n_pattern_y*pattern_x)/2;

    pattern_count_x = n_pattern_x+2;
    pattern_count_y = n_pattern_y+2;
    
    translate([H4_NAS_WT,0,0])
        stencil(pattern_size_x=pattern_x,
                pattern_size_y=pattern_y,
                pattern_spacing_x=0,
                pattern_spacing_y=0,
                pattern_count_x=pattern_count_x,
                pattern_count_y=pattern_count_y,
                pattern_offset_x=pattern_offset_x,
                pattern_offset_y=(-H4_PCB_A/2),
                modulo_offset_y=pattern_y/2)
        {
            // pattern
            cylinderpp(d=hexagon_d,
                        h=3*H4_NAS_WT,
                        $fn=6,
                        align="");
            // area
            cubepp([area_h,H4_PCB_A,3*H4_NAS_WT], align="x");
        }
}

module nas_fan_pattern_holes(hexagon_d)
{

    area_h = H4_PCB_A;
    // pattern dimensions
    pattern_y = deez_nutz_polygon_width_to_circumscribed_diameter(hexagon_d);
    pattern_x = hexagon_d;
    
    // number of pattern in x (vertical) direction
    n_pattern_x = floor(area_h/pattern_x);
    n_pattern_y = floor(H4_PCB_A/pattern_y);

    // offset to center the pattern
    pattern_offset_x = -H4_PCB_A/2-pattern_x/2;
    pattern_offset_y = -H4_PCB_A/2;
    
    pattern_count_x = n_pattern_x+3;
    pattern_count_y = n_pattern_y+2;
    
    //translate([H4_NAS_WT,0,0])
    stencil(pattern_size_x=pattern_x,
            pattern_size_y=pattern_y,
            pattern_spacing_x=0,
            pattern_spacing_y=0,
            pattern_count_x=pattern_count_x,
            pattern_count_y=pattern_count_y,
            pattern_offset_x=pattern_offset_x,
            pattern_offset_y=pattern_offset_y,
            modulo_offset_y=pattern_y/2)
    {
        // pattern
        cylinderpp(d=hexagon_d,
                    h=3*H4_NAS_WT,
                    $fn=6,
                    align="");
        // area
        cylinderpp(d=H4_CF_BLADE_D,h=3*H4_NAS_WT, align="");
    
    }

}

//////////
// FANS //
//////////

module fan_interface(height=5, clearance=0.2)
{
    mirrorpp([0,1,0], true)
        mirrorpp([1,0,0], true)
            translate([H4_CF_BOLT_G/2, H4_CF_BOLT_G/2, 0])
                cylinderpp(d1=H4_CF_BOLT_D-2*clearance, d2=H4_CF_BOLT_D, h=height);
}

// cable vent hole with compartement for cables
module fan_vent_hole_with_cables()
{
    // add hole for the fan
    cylinderpp(d=H4_CF_BLADE_D,h=3*H4_NAS_ODR_WT, align="");

    _smoothing_r = (H4_CF_A-H4_CF_BLADE_D);
    cube_d = H4_CF_BLADE_D/2-2*_smoothing_r;
    translate([-_smoothing_r,0,0])
        cubepp([cube_d+_smoothing_r, H4_CF_BLADE_D/2,3*H4_NAS_WT],
                align="xy",
                mod_list=[round_edges(r=_smoothing_r)]);
    translate([0,-_smoothing_r,0])
        cubepp([H4_CF_BLADE_D/2,cube_d+_smoothing_r,3*H4_NAS_WT],
                align="xy",
                mod_list=[round_edges(r=_smoothing_r)]);
    translate([cube_d, cube_d,0])
        difference()
        {
            cubepp([_smoothing_r, _smoothing_r, 3*H4_NAS_WT], align="xy");
            cylinderpp(r=_smoothing_r, h=9*H4_NAS_WT, align="xy");
        }
}

// fans with holes for SATA cables
module fan_ven_hole_with_SATA_cables()
{
    _smoothing_r = (H4_CF_A-H4_CF_BLADE_D);

    translate([0,0,-1.5*H4_NAS_WT])
        linear_extrude(3*H4_NAS_WT)
            offset(_smoothing_r)
            offset(-_smoothing_r)
            offset(-_smoothing_r)
            offset(_smoothing_r)
                union()
                {
                    circlepp(d=H4_CF_BLADE_D);
                    squarepp([H4_CF_A/2,H4_CF_A+2*CABLE_T],align="");
                }

    //cubepp([H4_PCB_A,H4_PCB_A,20], align="");
    
    /*
    %render(10)
    mirorpp([0,1,0], true)
    {   
        fan_vent_hole_with_cables();
 
        rotate([0,0,90])
            fan_vent_hole_with_cables();

        // SATA CABLES hole
        _smoothing_r = (H4_CF_A-H4_CF_BLADE_D);
        translate([0,H4_CF_A/2+CABLE_T,0])
            cubepp([H4_CF_BOLT_G-2*_smoothing_r,H4_NAS_A/2,3*H4_NAS_WT],
                    align="Y",
                    mod_list=[round_edges(r=_smoothing_r)]);
    }
    */
}


// there is only shell
module top_fan_shell()
{

    difference()
    {
        // main shape
        union()
        {
            nas_parametric_shell(H4_NAS_FB_H);
            
            // handles reinforcements
            translate([0,0,H4_NAS_FB_H-H4_NAS_WT])
            difference()
            {
                cubepp( [H4_NAS_A,H4_NAS_A,H4_NAS_HND_RF_H],
                        align="Z",
                        mod_list=[round_edges(d=H4_NAS_INTERFACE_OFF)]);
                // inner cut
                cubepp( [H4_NAS_A-2*H4_NAS_HND_RF_W,H4_NAS_A-2*H4_NAS_HND_RF_W,3*H4_NAS_HND_RF_H],
                        align="",
                        mod_list=[round_edges(d=H4_NAS_INTERFACE_OFF-H4_NAS_HND_RF_W)]);
            }
        }

        // holes
        interace_holes(h=3*H4_NAS_FB_H);

        // cooling fan holes
        translate([0,0,H4_NAS_FB_H])
            nas_fan_pattern_holes(hexagon_d=H4_NAS_ACTIVE_COOLING_D);
        
        //%cubepp([H4_CF_BLADE_D/2,H4_CF_BLADE_D/2,H4_NAS_FB_H]);
        
        // handle mounts
        mirrorpp([1,0,0], true)        
            mirrorpp([0,1,0], true)
                translate([H4_NAS_A/2-H4_NAS_HND_RF_W,
                            H4_NAS_HND_MNT_G/2,
                            H4_NAS_FB_H-H4_NAS_WT-H4_NAS_HND_RF_H/2])
                    rotate([0,-90,0])
                        bolt_hole(  descriptor=str("M",H4_NAS_HND_MNT_D,"x",H4_NAS_HND_RF_W),
                                    standard=H4_NAS_HND_MNT_STANDARD,
                                    clearance=0.2,
                                    align="t");

    }   

    // fan pin
    translate([0,0,H4_NAS_FB_H-H4_NAS_FB_PIN_HEIGHT-H4_NAS_WT])
        fan_interface(H4_NAS_FB_PIN_HEIGHT);

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
            interface_plate(clearance=H4_NAS_INTERFACE_ROD_CLEARANCE);
            
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
            //pcb_visual();

            //%translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
            //    odroid_h4_port_holes();

            translate([-H4_PCB_A/2, -H4_PCB_A/2, 0])
                replicate_pcb_holes()
                    odroid_mount_holes();

        }

        _pcb_shift = (H4_NAS_INTERFACE_OFF-H4_NAS_ODR_WT);
        _y_off = H4_PCB_A/2-_pcb_shift-(H4_PCB_A-H4_PCB_MP_LU_Y)-H4_NAS_ODR_HOLE_OFF;
        _y_lower = H4_PCB_A/2-H4_PCB_MP_RD_Y+_pcb_shift-H4_NAS_ODR_HOLE_OFF;
        _w = H4_PCB_A-H4_PCB_MP_LU_X-(H4_PCB_A-H4_PCB_MP_RU_X)-2*H4_NAS_ODR_HOLE_OFF;
        _l = _y_off+_y_lower;//H4_PCB_A/2+0*(H4_PCB_A/2-H4_PCB_MP_RD_Y);
        translate([0,_y_off,0])
            cubepp([H4_PCB_A,
                    _l,
                    3*H4_NAS_WT],
                    align="Y",
                    mod_list=[round_edges(d=H4_NAS_ODR_HOLE_OFF)]);

        translate([0,H4_PCB_A/2-_pcb_shift,0])
            cubepp([_w,
                    _l,
                    3*H4_NAS_WT],
                    align="Y",
                    mod_list=[round_edges(d=H4_NAS_ODR_HOLE_OFF)]);

        mirrorpp([1,0,0], true)
            translate([_w/2, _y_off,0])
                difference()
                {
                    cubepp([H4_NAS_ODR_HOLE_OFF, H4_NAS_ODR_HOLE_OFF, 3*H4_NAS_WT], align="xy");
                    cylinderpp(r=H4_NAS_ODR_HOLE_OFF, h=9*H4_NAS_WT, align="xy");
                }
        

        // hole for cables
        //translate([-H4_PCB_A/2,0,0])
        //    cubepp( [H4_NAS_ODR_CH_W,H4_NAS_ODR_CH_L,3*H4_NAS_WT],
        //            align="x",
        //            mod_list=[round_edges(d=H4_NAS_ODR_CH_W)]);

    }
}

// odroid shell
module odroid_shell(has_fan=true)
{
    difference()
    {
        
        // basic shell
        nas_parametric_shell(height=H4_NAS_ODR_SHELL_H);
        
        // odroid holes
        translate([-H4_PCB_A/2, -H4_NAS_A/2, H4_PCB_T+H4_PCB_BOTTOM_MINIMAL_CLEARANCE])
            odroid_h4_port_holes(   t=H4_NAS_WT,
                                    bevel=H4_NAS_ODR_PORT_BEVEL,
                                    clearance=H4_NAS_ODR_PORT_CLEARANCE);

        // ventilation holes
        ventilation_h = H4_NAS_ODR_SHELL_H-2*H4_NAS_WT;

        translate([H4_NAS_A/2,0,0])
            rotate([0,-90,0])
                nas_parametric_shell_pattern_holes( area_h=ventilation_h,
                                                    hexagon_d=H4_NAS_ACTIVE_COOLING_D);

        translate([-H4_NAS_A/2,0,0])
            rotate([0,-90,0])
                nas_parametric_shell_pattern_holes( area_h=ventilation_h,
                                                    hexagon_d=H4_NAS_ACTIVE_COOLING_D);
        
        translate([0,H4_NAS_A/2,0])
            rotate([0,-90,90])
                nas_parametric_shell_pattern_holes( area_h=ventilation_h,
                                                    hexagon_d=H4_NAS_ACTIVE_COOLING_D);
        

        // fan holes
        translate([0,0,H4_NAS_ODR_SHELL_H])
        if (has_fan)
        {
            fan_vent_hole_with_cables();
        }
        else
        {
            // TODO add mesh for the ventilation
        }
    }   
    
    // stumbs for the fan, if present
    //if (has_fan)
    //{
    //    // add stumbs
    //    translate([0,0,H4_NAS_ODR_SHELL_H])
    //        fan_interface();
    //} 
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
module hdd_core(clearance=0.5)
{

    //
    //_w = H4_NAS_A-2*H4_NAS_WT-2;
    //#cubepp([_w,H4_PCB_A,10], align="z");

    // front and back wall
    mirrorpp([1,0,0], true)
        translate([2*H4_NAS_HB_SPACING,0,0])
            hdd_bay_non_mounting_wall(clearance);
    

    // side walls
    mirrorpp([0,1,0], true)
        translate([-2*H4_NAS_HB_SPACING,HDD_X/2+clearance,0])
            hdd_bay_mounting_wall(clearance);
}


// HDD bay compartement
module hdd_compartement(clearance=0.5)
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


// hdd cover shell
module hdd_shell()
{
    difference()
    {

        nas_parametric_shell(height=H4_NAS_HB_COMPARTEMENT_HEIGHT);
        //echo(H4_NAS_HB_COMPARTEMENT_HEIGHT);

        // add pattern for passive ventilation
        ventilation_h = H4_NAS_HB_SHELL_H-2*H4_NAS_ODR_WT;
        mirrorpp([1,0,0],true)
            translate([H4_NAS_A/2,0,0])
                rotate([0,-90,0])
                    nas_parametric_shell_pattern_holes( area_h=ventilation_h,
                                                        hexagon_d=H4_NAS_PASSIVE_COOLING_D);

        mirrorpp([0,1,0],true)
            translate([0,H4_NAS_A/2,0])
                rotate([0,-90,90])
                    nas_parametric_shell_pattern_holes( area_h=ventilation_h,
                                                        hexagon_d=H4_NAS_PASSIVE_COOLING_D);

        // add top hole for the fan
        translate([0,0,H4_NAS_HB_SHELL_H])
            fan_ven_hole_with_SATA_cables();
            //cylinderpp(d=H4_CF_BLADE_D, h=3*H4_NAS_ODR_WT, align="");

    }   

}

module hdd_intake_shell()
{
    difference()
    {
        // main shape
        nas_parametric_shell(H4_NAS_HB_INTAKE_H, false);

        // ventilation holes
        mirrorpp([1,1,0], true)
            mirrorpp([1,0,0], true)    
                translate([H4_NAS_A/2,0,0])
                    rotate([0,-90,0])
                        nas_parametric_shell_pattern_holes( area_h=H4_NAS_HB_INTAKE_H-2*H4_NAS_WT,
                                                            hexagon_d=H4_NAS_ACTIVE_COOLING_D);

    }
}


module hdd_fan_shell()
{

    difference()
    {
        // main shape
        nas_parametric_shell(H4_NAS_FB_H);
           

        // holes
        interace_holes(h=3*H4_NAS_FB_H);

        // cooling fan holes
        translate([0,0,H4_NAS_FB_H])
            fan_ven_hole_with_SATA_cables();
            
    }

    // fan pin
    translate([0,0,H4_NAS_FB_H-H4_NAS_FB_PIN_HEIGHT-H4_NAS_WT])
        fan_interface(H4_NAS_FB_PIN_HEIGHT);

}


//module odrioid_h4_nas(clearance=0.2)
//{
//    hdd_compartement(clearance=clearance);
//}




$fs = 0.1;
$fa = 5;

//interface_head();

//top_fan_shell();
//echo(H4_NAS_FB_H);
//#cylinderpp(d=10, h=H4_NAS_FB_H);

//odroid_shell();
//echo(H4_NAS_ODR_SHELL_H);
//#cylinderpp(d=120, h=H4_NAS_ODR_SHELL_H);

//odroid_compartement(clearance=0.2);
//echo(H4_NAS_WT);
//#cubepp([100,100,H4_NAS_WT]);

//hdd_intake_shell();
//echo(H4_NAS_HB_INTAKE_H);
//#cubepp([100,100, H4_NAS_HB_INTAKE_H]);

//hdd_fan_shell();
//echo(H4_NAS_FB_H);
//cubepp([100,100, H4_NAS_FB_H]);

//translate([0,0,H4_NAS_ODR_WT])
//hdd_shell();
//echo(H4_NAS_HB_COMPARTEMENT_HEIGHT);
//#cubepp([100,100, H4_NAS_HB_COMPARTEMENT_HEIGHT]);

//hdd_compartement();
//echo(H4_NAS_WT);
//#cubepp([100,100, H4_NAS_WT]);

interface_foot();