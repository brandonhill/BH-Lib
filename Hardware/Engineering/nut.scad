/******************************************************************************
 * Nut
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

use <../../helpers.scad>;
use <threads.scad>;

// dim = [inner dia., outer dia., height]
module nut_diff(dim, hole = false, mock = false, tolerance = 0, sides = 6) {

//	rotate([0, 0, 360 / sides / 2])
	if (hole)
		nut([dim[0] - tolerance * 2, dim[1] + tolerance * 2, dim[2] + tolerance * 2]);
	else
		hull()
		nut([dim[0] - tolerance * 2, dim[1] + tolerance * 2, dim[2] + tolerance * 2]);

	%
	if (mock)
		nut(dim);
}

module nut(
		dim,
		pitch = 0.5,
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
					#translate([0, 0, (width - dim[0])])
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
			metric_thread(diameter = dim[0], pitch = pitch, length = height + 0.2, internal = true);
		else
			cylinder(h = height + 0.2, r = dim[0] / 2);
	}
}
