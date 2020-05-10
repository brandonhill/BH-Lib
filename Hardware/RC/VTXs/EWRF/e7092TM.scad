/******************************************************************************
 * EWRF e7092TM smart switchable audio/video transmitter
 */

include <../../../../colours.scad>;

VTX_EWRF_E7092TM_BOARD_DIM = [24, 24, 1];
VTX_EWRF_E7092TM_DIM = [VTX_EWRF_E7092TM_BOARD_DIM[0], VTX_EWRF_E7092TM_BOARD_DIM[1], 4];
VTX_EWRF_E7092TM_HOLE_RAD = 1;
VTX_EWRF_E7092TM_HOLE_SPACING = [20, 20];

module vtx_ewrf_e7092tm(
		board_dim = VTX_EWRF_E7092TM_BOARD_DIM,
		colour = COLOUR_GREY_DARK,
		dim = VTX_EWRF_E7092TM_DIM,
		hole_rad = VTX_EWRF_E7092TM_HOLE_RAD,
		hole_spacing = VTX_EWRF_E7092TM_HOLE_SPACING,
		center = "board", // "board" || true || false
	) {

	comp_thickness = (dim[2] - board_dim[2]) / 2;
	interior_dim = [
		dim[0] - hole_rad * 4 * 2,
		dim[1] - hole_rad * 4 * 2,
	];

	color(colour)
	translate([0, 0, -(center == "board" ? comp_thickness : (center ? dim[2] / 2 : 0))])
	difference() {
		union() {
			// bottom components
			translate([0, 0, comp_thickness / 2])
			cube([interior_dim[0], interior_dim[1], comp_thickness], true);

			// button
			translate([board_dim[0] / 5, board_dim[1] / 2 - 1.5, comp_thickness / 2])
			cube([4.75, 3, comp_thickness], true);

			translate([0, 0, comp_thickness]) {

				// board
				linear_extrude(board_dim[2])
				square([board_dim[0], board_dim[1]], true);

				translate([0, 0, board_dim[2]]) {

					// top components
					translate([0, 0, comp_thickness / 2])
					cube([interior_dim[0], interior_dim[1], comp_thickness], true);

					// IPEX conn.
					translate([0, board_dim[1] / 2 - 1.5, comp_thickness / 2])
					cube([3, 3, comp_thickness], true);
				}
			}
		}

		reflect()
		translate(hole_spacing / 2)
		cylinder(h = dim[2], r = hole_rad);
	}
}

*vtx_ewrf_e7092tm();
