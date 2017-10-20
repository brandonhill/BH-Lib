/******************************************************************************
 * Surface mount LED
 */

include <../../../colours.scad>;

LED_SM_MINI_DIM = [3.6, 2.7, 1.5];
LED_SM_MICRO_DIM = [2, 1, 0.5];

module led_sm(dim = LED_SM_MINI_DIM, col = COLOUR_RED) {

	contact_thickness = 0.05;

	// LED
	color(alpha(col, 0.75))
	translate([0, 0, dim[2] / 2])
	cube([dim[0] - contact_thickness * 2, dim[1], dim[2]], true);

	// contacts
	color(COLOUR_STEEL)
	for (x = [0 : 1])
	scale([x == 0 ? -1 : 1, 1, 1])
	translate([(dim[0] - contact_thickness) / 2, 0, dim[2] / 4])
	cube([contact_thickness, dim[1], dim[2] / 2], true);
}

//led_sm();
