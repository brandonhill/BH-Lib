// ****************************************************************************
// Grid (for reinforcement, for example)

module grid(coords = [100, 100], x = 10, y = 10, walls = 1, edges = false, center = true) {

	hole = [
		(coords[0] - walls * (x + (edges ? 1 : -1))) / x,
		(coords[1] - walls * (y + (edges ? 1 : -1))) / y
	];

	module holes() {
		for (x = [0 : x - 1], y = [0 : y - 1])
			translate([
				(hole[0] + walls) * x,
				(hole[1] + walls) * y
			])
			square(hole);
	}

	difference() {

		if (edges) {
			square(coords, center);
		} else {
			square([coords[0] - 0.01, coords[1] - 0.01], center);
		}

		translate(center ? [-coords[0] / 2, -coords[1] / 2] : [])
		translate(edges ? [walls, walls] : [])
		holes();
	}
}
