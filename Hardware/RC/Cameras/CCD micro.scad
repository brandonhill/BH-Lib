/******************************************************************************
 * Micro CCD camera
 */

// this is confusing. TODO: orient vertically
CAM_CCD_MICRO_DIM = [17, 25, 28];
CAM_CCD_MICRO_BOARD_DIM = [17, 17, 3];
CAM_CCD_MICRO_HOUSING_DIM = [17, 17, 7];
CAM_CCD_MICRO_LENS_HEIGHTS = [9.5, 2.5, 3.75];
CAM_CCD_MICRO_RAD = [15.5, 12, 14] / 2;

module cam_ccd_micro(
		board_dim = CAM_CCD_MICRO_BOARD_DIM,
		dim = CAM_CCD_MICRO_DIM,
		housing_dim = CAM_CCD_MICRO_HOUSING_DIM,
		lens_heights = CAM_CCD_MICRO_LENS_HEIGHTS,
		rads = CAM_CCD_MICRO_RAD,
	) {

	wires = 3;
	wire_col = [COLOUR_BLACK, COLOUR_RED, COLOUR_YELLOW];
	wire_gauge = 28;
	wire_spacing = 1.25;
	wire_rad = wire_rad(wire_gauge, true);
	wire_pos = [-(wire_spacing * (wires - board_dim[0] / 2)) / 2, -(board_dim[1] / 2 + 1), wire_rad];

	module board() {

		// chip
		translate([-3, 1, board_dim[2] / 2])
		rotate([180, 0, 0])
		chip([board_dim[0] / 4, board_dim[1] / 3, board_dim[2] / 2], [0, 4, 0, 4]);

		// PCB
		color(COLOUR_PCB)
		translate([0, 0, board_dim[2] * 0.5])
		linear_extrude(board_dim[2] / 2)
		shape_housing();

		// wires
		translate(wire_pos)
		for (i = [0 : wires - 1]) {
			translate([wire_spacing * i, 0, board_dim[2] / 3])
			rotate([0, 0, 90])
			wire(l = 2, g = wire_gauge, s2 = 1, col = wire_col[i]);
		}
	}

	module shape_housing() {
		square([housing_dim[0], housing_dim[1]], true);
		hull()
		for (x = [-1, 1])
		scale([x, 1])
		translate([housing_dim[1] / 2 + (dim[1] - housing_dim[1]) / 4, 0])
		circle((dim[1] - housing_dim[1]) / 4);
	}

	module housing() {
		linear_extrude(housing_dim[2])
		shape_housing();
	}

	module lens_body() {
		difference() {
			union() {
				translate([0, 0, 0])
				cylinder(h = lens_heights[0], r = rads[0]);

				translate([0, 0, lens_heights[0]])
				cylinder(h = lens_heights[1], r = rads[1]);

				translate([0, 0, lens_heights[0] + lens_heights[1]])
				cylinder(h = lens_heights[2], r = rads[2]);
			}

			*translate([0, 0, lens_heights[0] + lens_heights[1] + lens_heights[2]])
			sphere(rads[2]);
		}
	}

	rotate([90, 0, 90])
	{

		board();
		translate([0, 0, board_dim[2]]) {

			color(COLOUR_GREY_DARK) {
				housing();
				translate([0, 0, housing_dim[2]]) {

					lens_body();
				}
			}

			*color(COLOUR_RED_DARK)
			translate([0, 0, heights[0] + heights[1] + heights[2] + heights[3] + heights[4]])
			scale([1, 1, 0.25])
			intersection() {
				difference() {
					sphere(rads[3] * 1.5);
					translate([0, 0, -rads[3] * 1.5])
					cube(rads[3] * 1.5 * 2, true);
				}
				cylinder(h = 100, r = rads[3] - 0.1);
			}
		}
	}
}

*cam_ccd_micro();
