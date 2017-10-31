/******************************************************************************
 * U beam
 */

use <../../2D/u.scad>;

module beam_u(dim = [100, 10, 10], t = 1, t1, t2, center = true, convexity = 1) {

	_t1 = t1 ? t1 : t;
	_t2 = t2 ? t2 : t;

	rotate([0, 90, 0])
	linear_extrude(dim[0], center = center, convexity = convexity)
	rotate([0, 0, 90])
	u([dim[2], dim[1]], t1 = _t1, t2 = _t2);
}
