include<../../../lib/solidpp/solidpp.scad>

SEAL_T = 1.2;
SEAL_DI = 28;
SEAL_DO = 35;

$fn = $preview ? 36 : 72;


module mold_interface(is_protruding, diameter, height, x_guage,  y_guage, clearance=0.1)
{
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate([x_guage/2, y_guage/2, is_protruding ? -clearance : 0])
                union()
                {
                    _d = is_protruding ? diameter-clearance : diameter+clearance;
                    _h = is_protruding ? height-clearance : height+clearance;
                    cylinderpp(d=_d, h=_h);
                }
}

module mold(size, interface_z_position, interface_x_guage, interface_y_guage, interface_height, interface_diameter, edges_rouding_radius)
{
    difference()
    {
        cubepp(size, mod_list = is_undef(edges_rouding_radius) ? undef : [round_edges(r=edges_rouding_radius)], align="z");
        translate([0,0,interface_z_position])
        {
            cubepp([2*size.x, 2*size.y, 0.01], align="");
            mold_interface( is_protruding=false,
                            diameter=interface_diameter,
                            height=interface_height,
                            x_guage=interface_x_guage,
                            y_guage=interface_y_guage);
        }
    }

    translate([0,0,interface_z_position])
        mold_interface( is_protruding=true,
                        diameter=interface_diameter,
                        height=interface_height,
                        x_guage=interface_x_guage,
                        y_guage=interface_y_guage);

}

module seal_mold(bottom_thickness=3, top_thickness=3, interface_height=1, interface_diameter=5, interface_offset = 2, seal_thickness=SEAL_T, seal_diameter_inner=SEAL_DI, seal_diameter_outer=SEAL_DO)
{
    _size = [   seal_diameter_outer + 2*interface_diameter + 2*interface_offset,
                seal_diameter_outer + 2*interface_diameter + 2*interface_offset,
                bottom_thickness + seal_thickness + top_thickness];
    difference()
    {
        // mold
        mold(   size=_size,
                interface_z_position=bottom_thickness+seal_thickness,
                interface_x_guage=seal_diameter_outer+interface_diameter,
                interface_y_guage=seal_diameter_outer+interface_diameter,
                interface_height=interface_height,
                interface_diameter=interface_diameter,
                edges_rouding_radius=interface_offset+interface_diameter/2);
        
        // seal
        translate([0,0,bottom_thickness])
            tubepp(d=seal_diameter_inner, D=seal_diameter_outer, h=seal_thickness, align="z");
    }
}

seal_mold();


//mold(size=[30,30,4], interface_z_position=2, interface_x_guage=20, interface_y_guage=20, interface_height=2, interface_diameter=5, edges_rouding_radius=4);


//seal_interface(is_protruding=true, diameter=10, height=2, x_guage=40, y_guage=30);