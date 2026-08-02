include<ksger-back-slider-parameters.scad>


module ksger_slider(width, height, neck_length=t12_int_h, clearance=0.2)
{

    points = [  [0,0],
                [width/2,0],
                [width/2,t12_int_h],
                [width/2-t12_int_bevel,t12_int_h+t12_int_bevel],
                [width/2-t12_int_bevel,t12_int_h+t12_int_bevel+neck_length],
                [-width/2+t12_int_bevel,t12_int_h+t12_int_bevel+neck_length],
                [-width/2+t12_int_bevel,t12_int_h+t12_int_bevel],
                [-width/2,t12_int_h],
                [-width/2,0],
                ];

    linear_extrude(height)
        offset(clearance)
            polygon(points);

}


#ksger_slider(10, 5, clearance=0);
ksger_slider(10, 5);
