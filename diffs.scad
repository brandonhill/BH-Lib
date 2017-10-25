/******************************************************************************
 * DIFFS - for diff'ing!
 */

use <bh_lib.scad>;

module diff_nut(dim, n = 1, mock = true, sides = 6, tolerance = 0) {

	height = dim[2] * n + tolerance * (n - 1);

	dim_tol = [
		tolerance * 2 + dim[0],
		tolerance * 2 + dim[1],
		tolerance * 2 + height
	];

	translate([0, 0, -tolerance])
	hull()
	nut(dim_tol, sides);

	if (mock) % nut([dim[0], dim[1], height], sides);
}

module diff_screw(
		dim,
		l,
		depth = 0,
		poly = 0,
		mock = true,
		tolerance = 0,
	) {

	dim_tol = [
		dim[0] + tolerance * 2,
		dim[1] + tolerance * 2,
		depth ? depth + tolerance : 0 // set head height to depth
	];

	translate([0, 0, tolerance / 2])
	screw(dim_tol, l + tolerance, poly);

	if (mock) % screw(dim, l);
}
