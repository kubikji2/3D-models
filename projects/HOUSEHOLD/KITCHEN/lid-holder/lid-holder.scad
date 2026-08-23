use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

$fn = $preview ? 36 : 72;

module lid_holder_interface(
    height,
    length,
    bt,
    wt,
    peg_d,
    has_fastener = true,
    is_nut = true,
    fasterner_d = 3,
    fasterner_clearance = 0.2,
    bolt_standard = "DIN84A",
    bolt_length = 20,
    nut_standard = "DIN562",
    //fasterner_wt = 3,
    //nut_standard = "DIN934",
    //tightener_d = 8,
    clearance=0)
{
    
    _interface_h = height - 2*bt + 2*clearance;
    
    _bolt_descriptor = str("M", fasterner_d, "x", bolt_length);

    // interface
    translate([peg_d/2+wt/2,0,0])
        cubepp( [2*length, _interface_h, _interface_h],
                align="x",
                mod_list=[bevel_edges(bevel=bt, axes="yz")]);
    
    // bolt and nut
    #translate([-peg_d/2-wt,0,0])
    rotate([0,-90,0])
    if (has_fastener)
    {
        bolt_hole(
            standard=bolt_standard,
            descriptor=_bolt_descriptor,
            align="t",
            hh_off=wt);
        translate([0,0,-bolt_length])
            nut_hole(
                d=fasterner_d,
                standard=nut_standard,
                s_off=height);
    }

    /*
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
    */

}


module connector(
    height = 13,
    length = 120,
    bt = 2,
    wt = 3,
    peg_d=7.7,
    fasterner_d = 3,
    fasterner_clearance = 0.2,
    bolt_standard = "DIN84A",
    bolt_length = 20,
    nut_standard = "DIN562",
    clearance=0.2,
    shaft_clearance=0.5)
{

    _interface_h = height - 2*bt - 2*clearance;
    
    _bolt_descriptor = str("M", fasterner_d, "x", bolt_length);

    // interface
    difference()
    {
        cubepp( [length, _interface_h, _interface_h],
                align="x",
                mod_list=[bevel_edges(bevel=bt, axes="yz")]);
        
        // bolt and nut
        _interface_offset = -peg_d-wt-wt/2;
        translate([_interface_offset-2*shaft_clearance,0,0])
        rotate([0,-90,0])
        {
            //coordinate_frame();
            translate([0,0,-shaft_clearance])
            bolt_hole(
                standard=bolt_standard,
                descriptor=_bolt_descriptor,
                align="t",
                hh_off=wt);
            translate([0,0,-bolt_length])
                nut_hole(
                    d=fasterner_d,
                    standard=nut_standard,
                    s_off=height);
        }

        translate([length-_interface_offset,0,0])
            mirrorpp([1,0,0])
                rotate([0,-90,0])
                {
                    translate([0,0,-shaft_clearance])
                    bolt_hole(
                        standard=bolt_standard,
                        descriptor=_bolt_descriptor,
                        align="t",
                        hh_off=wt);
                    translate([0,0,-bolt_length])
                        nut_hole(
                            d=fasterner_d,
                            standard=nut_standard,
                            s_off=height);
                }   


    }

}

module lid_holder_comb(
    wt        = 3,
    bt        = 2,
    height    = 13,
    //width     = 20,
    peg_angle = 15,
    peg_d=7.7,
    peg_count=6,
    //peg_count=1,
    peg_gauge=22,
    spacer_interface_wt = 2,
    spacer_interface_clearance=0.2,
    is_left=true)
{

    _offset = sin(peg_angle)*(height-wt/2) + peg_d/2;
    _x=2*wt+peg_d;
    _y=peg_count*(peg_gauge+peg_d)-peg_gauge + wt + _offset;
    _z=height;

    _peg_spacing = peg_gauge + peg_d;

    width = peg_d+2*wt;

    difference()
    {   
        union()
        { 
            //translate([0,-_offset,0])        
            //{
            //    cubepp( [width, _y, bt],
            //            align="yz",
            //            mod_list=[round_edges(d=width,axes="xy")]);
            //
            //    %cubepp(
            //            [_x,_y,_z],
            //            align="yz",
            //            mod_list=[round_edges(d=_x,axes="xy")]);
            //}

            for (i=[0:peg_count-1])
            {
                
                translate([0,i*_peg_spacing])
                {
                    _y_off = (height-bt)*sin(peg_angle);

                    hull()
                    {
                        cylinderpp(d=width, h=bt);
                        
                        translate([0,_y_off,height])
                            cylinderpp(d=peg_d+2*wt, h=bt, align="Z");
                    }

                    // previous
                    if (i > 0)
                    {
                        hull()
                        {
                            // this bottom
                            cylinderpp(d=peg_d, h=bt);
                            // this top
                            translate([0,_y_off,height])
                                cylinderpp(d=peg_d, h=bt, align="Z");
                            // previous bottom
                            translate([0,_y_off-(_peg_spacing)])
                                cylinderpp(d=peg_d, h=bt);
                        }
                    }

                    // next
                    if (i < peg_count-1)
                    {
                        hull()
                        {
                            // this bottom
                            cylinderpp(d=peg_d, h=bt);
                            // this top
                            translate([0,_y_off,height])
                                cylinderpp(d=peg_d, h=bt, align="Z");
                            // previous bottom
                            translate([0,_y_off+(_peg_spacing)])
                                cylinderpp(d=peg_d, h=bt);
                        }
                    }
                        
                }
            }
        }


        for (i=[0:peg_count-1])
        {
            translate([0,i*_peg_spacing,bt])
                rotate([-peg_angle,0,0])
                    cylinderpp(d=peg_d, h=height, align="z");
        }

        _interface_off = sin(peg_angle)*(height/2);
        
        // front interface
        translate([0,_peg_spacing+_interface_off,height/2])
            rotate([(is_left ? 180-peg_angle : peg_angle),is_left ? 0 : 180,0])
                lid_holder_interface(
                    height=height,
                    length=_x/2,
                    wt=wt,
                    bt=spacer_interface_wt,
                    peg_d=peg_d,
                    is_nut=is_left);

        // back interface
        translate([0,(peg_count-2)*_peg_spacing+_interface_off,height/2])
            rotate([(is_left ? 180-peg_angle : peg_angle),is_left ? 0 : 180,0])
                lid_holder_interface(
                    height=height,
                    length=_x/2,
                    wt=wt,
                    bt=spacer_interface_wt,
                    peg_d=peg_d,
                    is_nut=!is_left);

    }
}


//lid_holder_comb();
//
//translate([120+7.7+4,0,0])
//    lid_holder_comb(is_left=false);


translate([7.7/2+4/2, 22+7.7+1.5,13/2])
    rotate([-15,0,0])
        connector();