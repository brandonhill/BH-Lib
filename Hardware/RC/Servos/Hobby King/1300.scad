/******************************************************************************
 * Hobby King 1300 micro linear servo
 */

include <../../../../colours.scad>;
include <../../../Electrical/Chip.scad>;
include <../../../Electrical/Wire.scad>;

SERVO_HK_1300_DIM = [19, 15, 7.6]; // bounding box
SERVO_HK_1300_ARM_DIM = [4, 1, 1.8];
SERVO_HK_1300_ARM_Y = -2;
SERVO_HK_1300_BOARD_DIM = [15.4, SERVO_HK_1300_DIM[1], 0.5];
SERVO_HK_1300_THROW = 4; // +/-

// a = angle (consistent terminology with non-linear servos), -1 to 1
module servo_hk_1300(a = 0) {

	// specs

	dim = SERVO_HK_1300_DIM;

	arm_dim = SERVO_HK_1300_ARM_DIM;
	arm_holes = 3;
	arm_hole_rad = 0.333;
	arm_hole_spacing = arm_dim[0] / (arm_holes + 1);

	board_col = COLOUR_RED;
	board_dim = SERVO_HK_1300_BOARD_DIM;
	board_hole_rad = 0.6;
	board_cutout = [5.5, 1.5];

	gear_rad = 3.25;
	gear_thickness = 0.8;

	housing_dim = [board_dim[0], 4.1, 4.3];

	motor_rad = 2;
	motor_length = 8;

	slot_dim = [housing_dim[0] - 2, arm_dim[1] * 1.2, housing_dim[2]];

	wires = 3;
	wire_col = [COLOUR_GREY_DARK, COLOUR_RED, COLOUR_YELLOW];
	wire_gauge = 28;
	wire_spacing = 1.25;
	wire_rad = wire_rad(wire_gauge, true);
	wire_pos = [-(dim[0] / 2 - 1), dim[1] / 2 - wire_spacing * wires - board_cutout[1], 1.5 + wire_rad];

	// positions

	arm_pos = [0, 0, housing_dim[2]];

	board_pos = [0, 0, 1];
	board_hole_pos = [4.2, board_dim[1] / 2 - board_hole_rad * 2];

	gear_pos = [housing_dim[0] / 2, 0, housing_dim[2] - 1.7];

	housing_pos = [0, SERVO_HK_1300_ARM_Y, board_pos[2] + board_dim[2]];

	motor_pos = [-1.5, 2.5, board_pos[2] + board_dim[2] + motor_rad + 0.5];

	// chip
	translate([1, -1, 1])
	rotate([180, 0, 0])
	chip([board_dim[0] / 3, board_dim[1] / 4, 1], [0, 5, 0, 5]);

	// board
	color(board_col)
	translate(board_pos)
	linear_extrude(board_dim[2])
	difference() {

		// board
		square([board_dim[0], board_dim[1]], true);

		// cutouts
		for (y = [0 : 1]) {
			translate([
				0,
				(board_dim[1] / 2) * (y == 0 ? -1 : 1)
			])
			rounded_square([board_cutout[0], board_cutout[1] * 2], board_hole_rad, true);

			for (x = [0 : 1]) {
				translate([
					(board_dim[0] / 2 - 0.5) * (x == 0 ? -1 : 1),
					(board_dim[1] / 2) * (y == 0 ? -1 : 1)
				])
				rounded_square([board_cutout[1] * 2, board_cutout[1] * 2], board_hole_rad, true);

				// holes
				translate([
					board_hole_pos[0] * (x == 0 ? -1 : 1),
					board_hole_pos[1] * (y == 0 ? -1 : 1),
					0
				])
				circle(board_hole_rad);
			}
		}
	}

	// motor
	translate(motor_pos)
	rotate([0, 90, 0]) {

		color(COLOUR_STEEL) {
			cylinder(r = motor_rad, h = motor_length);
			cylinder(r = motor_rad * 0.75, h = motor_length + 0.75);
		}

		color(COLOUR_WHITE) {

			// mounts
			translate([0, 0, 1.6])
			cylinder(r = motor_rad + 0.2, h = 1.4);
			translate([0, 0, 5.5])
			cylinder(r = motor_rad + 0.2, h = 1.4);

			// pinion
			translate([0, 0, motor_length + 1])
			cylinder(r = 1.25, h = 2);
		}
	}

	// housing
	color(COLOUR_WHITE)
	translate(housing_pos)
	translate([0, 0, housing_dim[2] / 2])
	difference() {
		cube(housing_dim, true);
		translate([0, 0, housing_dim[2] / 2])
		cube(slot_dim, true);
	}

	// gear
	color(COLOUR_WHITE)
	translate(gear_pos)
	translate(housing_pos)
	rotate([0, 90, 0]) {
		cylinder(h = gear_thickness + 1, r = gear_rad * 0.3);
		translate([0, 0, 0.5])
		cylinder(h = gear_thickness, r = gear_rad);
	}

	// stopper
	color(COLOUR_WHITE)
	translate([-gear_pos[0] - 0.25, gear_pos[1], gear_pos[2]])
	translate(housing_pos)
	rotate([0, -90, 0])
	linear_extrude(1.4)
	square([1, 3], true);

	// arm
	translate(arm_pos)
	translate(housing_pos)
	translate([max(-1, min(1, a)) * 4, 0, 0]) {
		translate([0, 0, arm_dim[2] / 2]) {
			children();

			color(COLOUR_WHITE)
			difference() {
				cube(arm_dim, true);

				// holes
				translate([-arm_hole_spacing, 0, 0])
				for (x = [0 : 2])
				translate([arm_hole_spacing * x, -(arm_dim[1] / 2 + 0.1), 0])
				rotate([-90, 0, 0])
				cylinder(h = arm_dim[1] + 0.2, r = arm_hole_rad);
			}
		}
	}

	// wires
	translate(wire_pos)
	translate([0, -(wire_spacing * wires - 1) / 2 + wire_rad * 2, 0])
	for (i = [0 : wires - 1]) {
		translate([0, wire_spacing * i, 0])
		wire(l = 2, g = wire_gauge, s2 = 1, col = wire_col[i]);
	}

	// dim check
	*
	#
	translate([0, 0, dim[2] / 2])
	cube(dim, true);
}

//$fs = 0.1;
*
servo_hk_1300();
