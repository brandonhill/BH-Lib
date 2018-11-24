/******************************************************************************
 * VTX03 super mini 72 ch. switchable video transmitter
 */

include <../../../colours.scad>;

VTX_VTX03_ANT_MOUNT_DIM = [5.5, 5.3];
VTX_VTX03_BOARD_DIM = [19.6, 22, 0.85];
VTX_VTX03_DISPLAY_DIM = [7, 8, 3.25];
VTX_VTX03_DIM = [VTX_VTX03_BOARD_DIM[0], VTX_VTX03_BOARD_DIM[1], 6];

module vtx_vtx03(
		antenna_mount_dim = VTX_VTX03_ANT_MOUNT_DIM,
		board_dim = VTX_VTX03_BOARD_DIM,
		dim = VTX_VTX03_DIM,
		display_dim = VTX_VTX03_DISPLAY_DIM,
		center = "board", // "board" || true || false
		offset = 0, // for diffs - currently only applied to display
	) {

	comp_thickness = dim[2] - display_dim[2] - board_dim[2];

	translate([0, -antenna_mount_dim[1], -(center == "board" ? comp_thickness : (center ? dim[2] / 2 : 0))]) {

		// back
		color(COLOUR_GREY_DARK)
		translate([0, antenna_mount_dim[1] / 2, comp_thickness / 2])
		cube([dim[0] * 0.75, (dim[1] - antenna_mount_dim[1]) * 0.75, comp_thickness], true);
		translate([0, 0, comp_thickness]) {

			color(COLOUR_GREY_DARK)
			translate([0, 0, board_dim[2] / 2]) {
				// board
				translate([0, antenna_mount_dim[1] / 2])
				cube([board_dim[0], board_dim[1] - antenna_mount_dim[1], board_dim[2]], true);

				// antenna mount
				translate([0, (dim[1] + antenna_mount_dim[1]) / 2])
				cube([antenna_mount_dim[0], antenna_mount_dim[1], board_dim[2]], true);
			}
			translate([0, 0, board_dim[2]]) {

				// 7 segment display
				translate([
					-((dim[0] - display_dim[0]) / 2 - 0.37),
					(dim[1] - display_dim[1]) / 2 - 1.7,
					0]) {

					// base
					color(COLOUR_GREY_DARK)
					translate([0, 0, (0.8 + offset) / 2])
					cube([
						display_dim[0] + offset * 2,
						display_dim[1] + (1.1 + offset) * 2,
						0.8 + offset], true);

					// display
					color(COLOUR_WHITE)
					translate([0, 0, 0.8 + (display_dim[2] - 0.8 + offset) / 2])
					cube([
						display_dim[0] + offset * 2,
						display_dim[1] + offset * 2,
						display_dim[2] - 0.8 + offset], true);
				}
			}
		}
	}
}

*vtx_vtx03(center = "board");
