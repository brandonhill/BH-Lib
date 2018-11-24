/******************************************************************************
 * Generic motor
 */

include <../../../colours.scad>;

module motor_bell(h, r, poles, col = COLOUR_STEEL, thickness = 0.75, magnet_thickness) {

	magnet_thickness = magnet_thickness ? magnet_thickness : thickness;
	magnet_dim = [magnet_thickness, PI * 2 * (r - thickness - magnet_thickness) / poles * 0.9, h * 0.95];

	// housing
	color(col)
	linear_extrude(h)
	difference() {
		circle(r);
		offset(r = -thickness)
		circle(r);
	}

	// magnets
	color(COLOUR_STEEL)
	for (i = [0 : poles - 1])
		rotate([0, 0, 360 / poles * i])
		translate([r - thickness - magnet_dim[0] / 2, 0, magnet_dim[2] / 2])
		cube(magnet_dim, true);
}

module motor_stator(h, r, poles) {

	translate([0, 0, h / 2])
	for (i = [0 : poles - 1])
		rotate([0, 0, 360 / poles * i]) {
			color(COLOUR_GREEN_DARK) {
				translate([r * 0.25, 0, 0])
				cube([r * 0.5, PI * 2 * r / poles * 0.5, h * 0.75], true);

				translate([r * 0.95, 0, 0])
				cube([r * 0.1, PI * 2 * r / poles * 0.5, h * 0.75], true);
			}

			color(COLOUR_COPPER)
			translate([r * 0.9, 0, 0])
			rotate([0, -90, 0])
			cylinder(h = r * 0.5, r = h * 0.333);
		}
}

module motor_base(h, r, n = 0, thickness = 0.5, arm_width, bevel = 0.85, inner_rad = 0) {

	arm_width = arm_width ? arm_width : r * 0.25;

	module bounds() {
		union() {
			cylinder(h - thickness, r1 = r * bevel, r2 = r);

			translate([0, 0, h - thickness])
			cylinder(thickness, r = r);
		}
	}

	difference() {
		union() {
			translate([0, 0, h - thickness])
			cylinder(h = thickness, r = r);

			if (inner_rad > 0)
				cylinder(h = thickness, r = inner_rad);

			//#
			//translate([0, 0, -thickness])
			intersection() {
				bounds();

				if (n)
					linear_extrude(h, convexity = 2)
					for (i = [0 : n - 1])
						rotate([0, 0, 360 / n * i])
						translate([r / 2, 0])
						square([r, arm_width], true);
			}
		}

		translate([0, 0, thickness])
		scale([1 - thickness / r, 1 - thickness / r, 1.001]) // diff not working right
		bounds();
	}

	// dim check
	//#cylinder(h = h, r = r);
}

module motor_mount_shaft(h, r) {
	cylinder(h, r);
}

module motor_mount_legs(n, width, thickness, r, hole_rad) {
	for (i = [0 : n - 1]) {
		rotate([0, 0, 360 / n * i])
		linear_extrude(thickness, convexity = 3)
		difference() {
			hull() {
				translate([r, 0])
				circle(r = width / 2);
				circle(r = width / 2);
			}

			// screw hole
			if (hole_rad)
			translate([r, 0])
			circle(hole_rad);
		}
	}
}

module motor_generic(
		height,
		rad,
		mount_arm_width,
		mount_height,
		mount_rad,
		mount_holes = 0,
		mount_hole_rad,
		mount_thickness,
		shaft_height,
		shaft_rad,
		col_bell = COLOUR_STEEL,
		col_mount = COLOUR_GREY_DARK
	) {

	mount_hole_surround = 1.5; // % hole rad

	union() {

		// bell
		color(col_bell)
		translate([0, 0, mount_height ? mount_height : 0])
		cylinder(h = height, r = rad);

		// mount
		color(col_mount) {
			if (mount_height) {

				// shaft type
				if (mount_holes == 0) {
					cylinder(h = mount_height, r = mount_rad);

				// hole type
				} else {
					cylinder(h = mount_height, r = mount_rad * 0.75);
					for (i = [0 : mount_holes - 1]) {
						rotate([0, 0, 360 / mount_holes * i])
						linear_extrude(mount_thickness)
						difference() {
							hull() {
								translate([0, mount_rad])
								circle(r = mount_arm_width / 2);
								circle(r = mount_arm_width / 2);
							}
							translate([0, mount_rad])
							circle(r = mount_hole_rad);
						}
					}
				}
			}
		}

		// shaft
		color(COLOUR_STEEL)
		translate([0, 0, height + (mount_height ? mount_height : 0)])
		cylinder(h = shaft_height, r = shaft_rad);
	}
}

*
motor_generic(
	height = 8,
	rad = 6.5,
	mount_height = 10,
	mount_rad = 3,
	shaft_height = 7,
	shaft_rad = 0.75
);
