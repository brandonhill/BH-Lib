/******************************************************************************
 * L beam
 */

use <../../2D/l.scad>;

module beam_l(dim = [100, 10, 10], t = 1, t1, t2, center = true) {

	_t1 = t1 ? t1 : t;
	_t2 = t2 ? t2 : t;

	rotate([0, 90, 0])
	linear_extrude(dim[0], center = center)
	rotate([0, 0, 90])
	l([dim[1], dim[2]], t1 = _t1, t2 = _t2);
}
