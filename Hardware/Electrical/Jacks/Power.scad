/******************************************************************************
 * Coaxial power jack
 */

include <../constants.scad>;

JACK_COAX_MINI_DIM = [9, 6.2, 5]; // excluding flange
JACK_COAX_MINI_FLANGE_DIM = [5, 2]; // [dia., height]

module jack_coax_mini(
		dim = JACK_COAX_MINI_DIM,
		flange_dim = JACK_COAX_MINI_FLANGE_DIM,
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	translate([0, 0, dim[2] / 2])
	color("dimgray") {
		translate([-dim[0] / 2, 0])
		cube(dim, true);
		rotate([0, 90])
		translate([0, -(dim[1] - flange_dim[0]) / 2])
		cylinder(h = flange_dim[1] + _projection, r = flange_dim[0] / 2 + tolerance);
	}
}
