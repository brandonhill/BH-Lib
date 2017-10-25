/******************************************************************************
 * Duct flange
 */

use <../../3D/torus.scad>;

module duct_flange(r, w, screws, screw_hole_r, screw_head_r, thickness, countersink = 0) {

	difference() {

		show_half([90, 0, 0])
		hull()
		torus(thickness, r + w);

		translate([0, 0, -0.1]) {
			cylinder(h = thickness + 0.2, r = r);

			for (i = [0 : screws - 1])
			rotate([0, 0, (360 / screws) * i])
			translate([r + w * 2/3, 0]) {
				cylinder(h = thickness + 0.2, r = screw_hole_r);

				translate([0, 0, thickness - countersink])
				cylinder(h = thickness, r = screw_head_r);
			}
		}
	}
}

*
duct_flange(
	r = 100,
	w = 15,
	screws = 2,
	screw_hole_r = 2.5,
	screw_head_r = 5,
	thickness = 3,
	countersink = 1
);
