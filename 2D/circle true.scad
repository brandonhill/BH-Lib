// ****************************************************************************
// Circle with edges (instead of vertices) at radius

use <../helpers.scad>;

module circle_true(r, center = true, $fa = $fa, $fn = $fn, $fs = $fs) {
	translate([center ? 0 : r / 2, center ? 0 : r / 2])
	polygon(poly_coords(get_fragments_from_r(r, $fa, $fn, $fs), r));
}

