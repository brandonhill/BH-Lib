/******************************************************************************
 * 5.8 GHz cloverleaf antenna
 */

include <../../../colours.scad>;
include <../../Electrical/Wire.scad>;

5G_ANT_WIRE_GAUGE = 18;

module 5g_cp_antenna(
		h = 60,
		col_dome = COLOUR_GREY_DARK,
		col_wire = COLOUR_STEEL,
		wire_awg = 5G_ANT_WIRE_GAUGE) {

	dome_rad = 15;

	// wire
	rotate([0, -90, 0])
	wire(l = h, g = wire_awg, col = col_wire);

	// dome
	color(col_dome)
	translate([0, 0, h])
	difference() {
		sphere(dome_rad);

		translate([0, 0, dome_rad * 1.75])
		cube(dome_rad * 2, true);

		translate([0, 0, -dome_rad])
		cube(dome_rad * 2, true);
	}
}
