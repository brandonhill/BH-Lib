/******************************************************************************
 * Generic ESC
 */

module esc_generic(dim = [30, 20, 6]) {
	translate([-(dim[0] / 2), 0, dim[2] / 2])
	rotate([0, 90, 0])
	hull()
	for (y = [-1, 1])
		scale([1, y])
		translate([0, dim[1] / 2])
		cylinder(h = dim[0], r = dim[2] / 2);
}
