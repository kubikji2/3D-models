include<../../lib/solidpp/solidpp.scad>

// faucet interface
fi_d = 42.8;
fi_h = 40;
fi_clearance = 0.5;
fi_stopper = 5;

// rag rack
l = 200;
rack_t = 15;
n_stupports = 7;
wt = 3;


$fa = $preview ? 5 : 1;
$fs = $preview ? 0.1: 0.01;

module interface()
{
    linear_extrude(fi_h)
    {
        offset(r=wt/2)
            offset(r=-wt/2)
                difference()
                {
                    circlepp(d=fi_d+2*wt);
                    circlepp(d=fi_d-2*fi_clearance);
                    squarepp([fi_d, fi_d-2*fi_clearance-2*fi_stopper], align="X");
                }
    }
    //%tubepp(d=fi_d-2*fi_clearance, t=wt, h=fi_h);
    //%cubepp([fi_d, fi_d-2*fi_clearance-2*fi_stopper, 3*fi_h], align="X");
}

module rack()
{
    //intersection()
    //{
        difference()
        {
            cubepp([l,rack_t,2*wt], align="xz", mod_list=[bevel_edges(wt,axes="yz")]);
            translate([0,0,wt])
                cubepp([3*l,3*l,3*l], align="z");        
        }
        translate([l,0,0])
        cylinderpp(d2=rack_t, d1=rack_t-2*wt, h=wt);
        //translate()
        //    cubepp([l+2*rack_t,rack_t,2*wt]);
    //}
    for (i=[0:n_stupports-2])
    {   
        hull()
        {
            translate([i*(l/n_stupports),0,0])
                cylinderpp(d=wt, h=wt, zet="y");
            translate([(i+0.5)*(l/n_stupports),0,fi_h-(i+0.5)*(fi_h/n_stupports)])
                cylinderpp(d=wt, h=wt, zet="y", align="Z");
        }
        
        hull()
        {
            translate([(i+1)*(l/n_stupports),0,0])
                cylinderpp(d=wt, h=wt, zet="y");
            translate([(i+0.5)*(l/n_stupports),0,fi_h-(i+0.5)*(fi_h/n_stupports)])
                cylinderpp(d=wt, h=wt, zet="y", align="Z");
        }
    }

    hull()
    {
        translate([0,0,fi_h])
            cylinderpp(d=wt, h=wt, zet="y", align="Z");
        translate([l,0,0])
            cylinderpp(d=wt, h=wt, zet="y", align="zX");
    }
    //pairwise_hull()
    //{
    //    for (i=[0:4])
    //    {
    //        cubepp();
    //    }
    //}
}

module rag_drying_rack()
{
    interface();
    translate([fi_d/2+wt/2,0,0])
    rack();
}

rag_drying_rack();