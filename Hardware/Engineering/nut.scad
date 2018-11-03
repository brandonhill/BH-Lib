/******************************************************************************
 * Nut
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

use <../../helpers.scad>;
use <threads.scad>;

module nut(
		dim,
		pitch,
		sides = 6,
		threaded = false,
		wings = false, // butterfly
	) {

	height = dim && dim[2] ? dim[2] : dim[0] * 0.8;
	width = dim && dim[1] ? dim[1] : dim[0] * 1.6;

	difference() {

		if (wings) {
			union() {
				hull() {
					translate([0, 0, (width - dim[0])])
					rotate_extrude()
					translate([width / 2 - (width - dim[0]) / 2, 0, 0])
					circle(r = (width - dim[0]) / 2);

					cylinder(h = 0.1, r = width / 2);
				}

				for (i = [0 : 1]) {
					rotate([0, 0, 180 * i])
					translate([dim[0] / 2, dim[0] / 2, 0])
					rotate([90, 0, 0])
					/*
					linear_extrude(wings)
					hull() {
						square([0.1, height]);
						translate([width * 0.5, height * 1.5])
						circle(height);
					}
					//*/
					hull() {
						translate([width * 0.5, height * 1.5, dim[0] / 2 - 0.5])
						cylinder(height = 1, r = height);

						translate([0, 0, 0])
						cube([0.1, height, dim[0]]);
					}
					;
				}
			}
		} else {
			if (sides) {
				linear_extrude(height)
				polygon(poly_coords(sides, width / 2));
			} else {
				cylinder(h = height, r = width / 2);
			}
		}

		translate([0, 0, -0.1])
		if (threaded)
			thread_iso_metric(dim[0], height + 0.2, pitch, center = false, internal = true);
		else
			cylinder(h = height + 0.2, r = dim[0] / 2);
	}
}

module nut_diff(
		dim, // [inner dia., outer dia., height]
		conical = false, // for printing
		hole = false,
		mock = false,
		tolerance = 0,
		sides = 6) {

	_dim = [dim[0] - tolerance * 2, dim[1] + tolerance * 2, dim[2] + tolerance * 2];

	translate([0, 0, -tolerance])
	if (hole)
		nut(dim = _dim, sides = sides);
	else
		hull()
		nut(dim = _dim, sides = sides);

	if (conical)
	translate([0, 0, dim[2] + tolerance - 0.1])
	cylinder_true(h = (dim[1] - dim[0]) / 2 + 0.1, r1 = _dim[1] / 2 + tolerance, r2 = _dim[0] / 2 + tolerance, center = false, $fn = sides);

	if (mock)
	% nut(dim);
}
