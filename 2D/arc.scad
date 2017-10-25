/******************************************************************************
 * Arc
 */

use <segment.scad>;

module arc(a, r1, r2, $fn = $fn) {

	r_max = max(r1, r2);
	r_min = min(r1, r2);

	difference() {

		segment(a, r_max, $fn);

		rotate([0, 0, -1])
		segment(a + 2, r_min, $fn);
	}
}
