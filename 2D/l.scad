/******************************************************************************
 * L (for beams, for example)
 */

module l(dim = [10, 10], t = 1, t1, t2) {

	_t1 = t1 ? t1 : t;
	_t2 = t2 ? t2 : t;

	// horizontal part
	translate([dim[0] / 2, _t2 / 2])
	square([dim[0], _t2], true);

	// vertical part
	translate([_t1 / 2, dim[1] / 2])
	square([_t1, dim[1]], true);
}
