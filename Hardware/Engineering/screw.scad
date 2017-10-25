/******************************************************************************
 * Screw
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

include <constants.scad>;
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
		dim = SCREW_M2_DIM,
		h = 10,
		pitch = 0.25,
		threaded = false
	) {

	cylinder(h = dim[2], r = dim[1] / 2);

	translate([0, 0, -h])
	if (threaded) {
		metric_thread(diameter = dim[0], pitch = pitch, length = h, internal = false);
	} else {
		cylinder(h = h, r = dim[0] / 2);
	}
}

module screw_surround(
		h = 20,
		r = 1.75,

		cs_dim = [6, 2],
		cs_style = "none",
		attachCS = false,

		// wall thickness around hole
		walls = 1.5,
		attachWalls = false,

		// nut (probably only need this when cs_style = none)
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
	maxRad = max(cs_dim[0] / 2 + walls, nutRad + nutWalls);

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
				if (cs_style != "none") {
					hull () {
						if (cs_style == "recess") {

							// wall
							cylinder(cs_dim[1] + walls, cs_dim[0] / 2 + walls, cs_dim[0] / 2 + walls);

							// adjoining face
							if (attach && attachCS) {
								translate([-cs_dim[0] / 2 - walls, -r - inset, 0])
								cube([cs_dim[0] / 2 * 2 + walls * 2, 0.1, cs_dim[1] + walls]);
							}

						} else {

							// wall
							translate([0, 0, cs_dim[1]])
							cylinder(cs_dim[0] / 2 + walls, cs_dim[0] / 2 + walls, 0);
							cylinder(cs_dim[1], cs_dim[0] / 2 + walls, cs_dim[0] / 2 + walls);

							// adjoining face
							if (attach && attachCS) {
								translate([-cs_dim[0] / 2 - walls, -r - inset, 0])
								rotate([90, 0, 0])
								linear_extrude(0.1)
								polygon([
									[0, 0],
									[0, cs_dim[1]],
									[cs_dim[0] / 2 + walls, cs_dim[1] + cs_dim[0] / 2 + walls],
									[(cs_dim[0] / 2 + walls) * 2, cs_dim[1]],
									[(cs_dim[0] / 2 + walls) * 2, 0]
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
			screw_diff(h, r, cs_dim[0] / 2, cs_dim[1], cs_style);
		}
	}
}

module screw_diff(
		dim = SCREW_M2_DIM,
		h = 10,
		depth = 10,
		cs_style = "recess",
		tolerance = 0,
		mock = false,
	) {

	$fs = 1;

	union() {

		// hole
		translate([0, 0, -(h + tolerance)])
		cylinder(h = (h + tolerance), r = dim[0] / 2 + tolerance);

		// countersink
		if (cs_style != "none") {

			cylinder(h = depth, r = dim[1] / 2 + tolerance);

			if (cs_style == "bevel") {
				cylinder(h = dim[2], r1 = 0, r2 = dim[1] / 2 + tolerance);
			}
		}
	}

	%
	if (mock)
	screw(dim = dim, h = h);
}
