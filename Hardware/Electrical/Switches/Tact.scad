/******************************************************************************
 * Tact switch
 */

include <../../../colours.scad>;

SWITCH_TACT_DIM = [6, 6, 4];
SWITCH_TACT_BUTTON_RAD = [3.5, 3] / 2;

module switch_tact(
		h = 9.25,
		dim = SWITCH_TACT_DIM,
		btn_rad = SWITCH_TACT_BUTTON_RAD,
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	color(COLOUR_STEEL)
	translate([0, 0, dim[2] / 2])
	cube(dim, true);

	color("dimgray")
	translate([0, 0, dim[2]])
	cylinder(h = h - dim[2] + _projection, r1 = btn_rad[0] + tolerance, r2 = btn_rad[1] + tolerance);
}

SWITCH_TACT_MICRO_DIM = [4, 3, 2];
SWITCH_TACT_MICRO_HOUSING_DIM = [4, 3, 1.6];
SWITCH_TACT_MICRO_BUTTON_RAD = [1.7, 1.7] / 2; // [base, extent]

module switch_tact_micro(
		dim = SWITCH_TACT_MICRO_DIM,
		housing_dim = SWITCH_TACT_MICRO_HOUSING_DIM,
		btn_rad = SWITCH_TACT_MICRO_BUTTON_RAD,
		tolerance = 0,
	) {

	switch_tact(dim[2], housing_dim, btn_rad, tolerance);
}
