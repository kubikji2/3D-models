include<hdd-constants.scad>
include<odroid-h4-constants.scad>
include<cooling-fan-constants.scad>

///////////////
// Interface //
///////////////

// the screwed rods are run through the tower to connect all segments 

// vertical interface parameters
H4_NAS_INTERFACE_OFF = 10;
H4_NAS_INTERFACE_ROD_D = 3;
H4_NAS_INTERFACE_ROD_G = H4_PCB_A + H4_NAS_INTERFACE_OFF;
H4_NAS_INTERFACE_ROD_CLEARANCE = 0.4;

////////////////////
// NAS parameters //
////////////////////

// general parameters
H4_NAS_WT = 3;
H4_NAS_A = H4_PCB_A+2*H4_NAS_INTERFACE_OFF;

/////////////
// STENCIL //
/////////////

H4_NAS_ACTIVE_COOLING_D = 8;
// '-> active cooling hexagons diameter
H4_NAS_PASSIVE_COOLING_D = 16;

//////////////////////
// Odroid bay (ODR) //
//////////////////////

// wall thickness
H4_NAS_ODR_WT = 3;

// mount points bolts parameters
H4_NAS_ODR_BOLT_STANDARD = "DIN84A";
H4_NAS_ODR_BOLT_LENGTH = 10;
H4_NAS_ODR_BOLT_DESCRIPTOR = str("M",H4_PCB_MP_DIAMETER,"x",H4_NAS_ODR_BOLT_LENGTH);
H4_NAS_ODR_BOLT_OFFSET = H4_NAS_ODR_BOLT_LENGTH-H4_PCB_T;

// spacers transistion diameter
H4_NAS_ODR_TRANSIOTION_D = 2;

// cable holes paramters
H4_NAS_ODR_CH_L = H4_PCB_A/2;
H4_NAS_ODR_CH_W = 10;

// shell parameters
H4_NAS_ODR_MARGIN = 5;
H4_NAS_ODR_SHELL_H = H4_PCB_BOTTOM_MINIMAL_CLEARANCE + H4_PCB_T + H4_PORTS_AUDIO_H + H4_NAS_ODR_MARGIN + H4_NAS_ODR_WT;
//                    H4_PORTS_AUDIO_H is the tallest port on the board <-'

H4_NAS_ODR_COMPARTEMENT_HEIGHT = H4_NAS_ODR_SHELL_H + H4_NAS_WT;
// '-> total height equals to shell height and the bottom thickness

H4_NAS_ODR_PORT_CLEARANCE = 0.4;
H4_NAS_ODR_PORT_BEVEL = 2;

//////////////////
// HDD BAY (HB) //
//////////////////

H4_NAS_HB_WT = 4;

// reinforcements parameters
H4_NAS_HB_RF_W = 6;
H4_NAS_HB_RF_R = 6;

// HDD spacing
H4_NAS_HB_SPACING = 30;

// bolts
H4_NAS_HB_BOLT_STANDARD = "DIN84A";
H4_NAS_HB_BOLT_LENGTH = 5;
H4_NAS_HB_BOLT_DESCRIPTOR = str("M",HDD_MP_D,"x",H4_NAS_HB_BOLT_LENGTH);
H4_NAS_HB_BOLT_OFFSET = 3;


// shell
H4_NAS_HB_MARGIN = 40; // enough to bend sata+power cables
H4_NAS_HB_SHELL_H = HDD_Y + H4_NAS_HB_MARGIN + H4_NAS_ODR_WT;

H4_NAS_HB_COMPARTEMENT_HEIGHT = H4_NAS_HB_SHELL_H + H4_NAS_WT;



