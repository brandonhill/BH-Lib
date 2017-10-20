/******************************************************************************
 * Hobby King 5320 micro servo
 */

include <../../../../colours.scad>;

SERVO_HK_5320_DIM = [14, 16, 6];
SERVO_HK_5320_FLANGE_HOLE_RAD = 1;
SERVO_HK_5320_FLANGE_OFFSET = 6; // from bottom
SERVO_HK_5320_FLANGE_WIDTH = 3;
SERVO_HK_5320_HORN_HEIGHT = 2;
SERVO_HK_5320_HORN_RAD = 1.5;

module servo_hk_5320(a = 0, flanges = true) {

	SERVO_DIM = SERVO_HK_5320_DIM;
	FLANGE_HOLE_RAD = SERVO_HK_5320_FLANGE_HOLE_RAD;
	FLANGE_OFFSET = SERVO_HK_5320_FLANGE_OFFSET;
	FLANGE_WIDTH = SERVO_HK_5320_FLANGE_WIDTH;
	HORN_HEIGHT = SERVO_HK_5320_HORN_HEIGHT;
	HORN_RAD = SERVO_HK_5320_HORN_RAD;

	color(COLOUR_WHITE) {

		// body
		translate([-SERVO_DIM[2] / 2, -SERVO_DIM[1], 0])
		cube(SERVO_DIM);

		// flanges
		if (flanges) {
			translate([-FLANGE_WIDTH / 2 - SERVO_DIM[2] / 2, -FLANGE_OFFSET, FLANGE_WIDTH / 2])
			rotate([90, 0, 0])
			linear_extrude(0.5)
			hull() {
				for (x = [0 : 1], y = [0 : 1])
				translate([
					0 + (SERVO_DIM[0] + FLANGE_WIDTH) * x,
					0 + (SERVO_DIM[2] - FLANGE_WIDTH) * y
				])
				circle(FLANGE_WIDTH / 2);
			}
		}

		// shaft
		translate([0, 2, SERVO_DIM[2] / 2])
		rotate([90, 0, 0])
		cylinder(h = HORN_HEIGHT, r = HORN_RAD);
	}

	// arm
	translate([0, HORN_HEIGHT / 2, SERVO_DIM[2] / 2])
	rotate([90, a - 120, 0]) {
		children();
	}
	//*/


}

*
servo_hk_5320();
