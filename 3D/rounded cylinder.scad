/******************************************************************************
 * Rounded cylinder (different than `capsule` because end radius can be adjusted)
 *
 * r = radius
 * f = fillet radius
 */

include <../helpers.scad>;
use <../2D/segment.scad>;

module rounded_cylinder(h, r, f, f1, f2, r1, r2, center = true) {

	_r1 = r1 ? r1 : r;
	_r2 = r2 ? r2 : r;
	_f1 = min(_r1, max(0, f1 != undef ? f1 : f));
	_f2 = min(_r2, max(0, f2 != undef ? f2 : f));

	translate([0, 0, center ? -h / 2 : 0])
	hull() {
		translate([0, 0, h - _f2]) {
			if (_f2 <= 0) {
				transform([0, 0, 0.001])
				linear_extrude(0.001)
				circle(_r2);
			} else {
				rotate_extrude()
				translate([_r2 - _f2, 0, 0])
				segment(a = 90, r = _f2);
			}
		}
		translate([0, 0, _f1]) {
			if (_f1 <= 0) {
				linear_extrude(0.001)
				circle(_r1);
			} else {
				rotate_extrude()
				translate([_r1 - _f1, 0, 0])
				rotate([0, 0, -90])
				segment(a = 90, r = _f1);
			}
		}
	}
}
