/******************************************************************************
 * Generic surface mount semiconductor chip
 */

include <../../colours.scad>;

module chip(dim = [30, 10, 2], pins = [12, 0, 12, 0]) {

	pitch_x = pins[0] || pins[2] ? dim[0] / (max(pins[0], pins[2]) + 1) : 0;
	pitch_y = pins[1] || pins[3] ? dim[1] / (max(pins[1], pins[3]) + 1) : 0;

	pitch = max(pitch_x, pitch_y);
	pin_dim = [pitch * 0.3, 0.5];

	//echo(str("pitch: ", pitch, ", pin: ", pin_dim[0]));

	// chip
	//*
	//#
	color(COLOUR_GREY_DARK)
	translate([0, 0, dim[2] / 2])
	cube(dim, true);

	// pins
	color(COLOUR_STEEL)
	translate([0, 0, pin_dim[0] / 2])
	for (edge = [0 : 3])
	if (pins[edge] > 0)
	for (pin = [0 : max(0, pins[edge] - 1)])
	//*
	translate([
		pitch *
			(edge == 0 || edge == 2 ? pin : 0) +
			(edge == 0 || edge == 2 ? -(dim[0] / 2) + (dim[0] - max(0, pins[edge] - 1) * pitch) / 2 : 0) +
			(edge == 1 ? dim[0] / 2 : 0) +
			(edge == 3 ? -(dim[0] / 2 + pin_dim[1]) : 0),
		pitch *
			(edge == 1 || edge == 3 ? pin : 0) +
			(edge == 1 || edge == 3 ? -(dim[1] / 2) + (dim[1] - max(0, pins[edge] - 1) * pitch) / 2 : 0) +
			(edge == 0 ? dim[1] / 2 : 0) +
			(edge == 2 ? -(dim[1] / 2 + pin_dim[1]) : 0),
		0
	])
	//*/
	rotate([0, 0, (edge == 0 || edge == 2 ? 90 : 0)])
	translate([pin_dim[1] / 2, 0, 0])
	cube([pin_dim[1], pin_dim[0], pin_dim[0]], true);
}

*chip([10, 4, 1.5], [10, 0, 2, 0], 1);

*chip([8, 4, 1], [6, 3, 6, 3]);

//chip([3, 2, 1], [3, 0, 3, 0]);
