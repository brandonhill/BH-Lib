/******************************************************************************
 * Happymodel Teeny 1S F4 flight controller
 */

include <../../../../colours.scad>;
include <../../../../helpers.scad>;
include <../../../Electrical/Jacks/USB.scad>;

FC_TEENY_F4_BOARD_DIM = [20.1, 20.1, 1];
FC_TEENY_F4_BOARD_POS = [0, 0, -0.7];
FC_TEENY_F4_DIM = [FC_TEENY_F4_BOARD_DIM[0], FC_TEENY_F4_BOARD_DIM[1], 6];
FC_TEENY_F4_HOLE_RAD = 2.25 / 2;
FC_TEENY_F4_HOLE_SPACING = [16, 16];
FC_TEENY_F4_USB_POS = [
	0,
	FC_TEENY_F4_BOARD_DIM[1] / 2 + 1.7,
	FC_TEENY_F4_BOARD_POS[2] + FC_TEENY_F4_BOARD_DIM[2] / 2];

module fc_teeny_f4(
		board_dim = FC_TEENY_F4_BOARD_DIM,
		board_pos = FC_TEENY_F4_BOARD_POS,
		dim = FC_TEENY_F4_DIM,
		hole_rad = FC_TEENY_F4_HOLE_RAD,
		hole_spacing = FC_TEENY_F4_HOLE_SPACING,
		tolerance = 0,
		usb_pos = FC_TEENY_F4_USB_POS,
		center = "board", // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[1] - hole_rad * 4 * 2,
	];

	translate([0, 0, center == "board" ? -board_pos[2] + board_dim[2] / 2 : (center ? 0 : dim[2] / 2)]) {
		color(COLOUR_GREY_DARK)
		difference() {
			union() {
				color("dimgray") {
					translate(board_pos)
					cube([
						board_dim[0],
						board_dim[1],
						board_dim[2]], true);

					cube([
						interior_dim[0],
						interior_dim[1],
						dim[2]], true);
				}
			}

			transpose(hole_spacing / 2)
			cylinder(h = dim[2], r = hole_rad, center = true);
		}

		translate(usb_pos)
		rotate([0, 0, 90])
		jack_usb_micro(tolerance = tolerance)
		children(); // for plug diff

		// dim check
		*cube(dim, true);
	}
}
