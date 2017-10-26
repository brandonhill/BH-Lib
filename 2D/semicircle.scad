/******************************************************************************
 * Semicircle
 */

use <../helpers.scad>;

module semicircle(r = 1, $fa = $fa, $fn = $fn, $fs = $fs) {
	difference() {
		circle(r, $fn = get_fragments_from_r(r, $fa, $fn, $fs));

		translate([-r, -r * 2, 0])
		square(r * 2);
	}
}

module semicircle_true(r = 1, $fa = $fa, $fn = $fn, $fs = $fs) {
	difference() {
		circle_true(r, $fa = $fa, $fn = $fn, $fs = $fs);

		translate([-r, -r * 2, 0])
		square(r * 2);
	}
}
