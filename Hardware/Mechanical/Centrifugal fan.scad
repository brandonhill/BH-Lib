/******************************************************************************
 * Centrifugal fan (blower)
 */

include <../../2D/arc.scad>;
include <../../helpers.scad>;

module centrifugal_fan(
		blade_angle = -45, // radial = 0
		blade_dim, // [inner dia., outer dia., height]
		blades,
		clearance = 0.5, // between blade and housing
		inlet_rad,
		outlet_width,
		thickness_blade = 0.5,
		thickness_housing = 1,
	) {

	height = blade_dim[2] + (clearance + thickness_housing) * 2;
	_outlet_width = outlet_width != undef ? outlet_width : blade_dim[0];
	r_inlet = inlet_rad != undef ? inlet_rad : blade_dim[0] / 2;
	r_outer_end = blade_dim[0] + clearance + thickness_housing;
	r_outer_start = blade_dim[1] / 2 + clearance + thickness_housing;

	module shape_housing(inlet = false) {

		steps = get_fragments_from_r(r_outer_end);

		difference() {
			union() {
				hull() {
					circle(r_outer_start);

					for (step = [0 : steps])
					rotate([0, 0, 270 / steps * -step])
					translate([r_outer_start - thickness_housing / 2 + (r_outer_end - r_outer_start) * step / steps, 0])
					circle(thickness_housing / 2);
				}

				translate([0, r_outer_end - (_outlet_width + thickness_housing * 2)])
				square([r_outer_start, _outlet_width + thickness_housing * 2]);
			}

			if (inlet)
			circle(r_inlet);
		}
	}

	// bottom/top
	for (z = [0, height - thickness_housing])
	translate([0, 0, z])
	linear_extrude(thickness_housing)
	shape_housing(inlet = !!z);

	// sides
	difference() {
		linear_extrude(height, convexity = 4)
		difference() {
			shape_housing();
			offset(r = -thickness_housing)
			shape_housing();
		}

		// outlet cutout
		translate([r_outer_start - thickness_housing / 2, r_outer_end - _outlet_width / 2 - thickness_housing, height / 2])
		cube([thickness_housing + 0.2, _outlet_width, height - thickness_housing * 2], true);
	}

	// impeller
	translate([0, 0, thickness_housing + clearance])
	centrifugal_impeller(
		blade_angle = blade_angle,
		dim = blade_dim,
		n = blades,
		thickness_blade = thickness_blade,
		thickness_housing = thickness_housing);
}

module centrifugal_impeller(
		dim,
		n,
		blade_angle = 0,
		thickness_blade = 0.5,
		thickness_plate = 1,
	) {

	module shape_blade() {
		hull()
		for (x = [0 : dim[1]])
		translate([x, 0])
		circle(thickness_blade / 2);
	}

	blades = n != undef ? n : get_fragments_from_r(dim[0] / 2) * 2/3;

	// plate
	cylinder(h = thickness_plate, r = dim[1] / 2);

	// blades
	linear_extrude(dim[2])
	intersection() {
		difference() {
			for (a = [0 : 360 / blades : 359])
			rotate([0, 0, a])
			translate([(dim[0] + thickness_blade) / 2, 0])
			rotate([0, 0, -blade_angle])
			shape_blade();

			circle(dim[0] / 2);
		}
		circle(dim[1] / 2);
	}
}

centrifugal_fan(
	blade_dim = [40, 60, 10]
	,outlet_width = 20
);
