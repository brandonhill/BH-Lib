/******************************************************************************
 * Constants
 */

include <../../constants.scad>;

// BEARINGS

BEARING_688_DIM = [8, 16, 5];
BEARING_608_DIM = [8, 22, 7];

// BOLTS - [thread dia., head dia., head height]

// 1/4" 20 TPI
BOLT_I1_4_20_DIM = [1/4 * MMPI, 0.38 * MMPI, 0.25 * MMPI];

// NUTS - [inner dia., outer dia. (to edges), height]

// 5/16"
NUT_I_5_16_DIM = [5/16 * MMPI, 13, 8];

NUT_M2_DIM = [2, 3.9, 1.5];
NUT_M3_DIM = [3, 5.5, 2.4];
NUT_M4_DIM = [4, 7, 3.2];

// SCREWS - [thread dia., head dia., head height, socket dia, socket depth]

SCREW_M1_6_PAN_DIM = [1.6, 2.5, 0.5];

SCREW_M2_FLAT_DIM = [2, 3.8, 1.2];
SCREW_M2_SOCKET_DIM = [2, 3.8, 2, 1.55, 1];

SCREW_M3_FLAT_DIM = [3, 6, 1.65, 2.1, 1];
SCREW_M3_SOCKET_DIM = [3, 5.5, 3, 2.55, 1.3];

SCREW_M4_SOCKET_DIM = [4, 7, 4, 3.05, 2];

SCREW_M6_SOCKET_DIM = [6, 10, 6, 5, 3];

SCREW_M8_SOCKET_DIM = [8, 13, 8, 6, 4];

// THREADS

THREAD_PITCH_M2_COARSE = 0.4;
THREAD_PITCH_M2_FINE = 0.25;

THREAD_PITCH_M3_COARSE = 0.5;
THREAD_PITCH_M3_FINE = 0.35;

THREAD_PITCH_M4_COARSE = 0.7;
THREAD_PITCH_M4_FINE = 0.5;

// WASHERS

WASHER_M2_DIM = [2.2, 5, 0.3];
