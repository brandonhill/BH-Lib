/******************************************************************************
 * Stepper motor
 */

module stepper_motor(
		dim,
		flange_dim = false,
		screw_dim = false,
		screw_hole_spacing = false,
		shaft_dim = false,
	) {

	screw_l = dim[2] / 2;

	difference() {
		union() {

			// body
			translate([0, 0, -dim[2] / 2])
			cube(dim, true);

			// flange
			if (flange_dim)
				cylinder(h = flange_dim[1], r = flange_dim[0] / 2);

			// shaft
			if (shaft_dim)
				cylinder(h = shaft_dim[1], r = shaft_dim[0] / 2);
		}

		// screw holes
		if (screw_dim && screw_hole_spacing)
			pos_stepper_motor_screws(screw_hole_spacing)
			screw(screw_dim, l = screw_l);
	}
}

module pos_stepper_motor_screws(spacing, places = [1, 1, 1, 1]) {
	for (i = [0 : 3])
		if (places[i])
		rotate([0, 0, 90 * i])
		translate([spacing / 2, spacing / 2])
		children();
}
