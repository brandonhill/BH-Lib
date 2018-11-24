/******************************************************************************
 * Screw
 *
 * See: http://www.metrication.com/engineering/threads.html
 */

include <constants.scad>;
include <nut.scad>;
include <threads.scad>;
include <../../2D/semicircle.scad>;
include <../../3D/cylinder true.scad>;
include <../../3D/sphere true.scad>;
use <washer.scad>;

module screw(
		dim = SCREW_M2_SOCKET_DIM,
		h = 10,
		pitch = 0.25,
		head = "socket", // bolt, flat, socket
		offset = 0, // for print tolerance
		reverse = false,
		socket, // hex, star
		threaded = false,
		washer_dim = false,
	) {

	if (washer_dim)
	washer(washer_dim);

	translate([0, 0, head == "flat" ? -dim[2] : 0])
	translate([0, 0, washer_dim ? washer_dim[2] : 0]) {

		// head
		difference() {
			if (head == "flat") {
				cylinder(h = dim[2], r2 = dim[1] / 2, r1 = dim[0] / 2);
			} else if (head == "bolt" || head == "socket") {
				cylinder_true(h = dim[2], r = dim[1] / 2, center = false, $fn = head == "bolt" ? 6 : $fn);
			}

			// socket
			if (socket == "hex") {
				translate([0, 0, dim[2] - dim[4] / 2 + 0.05])
				cylinder_true(h = dim[4] + 0.1, r = dim[3] / 2 + offset, $fn = 6);
			} else if (socket == "star") {
				// TODO
			}
		}

		// shaft
		translate([0, 0, -h])
		if (threaded) {
			thread_iso_metric(dim[0] - offset * 2, h, pitch, center = false, reverse = reverse);
		} else {
			cylinder(h = h, r = dim[0] / 2);
		}
	}
}

module screw_surround(
		dim = SCREW_M2_FLAT_DIM,
		h = 20,

		attach_cs = false,
		attach_walls = false,
		attach_nut = false, // only applies when attach = true
		attach = false, // attach to adjoining face
		cs_style = "none",
		end, // [undef | true (flat) | "rounded" | "point"]
		fn, // for surround (not hole)
		holes = false, // show holes (usually want to difference the holes from final object)
		inset, // [x, y]; inset from wall (typically used with attach = true)
		mock = false,
		nut = false,
		nut_dim = NUT_M2_DIM,
		nut_walls = 2, // can make beefier than hole walls
		pitch, // no threads if left undefined
		print_support,
		tolerance = 0,
		walls = 1.5, // wall thickness around hole
	) {

	if (end && nut)
		warn(["screw_surround() - `end` (", end, ") and `nut` (", nut, ") can't be used at the same time"]);

	r_outer = dim[0] / 2 + tolerance + walls;
	fn = fn != undef ? fn : get_fragments_from_r(r_outer);
	_end = end == true ? walls : (end == "point" ? r_outer * 2 : (end == "rounded" ? r_outer : 0));
	_inset = inset != undef ? inset : walls;
	r = dim[0] / 2 + tolerance;
	nut_walls = nut_walls ? nut_walls : walls;
	r_max = max(dim[1] / 2 + walls, nut_dim[1] / 2 + nut_walls);

	module print_support() {
		t = max(walls, (r_outer * tan(360 / fn / 2)) * 2);
		translate([0, 0, h])
		rotate([-90, 0, -90])
		linear_extrude(t, center = true)
		polygon([
			[0, 0],
			[-walls / 2, 0],
			[-walls / 2, h],
			[0, h],
			[h * 2/3, 0],
		]);
	}

	module surround() {

		// wall
		translate([0, 0, end == "rounded" ? -_end : 0])
		if (attach_walls)
			linear_extrude(h + (end == true ? _end : 0))
			semicircle_true(r_outer, $fn = fn);
		else
			cylinder_true(h = h + (end == true ? _end : 0), r = r_outer, $fn = fn, center = false);

		if (end == "point" || end == "rounded")
			translate([0, 0, h])
			if (attach_walls)
				difference() {
					sphere_true(r_outer, $fn = fn);
					translate([0, -r_outer])
					cube(r_outer * 2, true);
				}
			else
				sphere_true(r_outer, $fn = fn);

		if (end == "point") {
			translate([0, -r_outer, h + _end])
			sphere(0.05);
		}
	}

	difference() {
		intersection() {

			translate([-r_max, attach ? -r - _inset : -r_max, 0])
			cube([r_max * 2, r_max * 2 + _inset, h + _end]);

			union() {
				hull() {
					surround();

					// adjoining face (meets with wall)
					if (attach_walls) {
						translate([0, -r - _inset])
						rotate([-90, 0])
						linear_extrude(0.1)
						projection()
						rotate([90, 0])
						surround();
					}
				}

				if (attach && !attach_walls) {
					translate([-(attach == true ? walls : attach) / 2, -r - _inset, 0])
					cube([attach == true ? walls : attach, r + _inset, h]);
				}

				// nut wall
				if (nut) {
					hull () {
						translate([0, 0, h - nut_dim[2]])
						cylinder(nut_dim[2], nut_dim[1] / 2 + nut_walls, nut_dim[1] / 2 + nut_walls);
						translate([0, 0, h - nut_dim[2] - nut_dim[1] / 2 - nut_walls])
						cylinder(nut_dim[1] / 2 + nut_walls, 0, nut_dim[1] / 2 + nut_walls);

						// adjoining face
						if (attach && attach_nut) {
							translate([-(nut_dim[1] / 2 + nut_walls), -r - _inset, h])
									rotate([-90, 0, 0])
									linear_extrude(0.1)
									polygon([
										[0, 0],
										[0, nut_dim[2]],
										[nut_dim[1] / 2 + nut_walls, nut_dim[2] + nut_dim[1] / 2 + nut_walls],
										[(nut_dim[1] / 2 + nut_walls) * 2, nut_dim[2]],
										[(nut_dim[1] / 2 + nut_walls) * 2, 0]
									]);
						}
					}
				}

				// countersink walls
				hull () {
					if (cs_style == "recess") {

						// wall
						cylinder(dim[1] + walls, dim[0] / 2 + walls, dim[0] / 2 + walls, $fn = fn);

						// adjoining face
						if (attach && attach_cs) {
							translate([-dim[0] / 2 - walls, -r - _inset, 0])
							cube([dim[0] / 2 * 2 + walls * 2, 0.1, dim[1] + walls]);
						}

					// bevel
					} else if (cs_style == "bevel") {

						// wall
//						#
//						translate([0, 0, dim[2]])
//						cylinder(dim[0] / 2 + walls, dim[0] / 2 + walls, 0);
//						#
						cylinder(
							h = dim[2] + tolerance,
							r1 = dim[1] / 2 + tolerance + walls,
							r2 = dim[0] / 2 + tolerance + walls, $fn = fn);

						// adjoining face
						if (attach && attach_cs) {
							translate([-dim[0] / 2 - walls, -r - _inset, 0])
							rotate([90, 0, 0])
							linear_extrude(0.1)
							polygon([
								[0, 0],
								[0, dim[1]],
								[dim[0] / 2 + walls, dim[1] + dim[0] / 2 + walls],
								[(dim[0] / 2 + walls) * 2, dim[1]],
								[(dim[0] / 2 + walls) * 2, 0]
							]);
						}
					}
				}
			}
		}

		if (nut)
		translate([0, 0, h - nut_dim[2]])
		nut(nut_dim[2], nut_dim[1] / 2);

		if (holes || pitch != undef) {
			translate([0, 0, (cs_style != "none" ? dim[2] : 0) - 0.1])
			scale([1, 1, -1])
			screw_diff(
				dim,
				h + 0.2,
				cs_style = cs_style,
				mock = mock,
				pitch = pitch,
				tolerance = tolerance);
		}
	}

	if (print_support != undef)
	rotate([0, 0, 90 + print_support])
	translate([0, -r_outer])
	print_support();

	// dim check
	*#cylinder(h = h, r = r_outer);
}

module screw_diff(
		dim = SCREW_M2_SOCKET_DIM,
		h = 10,
		depth = 10,
		conical = false, // for printing
		cs_style = "none",
		pitch,
		tolerance = 0,
		mock = false,
	) {

	union() {

		// thread hole
		translate([0, 0, -(h + tolerance)])
		if (pitch != undef)
			thread_iso_metric(dim[0] + tolerance * 2, h + tolerance, pitch, center = false, internal = true);
		else
			cylinder(h = (h + tolerance), r = dim[0] / 2 + tolerance);

		// head hole
//		translate([0, 0, -0.01])
		cylinder(h = depth + 0.01, r = dim[1] / 2 + tolerance);

		if (conical)
		scale([1, 1, -1])
		cylinder(h = (dim[1] - dim[0]) / 2, r1 = dim[1] / 2 + tolerance, r2 = dim[0] / 2 + tolerance);

		// countersink
		translate([0, 0, -dim[2]])
		if (cs_style == "recess") {
			cylinder(h = dim[2], r = dim[1] / 2 + tolerance);
		} else if (cs_style == "bevel") {
			cylinder(h = dim[2], r1 = dim[0] / 2 + tolerance, r2 = dim[1] / 2 + tolerance);
		}
	}

	%
	if (mock)
	translate([0, 0, cs_style == "recess" ? -dim[2] : 0])
	screw(dim = dim, h = h, head = cs_style == "bevel" ? "flat" : "socket");
}
