/******************************************************************************
 * SD jack
 */

include <../../../colours.scad>;
include <../constants.scad>;

JACK_SD_MICRO_DIM = [15, 14.75, 2];
JACK_SD_MICRO_CARD_POS = [
	JACK_SD_MICRO_DIM[0] / 2 + 2.4 - SD_MICRO_DIM[0] / 2,
	-JACK_SD_MICRO_DIM[1] / 2 + 1 + SD_MICRO_DIM[1] / 2,
	JACK_SD_MICRO_DIM[2] / 2 - 0.15 - SD_MICRO_DIM[2] / 2];

module jack_sd_micro(
		dim = JACK_SD_MICRO_DIM,
		card = true,
		card_dim = SD_MICRO_DIM,
		card_pos = JACK_SD_MICRO_CARD_POS,
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	translate([0, 0, dim[2] / 2]) {
		color(COLOUR_STEEL)
		cube(dim, true);

		if (card)
		color("dimgray")
		translate(card_pos)
		cube([card_dim[0] + _projection * 2, card_dim[1] + tolerance * 2, card_dim[2] + tolerance * 2], true);
	}
}
