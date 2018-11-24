// ****************************************************************************
// Hextronic 5g 2000kV motor

include <../../../../colours.scad>;
include <../generic.scad>;

//
MOTOR_HXT_5G2000KV_HEIGHT = 7;
MOTOR_HXT_5G2000KV_RAD = 7;
MOTOR_HXT_5G2000KV_MOUNT_HEIGHT = 2;
MOTOR_HXT_5G2000KV_MOUNT_HOLE_RAD = 0.75;
MOTOR_HXT_5G2000KV_MOUNT_HOLES = 4; // base
MOTOR_HXT_5G2000KV_MOUNT_RAD = 8; // base
// MOTOR_HXT_5G2000KV_MOUNT_RAD = 3; // without base
MOTOR_HXT_5G2000KV_SHAFT_HEIGHT = 6;
MOTOR_HXT_5G2000KV_SHAFT_RAD = 0.75;

module motor_turnigy_a1309() {
	motor_generic(
		height = MOTOR_HXT_5G2000KV_HEIGHT,
		rad = MOTOR_HXT_5G2000KV_RAD,
		mount_height = MOTOR_HXT_5G2000KV_MOUNT_HEIGHT,
		mount_hole_rad = MOTOR_HXT_5G2000KV_MOUNT_HOLE_RAD,
		mount_holes = MOTOR_HXT_5G2000KV_MOUNT_HOLES,
		mount_rad = MOTOR_HXT_5G2000KV_MOUNT_RAD,
		mount_thickness = 1,
		shaft_height = MOTOR_HXT_5G2000KV_SHAFT_HEIGHT,
		shaft_rad = MOTOR_HXT_5G2000KV_SHAFT_RAD
	);
}

*
motor_turnigy_a1309();
