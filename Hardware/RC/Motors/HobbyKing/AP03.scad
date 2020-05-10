/******************************************************************************
 * HobbyKing AP03 motor
 * https://hobbyking.com/en_us/hobbyking-ap03-4000kv-brushless-micro-motor-3-1g.html
 * - 4000 kV
 * - 1-2S
 * - 2/2.5A max current continuous/burst (10s)
 * - 3.1g
 * - 3020 x 7.4V = 61g, 1.7A
 */

include <../../../../colours.scad>;
include <../generic.scad>;

MOTOR_HOBBYKING_AP03_AXLE_CLEARANCE_RAD = 7;
MOTOR_HOBBYKING_AP03_HEIGHT = 4;
MOTOR_HOBBYKING_AP03_RAD = 13 / 2;
MOTOR_HOBBYKING_AP03_MOUNT_ARM_WIDTH = 2.6;
MOTOR_HOBBYKING_AP03_MOUNT_HEIGHT = 2;
MOTOR_HOBBYKING_AP03_MOUNT_HOLE_RAD = 1.6 / 2;
MOTOR_HOBBYKING_AP03_MOUNT_HOLES = 3;
MOTOR_HOBBYKING_AP03_MOUNT_RAD = 17 / 2;
MOTOR_HOBBYKING_AP03_MOUNT_THICKNESS = 1;
MOTOR_HOBBYKING_AP03_SHAFT_HEIGHT = 5;
MOTOR_HOBBYKING_AP03_SHAFT_RAD = 1;

module motor_hobbyking_ap03() {
	motor_generic(
		col_bell = COLOUR_STEEL,
		col_mount = COLOUR_GREY_DARK,
		height = MOTOR_HOBBYKING_AP03_HEIGHT,
		mount_arm_width = MOTOR_HOBBYKING_AP03_MOUNT_ARM_WIDTH,
		mount_height = MOTOR_HOBBYKING_AP03_MOUNT_HEIGHT,
		mount_hole_rad = MOTOR_HOBBYKING_AP03_MOUNT_HOLE_RAD,
		mount_holes = MOTOR_HOBBYKING_AP03_MOUNT_HOLES,
		mount_rad = MOTOR_HOBBYKING_AP03_MOUNT_RAD,
		mount_thickness = MOTOR_HOBBYKING_AP03_MOUNT_THICKNESS,
		rad = MOTOR_HOBBYKING_AP03_RAD,
		shaft_height = MOTOR_HOBBYKING_AP03_SHAFT_HEIGHT,
		shaft_rad = MOTOR_HOBBYKING_AP03_SHAFT_RAD
	);
}

// motor_hobbyking_ap03();
