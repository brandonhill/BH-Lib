/******************************************************************************
 * RD945 5.8GHz 48 channel diversity video receiver
 */

include <../../../colours.scad>;
include <../../Electrical/all.scad>;

VRX_RD945_DIM = [59, 75, 8];

VRX_RD945_ANT_SPACING = 46;
VRX_RD945_BOARD_DIM = [59, 73.3, 1.1];
VRX_RD945_BOARD_POS = [
	0,
	-(VRX_RD945_DIM[1] - VRX_RD945_BOARD_DIM[1]) / 2,
	-(VRX_RD945_BOARD_DIM[2] / 2 + SMA_PIN_RAD)];
VRX_RD945_DISPLAY_POS = [
	-VRX_RD945_BOARD_DIM[0] / 2 + 9.5 + LED_7_SEGMENT_DIM[0],
	VRX_RD945_BOARD_DIM[1] / 2 - 36.5 - LED_7_SEGMENT_DIM[1] / 2];
VRX_RD945_HOLE_POS = [
	VRX_RD945_BOARD_DIM[0] / 2 - 7.5,
	-VRX_RD945_BOARD_DIM[1] / 2 + 14.5];
VRX_RD945_HOLE_RAD = 3.5 / 2;
VRX_RD945_LED_SPACING = 25.4; // oy
VRX_RD945_AV_OUT_POS = [
	-VRX_RD945_BOARD_DIM[0] / 2 + 4.5 + JACK_PHONO_MINI_DIM[1] / 2,
	-VRX_RD945_BOARD_DIM[1] / 2];
VRX_RD945_AV_OUT_SPACING = 22.5;
VRX_RD945_POWER_JACK_POS = [
	VRX_RD945_BOARD_DIM[0] / 2 - 6.2 - JACK_COAX_MINI_DIM[1] / 2,
	-VRX_RD945_BOARD_DIM[1] / 2];
VRX_RD945_SWITCH_POS = [ // of uppermost switch
	VRX_RD945_BOARD_DIM[0] / 2 - 11.3 - SWITCH_TACT_DIM[0] / 2,
	VRX_RD945_BOARD_DIM[1] / 2 - 30.8 - SWITCH_TACT_DIM[1] / 2];
VRX_RD945_SWITCH_SPACING = 15.25;

module pos_vrx_rd945_screws(
		board_pos = VRX_RD945_BOARD_POS,
		hole_pos = VRX_RD945_HOLE_POS,
	) {
	translate(board_pos)
	transpose(hole_pos, y = false)
	children();
}

module vrx_rd945(,
		ant_spacing = VRX_RD945_ANT_SPACING,
		dim = VRX_RD945_DIM,
		board_dim = VRX_RD945_BOARD_DIM,
		board_pos = VRX_RD945_BOARD_POS,
		display_pos = VRX_RD945_DISPLAY_POS,
		hole_pos = VRX_RD945_HOLE_POS,
		hole_rad = VRX_RD945_HOLE_RAD,
		led_spacing = VRX_RD945_LED_SPACING,
		omit = [],
		phono_jack_pos = VRX_RD945_AV_OUT_POS,
		phono_jack_spacing = VRX_RD945_AV_OUT_SPACING,
		power_jack_pos = VRX_RD945_POWER_JACK_POS,
		switch_pos = VRX_RD945_SWITCH_POS,
		switch_spacing = VRX_RD945_SWITCH_SPACING,
		tolerance = 0,
	) {

	*%
	cube(dim, true);

	reflect(y = false)
	translate([0, board_pos[1] + board_dim[1] / 2]) {

		// antennas
		translate([ant_spacing / 2, SMA_NUT_DIM[2]])
		rotate([-90, 0])
		conn_rp_sma(pin = false, tolerance = tolerance);

		// LEDs
		reflect(y = false)
		translate([led_spacing / 2, 0])
		rotate([-90, 0])
		led_mini(col = "powderblue", tolerance = tolerance);
	}

	translate(board_pos) {
		// board
		color(COLOUR_PCB)
		difference() {
			cube(board_dim, true);

			// holes
			reflect(y = false)
			translate(hole_pos)
			cylinder(h = board_dim[2] * 3, r = hole_rad, center = true);
		}

		translate([0, 0, board_dim[2] / 2]) {

			// AV outs
			for (x = [0, phono_jack_spacing])
			translate([x, 0])
			translate(phono_jack_pos)
			rotate([0, 0, -90])
			jack_phono_mini(tolerance = tolerance);

			// display
			translate(display_pos)
			led_7_segment(n = 2, tolerance = tolerance);

			// power jack
			if (!contains("power_jack", omit))
			translate(power_jack_pos)
			rotate([0, 0, -90])
			jack_coax_mini(tolerance = tolerance);

			// switches
			for (y = [0, switch_spacing])
			translate([0, -y])
			translate(switch_pos)
			switch_tact(9.25, tolerance = tolerance);
		}
	}
}
