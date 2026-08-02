module badge()
{
    
    // base badge
    color([0.75,0.45,0.2])
        //scale([1.25,1.25,1.0])
        import("import/badge_ankh_morkport_NoText.stl");
    
    // text
    scale([1/1.25,1/1.25,1])
    {
        color([0.2,0.2,0.2])
        translate([-0.75,0.5,3]){
            char_len = len("Fabricati Diem pvnc")+1;
            text_arch(17,"    A-M      C W",char_len, 3);
            text_arch_inv(17,"FABRICATI DIEM PVNC",char_len,3);
        }
        
        // badge number
        translate([0,-31,3])
        linear_extrude(height = 2.02) {
            text( "177",
                  font = "Arial:style=Bold", 
                  size = 6, 
                  valign = "center", halign = "center"
                );
        }
    }
    
}

module text_arch(radius, chars, chars_len, font_size=5)
{
    PI = 3.14159;
    circumference = 2*PI * radius;
    //chars_len = len(chars)+1;
    off = 5;
    step_angle = 180 / chars_len;
    for(i = [0 : chars_len - 1]) 
    {
        
        tmp_off = i==chars_len-2 ? -off : 0;
        
        rotate(-(i-chars_len/2) * step_angle  - step_angle+off+tmp_off) 
            translate([0, radius + font_size / 2, 0])
                scale([1,1.5,1])
                linear_extrude(height = 2.02) {
                    text(
                        chars[i], 
                        font = "Arial:style=Bold", 
                        size = font_size, 
                        valign = "center", halign = "center"
                    );
            }
    }
}

module text_arch_inv(radius, chars, chars_len, font_size=5)
{
    PI = 3.14159;
    circumference = 2*PI * radius;
    //chars_len = len(chars)+1;
    step_angle = 180 / chars_len;
    for(i = [0 : chars_len - 1]) 
    {
        rotate((i-len(chars)/2) * step_angle + 180 + 0.5*step_angle) 
            translate([0, radius + font_size / 2, 0])
                rotate(180)
                scale([1,1.5,1])
                linear_extrude(height = 2.02) {
                    text(
                        chars[i], 
                        font = "Arial:style=Bold", 
                        size = font_size, 
                        valign = "center", halign = "center"
                    );
            }
    }
}

badge();