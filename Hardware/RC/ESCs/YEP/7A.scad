/******************************************************************************
 * YEP 7A ESC
 */

include <../../../../colours.scad>;
use <../generic.scad>;
use <../../../Electrical/Chip.scad>;
use <../../../Electrical/Wire.scad>;

ESC_YEP_7A_DIM = [20.3, 10.9, 3.2];

module esc_yep_7a() {

	dim = ESC_YEP_7A_DIM;

	cap_col = COLOUR_STEEL;
	cap_dim = [3.1, 2.36, 1.7];
	cap_pos = [(dim[0] - cap_dim[0]) / 2 - 1.35, (dim[1] - cap_dim[1]) / 2 - 0.2, cap_dim[2] / 2];

	pcb_col = COLOUR_PCB;
	pcb_dim = [dim[0], dim[1], 0.5];
	pcb_pos = [0, 0, pcb_dim[2] / 2 + cap_dim[2]];

	wires = 3;
	wire_col = [COLOUR_ORANGE, COLOUR_RED, COLOUR_GREY_DARK];
	wire_gauge = 28;
	wire_spacing = PIN_HEADER_PITCH;
	wire_rad = wire_rad(wire_gauge, true);
	wire_pos = [dim[0] / 2 - 1.5, -dim[1] / 2 + wire_spacing * 1.5 + 0.5, cap_dim[2] - wire_rad];

	// board
	//*
	//#
	//translate([0, 0, -2])

	color(pcb_col)
	translate(pcb_pos)
	cube(pcb_dim, true);

	// fets
	module fet() {
		chip([1.5, 3.2, 1], [0, 3, 0, 3]);
	}

	// bottom
	translate([-dim[0] / 2 + 2, -3.5, 0])
	for (x = [0 : 1], y = [0 : 2])
	translate([
		4 * x,
		3.5 * y,
		cap_dim[2]
	])
	scale([1, 1, -1])
	fet();

	// big honkin' cap.
	color(cap_col)
	translate(cap_pos)
	cube(cap_dim, true);

	// top
	translate([0, 0, pcb_pos[2] + pcb_dim[2] / 2]) {
		translate([-dim[0] / 2 + 4, -3.5, 0])
		for (x = [0 : 1], y = [0 : 2])
		translate([
			4 * x,
			3.5 * y,
			0
		])
		fet();

		translate([4, -1, 0])
		rotate([0, 0, 45])
		chip([dim[1] * 0.4, dim[1] * 0.4, 1], [8, 8, 8, 8]);
	}

	// wires
	translate(wire_pos)
	translate([0, -(wire_spacing * wires - 1) / 2 + wire_rad * 2, 0])
	for (i = [0 : wires - 1]) {
		translate([0, wire_spacing * i, 0])
		wire(l = 2, g = wire_gauge, s1 = 1, col = wire_col[i]);
	}

	// dim check
	*
	#
	translate([0, 0, dim[2] / 2])
	cube(dim, true);
}

*
esc_yep_7a();
