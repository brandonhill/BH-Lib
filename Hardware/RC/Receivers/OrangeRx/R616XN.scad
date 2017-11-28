/******************************************************************************
 * OrangeRx R616XN receiver
 */

include <../../../../colours.scad>;
use <../../../../2D/rounded square.scad>;

// hopefully dim. are bigger because of heat shrink !!!
//RX_ORANGERX_R616XN_DIM = [16.5, 13, 2.5];//3.7];
RX_ORANGERX_R616XN_DIM = [14, 12, 2.5];

module rx_orangerx_r616xn() {

	ant_rad = 0.5;
	color_rx = COLOUR_ORANGE;
	color_ant = COLOUR_RED;
	color_io = [COLOUR_BROWN, COLOUR_RED, COLOUR_ORANGE];
	dim = RX_ORANGERX_R616XN_DIM;

	translate([-dim[0] / 2, 0, 0]) {

		// receiver
		color(color_rx)
		translate([0, 0, dim[2] / 2])
		rotate([90, 0, 90])
		linear_extrude(dim[0])
		rounded_square([dim[1], dim[2]], dim[2] / 2, true);

		// antenna
		color(color_ant)
		translate([0, dim[1] / 2 - ant_rad * 2, dim[2] / 2])
		rotate([0, -90, 0])
		cylinder(h = 30, r = ant_rad);

		// wires
		for (i = [0 : 2]) {
			color(color_io[i])
			translate([dim[0], -dim[1] / 2 + ant_rad * 2 * (i + 1), dim[2] / 2])
			rotate([0, 90, 0])
			cylinder(h = 2, r = ant_rad);
		}
	}
}

*
rx_orangerx_r616xn();
