/******************************************************************************
 * HakRC 20mm 15Ax4 ESC
 */

include <../../../../colours.scad>;
include <../../../../helpers.scad>;

ESC_HAKRC_20_15AX4_BOARD_DIM = [27.2, 27.2, 1];
ESC_HAKRC_20_15AX4_DIM = [31, ESC_HAKRC_20_15AX4_BOARD_DIM[1], 5.6];
ESC_HAKRC_20_15AX4_HOLE_RAD = 2.1 / 2;
ESC_HAKRC_20_15AX4_HOLE_SPACING = [20, 20];

module esc_hakrc_20_15ax4(
		board_dim = ESC_HAKRC_20_15AX4_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = ESC_HAKRC_20_15AX4_DIM,
		hole_rad = ESC_HAKRC_20_15AX4_HOLE_RAD,
		hole_spacing = ESC_HAKRC_20_15AX4_HOLE_SPACING,
		tolerance = 0,
		center = "board", // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		board_dim[0] - hole_rad * 4 * 2,
		board_dim[1] - hole_rad * 4 * 2,
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
				rounded_square([board_dim[0], dim[1]], 3);
				translate([0, 0, board_dim[2] / 2])
				cube([dim[0], hole_spacing[0], board_dim[2]], true);

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

*esc_hakrc_20_15ax4(center = "board");
