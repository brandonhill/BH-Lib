/******************************************************************************
 * Screw
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

include <nut.scad>;
include <threads.scad>;

module _X_screw(
		dim, // [dia., head_rad, head_height]
		l, // length
		poly = 0 // prints radius exactly
	) {

	// head
	if (dim[1] && dim[2]) {
		if (poly) {
			linear_extrude(dim[2])
			polygon(poly_coords(poly, dim[1] / 2));
		} else {
			cylinder(h = dim[2], r = dim[1] / 2);
		}
	}

	// shaft
	if (dim[0]) {
		translate([0, 0, -l])
		if (poly) {
			linear_extrude(l)
			polygon(poly_coords(poly, dim[0] / 2));
		} else {
			cylinder(h = l, r = dim[0] / 2);
		}
	}
}

module screw(
		thread_dia = 1,
		pitch = 0.25,
		length = 10,
		head_height = 1,
		head_rad = 1.5,
		threaded = false
	) {

	cylinder(h = head_height, r = head_rad);

	translate([0, 0, -length])
	if (threaded) {
		metric_thread(diameter = thread_dia, pitch = pitch, length = length, internal = false);
	} else {
		cylinder(h = length, r = thread_dia / 2);
	}
}

module screw_surround(
		h = 20,
		r = 1.75,
		csRad = 3,
		csDepth = 2,
		csStyle = "none",
		attachCS = false,

		// wall thickness around hole
		walls = 1.5,
		attachWalls = false,

		// nut (probably only need this when csStyle = none)
		nutRad = 2.5,
		nutDepth = 0,
		attachNut = false, // only applies when attach = true
		nutWalls = 2, // can make beefier than hole walls

		// attach to adjoining face
		attach = false,

		// inset the hole from a surface (typically used with attach = true)
		inset = 10,

		// show holes (usually want to difference the holes from final object)
		holes = false
	) {

	nutWalls = nutWalls ? nutWalls : walls;
	maxRad = max(csRad + walls, nutRad + nutWalls);

	difference() {
		intersection() {

			translate([-maxRad, attach ? -r - inset : -maxRad, 0])
			cube([maxRad * 2, maxRad * 2 + inset, h]);

			union() {
				hull() {

					// wall
					cylinder(h, r + walls, r + walls);

					// adjoining face (meets with wall)
					if (attach && attachWalls) {
						translate([-r - walls, -r - inset, 0])
						cube([(r + walls) * 2 , 0.1, h]);
					}
				}

				if (attach && !attachWalls) {
					translate([-(attach == true ? walls : attach) / 2, -r - inset, 0])
					cube([attach == true ? walls : attach, r + inset, h]);
				}

				// nut wall
				if (nutDepth) {
					hull () {
						translate([0, 0, h - nutDepth])
						cylinder(nutDepth, nutRad + nutWalls, nutRad + nutWalls);
						translate([0, 0, h - nutDepth - nutRad - nutWalls])
						cylinder(nutRad + nutWalls, 0, nutRad + nutWalls);

						// adjoining face
						if (attach && attachNut) {
							translate([-(nutRad + nutWalls), -r - inset, h])
									rotate([-90, 0, 0])
									linear_extrude(0.1)
									polygon([
										[0, 0],
										[0, nutDepth],
										[nutRad + nutWalls, nutDepth + nutRad + nutWalls],
										[(nutRad + nutWalls) * 2, nutDepth],
										[(nutRad + nutWalls) * 2, 0]
									]);
						}
					}
				}

				// countersink walls
				if (csStyle != "none") {
					hull () {
						if (csStyle == "recess") {

							// wall
							cylinder(csDepth + walls, csRad + walls, csRad + walls);

							// adjoining face
							if (attach && attachCS) {
								translate([-csRad - walls, -r - inset, 0])
								cube([csRad * 2 + walls * 2, 0.1, csDepth + walls]);
							}

						} else {

							// wall
							translate([0, 0, csDepth])
							cylinder(csRad + walls, csRad + walls, 0);
							cylinder(csDepth, csRad + walls, csRad + walls);

							// adjoining face
							if (attach && attachCS) {
								translate([-csRad - walls, -r - inset, 0])
								rotate([90, 0, 0])
								linear_extrude(0.1)
								polygon([
									[0, 0],
									[0, csDepth],
									[csRad + walls, csDepth + csRad + walls],
									[(csRad + walls) * 2, csDepth],
									[(csRad + walls) * 2, 0]
								]);
							}
						}
					}
				}
			}
		}

		translate([0, 0, h - nutDepth])
		nut(nutDepth, nutRad);

		if (holes) {
			screw_diff(h, r, csRad, csDepth, csStyle);
		}
	}
}

module screw_diff(h = 20, r = 1.75, csRad = 3, csDepth = 2, csStyle = "none") {

	$fs = 1;

	union() {

		// hole
		cylinder(h, r, r);

		// countersink
		if (csStyle != "none") {
			cylinder(csDepth, csRad, csRad);
			if (csStyle == "bevel") {
				translate([0, 0, csDepth])
				cylinder(csRad, csRad, 0);
			}
		}
	}
}
