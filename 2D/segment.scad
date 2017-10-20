// ****************************************************************************
// Segment

use <semicircle.scad>;

module segment(a, r, $fn = $fn) {

	difference() {

		semicircle(r, $fn);

		if (a < 180) {
			rotate([0, 0, a])
			semicircle(r + 1, $fn);
		}
	}

	if (a > 180) {

		rotate([0, 0, 180])
		difference() {

			semicircle(r, $fn);

			rotate([0, 0, a - 180])
			semicircle(r + 1, $fn);
		}
	}
}
