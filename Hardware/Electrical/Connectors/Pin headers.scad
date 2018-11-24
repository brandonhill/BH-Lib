// ****************************************************************************
// Pin headers

include <../../../colours.scad>;

module pin_headers(x = 1, y = 1, pitch = 2.54, base = true, straight = true) {

	bend_height = 3.6;
	holder_height = 2;
	pin_dim = [0.6, 0.6, 5.9];

	for (i = [0 : x - 1], j = [0 : y - 1])
		translate([pitch * i, pitch * j, 0]) {

		if (base) {
			color(COLOUR_GREY_DARK)
			if (straight) {
				translate([0, 0, holder_height / 2])
				cube([pitch, pitch, holder_height], true);
			} else {
				translate([0, -(pin_dim[1] / 2 + holder_height / 2 + pitch * j), bend_height - pin_dim[1] + pitch * j])
				cube([pitch, holder_height, pitch], true);
			}
		}

		color(COLOUR_GOLD)
		translate([0, 0, ]) {
			if (straight) {
				translate([0, 0, (pin_dim[2] + holder_height) / 2 - 1])
				cube([pin_dim[0], pin_dim[1], pin_dim[2] + holder_height], true);
			} else {
				translate([0, 0, (pitch * j + bend_height) / 2 - pin_dim[1]])
				cube([pin_dim[0], pin_dim[1], pitch * j + pin_dim[1] + bend_height], true);

				translate([0, -(pin_dim[2] + j * pitch + pitch / 2) / 2, pitch * j + bend_height - 0.5])
				cube([pin_dim[0], pin_dim[2] + j * pitch + pitch / 2, pin_dim[1]], true);
			}
		}
	}
}

*
pin_headers(x = 4, y = 3, straight = false);
