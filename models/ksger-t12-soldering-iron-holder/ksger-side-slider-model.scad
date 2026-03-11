
include<ksger-side-slider-parameters.scad>


module t12_ksger_side_slider_model(length, neck_h=t12_si_slider_neck_h, clearance=0.2)
{

    points = [  [0,0],
                [t12_si_slider_neck_w/2,0],
                [t12_si_slider_neck_w/2,neck_h],
                [t12_si_slider_neck_w/2+t12_si_slider_bevel,neck_h+t12_si_slider_bevel],
                [t12_si_slider_neck_w/2+t12_si_slider_bevel,neck_h+t12_si_slider_bevel+t12_si_slider_neck_h],
                [-t12_si_slider_neck_w/2-t12_si_slider_bevel,neck_h+t12_si_slider_bevel+t12_si_slider_neck_h],
                [-t12_si_slider_neck_w/2-t12_si_slider_bevel,neck_h+t12_si_slider_bevel],
                [-t12_si_slider_neck_w/2,neck_h],
                [-t12_si_slider_neck_w/2,0],
                ];

    linear_extrude(length)
        offset(clearance)
            polygon(points);

}


//#t12_ksger_side_slider_model(10,clearance=0);
//t12_ksger_side_slider_model(10);