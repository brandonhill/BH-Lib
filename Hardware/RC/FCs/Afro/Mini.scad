/******************************************************************************
 * Afro mini flight controller
 */

include <../../../../colours.scad>;
include <../../../Electrical/Chip.scad>;
include <../../../Electrical/LEDs/surface mount.scad>;

FC_AFRO_MINI_DIM = [33.3, 16.5, 2.3];

module fc_afro_mini() {

	dim = FC_AFRO_MINI_DIM;

	led_col = [COLOUR_BLUE, COLOUR_RED, COLOUR_GREEN];
	led_dim = LED_SM_MICRO_DIM;

	pcb_col = COLOUR_GREY_DARK;
	pcb_dim = [dim[0], dim[1], 0.8];

	pitch = 2.54;
	hole_rad = 0.6;

	// pcb
	difference() {
		color(pcb_col)
		translate([0, 0, pcb_dim[2] / 2])
		cube(pcb_dim, true);

		// holes

		// servo pins
		translate([(dim[0] - pitch) / 2, -dim[1] / 2 + (pitch) / 2 + hole_rad, 0])
		for (x = [0 : 2], y = [0 : 5])
		translate([
			-pitch * x,
			pitch * y,
			-0.1
		])
		cylinder(h = pcb_dim[2] + 0.2, r = hole_rad);

		// rx
		translate([-(dim[0] - pitch) / 2, -dim[1] / 2 + (pitch) / 2 + hole_rad, 0])
		for (y = [0 : 5])
		translate([
			0,
			pitch * y,
			-0.1
		])
		cylinder(h = pcb_dim[2] + 0.2, r = hole_rad);
	}

	// chips
	translate([-1, 0, pcb_dim[2]])
	chip([dim[1] * 0.45, dim[1] * 0.45, 1.5], [12, 12, 12, 12]);

	translate([-pcb_dim[0] * 0.3, -pcb_dim[1] * 0.25, pcb_dim[2]])
	chip([dim[1] * 0.2, dim[1] * 0.2, 1], [6, 6, 6, 6]);

	// LEDs
	translate([pcb_dim[0] / 2 - 2.54 * 3 - (led_dim[1] * 3) - 1.5, dim[1] / 2 - 2.54, pcb_dim[2]])
	for (x = [0 : 2])
	translate([(led_dim[1] + 0.75) * x, 0, 0])
	rotate([0, 0, 90])
	led_sm(led_dim, led_col[x]);

	// baro
	color(COLOUR_STEEL)
	translate([-(dim[0] * 0.3), 1, pcb_dim[2] + 0.5])
	cube([2, 1.5, 1], true);

	// dim check
	*
	#
	translate([0, 0, dim[2] / 2])
	cube(dim, true);
}

//fc_afro_mini();
