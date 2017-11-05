/******************************************************************************
 * WS2811/12/12b circular board mounted LED
 */

LED_WS2812_DIM = [5, 5, 1.6];
LED_WS2812_DOT_BOARD_DIM = [10, 1.4]; // [dia., thickness]
LED_WS2812_DOT_DIM = [LED_WS2812_DOT_BOARD_DIM[0], LED_WS2812_DOT_BOARD_DIM[1] + LED_WS2812_DIM[2]];

module led_ws2812_dot(
		board_color = "dimgray",
		board_dim = LED_WS2812_DOT_BOARD_DIM,
		led_dim = LED_WS2812_DIM,
	) {

	// board
	color(board_color)
	cylinder(h = board_dim[1], r = board_dim[0] / 2);

	// LED
	color("white")
	translate([0, 0, board_dim[1] + led_dim[2] / 2])
	cube(led_dim, true);
}

//led_ws2812_dot();
