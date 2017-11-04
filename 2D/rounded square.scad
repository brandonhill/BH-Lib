// ****************************************************************************
// rounded square

module rounded_square(dim, r, center = true) {

	// limit r to half of smallest dimension
	_r = min(r, min(dim) / 2);

	// warn if r exceeds max
	if (r > _r)
		echo(str("WARNING: rounded_square(", dim, ", ", r, ", ", center, ") limited to max. r of ", _r));

	if (r <= 0)
		square(dim, center);
	else
		translate([center ? -dim[0] / 2 : 0, center ? -dim[1] / 2 : 0, 0])
		hull() {
			translate([_r, _r, 0])
			circle(_r);

			translate([_r, dim[1] - _r, 0])
			circle(_r);

			translate([dim[0] - _r, dim[1] - _r, 0])
			circle(_r);

			translate([dim[0] - _r, _r, 0])
			circle(_r);
		}
}
