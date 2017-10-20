/******************************************************************************
 * RX52S DSM2 6ch PPM micro receiver
 */

include <../../../colours.scad>;
include <../../Electrical/Chip.scad>;
include <../../Electrical/Wire.scad>;

RX_RX52S_DIM = [10.75, 9.5, 2.5];

module rx_rx52s(dim = RX_RX52S_DIM) {

	ant_gauge = 32;
	ant_pos = [dim[0] / 2, dim[1] / 2 - 1, dim[2] / 2];
	ant_rad = wire_rad(ant_gauge);

	holes = 7;
	pitch = 1.25;
	hole_rad = 0.3;

	pcb_col = [0, 0.4, 0.3];
	pcb_dim = [dim[0], dim[1], 0.5];
	pcb_pos = [0, 0, 1];

	wires = 3;
	wire_col = [COLOUR_BLACK, COLOUR_ORANGE, COLOUR_RED];

	// board
	translate(pcb_pos)
	difference() {
		color(pcb_col)
		translate([0, 0, pcb_dim[2] / 2])
		cube(pcb_dim, true);

		// holes
		translate([-(dim[0] - pitch * 1.25) / 2, -dim[1] / 2 + (pitch) / 2 + hole_rad, 0])
		for (y = [0 : holes - 1])
		translate([0, pitch * y, -0.1])
		cylinder(h = pcb_dim[2] + 0.2, r = hole_rad);
	}

	// top
	translate([0, 0, 1 + pcb_dim[2]])
	chip([dim[1] * 0.6, dim[1] * 0.6, 1], [10, 10, 10, 10]);

	// bottom
	color(COLOUR_STEEL)
	translate([(dim[0] - dim[0] * 0.225) / 2 - 0.5, -((dim[1] - dim[1] * 1/3) / 2 - 0.5), 0])
	translate([0, 0, 0.5])
	cube([dim[0] * 0.225, dim[1] * 1/3, 1], true);

	translate([0, -(dim[1] / 2 - 2.25), 1])
	rotate([180, 0, 0])
	chip([dim[0] * 0.2, dim[1] * 0.15, 1], [2, 0, 2, 0]);

	color(COLOUR_BROWN_LIGHT)
	translate([-dim[0] / 2 + 2.5, 0, 0])
	translate([0, 0, 0.5])
	cube([1, 2, 1], true);

	// antenna
	translate(ant_pos)
	wire(g = ant_gauge, l = 30);

	// wires
	translate([-(dim[0] / 2 - 1.25), dim[1] / 2 - 1, 1])
	rotate([0, 0, 180])
	for (y = [0 : wires - 1])
		translate([0, pitch * y + (y > 1 ? pitch * 4 : 0), 0])
		wire(g = 36, l = 2, s1 = 1, col = wire_col[y]);
}

//$fs = 0.1;
//rx_rx52s();
