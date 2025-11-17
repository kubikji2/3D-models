use<../../lib/solidpp/solidpp.scad>

module compact_cloth_hanger(
    wt = 5,
    length = 420,
    hook_d = 50,
    neck_h = 20,
    hanger_h = 30,
    hanger_d = 40,
    eps = 0.1)
{
    linear_extrude(wt)
    offset(-(wt/2-eps))
    offset(wt/2-eps)
    offset(wt/2-eps)
    offset(-(wt/2-eps))
    {
        // hook
        difference()
        {
            circlepp(d=hook_d);
            circlepp(d=hook_d-2*wt);
            //translate([-wt/2,0])
            squarepp([hook_d,hook_d], align="XY");
            rotate(45)
                squarepp([hook_d,hook_d], align="XY");
        }

        // neck
        pairwise_hull()
        {
            rotate(-45)
                translate([hook_d/2-wt/2,0])
                    circlepp(d=wt);
            translate([0,-hook_d/2-neck_h/5])
                circlepp(d=wt);
            translate([0,-hook_d/2-neck_h])
                circlepp(d=wt);
        }

        // arms
        //translate([0,-hook_d/2-neck_h])
        //{
        //    _l = length/2-hanger_d/2;
        //    pairwise_hull()
        //    {
        //        // mid-point
        //        circlepp(d=wt);
        //        // left point
        //        translate([-_l,-hanger_h])
        //            circlepp(d=wt);
        //        // right point
        //        translate([_l,-hanger_h])
        //            circlepp(d=wt);
        //        // mid-point
        //        circlepp(d=wt);
        //    }
        //}

        _l = length/2-hanger_d/2;

        translate([0,-hook_d/2-neck_h])
        difference()
        {
            hull()
            {
                // mid-point
                circlepp(d=wt);
                mirrorpp([1,0], true)
                translate([-_l,-hanger_h+wt/2])
                    circlepp(d=hanger_d,align="Y");
            }
            
            translate([0,-wt])
            hull()
            {
                // mid-point
                //translate([-wt,0])
                circlepp(d=wt);
                
                mirrorpp([1,0], true)
                translate([-_l,-hanger_h+wt/2])
                    circlepp(d=hanger_d-2*wt,align="Y");
            }


        }

        // reinforcements
        /*
        translate([0,-hook_d/2-neck_h-hanger_h])
        {
            mirrorpp([1,0], true)
                hull()
                {
                    translate([-_l,0])
                        circlepp(d=wt);
                    translate([0,-hanger_d+wt])
                        circlepp(d=wt);
                }
            hull()
            {
                translate([-_l,0])
                    circlepp(d=wt);
                translate([_l,0])
                    circlepp(d=wt);
            }
        }
        */
    }
}

$fs = $preview ? 0.25 : 0.1;
$fa = $preview ? 10 : 5;

compact_cloth_hanger();