use<../../lib/solidpp/solidpp.scad>


module lightning_crack(h, l, segment_length = 20, groove_w = 1.2, eps=0.3, angle=45)
{
    y_increment = segment_length*cos(angle);
    count = ceil(l/(y_increment))-1;

    groove_diag = sqrt(2)*groove_w;

    for (i=[0:count])
    {
        translate([0,i*y_increment,0])
            rotate([0,0,(i%2 == 0 ? 1 : -1)*angle])
            {
                _length_compensation = eps*tan(angle);
                cubepp([eps,segment_length+_length_compensation,3*h], align="");
                
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

                            cylinderpp(d1=0, d2=groove_diag,h=groove_diag/2, align="Z", $fn=18);
                            cylinderpp(d2=0, d1=groove_diag,h=groove_diag/2, align="z", $fn=18);
                        }
                
                }

    }

}

//$fn = $preview ? 36: 72;
//lightning_crack(10,  200);