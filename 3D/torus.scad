/******************************************************************************
 * Torus
 *
 * r1 = larger radius
 * r2 = smaller radius
 */

use <../helpers.scad>;
use <../2D/circle true.scad>;

module torus(r1, r2, fa = $fa, fn = $fn, fs = $fs) {
	rotate_extrude()
	translate([r1, 0])
	circle(r2, $fa = fa, $fn = fn, $fs = fs);
}

module torus_true(r1, r2, $fa = $fa, $fn = $fn, $fs = $fs) {
	rotate_extrude()
	translate([r1, 0])
	circle_true(r2, $fa = $fa, $fn = $fn, $fs = $fs);
}
