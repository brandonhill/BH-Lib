// ****************************************************************************
// rounded gear shape
// s = scale; [inner, outer]

module rounded_gear(r = 10, n = 3, inset = true, s = [1, 1]) {

	knob_angle = 360 / n / 4;
	knob_point_rad = sin(knob_angle) * r;
	scale_xy = inset ? r / (r + knob_point_rad) : 1;

	// dim check
	//#cylinder(h = height, r = r);

	scale([scale_xy, scale_xy, 1])
	difference() {
		union() {
			circle(cos(knob_angle) * r);
			for (i = [0 : n - 1])
				rotate([0, 0, 360 / n * i])
				translate([r, 0])
				scale([s[1], 1])
				circle(knob_point_rad);
		}

		rotate([0, 0, 360 / n / 2])
		for (i = [0 : n - 1])
			rotate([0, 0, 360 / n * i])
			translate([r, 0])
			scale([s[0], 1])
			circle(knob_point_rad);
	}
}
