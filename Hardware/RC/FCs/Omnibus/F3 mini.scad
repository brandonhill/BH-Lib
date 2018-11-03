/******************************************************************************
 * Omnibus F3 mini flight controller
 */

include <../../../../colours.scad>;

FC_OMNIBUS_F3_MINI_BOARD_DIM = [27.3, 27.3, 1.5];
FC_OMNIBUS_F3_MINI_DIM = [FC_OMNIBUS_F3_MINI_BOARD_DIM[0], FC_OMNIBUS_F3_MINI_BOARD_DIM[1], 5];
FC_OMNIBUS_F3_MINI_HOLE_RAD = 2.5 / 2;
FC_OMNIBUS_F3_MINI_HOLE_SPACING = [20, 20];

module fc_omnibus_f3_mini(
		board_dim = FC_OMNIBUS_F3_MINI_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = FC_OMNIBUS_F3_MINI_DIM,
		hole_rad = FC_OMNIBUS_F3_MINI_HOLE_RAD,
		hole_spacing = FC_OMNIBUS_F3_MINI_HOLE_SPACING,
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[1] - hole_rad * 4 * 2,
	];

	color(colour)
	translate([0, 0, board_dim[2] / 2])
	difference() {
		union() {
			translate([0, 0, -(comp_thickness + board_dim[2]) / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);

			cube(board_dim, true);

			translate([0, 0, (comp_thickness + board_dim[2]) / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);
		}

		reflect()
		translate([hole_spacing[0] / 2, hole_spacing[1] / 2])
		cylinder(h = dim[2], r = hole_rad, center = true);
	}
}

*
fc_omnibus_f3_mini();
