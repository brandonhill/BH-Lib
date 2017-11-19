/******************************************************************************
 * USB jack
 */

include <../../../colours.scad>;
include <../constants.scad>;

JACK_USB_MICRO_DIM = [5.8, 7.4, 2.5];

module jack_usb_micro(
		dim = JACK_USB_MICRO_DIM,
		tolerance,
	) {

	_tolerance = tolerance != undef ? tolerance : 0;
	_projection = tolerance > 0 ? 10 : 0;

	color(COLOUR_STEEL)
	translate([-dim[0] / 2, 0, dim[2] / 2])
	cube([dim[0] + _projection, dim[1] + tolerance * 2, dim[2] + tolerance * 2], true);

	// for diffs, using children since cutout will depend on plug, not jack
	if ($children > 0)
	translate([0, 0, dim[2] / 2])
	rotate([90, 0, 90])
	linear_extrude(10)
	children();
}
