/******************************************************************************
 * Hobby King 282A micro servo
 */

include <../../../../colours.scad>;

SERVO_HK_282A_DIM = [16, 15, 8.5, 6];

module servo_hk_282a(a = 0, flanges = true) {

	SERVO_DIM = SERVO_HK_282A_DIM;
	SERVO_FLANGE_DEPTH = 4;
	SERVO_FLANGE_OFFSET = 4.5; // from top

	color(COLOUR_WHITE) {

		// body
		translate([-SERVO_DIM[2] / 2, -(SERVO_DIM[1] + SERVO_DIM[3] / 2), 0])
		difference() {
			cube([SERVO_DIM[0], SERVO_DIM[1], SERVO_DIM[2]]);

			translate([SERVO_DIM[0] * 0.7, SERVO_DIM[1], -1])
			rotate([0, 0, -20])
			cube([SERVO_DIM[0], SERVO_DIM[1], SERVO_DIM[2] + 2]);
		}

		// flanges
		if (flanges) {
			translate([-SERVO_FLANGE_DEPTH / 2 - SERVO_DIM[2] / 2, -SERVO_DIM[3] / 2 - SERVO_FLANGE_OFFSET, SERVO_FLANGE_DEPTH / 2])
			rotate([90, 0, 0])
			linear_extrude(0.5)
			hull() {
				for (x = [0 : 1], y = [0 : 1])
				translate([
					0 + (SERVO_DIM[0] + SERVO_FLANGE_DEPTH) * x,
					0 + (SERVO_DIM[2] - SERVO_FLANGE_DEPTH) * y
				])
				circle(SERVO_FLANGE_DEPTH / 2);
			}
		}

		// shaft surround
		translate([0, 0, SERVO_DIM[2] / 2])
		rotate([90, 0, 0])
		cylinder(h = SERVO_DIM[3] / 2, r = SERVO_DIM[2] / 2);

		// shaft
		translate([0, SERVO_DIM[3] / 2, SERVO_DIM[2] / 2])
		rotate([90, 0, 0])
		cylinder(h = SERVO_DIM[3] / 2, r = SERVO_DIM[2] / 4);
	}

	// arm
	translate([0, SERVO_DIM[3] / 2, SERVO_DIM[2] / 2])
	rotate([90, a - 120, 0]) {
		children();
	}
	//*/


}

*
servo_hk_282a();
