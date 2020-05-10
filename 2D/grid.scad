// ****************************************************************************
// Grid (for reinforcement, for example)

module grid(
		dim = [100, 100],
		divisions = [10, 10],
		walls = 1,
		edges = true,
		center = true
	) {

	hole = [
		(dim[0] - walls * (divisions[0] + (edges ? 1 : -1))) / divisions[0],
		(dim[1] - walls * (divisions[1] + (edges ? 1 : -1))) / divisions[1]
	];

	module holes() {
		for (x = [0 : divisions[0] - 1], y = [0 : divisions[1] - 1])
			translate([
				(hole[0] + walls) * x,
				(hole[1] + walls) * y
			])
			square(hole);
	}

	difference() {

		if (edges) {
			square(dim, center);
		} else {
			square([dim[0] - 0.01, dim[1] - 0.01], center);
		}

		translate(center ? [-dim[0] / 2, -dim[1] / 2] : [])
		translate(edges ? [walls, walls] : [])
		holes();
	}
}
