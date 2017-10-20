/******************************************************************************
 * FX758 32 ch. video transmitter
 */

include <../../../colours.scad>;
include <../../Electrical/Chip.scad>;

VTX_FX758_DIM = [22, 19, 3.5];
VTX_FX758_PCB_THICKNESS = 1;
VTX_FX758_BOX_DIM = [VTX_FX758_DIM[0] - PIN_HEADER_PITCH, VTX_FX758_DIM[1] - 0.5, VTX_FX758_DIM[2] - VTX_FX758_PCB_THICKNESS];

module vtx_fx758() {

	dim = VTX_FX758_DIM;

	hole_pitch = PIN_HEADER_PITCH;
	hole_rad = 2/3;

	pcb_dim = [dim[0], dim[1], VTX_FX758_PCB_THICKNESS];

	block_dim = VTX_FX758_BOX_DIM;
	block_pos = [0, 0, pcb_dim[2]];

	// pcb
	color(COLOUR_PCB)
	difference() {
		translate([0, 0, pcb_dim[2] / 2])
		cube(pcb_dim, true);

		// holes
		for (x = [-1, 1], y = [0 : 5])
			if (x < 0 || y > 0)
				scale([x, 1])
				translate([
					dim[0] / 2,
					-(dim[1] / 2) + hole_pitch - hole_rad + hole_pitch * y,
					-0.1
				])
				cylinder(h = pcb_dim[2] + 0.2, r = hole_rad);
	}

	// block
	color(COLOUR_STEEL)
	translate(block_pos)
	translate([0, 0, block_dim[2] / 2])
	cube(block_dim, true);

	// dim check
	//#translate([0, 0, dim[2] / 2]) cube(dim, true);
}

//vtx_fx758();
