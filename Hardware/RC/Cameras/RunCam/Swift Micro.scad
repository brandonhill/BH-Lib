/******************************************************************************
 * RunCam Swift Micro CCD camera
 */

include <../../../../colours.scad>;
include <../../../../helpers.scad>;

CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM = [19.25, 19.25, 6.2]; // includes plug
CAM_RUNCAM_SWIFT_MICRO_HOUSING_DIM = [
	CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM[0],
	CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM[1],
	7];
CAM_RUNCAM_SWIFT_MICRO_LENS_HEIGHTS = [2, 3, 3];
CAM_RUNCAM_SWIFT_MICRO_PIVOT_OFFSET = -11.5;
CAM_RUNCAM_SWIFT_MICRO_RAD = [10.25, 7, 12] / 2;
CAM_RUNCAM_SWIFT_MICRO_DIM = [
	CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM[0],
	CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM[1],
	CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM[2]
	+ CAM_RUNCAM_SWIFT_MICRO_HOUSING_DIM[2]
	+ sum(CAM_RUNCAM_SWIFT_MICRO_LENS_HEIGHTS)
];

module cam_runcam_swift_micro(
		board_dim = CAM_RUNCAM_SWIFT_MICRO_BOARD_DIM,
		dim = CAM_RUNCAM_SWIFT_MICRO_DIM,
		housing_dim = CAM_RUNCAM_SWIFT_MICRO_HOUSING_DIM,
		lens_heights = CAM_RUNCAM_SWIFT_MICRO_LENS_HEIGHTS,
		pivot_offset = CAM_RUNCAM_SWIFT_MICRO_PIVOT_OFFSET,
		rads = CAM_RUNCAM_SWIFT_MICRO_RAD,
	) {

	pcb_thickness = 1.5;
	plug_dim = [10, 3.2, board_dim[2] - pcb_thickness];
	plug_pos = [(board_dim[0] - plug_dim[0]) / 2, (board_dim[1] - plug_dim[1]) / 2, plug_dim[2] / 2];

	module board() {

		// plug
		color(COLOUR_WHITE)
		translate(plug_pos)
		cube(plug_dim, true);

		// PCB
		color(COLOUR_PCB)
		translate([0, 0, board_dim[2] - pcb_thickness])
		linear_extrude(1.5)
		shape_board();

		// wires
		*translate(wire_pos)
		for (i = [0 : wires - 1]) {
			translate([wire_spacing * i, 0, board_dim[2] / 3])
			rotate([0, 0, -90])
			wire(l = 2, g = wire_gauge, s2 = 1, col = wire_col[i]);
		}
	}

	module shape_board() {
		square([board_dim[0], board_dim[1]], true);
	}

	module shape_housing() {
		inset_factor = 0.7;
		pivot_thickness = 6;
		r = 3.35 / 2;

		hull()
		for (x = [1, -1], y = [1])
		scale([x, x * y])
		translate([-(housing_dim[0] / 2 - r), (housing_dim[0] / 2 - r)])
		circle(r);

		square([housing_dim[0], pivot_thickness], true);

		square([housing_dim[0] * inset_factor, housing_dim[1] * inset_factor], true);
	}

	module housing() {
		linear_extrude(housing_dim[2], convexity = 2)
		shape_housing();
	}

	module lens_body() {
		difference() {
			union() {
				color(COLOUR_ORANGE)
				translate([0, 0, 0])
				cylinder(h = lens_heights[0], r = rads[0]);

				color(COLOUR_GREY_DARK) {
					translate([0, 0, lens_heights[0]])
					cylinder(h = lens_heights[1], r = rads[1]);

					translate([0, 0, lens_heights[0] + lens_heights[1]])
					cylinder(h = lens_heights[2], r = rads[2]);
				}
			}

			*translate([0, 0, sum(lens_heights)])
			cylinder(h = lens_heights[2], r = rads[2] * 0.9, center = true);
		}
	}

// 	union()
	rotate([90, 0, 90])
	{

		board();
		translate([0, 0, board_dim[2]]) {

			color(COLOUR_ORANGE)
			difference() {
				housing();

				translate([0, 0, -pivot_offset - board_dim[2]])
				rotate([0, 90])
				cylinder(h = board_dim[0] + 1, r = 1, center = true);
			}
			translate([0, 0, housing_dim[2]]) {

				lens_body();
			}

			*color(COLOUR_RED_DARK)
			translate([0, 0, housing_dim[2] + sum(lens_heights) - 1])
			scale([1, 1, 0.25])
			intersection() {
				difference() {
					sphere(rads[len(rads) - 1]);

					translate([0, 0, -rads[len(rads) - 1] * 1.5])
					cube(rads[len(rads) - 2] * 1.5 * 2, true);
				}

				cylinder(h = 100, r = rads[len(rads) - 1] * 0.9);
			}
		}
	}
}

*cam_runcam_swift_micro();
