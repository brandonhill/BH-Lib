/******************************************************************************
 * FrSky XM+ micro full range receiver
 */

include <../../../../colours.scad>;
include <../../../Electrical/constants.scad>;

// with heat-shrink
RX_FRSKY_XM_PLUS_DIM = [22, 13, 4.5];

module rx_frsky_xm_plus(
		ant_rad = 0.5,
		dim = RX_FRSKY_XM_PLUS_DIM,
		color_ant = COLOUR_GREY_DARK,
		color_io = [COLOUR_GREY_DARK, COLOUR_RED, COLOUR_WHITE],
		color_rx = COLOUR_GREY_DARK,
	) {

	// receiver
	color(color_rx)
	cube(dim, true);

	// antennas
	color(color_ant)
	for (i = [0 : 1])
	translate([dim[0] / 2, -dim[1] / 2 + PIN_HEADER_PITCH * (i + 1), dim[2] * 0.25])
	rotate([0, 90, 0])
	cylinder(h = 2, r = ant_rad);

	// wires
	for (i = [0 : len(color_io) - 1])
	color(color_io[i])
	translate([-dim[0] / 2, -dim[1] / 2 + PIN_HEADER_PITCH * (i + 1), dim[2] * 0.25])
	rotate([0, -90, 0])
	cylinder(h = 2, r = ant_rad);
}

*
rx_frsky_xm_plus();
