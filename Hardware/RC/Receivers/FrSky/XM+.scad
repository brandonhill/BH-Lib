/******************************************************************************
 * FrSky XM+ micro full range receiver
 */

include <../../../../colours.scad>;
include <../../../Electrical/constants.scad>;

RX_FRSKY_XM_PLUS_BOARD_DIM = [22, 11.75, 0.85];
RX_FRSKY_XM_PLUS_DIM = [RX_FRSKY_XM_PLUS_BOARD_DIM[0], RX_FRSKY_XM_PLUS_BOARD_DIM[1], 3.5];

module rx_frsky_xm_plus(
		ant_rad = 0.5,
		board_dim = RX_FRSKY_XM_PLUS_BOARD_DIM,
		dim = RX_FRSKY_XM_PLUS_DIM,
		color_ant = COLOUR_GREY_DARK,
		color_io = [COLOUR_GREY_DARK, COLOUR_RED, COLOUR_WHITE],
		center = true, // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;

	translate([0, 0, -(center == "board" ? comp_thickness : (center ? dim[2] / 2 : 0))]) {

		// back components
		color(COLOUR_GREY_DARK)
		translate([0, 0, comp_thickness / 2])
		cube([dim[0] * 0.75, dim[1] * 0.75, comp_thickness], true);

		translate([0, 0, comp_thickness]) {

			// board
			color(COLOUR_PCB)
			translate([0, 0, board_dim[2] / 2])
			cube(board_dim, true);

			translate([0, 0, board_dim[2]]) {

				// antenna
				color(color_ant)
				for (i = [0 : 1])
				translate([dim[0] / 2, -dim[1] / 2 + PIN_HEADER_PITCH * (i + 1), dim[2] * 0.25])
				rotate([0, 90, 0])
				cylinder(h = 2, r = ant_rad);

				// front components
				color(COLOUR_GREY_DARK)
				translate([0, 0, comp_thickness / 2])
				cube([dim[0] * 0.75, dim[1] * 0.75, comp_thickness], true);

				// wires
				for (i = [0 : len(color_io) - 1])
				color(color_io[i])
				translate([-dim[0] / 2, -dim[1] / 2 + PIN_HEADER_PITCH * (i + 1)])
				rotate([0, -90, 0])
				cylinder(h = 2, r = ant_rad);
			}
		}
	}
}

*rx_frsky_xm_plus();
