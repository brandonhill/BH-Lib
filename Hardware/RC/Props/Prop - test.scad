
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/_helpers.scad>;
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/bh_lib.scad>;
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/polyhole.scad>;

MMPI = 25.4;
PI = 3.14159;

/*
helix:

x(h) = r * cos(h)
y(h) = r * sin(h)
z(h) = slope * r * h

angle(r) = atan(pitch / (PI * 2 * r))

*/

// Describes the upper surface as a percent of chord
function airfoil_top(p) = lookup(p, [
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
function airfoil_bottom(p) = lookup(p, [
	[0,		0],
	[5,		-0.03],
	[10,	-0.04],
	[50,	-0.03],
	[100,	0]
]);

module printable_blade(dia, pitch, width, thickness, hub_height, hub_rad, hub_hole_rad, screw_hole_spacing, screw_hole_rad) {

	rad = dia / 2;
	steps = get_fragments_from_r(rad, $fa, $fn, $fs);

	thicknesses = [
		[0, 10],
		[25, 1],
		[85, 1],
		[100, 1],
	];

	widths = [
		[0, 0.6],
		[50, 1],
		[100, 0.7],
	];

	module blade(anchor_front = true) {
		
		step = rad / steps;
		
		intersection() {

			rotate([180, -90])
			for (i = [1 : steps]) let (r0 = step * (i - 1), r1 = step * i)
				hull() {
					translate([0, 0, r0])
					rotate([0, 0, helix_angle(r0, pitch)])
					segment(
						anchor_front,
						width * lookup(r0 / rad * 100, widths),
						thickness * lookup(r0 / rad * 100, thicknesses));

					translate([0, 0, r1])
					rotate([0, 0, helix_angle(r1, pitch)])
					scale([1, 1, -1])
					segment(
						anchor_front,
						width * lookup(r1 / rad * 100, widths),
						thickness * lookup(r1 / rad * 100, thicknesses));
				}

			union() {
				translate([0, anchor_front ? -hub_height : 0, anchor_front ? 0 : -width])
				cube([rad, hub_height, width]);

				translate([rad * 0.3, anchor_front ? -hub_height : -thickness, anchor_front ? 0 : -width])
				cube([rad, hub_height + thickness, width]);
			}
		}
	}

	module hub() {
		hull()
		for (x = [-1, 1])
			scale([x, 1])
			translate([screw_hole_spacing / 2, 0])
			cylinder(h = hub_height, r = hub_rad);
	}

	module segment(anchor_front = true, width, thickness) {
	
		step = 100 / steps;
	
		translate([anchor_front ? 0 : -width, 0])
		linear_extrude(0.01)
		//scale([1, -1])
// 		polygon([
// 			for (pct = [0 : step : 100]) [width * pct / 100, (airfoil_top(pct) + thickness / 2)],
// 			for (pct = [0 : step : 100]) [width * (100 - pct) / 100, (airfoil_bottom(100 - pct) - thickness / 2)]
// 		]);
		translate([0, -thickness / 2])
		square([width, thickness]);
	}

	difference() {

		union() {

			blade();

			translate([0, -hub_height])
			rotate([0, 180])
			blade(false);

			// hub
			translate([0, 0, hub_rad])
			rotate([90, 0])
			hub();
		}

		// holes
		translate([0, 0, hub_rad])
		rotate([90, 0])
		translate([0, 0, -width])
		linear_extrude(width * 2, convexity = 2) {
			for (x = [-1, 1])
				scale([x, 1])
				translate([screw_hole_spacing / 2, 0])
				polyhole(screw_hole_rad, $fn = 6);

			polyhole(hub_hole_rad, $fn = 6);
		}
	}
}

$fs = 0.1;

AXLE_DIA = 1.5;
SCREW_HOLE_SPACING = 5;
HUB_HEIGHT = 4;
HUB_RAD = 3;
SCREW_DIA = 2;
WIDTH = 9;
THICKNESS = 1;

printable_blade(3 * MMPI, 2 * MMPI, WIDTH, THICKNESS, HUB_HEIGHT, HUB_RAD, AXLE_DIA / 2, SCREW_HOLE_SPACING, SCREW_DIA / 2);

