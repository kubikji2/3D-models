use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

$fn = $preview ? 36 : 72;

module lid_holder_interface(
    height,
    length,
    wt,
    has_fastener = true,
    is_nut = true,
    fasterner_d = 3,
    fasterner_clearance = 0.2,
    fasterner_wt = 3,
    nut_standard = "DIN934",
    tightener_d = 8,
    clearance=0)
{
    
    _interface_h = height - 2*wt + 2*clearance;
        
    // interface
    cubepp([length, _interface_h, _interface_h], align="x", mod_list=[bevel_edges(bevel=wt, axes="yz")]);
    
    // hole for the fastener
    if (has_fastener)
    {
        // cylinder
        cylinderpp(d=fasterner_d+2*fasterner_clearance, h=length, zet="x", align="X");

        translate([-fasterner_wt,0,0])
            if (is_nut)
            {
                    rotate([0,90,0])
                        nut_hole(
                            d=fasterner_d,
                            standard=nut_standard,
                            clearance=fasterner_clearance,
                            h_off=length,
                            align="t");
            }
            else
            {
                cylinderpp(d=tightener_d+2*fasterner_clearance, h=length, align="X", zet="x");

            }
    }

}


module lid_holder_comb(
    wt=4,
    height=10,
    peg_angle=15,
    peg_d=8,
    peg_count=6,
    peg_gauge=22,
    spacer_interface_wt = 1.2,
    spacer_interface_clearance=0.2,
    is_left=true)
{

    _offset = sin(peg_angle)*(height-wt) + peg_d/2+wt;
    _x=2*wt+peg_d;
    _y=peg_count*(peg_gauge+peg_d)-peg_gauge + wt + _offset;
    _z=height;

    _peg_spacing = peg_gauge + peg_d;

    difference()
    {    
        translate([0,-_offset,0])
            cubepp(
                [_x,_y,_z],
                align="yz",
                mod_list=[round_edges(d=_x,axes="xy")]);

        for (i=[0:peg_count-1])
        {
            translate([0,i*_peg_spacing,wt])
                rotate([-peg_angle,0,0])
                    cylinderpp(d=peg_d, h=height, align="z");
        }
        
        // front interface
        translate([0,_peg_spacing/2,height/2])
            rotate([0,is_left ? 0 : 180,0])
                lid_holder_interface(
                    height=height,
                    length=_x/2,
                    wt=spacer_interface_wt,
                    is_nut=is_left);

        // back interface
        translate([0,peg_count*_peg_spacing-3*_peg_spacing/2,height/2])
            rotate([0,is_left ? 0 : 180,0])
                lid_holder_interface(
                    height=height,
                    length=_x/2,
                    wt=spacer_interface_wt,
                    is_nut=!is_left);

    }
}

lid_holder_comb();

translate([50,0,0])
    lid_holder_comb(is_left=false);
