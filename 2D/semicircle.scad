/******************************************************************************
 * Semicircle
 */

use <../helpers.scad>;
use <circle true.scad>;

module semicircle(r = 1) {
	difference() {
		circle(r);

		translate([-r, -r * 2, 0])
		square(r * 2);
	}
}

module semicircle_true(r = 1) {
	difference() {
		circle_true(r);

		translate([-r, -r * 2, 0])
		square(r * 2);
	}
}
