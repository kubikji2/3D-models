include<ivar-dimensions.scad>

use<../../../../lib/deez-nuts/deez-nuts.scad>
use<../../../../lib/solidpp/solidpp.scad>

module replicate_at_ivar_interface_holes()
{
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate([ivar_leg_hole_gauge_w/2, ivar_leg_hole_gauge_h/2,0])
                children();
}

// ???
module ivar_interface_holes(wall_thickness, clearance=0.2)
{
    replicate_at_ivar_interface_holes()
        cylinderpp(h=3*wall_thickness, d=ivar_leg_hole_diameter+2*clearance, align="");
}

module ivar_interface_hole_filling_peg(
    nut_standard,
    bolt_standard,
    bolt_descriptor,
    bolt_off = 3)
{
    // unpack data
    data = deez_nuts_parse_descriptor(bolt_descriptor);
    fastener_diameter = data[0];
    bolt_l = data[1]; 

    difference()
    {
        // peg
        cylinderpp( d=ivar_leg_hole_diameter-2*ivar_clearance,
                    h=bolt_l-bolt_off-get_nut_height(d=fastener_diameter,
                    standard=nut_standard));

        // bolt hole
        bolt_hole(  standard=bolt_standard,
                    descriptor=bolt_descriptor,
                    clearance=0.2);
        
        // nut hole -- abandoned as there is not enough space
        /*  
        nut_hole(   d=hole_filling_fastener_diameter,
                    standard=hole_filling_nut_standard);
        */
    }

}

module ivar_interface_hole_filling_interface(
    bolt_standard,
    bolt_descriptor,
    wall_thickness,
    hole_filling_interface_wall_thickness,
    bolt_off = 3
)
{

    translate([0,0,wall_thickness-bolt_off])
    difference()
    {
        union()
        {
        // bottom interface
        cylinderpp( d1=ivar_leg_hole_diameter+2*(bolt_off+hole_filling_interface_wall_thickness), 
                    d2=ivar_leg_hole_diameter+2*(hole_filling_interface_wall_thickness),
                    h=bolt_off+get_bolt_head_height(descriptor=bolt_descriptor, standard=bolt_standard),
                    align="z");
        
        // top brim
        /*
        translate([0,0,bolt_off])
            cylinderpp(d=ivar_leg_hole_diameter+2*wall_thickness,
                        h=get_bolt_head_height(descriptor=bolt_descriptor, standard=bolt_standard));
        */
        }

        // hole for the bolt
        translate([0,0,bolt_off])
            bolt_hole(  standard=bolt_standard,
                        descriptor=bolt_descriptor,
                        clearance=0.2,
                        align="m");
    }

}

//ivar_interface_hole_filling_interface(bolt_standard="DIN84A", bolt_descriptor="M3x30", hole_filling_interface_wall_thickness=1, wall_thickness=4);

//ivar_interface_hole_filling_peg(nut_standard="DIN934", bolt_standard="DIN84A", bolt_descriptor="M3x30");

module ivar_interface_basic_geometry(
    wall_thickness,
    height=undef,
    bevel=undef,
    clearance=0.1)
{
    join_w = ivar_leg_w + 2*(wall_thickness+clearance);
    join_d = ivar_leg_d + wall_thickness;
    join_h = is_undef(height) ? ivar_leg_hole_gauge_h + ivar_leg_hole_diameter+2*wall_thickness : height;
    join_bevel_r = is_undef(bevel) ? wall_thickness : bevel;

    // main shape with cut corners
    render(10)
    difference()
    {
        cubepp([join_w, join_h, join_d], align="Z", mod_list=[bevel_edges(join_bevel_r, axes="xz")]);

        translate([0,0,-wall_thickness+clearance])
            cubepp([ivar_leg_w+2*clearance, join_h, ivar_leg_d+wall_thickness], align="Z");
    }
}

//ivar_interface_basic_geometry(wall_thickness=4);

module ivar_interface(
    wall_thickness,
    bolt_standard=undef,
    bolt_descriptor=undef,
    has_bolts=false,
    has_stoppers=true,
    stopper_length=undef,
    hole_filling_interface_wall_thickness=1,
    bolt_off = 3,
    stopper_clearance = 0.2
    )
{
    assert ( (!has_bolts) || (!is_undef(bolt_descriptor) && !is_undef(bolt_standard)) ,"[ivar-interface] when using bolts (has_bolts=true), both bolt_standard and bolt_descriptor must be defined!");
    
    // add interface for the ivar
    difference()
    {
        ivar_interface_basic_geometry(wall_thickness=wall_thickness);
        if (has_bolts)
            ivar_interface_holes(wall_thickness=wall_thickness);
    }

    // add hole filling interface
    if (has_bolts)
    {
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([ivar_leg_hole_gauge_w/2, ivar_leg_hole_gauge_h/2,-wall_thickness])
                    ivar_interface_hole_filling_interface(
                        bolt_standard=bolt_standard,
                        bolt_descriptor=bolt_descriptor,
                        wall_thickness=wall_thickness,
                        hole_filling_interface_wall_thickness=hole_filling_interface_wall_thickness,
                        bolt_off = bolt_off);
    }

    if (has_stoppers)
    {
        _l = is_undef(stopper_length) ? ivar_leg_hole_depth-bolt_off : stopper_length;
        translate([0,0,-wall_thickness])
            replicate_at_ivar_interface_holes()
                cylinderpp( d=ivar_leg_hole_diameter-2*stopper_clearance,
                            h=_l,
                            align="Z");
    }
}

//ivar_interface(wall_thickness=4, stopper_length=10);
