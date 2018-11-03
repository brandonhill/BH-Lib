/******************************************************************************
 * Slide switch
 */

include <../../../colours.scad>;
include <../../../helpers.scad>;

SWITCH_SLIDE_SM_BODY_DIM = [10.75, 6, 5.5];
SWITCH_SLIDE_SM_CASE_THICKNESS = 0.5;
SWITCH_SLIDE_SM_DIM = [20, SWITCH_SLIDE_SM_BODY_DIM[1], 13]; // excl. slide
SWITCH_SLIDE_SM_SLIDE_DIM = [2.9, 2.9, 4];
SWITCH_SLIDE_SM_HOLE_RAD = 1.25;
SWITCH_SLIDE_SM_HOLE_SPACING = 15;

module pos_switch_slide_screws(hole_spacing) {
	transpose([hole_spacing / 2, 0])
	children();
}

module pos_switch_slide_sm_screws(
		hole_spacing = SWITCH_SLIDE_SM_HOLE_SPACING,
	) {
	pos_switch_slide_screws(hole_spacing)
	children();
}

module switch_slide_sm(
		h = SWITCH_SLIDE_SM_SLIDE_DIM[2], // can have std. dim. but custom height
		body_dim = SWITCH_SLIDE_SM_BODY_DIM,
		case_thickness = SWITCH_SLIDE_SM_CASE_THICKNESS,
		dim = SWITCH_SLIDE_SM_DIM,
		hole_rad = SWITCH_SLIDE_SM_HOLE_RAD,
		slide_dim = SWITCH_SLIDE_SM_SLIDE_DIM, // doubled for cutout
		pos = 0, // 0 || 1
		top_mount = false, // positioned with mounts above origin
		tolerance = 0,
	) {

	_projection = tolerance > 0 ? 10 : 0;

	translate([0, 0, top_mount ? case_thickness : 0]) {
		color(COLOUR_STEEL) {
			translate([0, 0, -body_dim[2] / 2])
			cube(body_dim, true);

			scale([1, 1, -1])
			linear_extrude(case_thickness)
			difference() {
				square([dim[0], dim[1]], true);

				pos_switch_slide_sm_screws()
				circle(hole_rad);
			}
		}

		color("dimgray")
		translate([tolerance ? 0 : slide_dim[0] / 2 * (pos ? 1 : -1), 0, (h + _projection) / 2])
		cube([slide_dim[0] * (tolerance > 0 ? 2 : 1) + tolerance * 2, slide_dim[1] + tolerance * 2, h + _projection], true);
	}
}
