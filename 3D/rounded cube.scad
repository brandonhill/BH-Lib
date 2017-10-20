// ****************************************************************************
// Rounded cube

module rounded_cube(dim, r, edges = false, center = true, $fa = $fa, $fn = $fn, $fs = $fs) {

	if (r <= 0) {
		cube(dim, center);

	} else {
		let(
			_dim = dim[0] && dim[1] && dim[2] ? dim : [dim, dim, dim],
			_r = min(r, min(_dim) / 2)) {

			if (r > _r)
				warn(str("rounded_cube radius ", r, " exceeds maximum due to dimensions, reduced to ", _r));

			translate(center ? 0 : _dim / 2)
			hull()
			for (x = [-1, 1], y = [-1, 1], z = [-1, 1])
				scale([x, y, z])
				translate([_dim[0] / 2 - _r, _dim[1] / 2 - _r, _dim[2] / 2 - _r]) {
					if (edges)
						sphere_true(_r, $fa = $fa, $fn = $fn, $fs = $fs);
					else
						sphere(_r, $fa = $fa, $fn = $fn, $fs = $fs);
				}
		}
	}
}
