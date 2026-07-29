$fn = 180;

sf_x = 0.8795;
sf_y = sf_x;
sf_zw = 0.6666;
sf_zb = 3.33335;

module layer_mm_rorschach_coaster()
{
    difference()
    {
        cylinder(d=95,h=4);
        translate([0,0,-4*(sf_zb+1)+2*sf_zw-0.01])
            scale([sf_x,sf_y,sf_zb+0.02])
                import("import/rorschach-2-black.stl");
    }
}

//layer_mm_rorschach_coaster();

module mm_rorschach_coaster(clr="black")
{
    if (clr=="white")
    {
        color("white")
        difference()
        {
            /*
            scale([sf_x,sf_y,sf_zw])
                import("import/rorschach-1-white.stl");
            */
            cylinder(d=95,h=4);
            translate([0,0,-4*(sf_zb+1)+2*sf_zw+0.01])
                scale([sf_x,sf_y,sf_zb])
                    import("import/rorschach-2-black.stl");
        }
    }
    
    if(clr=="black")
    {
        translate([0,0,-4*(sf_zb+1)+2*sf_zw])
            color([0.25,0.25,0.25])
                scale([sf_x,sf_y,sf_zb])
                    import("import/rorschach-2-black.stl");
    }
}

mm_rorschach_coaster();


