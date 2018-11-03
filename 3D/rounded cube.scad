/******************************************************************************
 * Rounded cube
 */

use <../helpers.scad>;

module rounded_cube(dim, r, edges = false, center = true) {

	_dim = dim[0] && dim[1] && dim[2] ? dim : [dim, dim, dim];
	_r = min(r, min(_dim) / 2);

	if (r <= 0) {
		cube(_dim, center);

	} else {

		if (r > _r)
			warn(str("rounded_cube radius ", r, " exceeds maximum due to dimensions, reduced to ", _r));

		translate(center ? 0 : _dim / 2)
		hull()
		reflect(z = [-1, 1])
		translate([_dim[0] / 2 - _r, _dim[1] / 2 - _r, _dim[2] / 2 - _r])
		if (edges)
			sphere_true(_r);
		else
			sphere(_r);
	}
}
