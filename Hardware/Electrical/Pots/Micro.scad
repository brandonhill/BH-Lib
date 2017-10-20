/******************************************************************************
 * Micro potentiometer
 */

include <../../../colours.scad>;

module pot_micro() {

	rad = 1.5;

	base_col = COLOUR_WHITE;
	base_dim = [rad * 2, rad * 2, 1];
	base_pos = [0, 0, base_dim[2] / 2];

	housing_col = COLOUR_BLACK;
	housing_height = 1;
	housing_rad = rad - 0.25;
	housing_pos = [0, 0, base_dim[2]];

	screw_col = COLOUR_STEEL;
	screw_height = 0.25;
	screw_hole = [rad * 2 - 2/3, 2/3];
	screw_rad = rad;
	screw_pos = [0, 0, base_dim[2] + housing_height];

	// base
	color(base_col)
	translate(base_pos)
	cube(base_dim, true);

	// housing
	color(housing_col)
	translate(housing_pos)
	difference() {
		cylinder(h = housing_height, r = housing_rad);
		translate([0, 0, -0.1])
		cylinder(h = housing_height + 0.2, r = housing_rad - 0.1);
	}

	// screw
	color(screw_col)
	difference() {
		union() {
			translate(screw_pos) {
				cylinder(h = screw_height, r = screw_rad);
			}
			translate([0, 0, base_dim[2]])
			cylinder(h = housing_height, r = housing_rad - 0.05);
		}
		translate([0, 0, base_dim[2] + housing_height + screw_height / 2 + 0.05]) {
			cube([screw_hole[0], screw_hole[1], screw_height + 0.1], true);
			cube([screw_hole[1], screw_hole[0], screw_height + 0.1], true);
		}
	}
}


//$fs = 0.1;
*
pot_micro();
