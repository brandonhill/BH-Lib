/******************************************************************************
 * Micro MinimOSD
 */

include <../../../colours.scad>;
include <../../Electrical/constants.scad>;
use <../../Electrical/Chip.scad>;

MINIMOSD_MICRO_DIM = [15.25, 15.25, 3];

module minimosd_micro() {

	dim = MINIMOSD_MICRO_DIM;
	pitch = PIN_HEADER_PITCH;

	pcb_col = COLOUR_GREY_DARK;
	pcb_dim = [dim[0], dim[1], 1];
	pcb_pos = [0, 0, 1];

	hole_rad = 0.6;
	holes = [6, 0, 6, 6];

	// pcb
	color(pcb_col)
	translate(pcb_pos)
	difference() {
		translate([0, 0, pcb_dim[2] / 2])
		cube(pcb_dim, true);

		// holes
		for (edge = [0 : 3], pin = [0 : max(0, holes[edge] - 1)])
		if (holes[edge] > 0)
		rotate([0, 0, -90 * edge])
		translate([
			-(dim[0] / 2) + (pitch * pin) + pitch / 2,
			(dim[1] - pitch) / 2,
			-0.1
		])
		cylinder(h = pcb_dim[2] + 0.2, r = hole_rad);
	}

	// bottom SMCs
	translate([0, 0, 1])
	scale([1, 1, -1]) {
		chip([dim[0] * 0.25, dim[1] * 0.7, 1], [0, 14, 0, 14]);

		color(COLOUR_STEEL)
		translate([-4, -1, 0.5])
		cube([2, 3, 1], true);
	}

	// top SMCs
	translate([0.5, 0.5, pcb_dim[2] + pcb_pos[2]])
	chip([dim[0] * 0.3, dim[1] * 0.3, 1], [8, 8, 8, 8]);
}

*
minimosd_micro();
