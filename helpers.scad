/******************************************************************************
 * HELPERS
 */

/***
 * Determines $fn for given $fa/$fs
 *
 * See: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#.24fa.2C_.24fs_and_.24fn
 */

function get_fragments_from_r(r, fa = $fa, fn = $fn, fs = $fs) =
// 	(r < GRID_FINE) ? 3 : (
		(fn > 0) ?
			(fn >= 3 ? fn : 3) :
			ceil(max(min(360 / fa, r * 2 * PI / fs), 5))
// 	)
;

/***
 * Gets angle of a helix at given radius and pitch
 */

function helix_angle(r, pitch) = atan(pitch / (PI * 2 * r));


/***
 * Joins an array into a string
 */

function join(values, sep = ", ", _out = "", _i = 0) =
	_i >= len(values) ? _out :
		join(values, sep, str(_out, values[_i], _i + 1 == len(values) ? "" : sep), _i + 1);

/***
 * Same as `lookup`, but also works with vectors
 */

function lookup_linear(i, table) =
	let(size = len(table),
		dim = max([ for (i = [0 : size - 1]) len(table[i][1]) ]))
	dim == 1 ? lookup(i, table) :
		[ for(col = [0 : dim - 1])
			let(vals = [ for (i = [0 : size - 1]) [table[i][0], table[i][1][col]] ])
			lookup(i, vals)
		];

/***
 * Creates array of polygon coordinates with faces at radius. Used for nuts and
 * critical internal radii. (Low poly `circle` has points at radius, so
 * effective radius is considerably reduced.)
 */

function poly_coords(n, r = 1, mid = true) = [
	for (i = [0 : n - 1]) [
		sin((360 / n / 2) + 360 / n * i),
		cos((360 / n / 2) + 360 / n * i)
	] * (mid ? r / cos(360 / n / 2) : r)
];

/***
 * Sweep a value (for animation)
 */

function oscillate(min = -1, max = 1, t = $t) = (
	(t < 0.5 ?
	t * 2 :
	1 - 2 * (t - 0.5)) * (max - min) + min
);

/***
 * Sum a vector
 */

function sum(v, a = 0, i = 0) =
	i == len(v) ? a : sum(v, a + v[i], i + 1);

/************************************************************
 * PRINTING
 *
 * expects constants PRINT_LAYER, PRINT_NOZZLE, TOLERANCE_XY and TOLERANCE_Z
 */

// from http://manual.slic3r.org/advanced/flow-math
function printExtrusionWidth(nozzle_dia) = nozzle_dia;// * 1.05; // meh

// clamps height to multiple of layer height
function printHeight(n) = PRINT_LAYER * ceil(n / PRINT_LAYER);

// clamps width to multiple of extrusion width
function printWall(n) = printExtrusionWidth(PRINT_NOZZLE) * ceil(n / printExtrusionWidth(PRINT_NOZZLE));

// adds tolerance (use where fit requires clearance)
function toleranceXY(n = 0) = n + TOLERANCE_XY;
function toleranceZ(n = 0) = n + TOLERANCE_Z;

/***
 * Formatted logging
 */

module error(msg) {
	print(["[ERROR] ", msg]);
}

module print(values) {
	echo(join(values, ""));
}

module warn(msg) {
	print(["[WARN] ", msg]);
}

/***
 * Orient for use in Unity3D
 */

module for_unity3d(scale = 0.001) {
	rotate([-90, 0, 0])
	rotate([0, 0, 90])
	scale(scale)
	children();
}

/***
 * Chamfers while extruding a 2D shape
 */

module linear_extrude_chamfer(h, chamfer, round = false, center = false, convexity = 1, $fn = $fn) {

	render(convexity = convexity)
	translate([0, 0, center ? 0 : chamfer])
	minkowski() {

		// extrude
		linear_extrude(h - chamfer * 2, center = center)//, convexity = convexity)
		offset(r = -chamfer)
		children();

		// this is the chamfer we're interested in
		if (round)
			sphere(chamfer, $fn = $fn);
		else
			for (z = [-1, 1])
				scale([1, 1, z])
				cylinder(h = chamfer, r1 = chamfer, r2 = 0);
	}
}

/***
 * For printing "separate" objects (with 0 separation) with different print settings.
 * Include this in each STL export (one per required settings group).
 */

module print_registration_bounds(bounds = [180, 180], h = 0.2, t = 0.5) {
	linear_extrude(h)
	difference() {
		square([bounds[0], bounds[1]], true);

		offset(r = -t)
		square([bounds[0], bounds[1]], true);
	}
}

/***
 * Mirrors X and Y axes by default (keeps original, unlike `mirror`)
 */

module reflect(x = [-1, 1], y = [-1, 1], z = false) {
	for (
		_x = x && len(x) > 0 ? x : [1],
		_y = y && len(y) > 0 ? y : [1],
		_z = z && len(z) > 0 ? z : [1])
		scale([_x, _y, _z])
		children();
}

/***
 * Show half of the thing
 */

module show_half(r = [0, 0, 0], t = [0, 0, 0], d = 1000, 2d = false) {
	intersection() {
		translate(t)
		rotate(r)
		translate([0, d / 2]) {
			if (2d) {
				square(d, true);
			} else {
				cube(d, true);
			}
		}
		children();
	}
}
