/******************************************************************************
 * EWRF e7082C-Pro smart switchable video transmitter
 */

include <../../../../colours.scad>;

VTX_EWRF_E7082CPRO_BOARD_DIM = [14, 21.9, 1];
VTX_EWRF_E7082CPRO_DIM = [VTX_EWRF_E7082CPRO_BOARD_DIM[0], VTX_EWRF_E7082CPRO_BOARD_DIM[1], 5.5];

module vtx_ewrf_e7082cpro(
		board_dim = VTX_EWRF_E7082CPRO_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = VTX_EWRF_E7082CPRO_DIM,
		center = "board", // "board" || true || false
	) {

	comp_thickness = 1;
	interior_dim = [
		dim[0] * 0.8,
		dim[1] * 0.8,
	];

	translate([0, 0, -(center == "board" ? comp_thickness : (center ? dim[2] / 2 : 0))]) {
		// bottom components
		color(colour)
		translate([0, 0, comp_thickness / 2])
		cube([interior_dim[0], interior_dim[1], comp_thickness], true);

		// ant. conn.
		color(COLOUR_GOLD)
		translate([0, board_dim[1] / 2 - 1.5])
		cube([3, 3, 2], true);

		translate([0, 0, comp_thickness]) {

			// board
			color(colour)
			linear_extrude(board_dim[2])
			square([board_dim[0], board_dim[1]], true);

			translate([0, 0, board_dim[2]]) {

				// top components
				color(colour)
				translate([0, 0, comp_thickness / 2])
				cube([interior_dim[0], interior_dim[1], comp_thickness], true);

				// button
				color("white")
				translate([board_dim[0] / 4, (board_dim[1] - 2.25) / 2, 1])
				cube([4.5, 2.25, 2], true);

				// plug
				color("white")
				translate([-board_dim[0] / 4, -(board_dim[1] - 4.3) / 2, 3.25 / 2])
				cube([6, 4.3, 3.25], true);
			}
		}
	}
}

*vtx_ewrf_e7082cpro();
