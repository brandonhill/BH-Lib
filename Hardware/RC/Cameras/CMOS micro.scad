/******************************************************************************
 * 600 TVL 1/4 CMOS camera
 */

include <../../Electrical/Chip.scad>;
include <../../Electrical/Wire.scad>;

// this is confusing. TODO: orient vertically?
CAM_CMOS_MICRO_DIM = [11.5, 12.5, 12.5];
CAM_CMOS_MICRO_BOARD_DIM = [12.5, 12.5, 1];
CAM_CMOS_MICRO_HOUSING_DIM = [11.75, 11.75, 3];
CAM_CMOS_MICRO_HEIGHTS = [2.5, CAM_CMOS_MICRO_HOUSING_DIM[2], 1.75, 1.65, 1, 2.75];
CAM_CMOS_MICRO_RAD = [4, 3.5, 4, 5];

module cam_cmos_micro() {

	dim = CAM_CMOS_MICRO_DIM;
	board_dim = CAM_CMOS_MICRO_BOARD_DIM;
	heights = CAM_CMOS_MICRO_HEIGHTS;
	rads = CAM_CMOS_MICRO_RAD;

	wires = 4;
	wire_col = [COLOUR_RED, COLOUR_YELLOW, COLOUR_BLACK, COLOUR_WHITE];
	wire_gauge = 28;
	wire_spacing = 1.25;
	wire_rad = wire_rad(wire_gauge, true);
	wire_pos = [-(wire_spacing * (wires - 1)) / 2, -(board_dim[1] / 2 + 1), wire_rad];

	module board() {

		// PCB
		color(COLOUR_PCB)
		translate([0, 0, heights[0] - board_dim[2] / 2])
		cube(board_dim, true);

		// chip
		translate([-3, 1, 1.5])
		rotate([180, 0, 0])
		chip([board_dim[0] / 4, board_dim[1] / 3, 1.5], [0, 4, 0, 4]);

		// wires
		translate(wire_pos)
		for (i = [0 : wires - 1]) {
			translate([wire_spacing * i, 0, 0])
			rotate([0, 0, 90])
			wire(l = 2, g = wire_gauge, s2 = 1, col = wire_col[i]);
		}
	}

	module housing() {
		*translate([0, 0, heights[1] / 2])
		cube([CAM_CMOS_MICRO_HOUSING_DIM[0], CAM_CMOS_MICRO_HOUSING_DIM[1], heights[1]], true);
		translate([0, 0, CAM_CMOS_MICRO_HOUSING_DIM[2] / 2])
		cube(CAM_CMOS_MICRO_HOUSING_DIM, true);
	}

	module lens_body() {
		difference() {
			union() {
				translate([0, 0, ])
				cylinder(h = heights[2], r = rads[0]);

				translate([0, 0, heights[2]])
				cylinder(h = heights[3], r = rads[1]);

				translate([0, 0, heights[2] + heights[3]])
				cylinder(h = heights[4], r = rads[2]);


				translate([0, 0, heights[2] + heights[3] + heights[4]])
				cylinder(h = heights[5], r = rads[3]);
			}

			translate([0, 0, heights[2] + heights[3] + heights[4] + rads[3]])
			sphere(rads[3]);
		}
	}

	rotate([90, 0, 90])
	translate([0, 0, -dim[2] / 2]) {

		board();

		color(COLOUR_GREY_DARK)
		translate([0, 0, heights[0]]) {
			housing();

			translate([0, 0, heights[1]])
			lens_body();
		}

		color(COLOUR_RED_DARK)
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

*
cam_cmos_micro();
