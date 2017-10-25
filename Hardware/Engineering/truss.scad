/******************************************************************************
 * Truss
 */

// truss section
module truss_section(
		i,
		webLength,
		walls
	) {

	// determine even/odd section - "warren" alternates
	even = i % 2 == 0;

	module web() {
		l = webLength + walls * 4;
		translate([l / 2, 0, 0])
		square([l, webWidth], true);
	}

	module web_section() {
		union() {
			/*
			if (type == "k" || type == "pratt") {

				intersection() {
					if (type == "k") {
						union() {

							translate([0, inside[1] / sectionsY / 2, 0])
							rotate([0, 0, a])
							web();

							translate([0, inside[1] / sectionsY / 2, 0])
							rotate([0, 0, -a])
							web();
						}
					} else {
						rotate([0, 0, a])
						web();
					}

					// clip angled webbing
					cube([inside[0] / sections, inside[1] / sectionsY, webDepth]);
				}

				translate([inside[0] / sections - webThickness / 2, 0, 0])
				rotate([0, 0, 90])
				web();

			} else if (type == "warren") {

				translate([0, ((even ? inside[1] / sectionsY : 0)), 0])
				rotate([0, 0, a * (even ? -1 : 1)])
				web();

			} else
			//*/
			if (type == "x") {

				rotate([0, 0, a])
				web();

				translate([0, inside[1] / sectionsY, 0])
				rotate([0, 0, -a])
				web();
			}
		}
	}

	//intersection() {
		//square([inside[0] / (type == "k" || type == "pratt" ? 1 : sections), inside[1] / sectionsY], true);

		translate([-inside[0] / sections / 2, -inside[1] / sectionsY / 2])
		web_section();
	//}
}

module truss_shape(
		dim = [100, 25],
		sections = false,
		sectionsY = false,
		webWidth = 1,
		type = "x",
		walls = 0
	) {

	inside = [
		dim[0] - walls * (type == "k" || type == "pratt" ? 1 : 2),
		dim[1] - walls * 2
	];

	sections = sections ? sections : round(dim[0] / dim[1]);
	sectionsY = max(1, (sectionsY ? sectionsY : 1));

	// determine angle of web
	a = atan((inside[1] / sectionsY / (type == "k" ? 2 : 1)) / (inside[0] / sections - (type == "k" || type == "pratt" ? walls : 0)));

	// determine length of web
	webLength = sqrt(
		pow(inside[0] / sections / 2, 2) +
		pow(inside[1] / sectionsY / 2, 2)
	) * 2;

	union() {

		// walls
		if (walls > 0)
			difference() {
				square(dim, true);
				offset(r = -walls)
				square(dim, true);
			}

		// sections
		intersection() {
			square(inside, true);

			translate([-dim[0] / 2 + walls, -dim[1] / 2 + walls])
			for (i = [0 : sections - 1], j = [0 : sectionsY - 1]) {
				translate([
					(i + 0.5) * inside[0] / sections,
					(j + 0.5) * inside[1] / sectionsY,
					0
				])
				truss_section(i + j);
			}
		}
	}
}

*truss_shape(
	dim = [100, 20],
	sections = 5,
	sectionsY = 1,
	webWidth = 1,
	walls = 1
);

module truss(

		// flat for printing; Y = height, Z = width
		dim = [140, 40, 6.35],

		// number of truss sections along X/Y
		sections,
		sectionsY,

		// web dims
		webDepth, // default = width
		webThickness = 1,
		webWidth = 5,

		// chord has L shape? true|false|"x"|"y"
		chordBrace = true,

		// truss type [k | pratt | warren | x]
		type = "warren",

		// thickness of outer walls
		walls = 2,

		// lay flat for printing
		flat = true,
	) {

	/*tmp = dim[1];
	dim = [
		dim[0],
		dim[2] > dim[1] ? dim[2] : dim[1],
		dim[2] > dim[1] ? tmp : dim[2]
	];
	//*/
	webDepth = webDepth ? webDepth : dim[2];
	inside = [
		dim[0] - walls * (type == "k" || type == "pratt" ? 1 : 2),
		dim[1] - walls * 2,
		max(dim[2], webDepth)
	];

	sections = sections ? sections : round(dim[0] / dim[1]);
	sectionsY = max(1, (sectionsY ? sectionsY : 1));

	echo(str("Sections: ", sections, "x", sectionsY));
	echo(str("Length: ", dim[0], ", Height: ", dim[1], ", Depth: ", dim[2]));
	echo(str("Webs: depth: ", webDepth, ", width: ", webWidth, ", thickness: ", webThickness));
	echo(str("Chords: brace: ", (chordBrace ? "Y" : "N"), ", thickness: ", walls));

	// frame
	module frame() {
		difference() {

			// outer dimension
			cube(dim);

			// inside chords
			translate([walls, walls, webThickness])
			cube([dim[0] - walls * 2, dim[1] - walls * 2, inside[2]]);


			// truss opening
			translate([chordBrace == true || chordBrace == "y" ? webWidth : walls, chordBrace == true || chordBrace == "x" ? webWidth : walls, -1])
			cube([
				dim[0] - (chordBrace == true || chordBrace == "y" ? webWidth : walls) * 2,
				dim[1] - (chordBrace == true || chordBrace == "x" ? webWidth : walls) * 2,
				inside[2] + 2
			]);
		}
	}

	translate([flat ? 0 : dim[0], 0, 0])
	rotate([flat ? 0 : 90, 0, flat ? 0 : 180])
	union () {

		frame();

		// truss sections
		intersection() {
			translate([walls, walls, 0])
			for (i = [0 : sections - 1], j = [0 : sectionsY - 1]) {
			echo("about to call section!");
				translate([
					i * inside[0] / sections,
					j * inside[1] / sectionsY,
					0
				])
				truss_section(i + j);
			}
			cube([dim[0], dim[1], max(webDepth, dim[2])]);
		}
	}
}

truss(
	dim = [100, 5, 50],
	type = "x",
	webDepth = 3,
	webWidth = 3,
	walls = 1,
	webWalls = 1
);

/* examples

truss(
	type = "x"
);

truss(
	//sections = 4,
	//sectionsY = 2,
	dim = [100, 30, 10]
);

translate([0, 40, 0])
truss(
	type = "x"
);

translate([0, 90, 0])
truss(
	dim = [120, 30, 4],
	type = "pratt"
);

translate([0, 130, 0])
truss(
	type = "k",
	sections = 3
);
//*/
