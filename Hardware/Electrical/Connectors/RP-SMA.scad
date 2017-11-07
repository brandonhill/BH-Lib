/******************************************************************************
 * RP-SMA connector
 */

include <../constants.scad>;
include <../../Engineering/nut.scad>;

CONN_SMA_LENGTH = 11;

module conn_rp_sma(
		h = CONN_SMA_LENGTH,
		h_pin = 5,
		l = 5, // wire beyond end
		nut_dim = SMA_NUT_DIM,
		pin = true,
		r = SMA_RAD,
		r_pin = SMA_PIN_RAD,
		tolerance = 0,
	) {

	color("gold") {
		// main pos
		translate([0, 0, -nut_dim[2] * 2])
		cylinder(h = nut_dim[2] * 2 + h, r = r + tolerance);

		// static nut
		translate([0, 0, -nut_dim[2]])
		nut(nut_dim);
	}

	if (pin) {
		// pin
		color("dimgray")
		translate([0, 0, -nut_dim[2] * 2])
		scale([1, 1, -1])
		cylinder(h = h_pin, r = r_pin);

		// wire
		color("darkgray")
		translate([0, 0, -(nut_dim[2] * 2 + h_pin)])
		scale([1, 1, -1])
		cylinder(h = l, r = r_pin * 0.9);
	}
}
