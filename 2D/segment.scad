// ****************************************************************************
// Segment

use <semicircle.scad>;

module segment(a, r) {

	difference() {

		semicircle(r);

		if (a < 180) {
			rotate([0, 0, a])
			semicircle(r + 1);
		}
	}

	if (a > 180) {

		rotate([0, 0, 180])
		difference() {

			semicircle(r);

			rotate([0, 0, a - 180])
			semicircle(r + 1);
		}
	}
}

module segment_true(a, r) {

	difference() {

		semicircle_true(r);

		if (a < 180) {
			rotate([0, 0, a])
			semicircle_true(r + 1);
		}
	}

	if (a > 180) {

		rotate([0, 0, 180])
		difference() {

			semicircle_true(r);

			rotate([0, 0, a - 180])
			semicircle_true(r + 1);
		}
	}
}
