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

	d_minor = d - (5 * sqrt(3)) / 8 * pitch;
	H = pitch / (2 * tan(30));
	r_inner = d_minor / 2 - H / 4;
	r_outer = d / 2 + H / 8;

	polygon([
		[0, 0],
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
		reverse = false,
		starts = 1,
	) {

	d_minor = d - (5 * sqrt(3)) / 8 * pitch;
	H = pitch / (2 * tan(30));

	// inner
	cylinder(h = h, r = d_minor / 2 - (internal ? 0 : H / 4), center = center);

	intersection() {

		// outer
		cylinder(h = h, r = d / (internal ? 1 : 2), center = center);

		// thread
		for (i = [0 : pitch * starts : ceil(h)], j = [0 : starts - 1])
		translate([0, 0, -(center ? h / 2 : 0) + i])
		rotate([0, 0, 360 / starts * j])
		linear_rotate_extrude(pitch * starts * (reverse ? 1 : -1), $fn = get_fragments_from_r(d /2), convexity = 2)
		shape_thread_iso_metric(d, h, pitch);
	}

	// dim checks
	*#union() {
		cylinder(h = pitch / 8, r = d / 2, center = true);

		translate([0, 0, pitch / 2])
		cylinder(h = pitch / 4, r = d_minor / 2, center = true);
	}
}

/* examples

$fs = 0.5;
include <constants.scad>;

show_half() {
	thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE);

	translate([4, 0])
	thread_iso_metric(3, 4, THREAD_PITCH_M3_COARSE, internal = true);
}
//*/
