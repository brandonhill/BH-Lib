/******************************************************************************
 * Threads
 * See: https://en.wikipedia.org/wiki/ISO_metric_screw_thread
 */

include <../../helpers.scad>;

// does not include inner/outer cutoffs
module shape_thread_iso_metric(
		d,
		h,
		pitch,
	) {

	H = 0.866 * pitch;
	d_minor = d - 1.082532 * pitch;
	r_inner = d_minor / 2 - H / 4;
	r_outer = d / 2 + H / 8;

	polygon([
		[r_inner, pitch / 2],
		[r_outer, 0],
		[r_inner, -pitch / 2],
	]);
}

module thread_iso_metric(
		d,
		h,
		pitch,
		center = true,
		internal = false,
		starts = 1,
	) {

	d_minor = d - 1.082532 * pitch;

	// minor
	if (internal)
	cylinder(h = h, r = d_minor / 2, center = center);

	intersection() {

		// major
		cylinder(h = h, r = d / (internal ? 1 : 2), center = center);

		// thread
		for (i = [0 : pitch * starts : ceil(h)], j = [0 : starts - 1])
		translate([0, 0, -h / 2 + i])
		rotate([0, 0, 360 / starts * j])
		linear_rotate_extrude(pitch * starts, $fn = get_fragments_from_r(d /2))
		shape_thread_iso_metric(d, h, pitch);
	}
}

/* examples

$fs = 0.5;
include <constants.scad>;

thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE);

translate([4, 0])
thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE, internal = true);

//*/
