/******************************************************************************
 * Truss
 */

// truss section
module truss_section(
		i,
		inside,
		sections,
		sectionsY,
		type,
		walls,
		webWidth
	) {

	// determine angle of web
	a = atan((inside[1] / sectionsY / (type == "k" ? 2 : 1)) / (inside[0] / sections - (type == "k" || type == "pratt" ? walls : 0)));

	// determine even/odd section - "warren" alternates
	even = i % 2 == 0;

	// determine length of web
	webLength = sqrt(
		pow(inside[0] / sections / 2, 2) +
		pow(inside[1] / sectionsY / 2, 2)
	) * 2;

	module web() {
		l = webLength + walls * 4;
		translate([l / 2, 0, 0])
		square([l, webWidth], true);
	}

	module web_section() {
		union() {
			//*
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
					square([inside[0] / sections, inside[1] / sectionsY]);
				}

				translate([inside[0] / sections - webWidth / 2, 0, 0])
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

	intersection() {
		square([inside[0] / (type == "k" || type == "pratt" ? 1 : sections), inside[1] / sectionsY], true);

		translate([-inside[0] / sections / 2, -inside[1] / sectionsY / 2])
		web_section();
	}
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

	union() {

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
				truss_section(i + j, inside, sections, sectionsY, type, walls, webWidth);
			}
		}
	}
}

module truss(

		// flat for printing; Y = height, Z = width
		dim,

		// number of truss sections along X/Y
		sections,
		sectionsY,

		// web dims
		webDepth, // default = width
		webWidth, // default = walls

		// chord has L shape? true|false|"x"|"y"
		chordBrace = true,

		// truss type [k | pratt | warren | x]
		type = "warren",

		// thickness of outer walls
		walls = 2,

		// lay flat for printing
		flat = true,
	) {

	webDepth = webDepth ? webDepth : dim[2];
	webWidth = webWidth ? webWidth : walls;
	inside = [
		dim[0] - walls * (type == "k" || type == "pratt" ? 1 : 2),
		dim[1] - walls * 2,
		max(dim[2], webDepth) ];
	sections = sections ? sections : round(dim[0] / dim[1]);
	sectionsY = max(1, (sectionsY ? sectionsY : 1));

	// frame
	module frame() {
		difference() {

			// outer dimension
			cube(dim);

			// inside chords
			translate([walls, walls, webWidth])
			cube([dim[0] - walls * 2, dim[1] - walls * 2, inside[2]]);

			// truss opening
			translate([chordBrace == true || chordBrace == "y" ? dim[2] : walls, chordBrace == true || chordBrace == "x" ? dim[2] : walls, -1])
			cube([
				dim[0] - (chordBrace == true || chordBrace == "y" ? dim[2] : walls) * 2,
				dim[1] - (chordBrace == true || chordBrace == "x" ? dim[2] : walls) * 2,
				inside[2] + 2
			]);
		}
	}

	translate([flat ? 0 : dim[0], 0, 0])
	rotate([flat ? 0 : 90, 0, flat ? 0 : 180])
	union () {

		frame();

		translate([dim[0] / 2, dim[1] / 2])
		linear_extrude(webDepth)
		truss_shape(dim, sections, sectionsY, webWidth, type, walls);
	}
}

/* examples

truss(
	dim = [120, 30, 5]
);

translate([0, 40, 0])
truss(
	dim = [120, 30, 5],
	type = "x"
);

translate([0, 80, 0])
truss(
	dim = [120, 30, 5],
	type = "pratt"
);

translate([0, 120, 0])
truss(
	dim = [120, 30, 5],
	type = "k"
);
//*/
