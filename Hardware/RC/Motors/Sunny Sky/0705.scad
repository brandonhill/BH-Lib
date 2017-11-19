/******************************************************************************
 * Sunny Sky 0705 motor
 */

include <../../../../colours.scad>;
include <../generic.scad>;

MOTOR_SUNNYSKY_0705_AXLE_RAD = 7; // for bottom clearance
MOTOR_SUNNYSKY_0705_HEIGHT = 7;
MOTOR_SUNNYSKY_0705_RAD = 10 / 2;
MOTOR_SUNNYSKY_0705_MOUNT_ARM_WIDTH = 2.6;
MOTOR_SUNNYSKY_0705_MOUNT_HEIGHT = 3;
MOTOR_SUNNYSKY_0705_MOUNT_HOLE_RAD = 1.6 / 2;
MOTOR_SUNNYSKY_0705_MOUNT_HOLES = 3;
MOTOR_SUNNYSKY_0705_MOUNT_RAD = 6.5 / 2;
MOTOR_SUNNYSKY_0705_MOUNT_THICKNESS = 1;
MOTOR_SUNNYSKY_0705_SHAFT_HEIGHT = 3.15;
MOTOR_SUNNYSKY_0705_SHAFT_RAD = 0.5;

module motor_sunnysky_0705() {
	motor_generic(
		col_bell = COLOUR_GREY_DARK,
		col_mount = COLOUR_BLUE,
		height = MOTOR_SUNNYSKY_0705_HEIGHT,
		mount_arm_width = MOTOR_SUNNYSKY_0705_MOUNT_ARM_WIDTH,
		mount_height = MOTOR_SUNNYSKY_0705_MOUNT_HEIGHT,
		mount_hole_rad = MOTOR_SUNNYSKY_0705_MOUNT_HOLE_RAD,
		mount_holes = MOTOR_SUNNYSKY_0705_MOUNT_HOLES,
		mount_rad = MOTOR_SUNNYSKY_0705_MOUNT_RAD,
		mount_thickness = MOTOR_SUNNYSKY_0705_MOUNT_THICKNESS,
		rad = MOTOR_SUNNYSKY_0705_RAD,
		shaft_height = MOTOR_SUNNYSKY_0705_SHAFT_HEIGHT,
		shaft_rad = MOTOR_SUNNYSKY_0705_SHAFT_RAD
	);
}

// motor_sunnysky_0705();
