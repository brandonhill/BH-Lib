/******************************************************************************
 * HobbyKing AP05 motor
 * https://hobbyking.com/en_us/hobbyking-ap05-3000kv-brushless-micro-motor-5-4g.html
 * - 3000 kV
 * - 1-2S
 * - 3/4A max current continuous/burst (10s)
 * - 5.4g
 * - 5030 x 7V = 110g, 2.8A
 */

include <../../../../colours.scad>;
include <../generic.scad>;

MOTOR_HOBBYKING_AP05_AXLE_CLEARANCE_RAD = 7;
MOTOR_HOBBYKING_AP05_HEIGHT = 9;
MOTOR_HOBBYKING_AP05_RAD = 13 / 2;
MOTOR_HOBBYKING_AP05_MOUNT_ARM_WIDTH = 2.6;
MOTOR_HOBBYKING_AP05_MOUNT_HEIGHT = 3;
MOTOR_HOBBYKING_AP05_MOUNT_HOLE_RAD = 1.6 / 2;
MOTOR_HOBBYKING_AP05_MOUNT_HOLES = 3;
MOTOR_HOBBYKING_AP05_MOUNT_RAD = 17 / 2;
MOTOR_HOBBYKING_AP05_MOUNT_THICKNESS = 1;
MOTOR_HOBBYKING_AP05_SHAFT_HEIGHT = 7;
MOTOR_HOBBYKING_AP05_SHAFT_RAD = 1;

module motor_hobbyking_ap05() {
	motor_generic(
		col_bell = COLOUR_STEEL,
		col_mount = COLOUR_GREY_DARK,
		height = MOTOR_HOBBYKING_AP05_HEIGHT,
		mount_arm_width = MOTOR_HOBBYKING_AP05_MOUNT_ARM_WIDTH,
		mount_height = MOTOR_HOBBYKING_AP05_MOUNT_HEIGHT,
		mount_hole_rad = MOTOR_HOBBYKING_AP05_MOUNT_HOLE_RAD,
		mount_holes = MOTOR_HOBBYKING_AP05_MOUNT_HOLES,
		mount_rad = MOTOR_HOBBYKING_AP05_MOUNT_RAD,
		mount_thickness = MOTOR_HOBBYKING_AP05_MOUNT_THICKNESS,
		rad = MOTOR_HOBBYKING_AP05_RAD,
		shaft_height = MOTOR_HOBBYKING_AP05_SHAFT_HEIGHT,
		shaft_rad = MOTOR_HOBBYKING_AP05_SHAFT_RAD
	);
}

// motor_hobbyking_ap05();
