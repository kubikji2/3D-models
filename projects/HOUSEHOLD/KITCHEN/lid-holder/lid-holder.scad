use<../../../../lib/solidpp/solidpp.scad>
use<../../../../lib/deez-nuts/deez-nuts.scad>

$fn = $preview ? 36 : 72;

module lid_holder_interface(
    interface_d,
    interface_cut_off,
    thickness,
    fasterner_d = 3,
    fasterner_clearance = 0.2,
    bolt_standard = "DIN84A",
    bolt_length = 20,
    nut_standard = "DIN562",
    clearance=0,
    has_groove=true)
{

    _bolt_descriptor = str("M", fasterner_d, "x", bolt_length);

    // bolt and nut
    rotate([0,0,-90])
    {
        bolt_hole(
            standard=bolt_standard,
            descriptor=_bolt_descriptor,
            align="t",
            hh_off=10,
            sh_off=2);
        translate([0,0,-bolt_length])
            nut_hole(
                d=fasterner_d,
                standard=nut_standard,
                s_off=10);
    }

    if (has_groove)
        translate([0,0,-thickness])
            difference()
            {
                cylinderpp(d=interface_d+2*clearance, h=thickness, align="Z");
                translate([0,-(interface_d+2*clearance)/2+interface_cut_off,0])
                    cubepp([interface_d+2*clearance, interface_d+2*clearance, 3*thickness], align="Y");
            }
}


module connector(
    diameter            = 8,
    off                 = 1,
    length              = 60,
    thickness           = 5,
    fasterner_d         = 3,
    fasterner_clearance = 0.2,
    bolt_standard       = "DIN84A",
    bolt_length         = 20,
    nut_standard        = "DIN562",
    clearance           = 0.2,
    shaft_clearance     = 0.5)
{


    difference()
    {
        cylinderpp(d=diameter, h=length);
        
        // cut 
        translate([0,-diameter/2+off,0])
            cubepp([diameter, diameter, 3*length], align="Y");
        
        // top interface
        translate([0,0,length+thickness])
            lid_holder_interface(
                interface_d=diameter,
                interface_cut_off=off,
                thickness=thickness,
                clearance=0.2,
                has_groove=false);


        // bottom interface
        translate([0,0,-thickness])
            rotate([0,180,0])
                lid_holder_interface(
                    interface_d=diameter,
                    interface_cut_off=off,
                    thickness=thickness,
                    clearance=0.2,
                    has_groove=false);

    }

}


module lid_spacer_shape_2d(
    wt,
    bt,
    peg_height,
    peg_gauge,
    slit_height,
    slit_width
)
{
    hull()
    {
        circlepp(d=wt, align="xy");
        translate([0,peg_height+bt])
            circlepp(d=wt, align="xY");
        translate([peg_gauge-slit_width,0])
            circlepp(d=wt,align="Xy");
        translate([peg_gauge-slit_width,slit_height])
            circlepp(d=wt,align="Xy");
    }
}


module lid_spacer_2d(
    wt,
    bt,
    peg_height,
    peg_gauge,
    slit_height,
    slit_width,
    rounding=2
)
{

    difference()
    {
        lid_spacer_shape_2d(
            wt,
            bt,
            peg_height,
            peg_gauge,
            slit_height,
            slit_width
        );

        offset(rounding)
        offset(-rounding)
        offset(-wt)
            lid_spacer_shape_2d(
                wt,
                bt,
                peg_height,
                peg_gauge,
                slit_height,
                slit_width
            );
    }   
}

module slit(
    wt,
    bt,
    thickness,
    peg_height,
    peg_gauge,
    slit_height,
    slit_width
)
{
    linear_extrude(thickness)
    {
        // front
        hull()
        {
            circlepp(d=wt, align="Xy");
            translate([0,slit_height+bt])
                circlepp(d=wt, align="XY");
        }

        // back
        translate([slit_width,0])
        hull()
        {
            circlepp(d=wt, align="xy");
            translate([0,peg_height+bt])
                circlepp(d=wt, align="xY");
        
        }
        
        // bottom
        translate([-wt/2,0])
            squarepp([slit_width+wt, bt]);
    
    }
}


module slit_rounding(
    slit_w     = 8,
    thickness  = 4,
    rounding   = 2
)
{   
    translate([slit_w/2,0,0])
    mirrorpp([1,0,0], true)
    translate([-slit_w/2,0,0])
    difference()
    {
        cubepp([rounding, rounding, thickness]);
        cylinderpp(r=rounding, h=3*thickness, align="xy");
    }
}

module lid_holder_comb(
    //peg_w = 4,
    wt         = 5,
    bt         = 5,
    peg_height = 50,
    peg_count  = 4,
    peg_gauge  = 36,
    slit_w     = 8,
    slit_h     = 30,
    thickness  = 5,
    rounding   = 2,
    spacer_interface_w = 10,
    spacer_interface_cut = 1,
    spacer_interface_wt = 1,
    spacer_interface_clearance=0.2,
    spacer_interface_groove=1,
    is_left=true)
{

    // lid placeholder
    %translate([0,bt,0])
        cubepp([slit_w,peg_height,1]);
    // space placeholder
    %translate([slit_w,bt,0])
        cubepp([peg_gauge-slit_w, slit_h, 1]);

    difference()
    {
        union()
        {
            
            // individual fins
            for (i=[0:peg_count-1])
            {
                translate([i*(peg_gauge),0,0])
                {
                    linear_extrude(thickness)
                    {
                        translate([-wt/2,0])
                        {
                            squarepp([slit_w+wt,bt]);
                            circlepp(d=wt, align="y");
                        }

                        translate([slit_w,0])
                            lid_spacer_2d(
                                wt=wt,
                                bt=bt,
                                peg_height=peg_height,
                                peg_gauge=peg_gauge,
                                slit_height=slit_h,
                                slit_width = slit_w,
                                rounding=rounding
                            );
                    }

                    translate([0,bt,0])
                        slit_rounding(
                            slit_w     = slit_w,
                            thickness  = thickness,
                            rounding   = rounding
                        );
                }
            }

            // front slit    
            slit(
                wt=wt,
                bt=bt,
                thickness=thickness,
                peg_height=peg_height,
                peg_gauge=peg_gauge,
                slit_height=slit_h,
                slit_width = slit_w
            );


            // back slit
            translate([peg_gauge*peg_count,0,0])
            {
                slit(
                    wt=wt,
                    bt=bt,
                    thickness=thickness,
                    peg_height=peg_height,
                    peg_gauge=peg_gauge,
                    slit_height=slit_h,
                    slit_width = slit_w
                );
                
                translate([0,bt,0])
                    slit_rounding(
                        slit_w     = slit_w,
                        thickness  = thickness,
                        rounding   = rounding
                    );
            
            }

            // front interface
            hull()
            {
                cylinderpp(d=spacer_interface_w,h=thickness, align="Xyz");
                translate([0,slit_h+bt, 0])
                    cylinderpp(d=wt,h=thickness, align="XYz");
            }
            translate([-wt,0,0])
                cubepp([wt/2,
                        spacer_interface_w,
                        thickness], align="xyz");
            
            // back interface
            translate([peg_gauge*peg_count + slit_w, 0,0])
            {
                hull()
                {
                    cylinderpp(d=spacer_interface_w,h=thickness, align="xyz");
                    translate([0,peg_height+bt,0])
                        cylinderpp(d=wt, h=thickness,align="xYz");
                }
                cubepp([spacer_interface_w/2,
                        spacer_interface_w,
                        thickness], align="xyz");
            }

        }

        // front interface
        translate([-spacer_interface_w/2,spacer_interface_w/2,thickness])
            lid_holder_interface(
                interface_d=spacer_interface_w-2*spacer_interface_wt,
                interface_cut_off=spacer_interface_cut,
                thickness=thickness-spacer_interface_groove,
                clearance=0.2);

        // back interface
        translate([peg_gauge*peg_count+slit_w+spacer_interface_w/2,spacer_interface_w/2,thickness])
            lid_holder_interface(
                interface_d=spacer_interface_w-2*spacer_interface_wt,
                interface_cut_off=spacer_interface_cut,
                thickness=thickness-spacer_interface_groove,
                clearance=0.2);
    }
}


lid_holder_comb();

//translate([-5,5,-60])
//connector();
