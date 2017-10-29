/******************************************************************************
 * Omnibus F3 Pro flight controller
 */

include <../../../../colours.scad>;

FC_OMNIBUS_F3_PRO_BOARD_THICKNESS = 1.6;
FC_OMNIBUS_F3_PRO_DIM = [36, 36, 7.6];
FC_OMNIBUS_F3_PRO_HOLE_RAD = 1.5; // M3
FC_OMNIBUS_F3_PRO_HOLE_SPACING = [30.5, 30.5];

module fc_omnibus_f3_pro(
		board_thickness = FC_OMNIBUS_F3_PRO_BOARD_THICKNESS,
		colour = COLOUR_GREY_DARK,
		dim = FC_OMNIBUS_F3_PRO_DIM,
		hole_rad = FC_OMNIBUS_F3_PRO_HOLE_RAD,
		hole_spacing = FC_OMNIBUS_F3_PRO_HOLE_SPACING,
	) {

	comp_thickness = (dim[2] - board_thickness) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[1] - hole_rad * 4 * 2,
	];

	color(colour)
	difference() {
		union() {
			translate([0, 0, -(comp_thickness + board_thickness) / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);

			cube([dim[0], dim[1], board_thickness], true);

			translate([0, 0, (comp_thickness + board_thickness) / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);
		}

		reflect()
		translate([hole_spacing[0] / 2, hole_spacing[1] / 2])
		cylinder(h = dim[2], r = hole_rad, center = true);
	}
}

*
fc_omnibus_f3_pro();
