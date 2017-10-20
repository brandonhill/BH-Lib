/******************************************************************************
 * MTK-3329 GPS module
 */

include <../../../2D/rounded square.scad>;
include <../../../colours.scad>;

GPS_MTK_3329_DIM = [30.25, 26, 6];

module gps_mtk_3329() {

	dim = GPS_MTK_3329_DIM;
	dim_ant = [dim[1] - 1, dim[1] - 1, 2];
	ant_inset = (dim[1] - dim_ant[1]) / 2;
	pcb_thickness = 1;

	translate([-dim[0] / 2, -dim[1] / 2, 0]) {
		color(COLOUR_PCB)
		cube([dim[0], dim [1], pcb_thickness]);

		color(COLOUR_WHITE)
		translate([dim[0] - dim_ant[0] - ant_inset, ant_inset, pcb_thickness])
		linear_extrude(dim_ant[2])
		rounded_square([dim_ant[0], dim_ant[1]], 3);

		*color(COLOUR_STEEL)
		cube(GPS_MTK_3329_DIM);
	}
}

*
gps_mtk_3329();
