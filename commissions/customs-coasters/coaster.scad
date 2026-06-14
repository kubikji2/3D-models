include<../../lib/solidpp/solidpp.scad>

// support function
module text_arch(radius, chars, chars_len, height)
{
    PI = 3.14159;
    circumference = 2*PI * radius;
    //chars_len = len(chars)+1;
    off = 5;
    font_size = 11;
    step_angle = 180 / chars_len;
    for(i = [0 : chars_len - 1]) 
    {
        tmp_off = i==chars_len-2 ? -off : 0;
        rotate(-(i-chars_len/2) * step_angle  - step_angle+off+tmp_off) 
            translate([0, radius + font_size / 2, 0]) 
                linear_extrude(height = height) {
                    text(
                        chars[i], 
                        font = "Arial:style=Bold", 
                        size = font_size, 
                        valign = "center", halign = "center"
                    );
            }
    }
}

module text_arch_inv(radius, chars, chars_len, height)
{
    PI = 3.14159;
    circumference = 2*PI * radius;
    //chars_len = len(chars)+1;
    font_size = 11;
    step_angle = 180 / chars_len;
    for(i = [0 : chars_len - 1]) 
    {
        rotate((i-len(chars)/2) * step_angle + 180 + 0.5*step_angle) 
            translate([0, radius + font_size / 2, 0])
                rotate(180)
                linear_extrude(height = height) {
                    text(
                        chars[i], 
                        font = "Arial:style=Bold", 
                        size = font_size, 
                        valign = "center", halign = "center"
                    );
            }
    }
}

module logo(h=1)
{   
    scale([0.15,0.15,1])
        translate([-145,-175,0])
            linear_extrude(h)
            offset(0.5)
                import("import/Caduceus.dxf");
}

module text_and_logo(h, d, t, top_rounding=0, eps = 0.1)
{
    logo(h=h);

    // text
    step_angle = len("CUSTOMS")+0.55;
    translate([0,0,-eps]) text_arch(32,"CUSTOMS",step_angle,h);
    translate([0,0,-eps]) text_arch_inv(32,"DOUANE",step_angle,h);
    
    translate([0,0,0])
        tubepp(D=d, t=t, h=h, mod_list=[round_bases(r_top=top_rounding)]);

    //translate([0,0,eps])
    //difference()
    //{
    //    cylinder(d=92,h=2);
    //    translate([0,0,-eps])
    //        cylinder(d=89,h=2+2*eps);
    //}
}

module customs_coaster(d=95, h=3, border_t=2, is_embossed=false, is_logo=true)
{

    _eps = 0.1;

    base_h = is_embossed ? h/2 : h;

    multi_color_h = 0.6;
    
    if (!is_embossed && is_logo == false)
    difference()
    {
        if (!is_embossed && is_logo == false)
            //color([0.1,0.1,0.1])
            color("mediumblue")
                cylinder(d=d,h=base_h);
        

        translate([0,0,h-multi_color_h])
        if (!is_embossed)
        
            color("gold")
                union()
                {
                    text_and_logo(multi_color_h+multi_color_h, d, border_t, _eps);
                }
    }
    
    color("gold")
    if(is_embossed)
    {
        translate([0,0,h/2])
            text_and_logo(h/2, d, border_t, 0);
    }
    else if (is_logo)
    {
        translate([0,0,h-multi_color_h])
            text_and_logo(multi_color_h, d, border_t,0);

    }

    

}

$fn=$preview ? 36 : 144;

customs_coaster(is_logo=false);
//customs_coaster(is_logo=true);