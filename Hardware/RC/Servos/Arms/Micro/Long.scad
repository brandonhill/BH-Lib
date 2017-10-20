/******************************************************************************
 * Long micro servo arm
 */

include <../../../../../colours.scad>;

SERVO_ARM_MICRO_LONG_DIM = [15, 5, 1, 3];

module servo_arm_micro_long() {

	dim = SERVO_ARM_MICRO_LONG_DIM;

	color(COLOUR_WHITE) {
		linear_extrude(dim[2])
		hull() {
			circle(dim[1] / 2);

			translate([dim[0], 0, 0])
			circle(dim[1] / 2 * 0.6);
		}
		cylinder(h = dim[3], r = dim[1] / 2);
	}
}

//servo_arm_micro_long();
