/******************************************************************************
 * Semicircle
 */

use <../helpers.scad>;
use <circle true.scad>;

module semicircle(r = 1) {
	difference() {
		circle_true(r);

		translate([-r * 2, -r * 4, 0])
		square(r * 4);
	}
}

module semicircle_true(r = 1) {
	difference() {
		circle_true(r);

		translate([-r * 2, -r * 4, 0])
		square(r * 4);
	}
}
