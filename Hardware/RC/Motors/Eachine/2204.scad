/******************************************************************************
 * Eachine 2204 ?kv brushless motor (from Racer 250)
 */

include <../../../../colours.scad>;
include <../generic.scad>;

/*
MOTOR_2204_DIM = [28, [7, 11, 12]];
MOTOR_2204_HEIGHT = 18;
MOTOR_2204_RAD = 14;
MOTOR_2204_SHAFT_RAD = 5 / 2;
MOTOR_2204_SCREW_SPACING = [16, 19];
MOTOR_2204_SCREW_DEPTH = 4;
MOTOR_2204_CLEARANCE_DIM = [8, 2]; // dia, height
*/

MOTOR_EACHINE_2204_BELL_HEIGHT = 11;
MOTOR_EACHINE_2204_HEIGHT = 18;
//MOTOR_EACHINE_2204_HEIGHT_GROSS = 25.5;
MOTOR_EACHINE_2204_RAD = 14;
MOTOR_EACHINE_2204_MOUNT_AXLE_DEPTH = 2;
MOTOR_EACHINE_2204_MOUNT_AXLE_RAD = 4; // at base, for clearance
MOTOR_EACHINE_2204_MOUNT_HEIGHT = 3;
MOTOR_EACHINE_2204_MOUNT_HOLE_DEPTH = 4;
MOTOR_EACHINE_2204_MOUNT_SCREW_DIM = SCREW_M3_SOCKET_DIM;
MOTOR_EACHINE_2204_MOUNT_HOLES = 4;
MOTOR_EACHINE_2204_MOUNT_RAD = [8, 9.5];
MOTOR_EACHINE_2204_SHAFT_HEIGHT = 12;
MOTOR_EACHINE_2204_SHAFT_RAD = 2.5;

module pos_motor_eachine_2204_screws() {
	mount_rads_vary = MOTOR_EACHINE_2204_MOUNT_RAD[1] != undef;
	n_max = MOTOR_EACHINE_2204_MOUNT_RAD[1] ? len(MOTOR_EACHINE_2204_MOUNT_RAD) : MOTOR_EACHINE_2204_MOUNT_HOLES;
	mount_rads = [
		for (i = [0 : n_max - 1])
			mount_rads_vary ? MOTOR_EACHINE_2204_MOUNT_RAD[i] : MOTOR_EACHINE_2204_MOUNT_RAD
	];

	rotate([0, 0, 360 / MOTOR_EACHINE_2204_MOUNT_HOLES / 2])
	for (n = [0 : n_max - 1])
	rotate([0, 0, 360 / MOTOR_EACHINE_2204_MOUNT_HOLES * n])
	reflect(x = mount_rads_vary, y = false)
	translate([mount_rads[n], 0])
	children();
}

module motor_eachine_2204(
		detail = "low", // "high", "low"
	) {

	top_height = MOTOR_EACHINE_2204_HEIGHT - MOTOR_EACHINE_2204_BELL_HEIGHT - MOTOR_EACHINE_2204_MOUNT_HEIGHT;

	color(COLOUR_GREY_DARK)
	difference() {
		motor_base(
			h = MOTOR_EACHINE_2204_MOUNT_HEIGHT * (detail == "high" ? 0.95 : 1),
			r = MOTOR_EACHINE_2204_RAD,
			n = detail == "high" ? 6 : undef,
			arm_width = MOTOR_EACHINE_2204_RAD * 0.5,
			bevel = 0.9,
			inner_rad = MOTOR_EACHINE_2204_RAD * 0.9,
			thickness = 1
		);

		// mount holes
		pos_motor_eachine_2204_screws()
		translate([0, 0, -0.1])
		cylinder(h = MOTOR_EACHINE_2204_MOUNT_HEIGHT + 0.2, r = MOTOR_EACHINE_2204_MOUNT_SCREW_DIM[0] / 2);
	}

	translate([0, 0, MOTOR_EACHINE_2204_MOUNT_HEIGHT]) {
		motor_bell(
			MOTOR_EACHINE_2204_BELL_HEIGHT,
			MOTOR_EACHINE_2204_RAD,
			poles = detail == "high" ? 12 : undef,
			col = COLOUR_GREY_DARK
		);

		if (detail == "high")
		motor_stator(
			MOTOR_EACHINE_2204_BELL_HEIGHT,
			MOTOR_EACHINE_2204_RAD - 1.6,
			poles = 9
		);

		color(COLOUR_GREY_DARK)
		translate([0, 0, MOTOR_EACHINE_2204_BELL_HEIGHT]) {
			translate([0, 0, top_height])
			scale([1, 1, -1])
			motor_base(
				h = top_height,
				r = MOTOR_EACHINE_2204_RAD,
				n = detail == "high" ? 6 : undef,
				arm_width = MOTOR_EACHINE_2204_RAD * 0.6,
				bevel = 0.9
			);
		}
	}

	// collar
	*color(COLOUR_GREY_DARK)
	translate([0, 0, MOTOR_EACHINE_2204_HEIGHT])
	cylinder(
		h = MOTOR_EACHINE_2204_HEIGHT_GROSS - MOTOR_EACHINE_2204_SHAFT_HEIGHT - MOTOR_EACHINE_2204_HEIGHT,
		r = MOTOR_EACHINE_2204_RAD * 0.5
	);

	// shaft
	color(COLOUR_STEEL)
	translate([0, 0, -MOTOR_EACHINE_2204_MOUNT_AXLE_DEPTH])
	cylinder(
		h = MOTOR_EACHINE_2204_MOUNT_AXLE_DEPTH + MOTOR_EACHINE_2204_HEIGHT + MOTOR_EACHINE_2204_SHAFT_HEIGHT,
		r = MOTOR_EACHINE_2204_SHAFT_RAD
	);

	// axle end
	color(COLOUR_STEEL)
	translate([0, 0, -MOTOR_EACHINE_2204_MOUNT_AXLE_DEPTH / 2])
	cylinder(
		h = MOTOR_EACHINE_2204_MOUNT_AXLE_DEPTH / 2,
		r = MOTOR_EACHINE_2204_MOUNT_AXLE_RAD
	);
}

*motor_eachine_2204();
