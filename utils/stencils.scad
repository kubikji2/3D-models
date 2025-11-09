
// repeat pattern (children(0)) and limit it in given area (children(1)) if provided
// children(0) -- single pattern
// children(1) -- are where the cut is appled
module stencil( pattern_size_x,
                pattern_size_y,
                pattern_spacing_x,
                pattern_spacing_y,
                pattern_count_x,
                pattern_count_y,
                pattern_offset_x,
                pattern_offset_y,
                modulo_offset_x=0,
                modulo_offset_y=0,
                modulo_x = 2,
                modulo_y = 2)
{

    // stencil
    // NOTE without render there is so much elements in the tree
    render(pattern_count_x+pattern_count_y)
    intersection()
    {

        // repeat pattern
        for(xi=[0:pattern_count_x-1])
        {
            for(yi=[0:pattern_count_y-1])
            {
                // position
                _x = xi*(pattern_size_x+pattern_spacing_x)+pattern_offset_x;
                _y = yi*(pattern_size_y+pattern_spacing_y)+pattern_offset_y;
                // position for modulo
                _mod_x = yi % modulo_x == 0 ? modulo_offset_x : 0;
                _mod_y = xi % modulo_y == 0 ? modulo_offset_y : 0;

                translate([_x+_mod_x,_y+_mod_y,0])
                    children(0);
            }
        }

        // if provided, select only area of effect
        if ($children > 1)
        {
            children(1);
        }
    }
}


// cut repeteating pattern (children(1)) in area (children(2)) into target object (children(0)) 
// children(0) -- object to be cut using stencil
// children(1) -- single pattern
// children(2) -- area where the cut is appled
module cut_stencil( pattern_size_x,
                    pattern_size_y,
                    pattern_spacing_x,
                    pattern_spacing_y,
                    pattern_count_x,
                    pattern_count_y,
                    pattern_offset_x,
                    pattern_offset_y,
                    modulo_offset_x=0,
                    modulo_offset_y=0,
                    modulo_x = 2,
                    modulo_y = 2)
{
    difference()
    {
        // object
        children(0);
        
        // stencil
        stencil(pattern_size_x    = pattern_size_x,
                pattern_size_y    = pattern_size_y,
                pattern_spacing_x = pattern_spacing_x,
                pattern_spacing_y = pattern_spacing_y,
                pattern_count_x   = pattern_count_x,
                pattern_count_y   = pattern_count_y,
                pattern_offset_x  = pattern_offset_x,
                pattern_offset_y  = pattern_offset_y,
                modulo_offset_x = modulo_offset_x,
                modulo_offset_y = modulo_offset_y,
                modulo_x        = modulo_x,
                modulo_y        = modulo_y)
            children([1:$children-1]);
        

        
    }
}



