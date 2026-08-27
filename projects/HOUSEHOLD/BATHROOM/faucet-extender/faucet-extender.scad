use<../../../../lib/solidpp/solidpp.scad>


include<faucet-dimensions.scad>

$fn=$preview ? 36 : 72;


module faucet_part_shape(
    wt,
    stopper,
    has_protrusion
)
{
    difference()
    {

        offset((wt/2-0.01))
        offset(-(wt/2-0.01))
        difference()
        {
            union()
            {
                // main shape
                circlepp(d=f_d+2*wt);
                // top protrusion
                if (has_protrusion)
                    intersection()
                    {
                        circlepp(d=f_d+2*f_p_t+2*wt);
                        squarepp([f_p_w+2*wt, f_d], align="y");
                    }
            }
            // inner cut
            circlepp(d=f_d);
            // slide-in
            squarepp([f_d-2*stopper,f_d], align="Y");
        }


        // protrusion hole
        if (has_protrusion)
            intersection()
            {
                circlepp(d=f_d+2*f_p_t);
                squarepp([f_p_w, f_d], align="y");
            }
    }
    
    
}


module faucet_extension(
    wt = 5,
    lever_length = 40,
    lever_d = 7,
    lever_h = 15,
    lever_smoothing = 1.5,
    stopper = 8,
)
{
    _h = f_h + f_p_h + wt;

    difference()
    {
        render(10)
        union()
        {
            // bottom strip
            linear_extrude(f_h)
                faucet_part_shape(
                    wt=wt,
                    stopper=stopper,
                    has_protrusion=false
                );

            // middle strip
            linear_extrude(f_h+f_p_h+wt)
                    faucet_part_shape(
                    wt=wt,
                    stopper=stopper,
                    has_protrusion=true
                ); 
            
            // top strip
            translate([0,0,f_h+f_p_h])
                linear_extrude(wt)
                    faucet_part_shape(
                        wt=wt,
                        stopper=stopper,
                        has_protrusion=false
                );

            // lever
            difference()
            {
                minkowski()
                {
                    // smooth edges
                    sphere(r=lever_smoothing);

                    difference()
                    {
                        hull()
                        {
                            _w = lever_d-2*lever_smoothing;//f_p_w;
                            intersection()
                            {
                                tubepp(d=f_d+2*f_p_t,t=wt,h=_h);
                                cubepp([_w,f_d,_h],align="yz");

                            }

                            translate([0,f_d/2+wt+lever_length,(_h-lever_h)/2])
                                cylinderpp(
                                    d=lever_d-2*lever_smoothing,
                                    h=lever_h,
                                    align="Yz");
                        }
                        
                        cylinderpp(d=f_d+2*wt,h=3*(f_h+f_p_h+wt), align="");

                        // cut lever
                        translate([0,f_d/2+f_p_t+wt-2*lever_smoothing,_h/2])
                            mirrorpp([0,0,1], true)
                                translate([0,0,lever_h/2-lever_smoothing])
                                    cubepp(
                                        [_h,_h+lever_length,_h],
                                        mod_list=[round_edges((_h-lever_h)/2, axes="yz")], align="yz");
                    }

                
                }

                cylinderpp(d=f_d+2*wt,h=3*(f_h+f_p_h+wt), align="");

            }

        }


        // cut body
        translate([0,0,f_h+f_p_off])
        {
            mirrorpp([1,0,0], true)
                translate([f_p_w/2+wt,0,0])
                    cubepp([f_d,2*f_d,f_d], mod_list=[round_edges(wt, axes="xz")], align="xz");

            cubepp([2*f_d,2*f_d,f_d], align="Yz");

        }
        
    }   

    //%cubepp([f_p_w,f_d,f_d], align="yz");

    /*
    offset((wt/2-0.01))
    offset(-(wt/2-0.01))
    difference()
    {
        union()
        {
            // main shape
            circlepp(d=f_d+2*wt);
            // top protrusion
            intersection()
            {
                circlepp(d=f_d+2*f_p_t+2*wt);
                squarepp([f_p_w+2*wt, f_d], align="y");
            }
        }
        // inner cut
        circlepp(d=f_d);
        // slide-in
        squarepp([f_d-2*stopper,f_d], align="Y");
        // protrusion
        intersection()
        {
            circlepp(d=f_d+2*f_p_t);
            squarepp([f_p_w, f_d], align="y");
        }
    }
    */



}


faucet_extension();