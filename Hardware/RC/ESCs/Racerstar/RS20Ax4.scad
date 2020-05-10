/******************************************************************************
 * Racerstar RS20Ax4 ESC
 */

include <../../../../colours.scad>;
include <../../../../helpers.scad>;

ESC_RACERSTAR_RS20AX4_BOARD_DIM = [36, 36, 1.6];
ESC_RACERSTAR_RS20AX4_DIM = [ESC_RACERSTAR_RS20AX4_BOARD_DIM[0], ESC_RACERSTAR_RS20AX4_BOARD_DIM[1], 5.4];
ESC_RACERSTAR_RS20AX4_HOLE_RAD = 3 / 2;
ESC_RACERSTAR_RS20AX4_HOLE_SPACING = [30.5, 30.5];

module esc_racerstar_rs20ax4(
		board_dim = ESC_RACERSTAR_RS20AX4_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = ESC_RACERSTAR_RS20AX4_DIM,
		hole_rad = ESC_RACERSTAR_RS20AX4_HOLE_RAD,
		hole_spacing = ESC_RACERSTAR_RS20AX4_HOLE_SPACING,
		tolerance = 0,
		center = "board", // "board" || true || false
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
				translate([0, 0, board_dim[2] / 2])
				cube([dim[0], dim[1], board_dim[2]], true);

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

*esc_racerstar_rs20ax4();
