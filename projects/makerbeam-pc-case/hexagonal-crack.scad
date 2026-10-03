use<../../lib/solidpp/solidpp.scad>


module hexagonal_crack(h, l,
    segment_length = 20,
    //groove_w = 1.2,
    eps=0.3,
    //connector_h=4,
    //connector_d=4,
    //connector_spacing=2
)
{
    angle = 60;
    y_increment = segment_length*cos(angle);
    count = ceil(l/(y_increment));

    _length_compensation = eps*tan(angle);
    _width_compensation = eps*sin(angle);


    translate([-(segment_length*sin(angle)/2),0,0])
    for (i=[0:count])
    {
        _y_off = floor(i)*y_increment/2+ceil(i)*segment_length/2;
        _x_off = (i%2==0) ? (i%4 == 0 ? 1 : -1)*(segment_length*sin(angle)/2) : 0;
        _angle = (i%2 == 0 ? 0 : ((i%4==1)? 1 : -1))*angle;
        _align =  (i%2==0)? (i%4 == 0 ? "" : "") : "";
        _length= segment_length + ((i%2==0)? 0 : _width_compensation);
        translate([_x_off,_y_off,0])
            rotate([0,0,_angle])
                cubepp([eps,_length,3*h], align=_align);           
    }

}

$fn = $preview ? 36: 72;
hexagonal_crack(10,  200);