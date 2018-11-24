/******************************************************************************
 * Omnibus F3 mini flight controller
 */

include <../../../../colours.scad>;

FC_OMNIBUS_F4_MINI_BOARD_DIM = [27.3, 27.3, 1];
FC_OMNIBUS_F4_MINI_DIM = [FC_OMNIBUS_F4_MINI_BOARD_DIM[0], FC_OMNIBUS_F4_MINI_BOARD_DIM[1], 5.6];
FC_OMNIBUS_F4_MINI_HOLE_RAD = 2.5 / 2;
FC_OMNIBUS_F4_MINI_HOLE_SPACING = [20, 20];

module fc_omnibus_f4_mini(
		board_dim = FC_OMNIBUS_F4_MINI_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = FC_OMNIBUS_F4_MINI_DIM,
		hole_rad = FC_OMNIBUS_F4_MINI_HOLE_RAD,
		hole_spacing = FC_OMNIBUS_F4_MINI_HOLE_SPACING,
		center = true, // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[1] - hole_rad * 4 * 2,
	];

	color(colour)
	translate([0, 0, -(center == "board" ? comp_thickness : (center ? dim[2] / 2 : 0))])
	difference() {
		union() {
			// bottom components
			translate([0, 0, comp_thickness / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);

			translate([0, 0, comp_thickness]) {

				// board
				linear_extrude(board_dim[2])
				rounded_square([board_dim[0], board_dim[1]], 3);

				translate([0, 0, board_dim[2]]) {

					// top components
					translate([0, 0, comp_thickness / 2])
					cube([interior_dim[0], interior_dim[1], comp_thickness], true);
				}
			}
		}

		reflect()
		translate([hole_spacing[0] / 2, hole_spacing[1] / 2])
		cylinder(h = dim[2], r = hole_rad, center = true);
	}
}

*fc_omnibus_f4_mini(center = "board");
