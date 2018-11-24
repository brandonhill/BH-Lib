/******************************************************************************
 * Voltage step down regulator
 */

include <../../../colours.scad>;
include <../Chip.scad>;
include <../Pots/Micro.scad>;

VREG_3A_VAR_STEP_DOWN_DIM = [17.7, 11.7, 4.4];

module vreg_3A_var_step_down(dim = VREG_3A_VAR_STEP_DOWN_DIM) {

	hole_pitch = PIN_HEADER_PITCH;
	hole_rad = 2/3;

	pcb_dim = [dim[0], dim[1], 1.5];
	pcb_pos = [0, 0, pcb_dim[2] / 2];

	chip_dim = [dim[0] * 0.25, dim[1] * 0.3, 1.25];
	chip_pins = [4, 0, 4, 0];
	chip_pos = [-((dim[0] - chip_dim[0]) / 2 - 2.5), -dim[0] * 0.05, pcb_dim[2]];

	block_dim = [7, 7, dim[2] - pcb_dim[2]];
	block_pos = [
		(dim[0] - block_dim[0]) / 2 - hole_pitch,
		-((dim[1] - block_dim[1]) / 2 - 0.5),
		pcb_dim[2]
	];

	pot_pos = [
		block_pos[0],
		dim[1] / 2 - 1.5,
		pcb_dim[2]
	];

	// pcb
	color(COLOUR_PCB)
	difference() {
		translate(pcb_pos)
		cube(pcb_dim, true);

		// holes
		for (x = [0 : 1], y = [0 : 1])
		translate([
			(dim[0] - hole_pitch) / 2 * (x == 0 ? -1 : 1),
			(dim[1] - hole_pitch) / 2 * (y == 0 ? -1 : 1),
			-1
		])
		cylinder(h = pcb_dim[2] + 2, r = hole_rad);
	}

	// block
	color(COLOUR_GREY)
	translate(block_pos)
	linear_extrude(block_dim[2])
	rounded_square([block_dim[0], block_dim[1]], 1, true);

	// pot
	translate(pot_pos)
	pot_micro();

	// chip
	translate(chip_pos)
	chip(chip_dim, chip_pins, chip_dim[0] / 5);
}

*
vreg_3A_var_step_down();
