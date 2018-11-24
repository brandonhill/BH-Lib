// ****************************************************************************
// Mini pin headers

include <../../../colours.scad>;
include <../../../constants.scad>;

module pin_headers_mini(n = 1, male = true) {

	base_col = COLOUR_GREY_DARK;
	base_dim = [PIN_HEADER_PITCH, 2.65, 1.4];

	collar_height_top = male ? 0.6 : 0.3;
	collar_height_bottom = male ? 0 : 0.4;
	collar_rad = 1.75 / 2;

	pin_col = COLOUR_GOLD;
	pin_height_top = 3.15;
	pin_height_bottom = male ? 2.5 : 2.2;
	pin_rad_top = 0.2;
	pin_rad_bottom = male ? 0.2 : 0.35;

	translate([PIN_HEADER_PITCH / 2 - PIN_HEADER_PITCH * n / 2, 0, 0])
	for (x = [0 : n - 1])
		translate([base_dim[0] * x, 0, 0]) {

			// pin
			if (male)
			color(pin_col)
			cylinder(h = pin_height_top, r = pin_rad_top);

			// top collar
			difference() {
				translate([0, 0, -collar_height_top]) {
					color(pin_col)
					cylinder(h = collar_height_top, r = collar_rad);

					// base
					translate([0, 0, -base_dim[2]]) {
						color(base_col)
						linear_extrude(base_dim[2])
						rounded_square([base_dim[0], base_dim[1]], 0.25, true);

						// bottom collar
						translate([0, 0, -collar_height_bottom]) {
							color(pin_col)
							cylinder(h = collar_height_bottom, r = collar_rad);

							// bottom pin
							translate([0, 0, -pin_height_bottom])
							color(pin_col)
							cylinder(h = pin_height_bottom, r = pin_rad_bottom);
						}
					}
				}

				// pin hole
				if (!male)
				color(pin_col)
				scale([1, 1, -1])
				translate([0, 0, -0.1])
				cylinder(h = pin_height_top + 0.2, r = pin_rad_top * 1.5);
			}
		}
}

//$fs = 0.1;
//pin_headers_mini(5, 0);
//rotate([180, 0, 0]) pin_headers_mini(5, false);
