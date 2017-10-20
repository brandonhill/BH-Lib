// ****************************************************************************
// Capsule

module capsule(h = 10, r, r1, r2, center = false) {

	_r1 = r1 ? r1 : r;
	_r2 = r2 ? r2 : r;

	translate([0, 0, center ? -h / 2 : 0])
	hull () {
		translate([0, 0, h - _r2])
		sphere(_r2);

		translate([0, 0, _r1])
		sphere(_r1);
	}
}
