/******************************************************************************
 * Generic piezo buzzer
 */

include <../../../colours.scad>;
include <../Wire.scad>;

module buzzer_piezo(h = 5, r = 10, pins = false, wires = true) {

	wires = 2;
	wire_col = [COLOUR_GREY_DARK, COLOUR_RED];
	wire_gauge = 28;
	wire_rad = wire_rad(wire_gauge, true);

	color(COLOUR_GREY_DARK)
	difference() {
		cylinder(h = h, r = r, r2 = r * 0.98);

		translate([0, 0, 0.05])
		cylinder(h = h, r = 1.5);
	}

	color(COLOUR_GOLD)
	translate([0, 0, 0.1])
	cylinder(h = max(0.1, h - 1), r = r * 0.9);

	// pins
	if (pins) {
		for (i = [0 : wires - 1])
		translate([0, -r / 2 + r * i])
		rotate([0, 90])
		wire(l = 2, g = wire_gauge, col = wire_col[i]);

	// wires
	} else if (wires) {
		translate([0, -(wire_rad * wires), 0])
		for (i = [0 : wires - 1])
		translate([0, wire_rad + wire_rad * 2 * i, wire_rad])
		wire(l = r + 2, g = wire_gauge, col = wire_col[i]);
	}
}

*
buzzer_piezo();
