/******************************************************************************
 * Generic 800x600 LCD display
 */

include <../../../colours.scad>;
include <../Switches/Tact.scad>;

// 5.5 from front of case to back of screen

SCREEN_800x600_BOARD_DIM = [54, 34, 7];
SCREEN_800x600_CASE_DIM = [126, 83.3, 19];
SCREEN_800x600_SCREEN_DIM = [120.75, 76, 2.8];

SCREEN_800x600_DIM = [
	SCREEN_800x600_SCREEN_DIM[0],
	SCREEN_800x600_SCREEN_DIM[1],
	SCREEN_800x600_SCREEN_DIM[2] + 1 + SCREEN_800x600_BOARD_DIM[2]];

SCREEN_800x600_SCREEN_POS = [
	0,
	0,
	SCREEN_800x600_CASE_DIM[2] / 2 - 5.5 + SCREEN_800x600_SCREEN_DIM[2] / 2];

SCREEN_800x600_BOARD_POS = [
	-(SCREEN_800x600_SCREEN_DIM[0] / 2 - 21.5 - SCREEN_800x600_BOARD_DIM[0] / 2),
	SCREEN_800x600_SCREEN_DIM[1] / 2 - 25 - SCREEN_800x600_BOARD_DIM[1] / 2,
	SCREEN_800x600_SCREEN_POS[2] - (SCREEN_800x600_SCREEN_DIM[2] / 2 + 1 + SCREEN_800x600_BOARD_DIM[2] / 2)];

module screen_800x600(
		board_dim = SCREEN_800x600_BOARD_DIM,
		board_pos = SCREEN_800x600_BOARD_POS,
		case = false,
		case_dim = SCREEN_800x600_CASE_DIM,
		dim = SCREEN_800x600_DIM,
		screen_dim = SCREEN_800x600_SCREEN_DIM,
		screen_pos = SCREEN_800x600_SCREEN_POS,
		tolerance = 0,
	) {

	if (case)
	% color("silver", 0.5)
	cube(case_dim, true);

	translate([0, 0, case ? 0 : -(screen_pos[2] + screen_dim[2] / 2) + dim[2] / 2]) {

		// board
		color(COLOUR_PCB)
		translate(board_pos)
		cube(board_dim, true);

		// screen
		color("silver")
		translate(screen_pos)
		cube(screen_dim, true);

		// switches
		*for (y = [-1, 0, 1])
		scale([1, 1, -1])
		translate(switch_pos)
		translate([0, switch_spacing * y])
		switch_tact(9.25, tolerance = tolerance);
	}
}
