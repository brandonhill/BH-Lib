
include <../../2D/circle true.scad>
include <../../2D/smooth.scad>
include <../../2D/sq.scad>
include <../../3D/cylinder true.scad>

module component_diff(
		board_dim,
		lip_thickness = 0.4,
		tolerance = 0
	) {
	thickness = board_dim[2] + lip_thickness * 2;

	translate([0, 0, thickness / 2])
	reflect(x = false, y = false, z = true)
	translate([0, 0, -0.01])
	linear_extrude(max(board_dim[0], board_dim[1]) / 2, scale = 0)
	// offset(delta = thickness / 2) {
	offset(delta = board_dim[2] / 2 + tolerance) {
		if ($children > 0) {
			children();
		} else
			sq([board_dim[0], board_dim[1]]);
	}
}

module component_mount(
		bevel = true,
		board_dim,
		board_offset = [0, 0],
		cutouts = [0, 0],
		h,
		hole_offset = [0, 0],
		hole_spacing = [20, 20],
		lip_thickness = 0.4,
		screws = [true, true],
		screw_r,
		screw_surround = 1.5,
		surround = 1.5,
		tolerance = 0,
	) {

	thickness = board_dim[2] + lip_thickness * 2;
	height = max(h ? h : 0, thickness);

	difference() {
		union() {
			difference() {
				union() {

					// outer
					linear_extrude(thickness, convexity = 2)
					smooth_acute(thickness * 0.4)
					{

						// surround
						difference() {
							translate(board_offset)
							shape_component_surround(board_dim, surround, tolerance) {
								if ($children > 0)
									children();
								else
									sq([board_dim[0], board_dim[1]]);
							}
							if (cutouts[0]) {
								reflect(x = cutouts[0], y = false)
								translate([board_dim[0], 0])
								sq([board_dim[0], hole_spacing[1] - (screw_r + screw_surround + surround) * 2]);
								// sq([board_dim[0], board_dim[1] * 0.9]);
							}
							if (cutouts[1]) {
								reflect(x = false, y = cutouts[1])
								translate([0, board_dim[1] - surround])
								sq([hole_spacing[0] - (screw_r + screw_surround + surround) * 2, board_dim[1]]);
							}
						}

						// screw surrounds
						if (screw_r)
						reflect(x = screws[0], y = screws[1])
						shape_component_mount_screw_surround(
							hole_offset = hole_offset,
							hole_spacing = hole_spacing,
							screw_r = screw_r,
							screw_surround = screw_surround);
					}

					// posts
					if (height > thickness)
					reflect(x = screws[0], y = screws[1])
					component_post(
						bevel = bevel,
						h = height,
						hole_offset = hole_offset,
						hole_spacing = hole_spacing,
						screw_surround = screw_surround,
						screw_r = screw_r);
				}

				// cutout
				translate(board_offset)
				component_diff(board_dim, lip_thickness, tolerance) {
					if ($children > 0)
						children();
					else
						sq([board_dim[0], board_dim[1]]);
				}
			}
		}

		// screw holes
		if (screw_r)
		reflect(x = screws[0], y = screws[1])
		component_post_hole(
			h = height,
			hole_offset = hole_offset,
			hole_spacing = hole_spacing,
			screw_r = screw_r);
	}
}

module component_post(
		bevel = true,
		h,
		hole_offset = [0, 0],
		hole_spacing = [20, 20],
		screw_surround = 1.5,
		screw_r,
	) {
	translate(hole_offset)
	translate(hole_spacing / 2) {
		// bevel start of post
		cylinder_true(
			h = screw_surround,
			r1 = screw_r + screw_surround * (bevel == "both" ? 0.25 : 1),
			r2 = screw_r + screw_surround,
			center = false);

		translate([0, 0, screw_surround])
		cylinder_true(h = h - screw_surround * 2, r = screw_r + screw_surround, center = false);

		// bevel end of post
		translate([0, 0, h - screw_surround])
		cylinder_true(
			h = screw_surround,
			r1 = screw_r + screw_surround,
			r2 = screw_r + screw_surround * (bevel ? 0.25 : 1),
			center = false);
	}
}

module component_post_hole(
		h,
		hole_offset = [0, 0],
		hole_spacing = [20, 20],
		screw_r,
		terminal = false // doesn't use true radius hole when terminal (for tightness)
	) {
	translate(hole_offset)
	translate(hole_spacing / 2)
	translate([0, 0, -0.1]) {
		if (terminal)
			cylinder(h = h + 0.2, r = screw_r);
		else
			cylinder_true(h = h + 0.2, r = screw_r, center = false);
	}
}

module component_surround(
		board_dim,
		lip_thickness = 0.4,
		surround = 1.5,
		tolerance = 0,
	) {
	thickness = board_dim[2] + lip_thickness * 2;
	linear_extrude(thickness, convexity = 2)
	smooth_acute(thickness / 2)
	shape_component_surround(board_dim, surround, tolerance) {
		if ($children > 0)
			children();
		else
			sq([board_dim[0], board_dim[1]]);
	}
}

module shape_component_surround(
		board_dim,
		surround = 1.5,
		tolerance = 0,
	) {
	offset(r = tolerance + surround) {
		if ($children > 0)
			children();
		else
			sq([board_dim[0], board_dim[1]]);
	}
}

module shape_component_mount_screw_surround(
		hole_offset = [0, 0],
		hole_spacing = [20, 20],
		screw_r,
		screw_surround = 1.5,
	) {

	translate(hole_offset)
	translate(hole_spacing / 2)
	circle_true(screw_r + screw_surround);
}
