include<../../utils/circular-serration.scad>
include<../../lib/deez-nuts/deez-nuts.scad>

include<spool-rack-parameters.scad>

_r = sr_rod_d/2;
_R = sr_filament_spool_max_d/2;
rod_spacing = 2*sqrt((_R+_r)*(_R+_r) - (_R-_r)*(_R-_r));
echo(rod_spacing);

module replicate_at_rod()
{
    mirrorpp([1,0,0], true)
        translate([rod_spacing/2,-(_R-_r),sr_wt])
            children();
    
    mirrorpp([1,0,0], true)
        translate([rod_spacing/2,_R+sr_rod_d+_r,sr_wt])
        //coordinate_frame()
            children();
}

module rack_shape_2d()
{
    offset(-sr_blending_d)
    offset(sr_blending_d)
    offset(sr_wt)
    union()
    {
        // main circle
        circlepp(r=_R);   
        
        // support
        mirrorpp([1,0], true)
            translate([rod_spacing/2,-(_R-_r)])
                circlepp(d=sr_rod_d, align="");
        
        mirrorpp([1,0], true)
            translate([rod_spacing/2,_R+sr_rod_d+_r])
                circlepp(d=sr_rod_d, align="");
            
    }
}


module spool_row_2d(clearance=0.1)
{

    //linear_extrude()
    offset(-sr_wt/2)
    offset(sr_wt/2)
    union()
    {
        offset(-sr_blending_d)
        offset(sr_blending_d)
        difference()
        {
            rack_shape_2d();
            
            // inner hole
            difference()
            {
                circlepp(d=sr_filament_spool_max_d);
                replicate_at_rod()
                    circle(d=sr_rod_d+2*sr_wt);
            }
        }

        difference()
        {
            circle(d=rod_spacing+sr_wt);
            circle(d=rod_spacing-sr_wt);
        }

        n_reinforcements = 12;
        increment = 360/n_reinforcements;
        rotate(increment/2)
        for (i=[0:n_reinforcements-1])
        {
            rotate(i*increment)
            hull()
            {
                translate([rod_spacing/2,0])
                    circle(d=sr_wt);
                rotate(increment/2)
                    translate([sr_filament_spool_max_d/2,0])
                        circle(d=sr_wt);
            }
                    rotate(i*increment)
            hull()
            {
                translate([rod_spacing/2,0])
                    circle(d=sr_wt);
                rotate(-increment/2)
                    translate([sr_filament_spool_max_d/2,0])
                        circle(d=sr_wt);
            }
        }
    }
}

module rod_hole(clearance=0.2)
{
    difference()
    {
        cylinderpp(d=sr_rod_d+2*clearance, h=sr_h);
        
        if (!$preview)
        circular_serration(  radius=sr_rod_d/2+clearance,
                            height=sr_h-sr_wt,
                            n_serration=60,
                            serration_bottom_d=2*clearance,
                            serration_top_d=clearance,
                            z_align="z",
                            $fn=6);
    }
}

module fastener_pair_hole(nut_hole_off=20)
{
    _nh=get_nut_height( d=sr_bolt_d, standard=sr_nut_standard);
    rotate([-90,0,0])
        translate([0,0,-sr_bolt_l/2-_nh/2])
            union()
            {
                bolt_hole(  descriptor=sr_bolt_descriptor,
                            standard=sr_bolt_standard,
                            clearance=0.2,
                            hh_off=70);
                rotate([0,0,90])
                    nut_hole(   d=sr_bolt_d,
                                standard=sr_nut_standard,
                                h_off=nut_hole_off);
            }
}


module spool_rack(clearance=0.1)
{

    _top_row_offset = sr_filament_spool_max_d+_r+_r;

    difference()
    {
        union()
        {
            linear_extrude(sr_h)
                union()
                {
                    spool_row_2d();
                    translate([0,_top_row_offset,0])
                        spool_row_2d();
                }

            //difference()
            //{
            //    render()
            //    intersection()
            //    {
            //        cylinder(d=sr_filament_spool_max_d+2*sr_wt+2*sr_rod_d+2*sr_rod_d, h=sr_h);
            //        translate([0,_top_row_offset,0])
            //            cylinder(d=sr_filament_spool_max_d+2*sr_wt+2*sr_rod_d, h=sr_h);
            //        cubepp([rod_spacing,3*sr_filament_spool_max_d, sr_h], align="z");
            //    }
            //    
            //    cylinderpp(d=sr_filament_spool_max_d+2*sr_wt, h=3*sr_h, align="");
            //    
            //    translate([0,_top_row_offset,0])
            //        cylinderpp(d=sr_filament_spool_max_d+2*sr_wt, h=3*sr_h, align="");
            //}
        }

        // bottom holes
        replicate_at_rod()
            rod_hole();

        // top holes
        translate([0,_top_row_offset,0])
            replicate_at_rod()
                rod_hole();

        // bottom screw holes
        mirrorpp([1,0,0], true)
            translate([rod_spacing/2,-(_R-_r),sr_wt+(sr_h-sr_wt)/2])
                rotate([0,90,-45])
                    translate([0,0,-sr_screw_l/2+sr_wt])
                    screw_hole( descriptor=sr_screw_descriptor,
                                standard=sr_screw_standard);
        
        // top screw holes
        mirrorpp([1,0,0], true)
            translate([rod_spacing/2,3*(_R+_r)+sr_rod_d,sr_wt+(sr_h-sr_wt)/2])
                rotate([0,90,45])
                    translate([0,0,-sr_screw_l/2+sr_wt])
                    screw_hole( descriptor=sr_screw_descriptor,
                                standard=sr_screw_standard);

        // middle screw holes
        mirrorpp([1,0,0], true)
            translate([rod_spacing/2,-(_R-_r)+2*_R+sr_rod_d,sr_wt+(sr_h-sr_wt)/2])
                rotate([0,90,0])
                    translate([0,0,-sr_screw_l/2+sr_wt])
                        screw_hole( descriptor=sr_screw_descriptor,
                                    standard=sr_screw_standard,
                                    hh_off=sr_screw_l);
            //{
            //    rotate([0,90,-64])
            //        translate([0,0,clearance])
            //            screw_hole( descriptor=sr_screw_descriptor,
            //                        standard=sr_screw_standard,
            //                        hh_off=sr_screw_l);
            //    rotate([0,90,50])
            //        translate([0,0,clearance])
            //            screw_hole( descriptor=sr_screw_descriptor,
            //                        standard=sr_screw_standard,
            //                        hh_off=40);
            //
            //}
        
        // middle split
        //_cut_r = _R + _r;

        /*
        intersection()
        {
            translate([0,_R+sr_wt,0])
                cubepp([2*_R,clearance,2*_R], align="");
            cylinderpp(r=_cut_r+clearance, h=_R, align="");
        }

        difference()
        { 
            tubepp(r=_cut_r, t=clearance, h=_R);
            translate([0,_R+sr_wt,0])
                cubepp([2*_R,_R,_R], align="zy");
        }


        // middle connection from bottom
        _angle = 360/12;
        _angle_increment = 8;
        #mirrorpp([1,0,0], true)
            rotate([0,0,_angle-8])
                translate([0,(_R-_r)/cos(_angle),2*(sr_h)/3])
                    rotate([0,0,180])
                        fastener_pair_hole();
        */
        
        // middle cut
        //_middle_cut_y_off = _R+sr_wt;
        _middle_cut_y_off = _R+_r;
        translate([0,_middle_cut_y_off,0])
        {
            cubepp([2*_R,clearance,2*_R], align="");
            rotate([45,0,0])
                cubepp([2*_R,2,2], align="");
            translate([0,0,sr_h])
                rotate([45,0,0])
                    cubepp([2*_R,2,2], align="");
            
        }

        // middle connection from top
        _angle = 23;
        mirrorpp([1,0,0], true)
            translate([0,2*_R+sr_rod_d,(sr_h)/3])
                rotate([0,0,180-_angle])
                    translate([0,(_middle_cut_y_off)/cos(_angle),0])
                        rotate([0,0,180])
                            fastener_pair_hole(30);

        // middle connection from bottom
        mirrorpp([1,0,0], true)
            rotate([0,0,-_angle])
                translate([0,(_middle_cut_y_off)/cos(_angle),2*(sr_h)/3])
                    rotate([0,0,180])
                        fastener_pair_hole(18);
        
    }

    //#fastener_pair_hole();

}


$fn = $preview ? 36 : 144;
spool_rack();


//%cylinderpp(h=20, d=sr_filament_spool_max_d);