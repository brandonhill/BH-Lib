/******************************************************************************
 * Nut
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

use <../helpers.scad>;
use <threads.scad>;

// dim = [inner dia., outer dia., height]
module nut_diff(dim, hole = false, center = true, offset = 0, sides = 6) {

	linear_extrude(dim[2] + offset * 2, center = center)
	rotate([0, 0, 360 / sides / 2])
	difference() {

		// nut shape
		polygon(poly_coords(sides, dim[1] / 2 + offset));

		// hole
		if (hole)
		circle(dim[0] / 2 - offset, $fn = max($fn, 10));
	}
}

module nut(
		height,
		width,
		pitch = 0.5,
		sides = 6,
		thread_dia = 3.1,
		threaded = false,
		wings = false, // butterfly
	) {

	height = height ? height : thread_dia * 0.8;
	width = width ? width : thread_dia * 1.6;

	segment_angle = !sides ? 0 : 360 / sides;
	point_rad = (width / 2) / cos(segment_angle / 2);

	difference() {

		if (wings) {
			union() {
				hull() {
					#translate([0, 0, (width - thread_dia)])
					rotate_extrude()
					translate([width / 2 - (width - thread_dia) / 2, 0, 0])
					circle(r = (width - thread_dia) / 2);

					cylinder(h = 0.1, r = width / 2);
				}

				for (i = [0 : 1]) {
					rotate([0, 0, 180 * i])
					translate([thread_dia / 2, thread_dia / 2, 0])
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
						translate([width * 0.5, height * 1.5, thread_dia / 2 - 0.5])
						cylinder(height = 1, r = height);

						translate([0, 0, 0])
						cube([0.1, height, thread_dia]);
					}
					;
				}
			}
		} else {
			if (sides) {
				hull()
				for (i = [1 : sides])
					rotate([0, 0, segment_angle * i])
					translate([point_rad, 0, 0])
					cylinder(h = height, r = 0.1);
			} else {
				cylinder(h = height, r = width / 2);
			}
		}

		translate([0, 0, -0.1])
		if (threaded)
			metric_thread(diameter = thread_dia, pitch = pitch, length = height + 0.2, internal = true);
		else
			cylinder(h = height + 0.2, r = thread_dia / 2);
	}
}
