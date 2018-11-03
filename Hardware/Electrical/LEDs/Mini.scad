/******************************************************************************
 * Mini LED
 */

include <../../../colours.scad>;

LED_MINI_DIM = [3, 6]; // [dia., height]

module led_mini(
		col = "white",
		dim = LED_MINI_DIM,
		tolerance = 0,
	) {

	r = dim[0] / 2 + tolerance;

	color(col, 0.75)
	hull() {
		cylinder(h = dim[1] - dim[0] / 2, r = r);

		translate([0, 0, dim[1] - dim[0] / 2])
		difference() {
			sphere(r);
			translate([0, 0, -dim[0] / 2])
			cube(dim[0], true);
		}
	}
}
