// ATX PS2 PSU based on:
// https://www.silverstonetek.com/en/tech-talk/10055
// https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8SZsukpjUNBFcdGtNW7PyAzTLFnbaHwKWnKAZMKtFvukNtQiK5U_iaHI6&s=10
// https://h30434.www3.hp.com/t5/image/serverpage/image-id/253348iF3D239518AE3675F/image-size/large?v=v2&px=999

atx_ps2_psu_x = 86;
atx_ps2_psu_y = 140;
atx_ps2_psu_z = 150;

//
//          atx_ps2_psu_mnt_Gz
//    +----------------------------+
//    |                            |
//  +-O                            O-+
//  |                                |
//  |                                |
//  |->atx_ps2_psu_mnt_gx            |
//  |                                |-> atx_ps2_psu_mnt_Gx
//  |                                |
//  +-O                              |
//    |                              |
//    |                    O---------+
//    |                    |
//    +--------------------+
//      atx_ps2_psu_mnt_gz
//
// The most straighforward standard, that ever lived

atx_ps2_psu_mnt_Gz = 138;
atx_ps2_psu_mnt_gz = 114;
atx_ps2_psu_mnt_Gx = 74;
atx_ps2_psu_mnt_gx = 64;
// top hole is offseted by this much in both x and z
atx_ps2_psu_mnt_off = 6;

