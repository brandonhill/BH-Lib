/******************************************************************************
 * Eachine Pro DVR (without case)
 */

include <../../../../colours.scad>;
include <../../../Electrical/all.scad>;

DVR_EACHINE_PRO_CASE_DIM = [41, 33, 9.5];
DVR_EACHINE_PRO_BOARD_DIM = [38.25, 25.5, 1.25];
DVR_EACHINE_PRO_DIM = [DVR_EACHINE_PRO_BOARD_DIM[0], DVR_EACHINE_PRO_BOARD_DIM[1], 6.5];
DVR_EACHINE_PRO_BOARD_POS = [0, 0, -DVR_EACHINE_PRO_BOARD_DIM[2] / 2];
DVR_EACHINE_PRO_SCREW_DIM = SCREW_M2_SOCKET_DIM;
DVR_EACHINE_PRO_SCREW_INSET = [[15.25, 7.25], 2.25]; // [[x top, x bot], y]
DVR_EACHINE_PRO_SD_POS = DVR_EACHINE_PRO_BOARD_POS + [
	-DVR_EACHINE_PRO_BOARD_DIM[0] / 2 + 0.6 + JACK_SD_MICRO_DIM[0] / 2,
	DVR_EACHINE_PRO_BOARD_DIM[1] / 2 - 2 - JACK_SD_MICRO_DIM[1] / 2,
	DVR_EACHINE_PRO_BOARD_DIM[2] / 2];
DVR_EACHINE_PRO_SWITCH_POS = DVR_EACHINE_PRO_BOARD_POS + [
	-DVR_EACHINE_PRO_BOARD_DIM[0] / 2 + 3.15 + SWITCH_TACT_MICRO_DIM[0] / 2,
	-DVR_EACHINE_PRO_BOARD_DIM[1] / 2 + 1.15 + SWITCH_TACT_MICRO_DIM[1] / 2,
	DVR_EACHINE_PRO_BOARD_DIM[2] / 2];
DVR_EACHINE_PRO_SWITCH_SPACING = 7.5;

module pos_dvr_eachine_pro_screws(
		board_dim = DVR_EACHINE_PRO_BOARD_DIM,
		board_pos = DVR_EACHINE_PRO_BOARD_POS,
		screw_inset = DVR_EACHINE_PRO_SCREW_INSET,
	) {

	translate(board_pos)
	for (y = [-1, 1])
	translate([board_dim[0] / 2 - screw_inset[0][(y > 0 ? 0 : 1)], (board_dim[1] / 2 - screw_inset[1]) * y])
	children();
}

module pos_dvr_eachine_pro_switches(
		switch_pos = DVR_EACHINE_PRO_SWITCH_POS,
		switch_spacing = DVR_EACHINE_PRO_SWITCH_SPACING,
	) {

	for (x = [0 : 2])
	translate([switch_spacing * x, 0])
	translate(switch_pos)
	children();
}

module dvr_eachine_pro(
		board_dim = DVR_EACHINE_PRO_BOARD_DIM,
		board_pos = DVR_EACHINE_PRO_BOARD_POS,
		case = true,
		case_dim = DVR_EACHINE_PRO_CASE_DIM,
		dim = DVR_EACHINE_PRO_DIM,
		screw_dim = DVR_EACHINE_PRO_SCREW_DIM,
		sd_pos = DVR_EACHINE_PRO_SD_POS,
		switch_pos = DVR_EACHINE_PRO_SWITCH_POS,
		switch_spacing = DVR_EACHINE_PRO_SWITCH_SPACING,
		tolerance = 0,
	) {

	if (case)
	% color("orange", 0.5)
	cube(case_dim, true);

	color(COLOUR_PCB)
	translate(board_pos)
	difference() {
		cube(board_dim, true);
		pos_dvr_eachine_pro_screws()
		cylinder(h = board_dim[2] * 3, r = screw_dim[0] / 2, center = true);
	}

	// SD card
	translate(sd_pos)
	rotate([0, 0, 180])
	jack_sd_micro(tolerance = tolerance);

	// switches
	for (x = [0 : 2])
	translate([switch_spacing * x, 0])
	translate(switch_pos)
	switch_tact_micro(tolerance = tolerance);

	// dim check (no case)
	*#cube(dim, true);
}

