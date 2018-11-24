/******************************************************************************
 * Happymodel Teeny 6A 4 in 1 ESC
 */

include <../../../../colours.scad>;
include <../../../../helpers.scad>;

ESC_TEENY_6A_4IN1_BOARD_DIM = [23.1, 27.6, 1.1];
ESC_TEENY_6A_4IN1_BOARD_POS = [0, 0, -0.9];
ESC_TEENY_6A_4IN1_DIM = [ESC_TEENY_6A_4IN1_BOARD_DIM[0], ESC_TEENY_6A_4IN1_BOARD_DIM[1], 5.4];
ESC_TEENY_6A_4IN1_HOLE_RAD = 2.25 / 2;
ESC_TEENY_6A_4IN1_HOLE_SPACING = [16, 16];

module esc_teeny_6a_4in1(
		board_dim = ESC_TEENY_6A_4IN1_BOARD_DIM,
		board_pos = ESC_TEENY_6A_4IN1_BOARD_POS,
		dim = ESC_TEENY_6A_4IN1_DIM,
		hole_rad = ESC_TEENY_6A_4IN1_HOLE_RAD,
		hole_spacing = ESC_TEENY_6A_4IN1_HOLE_SPACING,
		tolerance = 0,
		center = "board", // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[0] - hole_rad * 4 * 2,
	];

	color(COLOUR_GREY_DARK)
	translate([0, 0, center == "board" ? -board_pos[2] + board_dim[2] / 2 : (center ? 0 : dim[2] / 2)]) {
		difference() {
			union() {
				translate(board_pos) {
					cube([board_dim[0], board_dim[0], board_dim[2]], true);
					cube([hole_spacing[1], board_dim[1], board_dim[2]], true);
				}

				cube([interior_dim[0], interior_dim[1], dim[2]], true);
			}

			transpose(hole_spacing / 2)
			cylinder(h = dim[2], r = hole_rad, center = true);
		}

		// dim check
		*cube(dim, true);
	}
}

*esc_teeny_6a_4in1();
