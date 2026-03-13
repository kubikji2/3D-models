
use<../../lib/solidpp/solidpp.scad>
use<../../lib/deez-nuts/deez-nuts.scad>

include<bearing-dimensions.scad>

include<carriage-parameters.scad>
include<carriage-interface-parameters.scad>

include<sliding-rod-holder-parameters.scad>
include<item-20-dimensions.scad>


module carraige_replicate_at_bearings()
{
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate([srh_rod_gauge/2,(car_bearing_spacing+sb_h)/2,0])
                children();
}

module carriage_assembly_fasterner_pair(cut_clearance=0.5)
{
    render(4)
    {
        nut_hole(   d=car_assemble_fastener_d,
                    standard=car_assemble_nut_standard,
                    s_off=5);
        bolt_hole(  standard=car_assemble_bolt_standard,
                    descriptor=car_assemble_bolt_descriptor,
                    sh_off=2*cut_clearance);
    }
}

module carriage_interface_fastener_pair(cut_clearance=0.5)
{
    render(4)
    {
        nut_hole(   d=car_int_fastener_d,
                    standard=car_int_nut_standard,
                    s_off=5);
        bolt_hole(  standard="DIN84A",
                    descriptor=str("M", car_int_fastener_d, "x",2*car_int_fastener_offset),
                    sh_off=2*cut_clearance);
    }
}


module carriage_top_part(tight_clearance=0.1, cut_clearance = 0.5)
{

    _bearing_holder_d = sb_D + 2*car_wt;
    _bearing_holder_h = sb_h + 2*car_wt;


    _a = car_int_g_outer+2*car_int_offset;
    _y = car_bearing_spacing + 2*sb_h + 2*car_wt;
    
    // side height
    _sh = item20_a + 1;

    difference()
    {
        union()
        {
            // bearing interface
            render()
            intersection()
            {
                // bearing interface
                carraige_replicate_at_bearings()
                    difference()
                    {   
                        // bounding shape
                        cylinderpp(d=_bearing_holder_d, h=_bearing_holder_h, zet="y", align="");
                        
                        // cut for bearing
                        cylinderpp(d=sb_D+2*tight_clearance, h=sb_h+2*tight_clearance, zet="y", align="");
                        
                        // cut for sliding rods
                        cylinderpp(d=12.5, h=2*_bearing_holder_h, zet="y", align="");
                    }
            }


            // bearing interface
            render()
            intersection()
            {
                difference()
                {
                    cubepp([_a,_a,_sh], align="",
                        mod_list=[round_edges(r=car_int_offset, axes="xy")]);

                    // rod holes
                    mirrorpp([1,0,0], true)
                        translate([srh_rod_gauge/2,0,0])
                            cylinderpp(d=sb_D,h=2*_a, align="", zet="y");

                    // middle holes
                    _mx = _sh;//srh_rod_gauge-_bearing_holder_d-2*car_wt;
                    cubepp([_mx, 2*_a ,_sh], align="");

                }

                union()
                {
                    translate([0,0,-car_assemble_bolt_l/2])
                    cubepp([_a,_a,_a], align="z");

                    _tmp_d = _bearing_holder_d;
                    mirrorpp([1,0,0], true)
                        translate([srh_rod_gauge/2,0,0])
                            cylinderpp(d=_tmp_d, h=_a, zet="y", align="");
                }
            }

            // top interface
            translate([0,0,_sh/2])
                cubepp([_a,_a,car_mp_t], align="z",
                        mod_list=[round_edges(r=car_int_offset, axes="xy")]);
        }


        // interface mount points
        //if (!$preview)
        //translate([-car_int_g_outer/2,-car_int_g_outer/2,_sh/2+car_mp_t-car_int_fastener_offset])
        //    for (xi=[0:3])
        //        for(yi=[0:3])
        //        {
        //            x_off = xi*car_int_gauge;
        //            y_off = yi*car_int_gauge;
        //            orientation = xi % 2 == 0 ? 180 : 0;
        //            
        //            translate([x_off, y_off,0])
        //                rotate([0,0,orientation])
        //                    carriage_interface_fastener_pair();
//
        //        }

        
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([0,0,_sh/2+car_mp_t-car_int_fastener_offset])
                {
                    translate([car_int_g_outer/2,car_int_g_outer/2,0])
                        carriage_interface_fastener_pair();

                    translate([car_int_g_inner/2,car_int_g_inner/2,0])
                        rotate([0,0,180])
                            carriage_interface_fastener_pair();

                    translate([car_int_g_inner/2,car_int_g_outer/2,0])
                        rotate([0,0,180])
                            carriage_interface_fastener_pair();
            
                    translate([car_int_g_outer/2,car_int_g_inner/2,0])
                        carriage_interface_fastener_pair();
        }
        

        // split cut
        cubepp([2*_a,2*_a, cut_clearance], align="");

        // split fasteners
        
        mirrorpp([0,1,0], true)
            mirrorpp([1,0,0], true)
                translate([0,0,car_assemble_bolt_l/2])
                {
                    // inner in x, inner in y
                    __tmp_bearing_halg_guage = (srh_rod_gauge/2 - sb_D/2);
                    _inner_fastener_offset = __tmp_bearing_halg_guage-(__tmp_bearing_halg_guage-_sh/2)/2;
                    translate([_inner_fastener_offset,0,0])
                        rotate([0,180,0])
                            carriage_assembly_fasterner_pair();

                    // inner in x, outer in y            
                    _y_off = car_int_g_outer/2;
                    translate([_inner_fastener_offset,_y_off,0])
                        rotate([0,180,0])
                            carriage_assembly_fasterner_pair();
            
                    // outer in x, inner in y
                    translate([_y_off,car_bearing_spacing/2+car_int_offset/2,0])
                        rotate([180,0,0])

                        carriage_assembly_fasterner_pair();

                    // outer in x, outer in y
                    translate([_y_off,_y_off,0])
                        rotate([180,0,0])
                            carriage_assembly_fasterner_pair();
                }

        // greasing hole
        _ghw = car_bearing_spacing-2*car_wt;
        
        mirrorpp([1,0,0], true)
            translate([srh_rod_gauge/2,0,0])
                render()
                intersection()
                {
                    cubepp([_a,_ghw,_bearing_holder_d],
                            align="x",
                            mod_list=[round_edges(d=_ghw, axes="xy")]);
                    cubepp([_a,_ghw,_bearing_holder_d],
                            align="x",
                            mod_list=[round_edges(d=_ghw, axes="yz")]);

                }
        
    }

    // visualize bearings
    carraige_replicate_at_bearings()
        %tubepp( d=sb_d, D=sb_D, h=sb_h, zet="y", align="");



}


module carriage_bottom_part()
{


}


$fa = $preview ? 10 : 5;
$fs = $preview ? 0.1: 0.05;
carriage_top_part();