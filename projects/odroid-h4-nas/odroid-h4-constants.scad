
// Odroid H4 PCB side lenth
H4_PCB_A = 120;
H4_PCB_T = 2;
H4_PCB_BOTTOM_MINIMAL_CLEARANCE = 6;

// mount points assuming the board coordinate system origin in the power port corner
// with ports facing in negative y-axis (same as reference drawing)

// holes parameters
H4_PCB_MP_DIAMETER = 3;
H4_PCB_MP_CLEARED_DIAMETER = 6.5;

// left up hole position
H4_PCB_MP_LU_X = 3.81;
H4_PCB_MP_LU_Y = H4_PCB_A - 3.81; // guessed as schematics is shit (GASIS)

// left down hole position
H4_PCB_MP_LD_X = H4_PCB_MP_LU_X; // GASIS
H4_PCB_MP_LD_Y = H4_PCB_MP_LU_Y - 98.41;

// right up hole position
H4_PCB_MP_RU_X = H4_PCB_A - 3.96;
H4_PCB_MP_RU_Y = H4_PCB_A - 3.81;

// right down hole position
H4_PCB_MP_RD_X = H4_PCB_A - (12.45+3.51/2); // measured as schematics is shit (MASIS)
H4_PCB_MP_RD_Y = H4_PCB_MP_RU_Y - 91.42;


// periferies/ports parameters
// offset is always a center of the port

// power port
H4_PORTS_POWER_OFF = 6.98;
H4_PORTS_POWER_W = 10;
H4_PORTS_POWER_H = 10;

// first combo USB + Ethernet port
H4_PORTS_USB1_OFF = H4_PORTS_POWER_OFF+22.85;
H4_PORTS_USB1_W = 18.9;
H4_PORTS_USB1_H = 31;

// second combo USB + Ethernet port
H4_PORTS_USB2_OFF = H4_PORTS_USB1_OFF+24.77;
H4_PORTS_USB2_W = H4_PORTS_USB1_W;
H4_PORTS_USB2_H = H4_PORTS_USB1_H;

// DP + HDMI combined port
H4_PORTS_MEDIA1_OFF = H4_PORTS_USB2_OFF + 23.2;
H4_PORTS_MEDIA1_W = 18;
H4_PORTS_MEDIA1_H = 19;

// DP single port
H4_PORTS_MEDIA2_OFF = H4_PORTS_MEDIA1_OFF + 18.33;
H4_PORTS_MEDIA2_W = 6.8;
H4_PORTS_MEDIA2_H = 18.3;

// AUDIO ports
H4_PORTS_AUDIO_OFF = H4_PORTS_MEDIA2_OFF + 15.37;
H4_PORTS_AUDIO_W = 12.7;
H4_PORTS_AUDIO_H = 35;

