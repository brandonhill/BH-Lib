// ****************************************************************************
// Sphere with edges (instead of vertices) at radius

use <../2D/circle true.scad>;

module sphere_true(r, $fa = $fa, $fn = $fn, $fs = $fs) {
	rotate_extrude()
	difference() {
		circle_true(r);
		translate([-r * 2, 0])
		square(r * 4, true);
	}
}
