/******************************************************************************
 * Wire
 */

include <../../colours.scad>;

// TODO: move
function deg_between(a, b) = atan((b[1] - a[1]) / (b[0] - a[0]));
function dist_between(a, b) = sqrt(pow(b[0] - a[0], 2) + pow(b[1] - a[1], 2));

// AWG approximation (0 - 40)
function wire_dia(g, _g = 40, _dia = 0.0799) =
	g < 0 || g > 40 || g == _g ? _dia : wire_dia(g, _g - 1, _dia * 1.12293);

function wire_rad(g, insulation = true) =
	wire_dia(g) / 2 * (insulation ? 1.1 + (g / 40) * 1.6 : 1);

module wire_connect(
		a = [-10, -10, 0],
		b = [30, 10, 10],
		g = 24, // AWG
		h = 5, // height
		s = 0,
		s1 = false,
		s2 = false,
		col = COLOUR_BLACK
	) {

	s1 = s1 != false ? s1 : s;
	s2 = s2 != false ? s2 : s;

	r = h;

	// make height a radius more than delta Z
	h = h + abs(b[2] - a[2]);

	// determine angle, distance between XY coords
	deg = deg_between([a[0], a[1]], [b[0], b[1]]);
	dist = dist_between([a[0], a[1]], [b[0], b[1]]);

	translate(a)
	rotate([0, 0, deg]) {

		if (a[2] < b[2]) {
			translate([0, 0, h - r])
			rotate([0, 90, 0])
			wire(g = g, l = h - r, col = col, s1 = s1);
		}

		translate([0, 0, h - r])
		wire_arc(a = 90, g = g, s1 = a[2] < b[2] ? 0 : s1, col = col, r = r);

		translate([r, 0, h])
		wire(g = g, l = dist - r * 2, col = col);

		translate([dist, 0, h - r])
		rotate([0, 0, 180])
		wire_arc(a = 90, g = g, s1 = b[2] < a[2] ? 0 : s2, col = col, r = r);

		if (b[2] < a[2]) {
			translate([dist, 0, h - r])
			rotate([0, 90, 0])
			wire(g = g, l = h - r, col = col, s1 = s1);
		}
	}
}

*
wire_connect(g = 30, s = 2, col = COLOUR_RED);

module wire_arc(
		a = 180,
		r = 20,
		g = 18,
		s = 0,
		s1 = false,
		s2 = false,
		col = COLOUR_BLACK
	) {

	s1 = s1 != false ? s1 : s;
	s2 = s2 != false ? s2 : s;

	// calculate stripped insulation by percentage
	circ = 3.14159 * 2 * r;
	len_wire = circ * a / 360;
	s1_pct = s1 / len_wire;
	s2_pct = s2 / len_wire;

	module mask(a) {
		translate([0, 0, -(wire_rad(g, true) + 1)])
		linear_extrude(wire_rad(g, true) * 2 + 2)
		scale([1, -1])
		segment(a = 360 - a, r = r + wire_rad(g, true) + 1);
	}

	translate([r, 0, 0])
	rotate([90, 0, 180]) {
		color(COLOUR_COPPER)
		difference() {
			rotate_extrude()
			translate([r, 0])
			circle(wire_rad(g));

			mask(a);
		}

		color(col)
		difference() {
			rotate_extrude()
			translate([r, 0])
			circle(wire_rad(g, true));

			rotate([0, 0, a * s1_pct])
			mask(a - (a * s1_pct + a * s2_pct));
		}
	}
}

*
wire_arc(s = 2);

module wire(
		l = 10,
		g = 18,
		s = 0,
		s1 = false,
		s2 = false,
		col = COLOUR_BLACK
	) {

	s1 = s1 != false ? s1 : s;
	s2 = s2 != false ? s2 : s;

	module conductor() {
		cylinder(h = l, r = wire_rad(g));
	}

	module insulation() {

		// make a tiny bit shorter than conductor
		l = l - 0.02;

		translate([0, 0, 0.01])
		difference() {
			cylinder(h = l - (s1 + s2), r = wire_rad(g, true));
			translate([0, 0, -0.1])
			cylinder(h = l + 0.2, r = wire_rad(g));
		}
	}

	rotate([0, 90, 0]) {

		// wire
		color(COLOUR_COPPER)
		conductor();

		// insulation
		color(col)
		translate([0, 0, s1])
		insulation();
	}
}

//$fs = 0.1;
*
wire(s1 = 2);//, s2 = 4);
