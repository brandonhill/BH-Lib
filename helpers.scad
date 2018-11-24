/******************************************************************************
 * HELPERS
 */

include <constants.scad>;

/***
 * Converts vec3 to vec2 (drops 2nd index)
 */

function vec3toVec2(points) = [
		for (i = [0 : len(points) - 1]) [points[i][0], points[i][1]]
	];

/***
 * Circumference of a circle
 */

function circumference(r) = 2 * PI * r;

/***
 * Clamp a value between two limiting values
 */

function clamp(value, v1, v2) =
	let (_max = max(v1, v2), _min = min(v1, v2))
	min(_max, max(_min, value));

/***
 * Check if vector contains given value
 */

function contains(needle, haystack) = index_of(needle, haystack) >= 0;

/***
 * Trig in radians - accepts degree or radian argument
 */

function acosr(a, deg) = deg_to_rad(acos(a));
function cosr(a, deg) = cos(deg != undef ? deg : rad_to_deg(a));

function asinr(a, deg) = deg_to_rad(asin(a));
function sinr(a, deg) = sin(deg != undef ? deg : rad_to_deg(a));

function atanr(a) = deg_to_rad(atan(a));
function tanr(a, deg) = tan(deg != undef ? deg : rad_to_deg(a));

/***
 * Convert degrees to radians
 */

function deg_to_rad(a) = a * PI / 180;

/***
 * Determines $fn for given r, [$fa, $fn, $fs]
 *
 * See: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#.24fa.2C_.24fs_and_.24fn
 */

function get_fragments_from_r(r) =
 	(r < 1 / pow(1024, 2)) ? 3 : (
		($fn > 0) ?
			($fn >= 3 ? $fn : 3) :
			ceil(max(min(360 / $fa, r * 2 * PI / $fs), 5))
 	);

/***
 * Gets angle of a helix at given radius and pitch
 */

function helix_angle(r, pitch) = atan(pitch / (PI * 2 * r));

/***
 * Gets pitch of a helix at given angle and radius
 */

function helix_pitch(a, r) = tan(a) * PI * 2 * r;

/***
 * Removes empties
 */

function filter(v, _acc = [], _i = 0) = _i >= len(v) ? _acc : filter(v, concat(_acc, v[_i] != undef && len(v[_i]) ? [v[_i]] : []), _i + 1);

/***
 * Find index of a given value, -1 if not found
 */

function index_of(needle, haystack, _i = 0) =
	_i >= len(haystack) ? -1 : (haystack[_i] == needle ? _i : index_of(needle, haystack, _i + 1));


/***
 * Joins an array into a string
 */

function join(values, sep = ", ", _out = "", _i = 0) =
	_i >= len(values) ? _out :
		join(values, sep, str(_out, values[_i], _i + 1 == len(values) ? "" : sep), _i + 1);

/***
 * Chamfers while extruding a 2D shape
 */

module linear_extrude_chamfer(h, chamfer, round = false, center = true, convexity = 1, $fn = $fn) {

	render(convexity = convexity)
	translate([0, 0, center ? 0 : chamfer])
	minkowski() {

		// extrude
		linear_extrude(h - chamfer * 2, center = center, convexity = convexity)
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
 * Same as `rotate_extrude`, but with height
 * Note: it's a hack since you can't hull 2D shapes :(
 */

module linear_rotate_extrude(h = 1, a = 360, center = true, convexity = 1, $fn = 0) {

	_steps = round(max(2, $fn != 0 ? $fn : a / 360 * 12));

	translate([0, 0, center ? -h / 2 : 0])
	for (i = [0 : _steps - 1])
	hull()
	for (j = [0, 1])
	translate([0, 0, h / _steps * (i + j)])
	rotate([0, 0, a / _steps * (i + j)])
	rotate([90, 0])
	scale([1, 1, 0.001]) // hack!
	linear_extrude(1)
	children();
}

/***
 * Same as `lookup`, but also works with vectors
 */

function lookup_vector(i, table) =
	let(size = len(table),
		dim = max([ for (i = [0 : size - 1]) len(table[i][1]) ]))
	dim == 1 ? lookup(i, table) :
		[ for(col = [0 : dim - 1])
			let(vals = [ for (i = [0 : size - 1]) [table[i][0], table[i][1][col]] ])
			lookup(i, vals)
		];

/***
 * Offsets points
 */

function offset_point(p, delta = 0) =
	concat([
		p[0] + delta * 2,
		p[1] + delta * 2],
		len(p) > 2 ? p[2] + delta * 2 : []);

/***
 * Sweep a value (for animation)
 */

function oscillate(min = -1, max = 1, t = $t) = (
	(t < 0.5 ?
	t * 2 :
	1 - 2 * (t - 0.5)) * (max - min) + min
);

/***
 * Convert polar to cartesian coordinates
 */

function polar_to_cartesian (a, r) = [ cos(a) * r,  -sin(a) * r];
function polar_to_cartesianr(a, r) = [cosr(a) * r, -sinr(a) * r];

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
 * Convert radians to degrees
 */

function rad_to_deg(a) = a * 180 / PI;

/***
 * Point rotations
 */

function rotate_point_x(p, a) =
	let(p2 = len(p) > 2 ? p[2] : 0)
	[p[0],
	p[1] * cos(a) - p2 * sin(a),
	p[1] * sin(a) + p2 * cos(a)];

function rotate_point_y(p, a) =
	let(p2 = len(p) > 2 ? p[2] : 0)
	[p[0] * cos(a) - p2 * sin(a),
	p[1],
	p[0] * sin(a) + p2 * cos(a)];

function rotate_point_z(p, a) =
	concat([
		p[0] * cos(a) - p[1] * sin(a),
		p[0] * sin(a) + p[1] * cos(a)],
		len(p) > 2 ? p[2] : []);

function rotate_point(p, a) =
	let(a2 = len(a) > 2 ? a[2] : 0)
	rotate_point_z(rotate_point_y(rotate_point_x(p, a[0]), a[1]), a2);

function rotate_points(p, a) = [
	for (i = [0 : len(p) - 1])
		rotate_point(p[i], a)
	];

function translate_point(p, t) =
	concat(
		[p[0] + t[0], p[1] + t[1]],
		len(p) > 2 ? p[2] + (len(t) > 2 ? t[2] : 0) : []);

function translate_points(p, t) = [ for (i = [0 : len(p) - 1]) translate_point(p[i], t) ];

/***
 * Sum a vector
 */

function sum(v, _a = 0, _i = 0) =
	_i == len(v) ? _a : sum(v, _a + v[_i], _i + 1);

/***
 * Similar to `reflect` but without mirroring
 */

module transpose(pos = [], x = true, y = true, z = false) {
	for (
		_x = x == true ? [-1, 1] : (x && len(x) > 0 ? x : [1]),
		_y = y == true ? [-1, 1] : (y && len(y) > 0 ? y : [1]),
		_z = z == true ? [-1, 1] : (z && len(z) > 0 ? z : [1]))
		translate([pos[0] * _x, pos[1] * _y, len(pos) > 2 ? pos[2] * _z : 0])
		children();
}

/************************************************************
 * PRINTING
 *
 * expects constants PRINT_LAYER_HEIGHT, PRINT_NOZZLE_DIA, TOLERANCE_XY and TOLERANCE_Z
 */

// from http://manual.slic3r.org/advanced/flow-math
//function print_width(nozzle_dia) = nozzle_dia;// * 1.05; // meh

// clamps height to multiple of layer height
function print_height(n, layer_height = PRINT_LAYER_HEIGHT) = layer_height * ceil(n / layer_height);

// clamps width to multiple of extrusion width
function print_width(n, nozzle_dia = PRINT_NOZZLE_DIA) = nozzle_dia * ceil(n / nozzle_dia);

// adds tolerance (use where fit requires clearance)
function toleranceXY(n = 0) = n + TOLERANCE_XY;
function toleranceZ(n = 0) = n + TOLERANCE_Z;

/***
 * Formatted logging
 */

module error(msg) {
	print(concat(["[ERROR] "], msg));
}

module print(values, sep = "") {
	echo(join(values, sep));
}

module warn(msg) {
	print(concat(["[WARN] "], msg));
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

module reflect(x = true, y = true, z = false) {
	for (
		_x = x == true ? [-1, 1] : (x && len(x) > 0 ? x : [1]),
		_y = y == true ? [-1, 1] : (y && len(y) > 0 ? y : [1]),
		_z = z == true ? [-1, 1] : (z && len(z) > 0 ? z : [1]))
		scale([_x, _y, _z])
		children();
}

/***
 * Show half of the thing
 */

module show_half(r = [], t = [], d = 1000, 2d = false) {
	intersection() {
		if ($children)
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
