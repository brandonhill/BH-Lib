/******************************************************************************
 * Cylinder with edges (instead of vertices) at radius
 */

use <../helpers.scad>;

module cylinder_true(h, r = 0, r1 = 0, r2 = 0, center = true) {

	_r1 = r > 0 ? r : r1;
	_r2 = r > 0 ? r : r2;

	fn1 = get_fragments_from_r(_r1, $fa, $fn, $fs);
	fn2 = get_fragments_from_r(_r2, $fa, $fn, $fs);

	translate([0, 0, center ? -h / 2 : 0])
	difference() {

		// one end is a point (cone end)
		if (_r1 == 0 || _r2 == 0) {
			hull() {
				cylinder(h = h, r1 = _r2 == 0 ? _r1 / 2 : 0, r2 = _r1 == 0 ? _r2 / 2 : 0);

				translate([0, 0, (_r1 > _r2 ? -0.1 : h)])
				linear_extrude(0.1)
				polygon(poly_coords(_r1 == 0 ? fn2 : fn1, _r1 == 0 ? _r2 : _r1));
			}
		} else {
			hull() {
				translate([0, 0, (_r1 > _r2 ? -0.1 : 0)])
				linear_extrude(0.1)
				polygon(poly_coords(fn1, _r1));

				translate([0, 0, h + (_r1 > _r2 ? -0.1 : 0)])
				linear_extrude(0.1)
				polygon(poly_coords(fn2, _r2));
			}
		}

		translate([0, 0, (_r1 > _r2 ? -0.2 : h)])
		cylinder(h = 0.2, r = max(_r1, _r2) * 2);
	}
}
