/******************************************************************************
 * 5.8 GHz UXII antenna
 */

include <../../../colours.scad>;
include <../../Electrical/Wire.scad>;

5G_ANT_UXII_DIM = [15.75, 8]; // [dia., height (main section)]

module 5g_uxii_antenna(
		h = 60,
		col_dome = COLOUR_GREY_DARK,
		col_wire = COLOUR_STEEL,
		wire_awg = 18) {

	dome_rad = 5G_ANT_UXII_DIM[0] / 2;

	// wire
	rotate([0, -90, 0])
	wire(l = h - 5, g = wire_awg, col = col_wire);

	// dome
	color(col_dome)
	translate([0, 0, h - 5 - 8 - 1.2])
	hull() {
		// conical bottom portion
		cylinder(h = 5, r1 = 2.5, r2 = dome_rad);

		translate([0, 0, 5]) {
			// main section
			cylinder(h = 8, r = dome_rad);

			// top is slightly raised
			translate([0, 0, 8])
			cylinder(h = 1.2, r1 = dome_rad, r2 = 0);
		}
	}
}

*5g_uxii_antenna();
