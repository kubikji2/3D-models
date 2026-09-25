

mougol_x99_x = 215;
mougol_x99_y = 190;
mougol_x99_z = 1.6;

mougol_x99_cr = 5;

include<../pc-parts/micro-atx-parameters.scad>
mougol_holes_offset_x = -(uatx_x-mougol_x99_x); 


// PCIe slot
// from datum B
mougol_x99_pcie_slot_x_off = uatx_c_hole_x_off; // approx
mougol_x99_pcie_slot_y_off = 31.2;