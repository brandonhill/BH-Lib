/******************************************************************************
 * Print-in-place bearing and diff
 */

use <../../helpers.scad>;
use <../../3D/cylinder true.scad>;

module bearing(
	dim, // [inner dia., outer dia., height]
	races,
	tolerance = 0.15,
	center = true,
	) {

	race_thickness = races ? races : (dim[1] - dim[0]) / 2 / 8;
	ball_dia = (dim[1] - dim[0]) / 2 - (race_thickness + tolerance) * 2;
	ball_height = dim[2] - race_thickness * 2;
	ball_x = dim[0] / 2 + (dim[1] - dim[0]) / 4;
	ball_shaft_dia = (dim[1] - dim[0]) / 2 - (race_thickness) * 4;
	balls = floor(circumference(ball_x) / (ball_dia + tolerance));

	module solid() {
		difference() {
			cylinder(h = dim[2], r = dim[1] / 2, center = true);
			cylinder(h = dim[2] + 0.2, r = dim[0] / 2, center = true);
		}
	}

	module ball() {

		// keep faces matching
//		$fn = get_fragments_from_r(ball_dia / 2);

		// shaft
		cylinder(h = dim[2], r = ball_shaft_dia / 2, center = true);

		// "ball"
		cylinder(h = ball_height, r = ball_dia / 2, center = true);

		// angled bits
		reflect(x = false, y = false, z = true)
		translate([0, 0, ball_height / 2])
		cylinder(h = race_thickness, r1 = ball_dia / 2, r2 = ball_shaft_dia / 2);
	}

	module race_diff() {
		rotate_extrude(convexity = 4)
		translate([ball_x, 0])
		offset(delta = tolerance)
		projection()
		rotate([90, 0])
		ball();
	}

	translate([0, 0, center ? 0 : dim[2] / 2]) {
		// races
		difference() {
			solid();
			race_diff();
		}

		// "balls"
		for (i = [0 : balls - 1])
		rotate([0, 0, 360 / balls * i])
		translate([ball_x, 0])
		ball();
	}
}

module diff_bearing(dim, center = true, hole = false, mock = true, tolerance = 0) {

	module mock_bearing(dim, center = true, hole = true, tolerance = 0) {
		difference() {
			translate([0, 0, center ? 0 : -tolerance])
			cylinder_true(h = dim[2] + tolerance * 2, r = dim[1] / 2 + tolerance, center = center);

			if (hole)
			translate([0, 0, -((center ? 0 : -tolerance) + 0.1)])
			cylinder_true(h = dim[2] + tolerance * 2 + 0.2, r = dim[0] / 2 - tolerance, center = center);
		}
	}

	mock_bearing(dim = dim, center = center, hole = hole, tolerance = tolerance);

	if (mock)
	% mock_bearing(dim = dim, center = center);
}

/*

$fs = 0.5;

show_half()
bearing(
	dim = [8, 22, 7] // 608
);

//*/
