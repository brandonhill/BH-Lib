/******************************************************************************
 * Dip switch (micro?)
 */

include <../../../colours.scad>;

module switch_dip(poles = 4, rand = true) {

	housing_dim = [2.54, 7, 3];
	slot_dim = [1.5, 3.5, 1];
	switch_dim = [1.3, 1.5, 0.7];

	for (i = [0 : poles - 1]) {
		translate([housing_dim[0] * i, 0, 0]) {
			color(COLOUR_GREY_DARK)
			difference() {
				cube(housing_dim);

				translate([housing_dim[0] / 2 - slot_dim[0] / 2, housing_dim[1] / 2 - slot_dim[1] / 2, housing_dim[2] - slot_dim[2]])
				cube([slot_dim[0], slot_dim[1], slot_dim[2] + 1]);
			}

			color(COLOUR_WHITE)
			translate([
				housing_dim[0] / 2 - switch_dim[0] / 2,
				(housing_dim[1] - slot_dim[1]) / 2 + (rand ? (slot_dim[1] - switch_dim[1]) * round(rands(0, 1, 1)[0]) : 0),
				housing_dim[2] - slot_dim[2]
			])
			cube([switch_dim[0], switch_dim[1], switch_dim[2] + slot_dim[2]]);
		}
	}
}
