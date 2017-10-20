/******************************************************************************
 * Propellor
 */

/*
helix:

x(h) = r * cos(h)
y(h) = r * sin(h)
z(h) = slope * r * h

angle(r) = atan(pitch / (PI * 2 * r))

*/

// Describes the upper surface as a percent of chord
function airfoilTop(p) = lookup(p, [
	[0,		0],
	[1.25,	0.04],
	[2.5,	0.0579],
	[5,		0.082],
	[7.5,	0.1],
	[10,	0.1138],
	[15,	0.13],
	[20,	0.1385],
	[25,	0.1429],
	[30,	0.1418],
	[35,	0.1384],
	[40,	0.1321],
	[50,	0.1129],
	[60,	0.0894],
	[70,	0.0622],
	[80,	0.0378],
	[90,	0.0157],
	[100,	0]
]);

// Describes the lower surface as a percent of chord
function airfoilBottom(p) = lookup(p, [
	[0,		0],
	[5,		-0.03],
	[10,	-0.04],
	[50,	-0.03],
	[100,	0]
]);

steps = 100;

module airfoil(width, min_thickness) {

	step = 100 / steps;

	polygon([
		for (pct = [0 : step : 100]) [width * pct / 100, airfoilTop(pct)],
		for (pct = [0 : step : 100]) [width * pct / 100, airfoilBottom(pct)]
	]);
}

// airfoil(6);

module prop(
	d,
	p,
	hole_rad,
	hub_height,
	hub_rad = false,
	thickness = 0.5,
	blades = 2,
	blade_width = false) {

	blade_width = blade_width ? blade_width : hub_rad * 2;
	hub_rad = hub_rad != false ? hub_rad : hole_rad * 3;

	module blade(r = 1, p = 1, h = 1, w = 1) {

		thicken_pct = 150 / 100;
		step = $fs;
		steps = r / step;

		rotate([90, 0, 0]) {
			intersection() {

				translate([-w, 0, 0])
				cube([w, h, r]);

				for (i = [0 : steps])
					translate([0, 0, i * step])
					linear_extrude(step) {
						a = atan(p / (PI * 2 * i * step));

						*echo(str(
							"r=", i * step
							,", pct=", (steps - i) / steps
							,", factor=", 1 + (steps - 1 - i) / steps * thicken_pct
							,", thickness=", thickness * (1 + (steps - 1 - i) / steps * thicken_pct)
						));

						// slope
						rotate([0, 0, -a])
						square([
							pow(w, 2),
							thickness * (1 + (steps - 1 - i) / steps * thicken_pct)
						], true)
						//rounded_square([pow(w, 2), thickness * (steps - i + 1) / steps * thicken_pct], 0.5, true)
						;
					}
			}

			// dim check
			*#
			translate([0, 0, r / 2])
			cube([w, h, r], true);
		}
	}

	difference() {
		union() {
			// blades
			for (i = [0 : blades - 1])
				rotate([0, 0, 360 / blades * i])
				blade(d / 2, p, hub_height, blade_width);

			// hub
			cylinder(h = hub_height, r = hub_rad);
		}

		// shaft hole
		translate([0, 0, -0.1])
		linear_extrude(hub_height + 0.2)
		polyhole(hole_rad);
	}
}

/*
$fs = 0.5;

// 60x10mm
// prop(60, 10, 0.75, 3.75, 3);

// 4x2.5"
prop(
	d = 4 * MMPI,
	p = 2.5 * MMPI,
	hole_rad = 2.5,
	hub_height = 6,
	hub_rad = 5,
	blades = 2
	//,blade_width = 14
);

// 5x3"
*prop(
	d = 5 * MMPI,
	p = 3 * MMPI,
	hole_rad = 0,//2.5,
	hub_height = 6,
	hub_rad = 1,//5.5,
	blades = 1
	,blade_width = 14
);

//*/
