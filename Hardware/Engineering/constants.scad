/******************************************************************************
 * Constants
 */

include <../../constants.scad>;

// Nuts - [inner dia., outer dia. (to edges), height]

// 5/16"
NUT_I_5_16_DIM = [5/16 * MMPI, 13, 8];

NUT_M2_DIM = [2, 4, 2];

NUT_M3_DIM = [3, 5.7, 2.4];

// SCREWS - [thread dia., head dia., head height, socket dia, socket depth]

SCREW_M1_6_PAN_DIM = [1.6, 2.5, 0.5];

SCREW_M2_FLAT_DIM = [2, 3.8, 1.2];
SCREW_M2_SOCKET_DIM = [2, 3.8, 2, 1.55, 1];

SCREW_M3_FLAT_DIM = [3, 6, 1.65, 2.1, 1];
SCREW_M3_SOCKET_DIM = [3, 5.5, 3, 2.55, 1.3];

// THREADS

THREAD_PITCH_M2_COARSE = 0.4;
THREAD_PITCH_M2_FINE = 0.25;

THREAD_PITCH_M3_COARSE = 0.5;
THREAD_PITCH_M3_FINE = 0.35;

