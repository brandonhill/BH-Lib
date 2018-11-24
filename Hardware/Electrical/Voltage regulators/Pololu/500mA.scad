/******************************************************************************
 * Pololu 500 mA step down voltage regulator
 */

include <../../../../colours.scad>;
include <../../Chip.scad>;

VREG_POLOLU_500MA_STEP_DOWN = [12.7, 10.2, 2.54];

module vreg_pololu_500ma_step_down(dim = VREG_POLOLU_500MA_STEP_DOWN) {

	hole_pitch = PIN_HEADER_PITCH;
	hole_rad = 2/3;

	pcb_dim = [dim[0], dim[1], 1];
	pcb_pos = [0, 0, pcb_dim[2] / 2];

	chip_dim = [dim[0] * 0.25, dim[1] * 0.4, 1.25];
	chip_pins = [0, 6, 0, 6];
	chip_pos = [-((dim[0] - chip_dim[0]) / 2 - 2.5), -dim[0] * 0.05, pcb_dim[2]];

	block_dim = [dim[1] * 0.4, dim[1] * 0.4, dim[2] - pcb_dim[2]];
	block_pos = [
		(dim[0] - block_dim[0]) / 2 - hole_pitch,
		((dim[1] - block_dim[1]) / 2),
		pcb_dim[2]
	];

	pot_pos = [
		(dim[0] - block_dim[0]) / 2 - hole_pitch / 2,
		dim[1] / 2 - 1.5,
		pcb_dim[2]
	];

	// pcb
	color(COLOUR_PCB)
	difference() {
		translate(pcb_pos)
		cube(pcb_dim, true);

		// holes
		translate([dim[0] / 2 - hole_pitch / 2, -(hole_pitch * 1.5), 0])
		for (y = [0 : 3])
		translate([
			0,
			hole_pitch * y,
			-1
		])
		cylinder(h = pcb_dim[2] + 2, r = hole_rad);
	}

	// block
	color(COLOUR_GREY)
	translate(block_pos)
	linear_extrude(block_dim[2])
	rounded_square([block_dim[0], block_dim[1]], 1, true);

	// chip
	translate(chip_pos)
	chip(chip_dim, chip_pins, chip_dim[0] / 5);
}

*
vreg_pololu_500ma_step_down();
