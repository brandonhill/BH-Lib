/******************************************************************************
 * Oversky MP03T 1103 16000kv brushless motor
 */

include <../../../../colours.scad>;
include <../generic.scad>;

MOTOR_OVERSKY_MP03T_BELL_HEIGHT = 4;
MOTOR_OVERSKY_MP03T_HEIGHT = 9;
MOTOR_OVERSKY_MP03T_RAD = 14 / 2;
MOTOR_OVERSKY_MP03T_MOUNT_AXLE_DEPTH = 0.5;
MOTOR_OVERSKY_MP03T_MOUNT_HEIGHT = 3;
MOTOR_OVERSKY_MP03T_MOUNT_HOLE_RAD = 1.6 / 2;
MOTOR_OVERSKY_MP03T_MOUNT_HOLES = 3;
MOTOR_OVERSKY_MP03T_MOUNT_RAD = 3.25;
MOTOR_OVERSKY_MP03T_SHAFT_HEIGHT = 4.6;
MOTOR_OVERSKY_MP03T_SHAFT_RAD = 0.75;

module motor_oversky_mp03t() {

	top_height = MOTOR_OVERSKY_MP03T_HEIGHT - MOTOR_OVERSKY_MP03T_BELL_HEIGHT - MOTOR_OVERSKY_MP03T_MOUNT_HEIGHT;

	color(COLOUR_STEEL)
	difference() {
		motor_base(
			h = (MOTOR_OVERSKY_MP03T_MOUNT_HEIGHT) * 0.95,
			r = MOTOR_OVERSKY_MP03T_RAD,
			n = 9,
			arm_width = MOTOR_OVERSKY_MP03T_RAD * 0.5,
			bevel = 0.9,
			inner_rad = MOTOR_OVERSKY_MP03T_RAD * 0.9
		);

		//rotate([0, 0, 360 / MOTOR_OVERSKY_MP03T_MOUNT_HOLES / 2])
		for (n = [0 : MOTOR_OVERSKY_MP03T_MOUNT_HOLES - 1])
			rotate([0, 0, 360 / MOTOR_OVERSKY_MP03T_MOUNT_HOLES * n])
			translate([MOTOR_OVERSKY_MP03T_MOUNT_RAD, 0, -0.1])
			cylinder(h = MOTOR_OVERSKY_MP03T_MOUNT_HEIGHT + 0.2, r = MOTOR_OVERSKY_MP03T_MOUNT_HOLE_RAD);
	}

	translate([0, 0, MOTOR_OVERSKY_MP03T_MOUNT_HEIGHT]) {
		motor_bell(
			MOTOR_OVERSKY_MP03T_BELL_HEIGHT,
			MOTOR_OVERSKY_MP03T_RAD,
			poles = 12,
			col = COLOUR_STEEL
		);

		motor_stator(
			MOTOR_OVERSKY_MP03T_BELL_HEIGHT,
			MOTOR_OVERSKY_MP03T_RAD - 1.6,
			poles = 9
		);

		color(COLOUR_STEEL)
		translate([0, 0, MOTOR_OVERSKY_MP03T_BELL_HEIGHT]) {
			translate([0, 0, top_height])
			scale([1, 1, -1])
			motor_base(
				h = top_height,
				r = MOTOR_OVERSKY_MP03T_RAD,
				n = 8,
				bevel = 0.75
			);
		}
	}

	color(COLOUR_STEEL)
	translate([0, 0, -MOTOR_OVERSKY_MP03T_MOUNT_AXLE_DEPTH])
	cylinder(
		h = MOTOR_OVERSKY_MP03T_MOUNT_AXLE_DEPTH + MOTOR_OVERSKY_MP03T_HEIGHT + MOTOR_OVERSKY_MP03T_SHAFT_HEIGHT,
		r = MOTOR_OVERSKY_MP03T_SHAFT_RAD
	);
}

*motor_oversky_mp03t();
