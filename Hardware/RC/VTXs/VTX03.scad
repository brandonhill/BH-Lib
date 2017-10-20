/******************************************************************************
 * VTX03 super mini 72 ch. switchable video transmitter
 */

include <../../../colours.scad>;

VTX_VTX03_DIM = [19.6, 22, 6];
VTX_VTX03_ANT_MOUNT_DIM = [5.5, 5.3];
VTX_VTX03_PCB_THICKNESS = 0.85;

module vtx_vtx03(
		antenna_mount_dim = VTX_VTX03_ANT_MOUNT_DIM,
		dim = VTX_VTX03_DIM,
		display_dim = [7, 8, 3.25],
		pcb_thickness = VTX_VTX03_PCB_THICKNESS,
	) {

	comp_thickness = dim[2] - display_dim[2] - pcb_thickness;

	translate([0, -antenna_mount_dim[1], -dim[2] / 2]) {

		// back
		color(COLOUR_GREY_DARK)
		translate([0, antenna_mount_dim[1] / 2, comp_thickness / 2])
		cube([dim[0] * 0.75, (dim[1] - antenna_mount_dim[1]) * 0.75, comp_thickness], true);
		translate([0, 0, comp_thickness]) {

			color(COLOUR_GREY_DARK)
			translate([0, 0, pcb_thickness / 2]) {
				// board
				translate([0, antenna_mount_dim[1] / 2])
				cube([dim[0], dim[1] - antenna_mount_dim[1], pcb_thickness], true);

				// antenna mount
				translate([0, (dim[1] + antenna_mount_dim[1]) / 2])
				cube([antenna_mount_dim[0], antenna_mount_dim[1], pcb_thickness], true);
			}
			translate([0, 0, pcb_thickness]) {

				// 7 segment display
				color(COLOUR_WHITE)
				translate([-((dim[0] - display_dim[0]) / 2 - 1), (dim[1] - display_dim[1]) / 2 - 1, pcb_thickness])
				cube([display_dim[0], display_dim[1], display_dim[2]], true);
			}
		}
	}
}

//vtx_vtx03();
