/******************************************************************************
 * 7 segment surface mount LED
 */

LED_7_SEGMENT_DIM = [7.5, 10, 6];
LED_7_SEGMENT_MICRO_DIM = [7, 8, 3.25];

module led_7_segment(
		dim = LED_7_SEGMENT_DIM,
		n = 1,
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	color("white")
	translate([0, 0, (dim[2] + _projection) / 2])
	cube([dim[0] * n + tolerance * 2, dim[1] + tolerance * 2, dim[2] + _projection], true);
}

module led_7_segment_micro(
		dim = LED_7_SEGMENT_MICRO_DIM,
		n = 1,
		tolerance = 0,
	) {

	led_7_segment(dim, n, tolerance);
}

//led_7_segment();
