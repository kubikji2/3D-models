MAKERBEAM_THREAD_D = 3;
MAKERBEAM_THREAD_DP = 8;



mbc_wt = 3;
mbc_bolt_d = 3;
mbc_bolt_l = 10;
assert(mbc_bolt_l - mbc_wt <= MAKERBEAM_THREAD_DP, "[MAKERBEAM-CORNER] the bolt will not fit the hole!");
mbc_bolt_descriptor = str("M",mbc_bolt_d,"x",mbc_bolt_l);
mbc_bolt_standard = "DIN73801"; // TODO: make it ISO7380

mbc_overlap = 10;

mbc_horizontal_bolt_standard = "DIN7991";
mbc_anchoring_nut_standard = "DIN934";
