use <../../lib/solidpp/solidpp.scad>

//include<scoretracks.scad>

clearance = 0.25;

wt = 2.4;
inner_h = 60;

BOARD   = [297, 210];       // outer size = box inner size minus 2 x clearance (A4 here)
BOARD_R = 3;                // rounding of the board corners
board_r = BOARD_R;
board_x = BOARD.x;
board_y = BOARD.y;

inner_x = board_x+2*clearance;
inner_y = board_y+2*clearance;
inner_r = board_r+clearance;

outer_x = inner_x+2*wt;
outer_y = inner_y+2*wt;
outer_r = inner_r+wt;


shell_inner_x = outer_x+2*clearance;
shell_inner_y = outer_y+2*clearance;
shell_inner_r = outer_r+clearance;

shell_outer_x = shell_inner_x + 2*wt;
shell_outer_y = shell_inner_y + 2*wt;
shell_outer_r = shell_inner_r + wt;

cover_h = inner_h+wt+clearance;


module inside_model()
{

    // baseplate
    cubepp([shell_outer_x,shell_outer_y,wt], mod_list=[rounding(shell_outer_r,"z-edges")], align="z");

    // walls
    difference()
    {
        cubepp([outer_x, outer_y, inner_h+wt], mod_list=[rounding(outer_r, "z-edges")], align="z");
        cubepp([inner_x, inner_y, 3*inner_h], mod_list=[rounding(inner_r, "z-edges")], align="");
    }
}

//inside_model();

module cover_model(is_logo=false)
{

    if (!is_logo)
    {
        difference()
        {

            cubepp([shell_outer_x, shell_outer_y, inner_h+wt], mod_list=[rounding(outer_r, "z-edges")], align="z");
            
            mirror([1,0,0])
                translate([0,0,inner_h+wt-0.6])
                    render(20)
                        scale([2,2,2])
                            import("../BOARDGAMES/carcasssone-organizers/import/card-back-raw.stl");
            
            cubepp([shell_inner_x, shell_inner_y, 2*inner_h], mod_list=[rounding(inner_r, "z-edges")], align="");

        }
    }
    else
    {
        intersection()
        {
            cubepp([shell_outer_x, shell_outer_y, inner_h+wt], mod_list=[rounding(outer_r, "z-edges")], align="z");
            
            mirror([1,0,0])
                translate([0,0,inner_h+wt-0.6])
                    render(20)
                        scale([2,2,2])
                            import("../BOARDGAMES/carcasssone-organizers/import/card-back-raw.stl");
            
        }
    }
}


translate([0,0,wt+clearance])
cover_model(false);