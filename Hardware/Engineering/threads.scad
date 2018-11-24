/******************************************************************************
 * Threads
 *
 * - `internal = true` has artifacts in preview mode but renders fine
 *
 * See: https://en.wikipedia.org/wiki/ISO_metric_screw_thread
 */

include <../../helpers.scad>;

module thread_iso_metric(
		d,
		h,
		pitch,
		center = true,
		internal = false, // i.e. when differencing
		reverse = false,
		starts = 1,
		tolerance = 0,
	) {

	d_minor = d - (5 * sqrt(3)) / 8 * pitch;
	H = pitch / (2 * tan(30));
	direction = reverse ? -1 : 1;
	r_inner = d_minor / 2 - H / 4 - tolerance * (internal ? -1 : 1);
	r_outer = d / 2 + H / 8 - tolerance * (internal ? -1 : 1);
	steps = get_fragments_from_r(d / 2);

	a = 360 / steps;
	dz = pitch * starts / steps * direction;

	profile = [
		[r_outer, 0, 0],
		[r_inner, 0, pitch / 2],
		[r_inner, 0, -pitch / 2],
	];

	points = concat(profile, translate_points(rotate_points(profile, [0, 0, a]), [0, 0, dz]));

//	1---4
//	| \ : \
//	|  0---3
//	| / : /
//	2---5

	faces = [
		[0, 1, 4], [0, 4, 3], // top
		[0, 3, 2], [2, 3, 5], // bottom
		[4, 1, 2], [4, 2, 5], // back
		[0, 2, 1], [3, 4, 5], // sides
	];

	intersection() {

		// outer
		cylinder(h = h, r = d / (internal ? 1 : 2), center = center, $fn = steps);

		union() {

			// inner
			cylinder(h = h, r = d_minor / 2 - (internal ? -tolerance : H / 4 + tolerance), center = center, $fn = steps);

			// thread
			for (start = [0 : starts - 1],
				step = [0 : steps - 1],
				z = [0 : pitch * starts : ceil(h)])
			translate([0, 0, -(center ? h / 2 : 0) - pitch / 2 * direction + z + dz * step])
			rotate([0, 0, 360 / starts * start + a * step])
			polyhedron(points, faces);
		}
	}
}

/* examples

include <constants.scad>;

// M3
thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE);

// M3 internal
*thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE, internal = true, center = false);

// Rohloff hub
*thread_iso_metric(d = 34, h = 10, pitch = 1, internal = true, starts = 6);

//*/
