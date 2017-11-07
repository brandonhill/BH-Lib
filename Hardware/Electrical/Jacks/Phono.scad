/******************************************************************************
 * Phono jack
 */

include <../constants.scad>;

JACK_PHONO_MINI_DIM = [10.5, 5.2, 3.25]; // excluding flange
JACK_PHONO_MINI_FLANGE_DIM = [4, 1.6]; // [dia., height]

module jack_phono_mini(
		dim = JACK_PHONO_MINI_DIM,
		flange_dim = JACK_PHONO_MINI_FLANGE_DIM,
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	translate([0, 0, dim[2] / 2])
	color("dimgray") {
		translate([-dim[0] / 2, 0])
		cube(dim, true);
		rotate([0, 90])
		cylinder(h = flange_dim[1] + _projection, r = flange_dim[0] / 2 + tolerance);
	}
}
