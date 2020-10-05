// ****************************************************************************
// rounded gear shape (for knobs)

include <smooth.scad>

module rounded_gear(r = 10, n = 3) {

	a = 360 / n / 4;
	r_point = sin(a) * r;

	// dim check
	// #circle(r);

	smooth_acute(r_point) {
		circle(r - r_point * 2);
		for (i = [0 : n - 1])
			rotate([0, 0, 360 / n * i])
			hull()
			for (j = [-1, 1])
				translate([(r - r_point) * j, 0])
				circle(r_point);
	}
}
