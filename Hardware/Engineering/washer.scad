/******************************************************************************
 * Washer
 *
 */

use <../../3D/cylinder true.scad>;
use <../../helpers.scad>;

module washer(
		dim, // [inner dia., outer dia., height]
	) {

	difference() {
		cylinder(h = dim[2], r = dim[1] / 2);

		// hole
		translate([0, 0, -0.1])
		cylinder(h = dim[2] + 0.2, r = dim[0] / 2);
	}
}

module washer_diff(
		dim, // [inner dia., outer dia., height]
		conical = false, // for printing
		hole = false,
		mock = false,
		tolerance = 0,
	) {

	_dim = [dim[0] - tolerance * 2, dim[1] + tolerance * 2, dim[2] + tolerance * 2];

	translate([0, 0, -tolerance])
	if (hole)
		washer(dim = _dim);
	else
		hull()
		washer(dim = _dim);

	if (conical)
	translate([0, 0, dim[2] + tolerance - 0.1])
	cylinder_true(h = (dim[1] - dim[0]) / 2 + 0.1, r1 = _dim[1] / 2, r2 = _dim[0] / 2, center = false);

	if (mock)
	% washer(dim);
}
