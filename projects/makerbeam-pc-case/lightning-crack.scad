use<../../lib/solidpp/solidpp.scad>


module lightning_crack(h, l,
    segment_length = 20,
    groove_w = 1.2,
    eps=0.3,
    angle=20,
    connector_h=4,
    connector_d=4,
    connector_spacing=2)
{
    y_increment = segment_length*cos(angle);
    count = ceil(l/(y_increment));

    _length_compensation = eps*tan(angle);
    _width_compensation = eps*sin(angle);

    groove_diag = sqrt(2)*groove_w;
    _connector_l = segment_length-2*connector_spacing;

    for (i=[0:count])
    {
        translate([0,i*y_increment,0])
        {
            rotate([0,0,(i%2 == 0 ? 1 : -1)*angle])
            {

                difference()
                {
                    cubepp([eps,segment_length+_length_compensation,3*h], align="");
                    cubepp([2*eps,_connector_l,connector_h], align="");
                }
                _groove_length_compensation = sqrt(2*groove_w*groove_w)*tan(angle)/2;
                mirrorpp([0,0,1], true)
                    translate([0,0,h/2])
                        rotate([0,45,0])
                            cubepp([groove_w, segment_length, groove_w], align="");

                // connecting the grooves
                mirrorpp([0,0,1],true)
                    translate([0,segment_length/2,h/2])
                        cut(i%2==0 ? [0,2*angle] : [2*angle, 360])
                        {

                            cylinderpp(d1=0, d2=groove_diag,h=groove_diag/2, align="Z", $fn=16);
                            cylinderpp(d2=0, d1=groove_diag,h=groove_diag/2, align="z", $fn=16);
                        }
            }

            // connectors
            _connector_off = connector_d*sin(angle);
            _connector_max_d = segment_length*sin(angle)/2+ connector_d;       
            translate([eps/2,0,0])
            difference()
            {
                cubepp([2*_connector_max_d,segment_length,connector_h],
                        align="");
                
                // right cut
                translate([connector_d,0,0])
                rotate([0,0,i%2==0 ? angle : -angle])
                {
                    cubepp([_connector_max_d, 2*segment_length, 2*connector_h], align="x");
                    
                    //mirrorpp([0,1,0], true)
                    translate([0, _connector_l/2+_length_compensation,0])
                        rotate([0,0,i%2==0 ?- angle : angle])
                            cubepp([4*_connector_max_d, segment_length, 2*connector_h], align="y");
                    
                    translate([0, -_connector_l/2-_length_compensation,0])
                        rotate([0,0,i%2==0 ? -angle : angle])
                            cubepp([4*_connector_max_d, segment_length, 2*connector_h], align="Y");

                    mirrorpp([0,0,1], true)
                        translate([0,0,connector_h/4])
                            rotate([0,45,0])
                                cubepp([connector_h,segment_length,connector_h], align="z");
                    
                    
                    rotate([0,0,angle])
                        translate([-connector_d-eps,0,0])
                            rotate([0,0,-angle])
                                cubepp([2*_connector_max_d, 2*segment_length, 2*connector_h], align="X");

                }

                // inner cut
                difference()
                {
                    cubepp([2*_connector_max_d,segment_length,connector_h-2*eps],
                        align="");
                
                    // right cut
                    translate([connector_d-eps,0,0])
                    rotate([0,0,i%2==0 ? angle : -angle])
                    {
                        cubepp([_connector_max_d, 2*segment_length, 2*connector_h], align="x");
                        
                        //mirrorpp([0,1,0], true)
                        translate([0, _connector_l/2+_length_compensation-eps,0])
                            rotate([0,0,i%2==0 ?- angle : angle])
                                cubepp([4*_connector_max_d, segment_length, 2*connector_h], align="y");
                        
                        translate([0, -_connector_l/2-_length_compensation+eps,0])
                            rotate([0,0,i%2==0 ? -angle : angle])
                                cubepp([4*_connector_max_d, segment_length, 2*connector_h], align="Y");

                        mirrorpp([0,0,1], true)
                            translate([0,0,connector_h/4])
                                rotate([0,45,0])
                                    cubepp([connector_h,segment_length,connector_h], align="z");
                        
                        
                        //rotate([0,0,angle])
                        //    translate([-connector_d-eps,0,0])
                        //        rotate([0,0,-angle])
                        //            cubepp([2*_connector_max_d, 2*segment_length, 2*connector_h], align="X");

                    }
                }


                //    rotate([0,0,90-angle])
                //        coordinate_frame()
                //            cubepp([_connector_off,2*connector_d, 2*connector_h], align="x");
                //// inner cut
                //cubepp([2*connector_d-2*eps,_connector_l-2*eps,connector_h-2*eps],
                //        align="",
                //        mod_list=[bevel_edges(connector_h/4, axes="xz")]);
                // cut back
                //translate([i%2==0?0:-eps,0,0])
                //    cubepp([2*connector_d, 2*_connector_l, 2*connector_h], align=i%2==0 ? "x": "X");                    

            }



        }


    }

}

$fn = $preview ? 36: 72;
lightning_crack(10,  200);