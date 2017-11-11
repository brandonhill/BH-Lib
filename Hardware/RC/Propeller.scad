/******************************************************************************
 * Propeller (with end supports for printing)
 */

module propeller(
		blade_dim, // [width, thickness]
		pitch,
		n = 2,
		r,
		hub_height,
		reverse = false,
		shaft_rad,
		shaft_surround,
		support = 0, // end supports
	) {

	r_hub = shaft_rad + shaft_surround;
	steps = get_fragments_from_r(r);
	step = r / steps;
	blade_thickness_lookup = [
		[r_hub, r_hub * 0.75],
		[r * 0.2, blade_dim[1]]];
	blade_width_lookup = [
		[r_hub, hub_height],
		[r * 0.4, blade_dim[0] * 0.5],
		[r, blade_dim[0]]];

	module blade() {
		for (i = [0 : steps - 1])
		hull()
		for (x = [step * i, step * (i + 1)])
		let(dim = [lookup(x, blade_width_lookup), lookup(x, blade_thickness_lookup)])
		translate([x, 0, dim[1] / 2])
		rotate([(90 - helix_angle(x, pitch)) * (reverse ? -1 : 1), 0])
		rotate([0, 90])
		linear_extrude(0.1)
		translate([-dim[0] / 2 + dim[1] / 2, 0])
		rounded_square(dim, dim[1] * 0.45);
	}

	// hub
	linear_extrude(hub_height)
	difference() {
		circle(r_hub);
		circle(shaft_rad);
	}

	// ring (acts as brim for printing)
	if (support)
	linear_extrude(0.2)
	difference() {
		circle(r);
		circle(r - support);
	}

	intersection() {
		cylinder(h = blade_dim[0] * 3, r = r, center = true);

		difference() {
			for (i = [0 : n - 1])
			rotate([0, 0, 360 / n * i]) {

				blade();

				// end supports (for FDM printing)
				if (support)
				difference() {
					hull()
					difference() {
						union() {
							blade();
							linear_extrude(0.1)
							projection()
							blade();
						}
						cylinder(h = blade_dim[0] * 3, r = r - support, center = true);
					}
					cylinder(h = blade_dim[0] * 3, r = r - support, center = true);
				}
			}

			cylinder(h = blade_dim[0] * 3, r = r_hub, center = true);
		}
	}
}

/*

PRINT_NOZZLE = 0.5;
TOLERANCE_CLOSE = 0.15;

propeller(
	blade_dim = [10, 1],
	n = 3,
	pitch = 50,
	r = 56,
	hub_height = 4,
	shaft_rad = 0.45 + TOLERANCE_CLOSE,
	shaft_surround = 2,
	support = PRINT_NOZZLE);

//*/
