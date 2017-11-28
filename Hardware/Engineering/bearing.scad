/******************************************************************************
 * Bearing
 */

use <../../3D/cylinder true.scad>;

// dim = [inner dia., outer dia., height]
module bearing(dim, center = true, hole = true, tolerance = 0) {
	difference() {
		translate([0, 0, center ? 0 : -tolerance])
		cylinder_true(h = dim[2] + tolerance * 2, r = dim[1] / 2 + tolerance, center = center);

		if (hole)
		translate([0, 0, -((center ? 0 : -tolerance) + 0.1)])
		cylinder_true(h = dim[2] + tolerance * 2 + 0.2, r = dim[0] / 2 - tolerance, center = center);
	}
}

module diff_bearing(dim, center = true, hole = false, mock = true, tolerance = 0) {
	bearing(dim = dim, center = center, hole = hole, tolerance = tolerance);

	if (mock)
	% bearing(dim = dim, center = center);
}
