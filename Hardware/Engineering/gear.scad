/******************************************************************************
 * Gear
 *
 * - greater tolerances tend to be required for greater helix angles
 */

use <../../2D/circle true.scad>;
use <../../2D/smooth.scad>;
use <../../3D/cylinder true.scad>;
include <../../constants.scad>;
use <../../helpers.scad>;

function gear_base_rad(contact_angle, teeth, pitch) = gear_pitch_rad(teeth, pitch) * cos(contact_angle);

function gear_inner_rad(contact_angle, teeth, pitch, inside = false) =
	let(r = gear_pitch_rad(teeth, pitch) - pitch / 4) (inside ? max(gear_base_rad(contact_angle, teeth, pitch), r) : r);


function gear_outer_rad(teeth, pitch, inside = false) =
	gear_pitch_rad(teeth, pitch) + pitch / 4 + (inside ? pitch * 0.02 : 0);

function gear_pitch_rad(teeth, pitch) = teeth * pitch / PI / 2;

module shape_gear(
		contact_angle = 20,
		inside = false, // can also pass desired `r` here
		limits = true, // render inner circle and clip teeth tips
		pitch,
		r_shaft = 0.5,
		teeth,
		tolerance = 0,
	) {

	r_pitch = gear_pitch_rad(teeth, pitch);
	r_base = gear_base_rad(contact_angle, teeth, pitch);

	deg_per_tooth = 360 / teeth;
	inv_a_contact = inv_a(r_pitch);
	r_inner = gear_inner_rad(contact_angle, teeth, pitch, inside);
	r_outer = gear_outer_rad(teeth, pitch, inside);
	radians_per_tooth = deg_to_rad(deg_per_tooth);
	steps = get_fragments_from_r(pitch / 8);

	tooth_profile = filter(concat(
		[polar_to_cartesianr(-radians_per_tooth / 2, r_inner * 0.9)],
		[ for (i = [0 : steps])
			let (r = (r_outer - r_inner) * i / steps + r_inner,
				a = inv_a(r) - inv_a_contact - radians_per_tooth / 4)
			a < 0 ? polar_to_cartesianr(a, r) : undef ],
		[ for (i = [0 : steps])
			let (r = (r_outer - r_inner) * (steps - i) / steps + r_inner,
				a = -inv_a(r) + inv_a_contact + radians_per_tooth / 4)
			a > 0 ? polar_to_cartesianr(a, r) : undef ],
		[polar_to_cartesianr(radians_per_tooth / 2, r_inner * 0.9)]));

	function inv_a(r) = r <= r_base ? 0 :
		let(hyp = sqrt(pow(r, 2) - pow(r_base, 2)))
		hyp / r_base - atanr(hyp / r_base);

	difference() {

		if (inside)
		circle(inside != true ? max(r_outer, inside) : r_outer + pitch * 0.7);

		// apply half of tolerance since other gear should have same
		offset(r = tolerance / 2 * (inside ? 1 : -1))
		intersection() {
			union() {
				// teeth
				for (i = [0 : teeth - 1])
				rotate([0, 0, deg_per_tooth * i])
				polygon(tooth_profile);

				// inner
				if (limits)
				circle_true(r_inner);
			}

			// outer
			if (limits)
			circle(r_outer);
		}
	}

	// dim checks

	// base
	*#circle(r_base);

	// inner
	*#circle(r_minor);

	// outer
	*#circle(r_major);

	// contact
	*#rotate_extrude()
	translate([r_pitch, 0])
	circle(0.01);
}

module shape_gear_spoke_cutouts(
		contact_angle,
		pitch,
		r_hole = 0.5,
		spokes = 3,
		teeth,
	) {

	r_inner = gear_inner_rad(contact_angle, teeth, pitch);
	spoke_w = r_inner * 0.2;

	// spokes
	if (spokes)
	smooth(spoke_w / 2)
	difference() {
		circle(r_inner * 0.8);

		// hub
		circle(r_hole * 3);

		// spokes
		for (i = [0 : spokes - 1]) {
			rotate([0, 0, 360 / spokes * i])
			translate([r_inner / 2, 0])
			square([r_inner, spoke_w], true);
		}
	}
}

module gear(
		contact_angle = 20,
		center = true,
		h = 1,
		helix = 0,
		herringbone = false,
		inside = false, // can also pass desired `r` here
		pitch,
		r_hole = 1,
		spokes = 3,
		teeth = 6,
		tolerance = 0,
	) {

	helix_pitch = helix_pitch(90 - helix, gear_pitch_rad(teeth, pitch));
	r_inner = gear_inner_rad(contact_angle, teeth, pitch, inside);
	r_outer = inside && inside != true ? inside : gear_outer_rad(teeth, pitch, inside);

	translate([0, 0, center ? 0 : h / 2])
	intersection() {
		difference() {
			union() {
				for (z = herringbone ? [-1, 1] * (inside ? -1 : 1) : [1])
				scale([1, 1, z])
				linear_extrude(herringbone ? h / 2 : h, twist = 360 / helix_pitch * h * (inside ? -1 : 1), center = !herringbone, convexity = 4)
				shape_gear(
					contact_angle = contact_angle,
					limits = inside,
					inside = inside ? r_outer + 1 : false,
					pitch = pitch,
					teeth = teeth,
					tolerance = tolerance);

				// define hole/inner/outer faces here (not in shape) to simplify twisted but straight faces

				// inner
				if (!inside)
				cylinder_true(h = h, r = r_inner - tolerance / 2);
			}

			// hole
			if (r_hole != undef)
			cylinder_true(h = h + 0.2, r = r_hole + tolerance);

			// inner
			if (inside)
			cylinder_true(h = h, r = r_inner + tolerance / 2);

			// spoke cutouts
			if (!inside)
			linear_extrude(h + 0.2, center = true, convexity = 3)
			shape_gear_spoke_cutouts(
				contact_angle = contact_angle,
				pitch = pitch,
				r_hole = r_hole,
				spokes = spokes,
				teeth = teeth);
		}

		// outer
		cylinder(h = h + 0.2, r = r_outer - (inside ? 0 : tolerance / 2), center = true);
	}
}

module gear_pair(
		contact_angle = 20,
		h_pinion = 2,
		h_spur = 2,
		helix = 15,
		herringbone = true,
		pitch = 2,
		r_hole_pinion = 1,
		r_hole_spur = 1,
		spokes_pinion = 0,
		spokes_spur = 3,
		teeth_pinion = 6,
		teeth_spur = 28,
		tolerance = 0,
	) {

	r_pinion = gear_pitch_rad(teeth_pinion, pitch);
	r_spur = gear_pitch_rad(teeth_spur, pitch);
	spacing = r_pinion + r_spur;
	teeth_rot_pinion = $t * teeth_pinion / teeth_pinion;
	teeth_rot_spur = teeth_spur / 2 - teeth_rot_pinion + 0.5;

	print(["gear_pair() spacing: ", spacing, ", pinion radius: ", r_pinion, ", spur radius: ", r_spur]);

	rotate([0, 0, teeth_rot_pinion / teeth_pinion * 360])
	gear(
		contact_angle = contact_angle,
		h = h_pinion,
		helix = helix,
		herringbone = herringbone,
		pitch = pitch,
		r_hole = r_hole_pinion,
		spokes = spokes_pinion,
		teeth = teeth_pinion,
		tolerance = tolerance);

	translate([spacing, 0])
	rotate([0, 0, teeth_rot_spur / teeth_spur * 360])
	gear(
		contact_angle = contact_angle,
		h = h_spur,
		helix = -helix,
		herringbone = herringbone,
		pitch = pitch,
		r_hole = r_hole_spur,
		spokes = spokes_spur,
		teeth = teeth_spur,
		tolerance = tolerance);
}

module planetary_gear_bearing(
		dim, // [inner dia., outer dia., height]
		contact_angle = 20,
		helix = 30,
		herringbone = true,
		pitch, // mm
		planets = 3,
		teeth_planet = 6,
		teeth_sun,
		tolerance = 0,
		center = true,
	) {

	teeth_ring = 2 * teeth_planet + teeth_sun;
	//print(["teeth_ring = ", teeth_ring, ", teeth_planet = ", teeth_planet, ", teeth_sun = ", teeth_sun]);

	// check meshing (only supporting evenly spaced planets for now)
	if ((teeth_sun + teeth_ring) % planets != 0)
		error(["planetary_gears()",
			" teeth_sun + teeth_ring (", teeth_sun + teeth_ring, ")",
			" must be evenly divisble by planets ", planets]);

	rot_teeth_planet = $t * teeth_sun / teeth_sun * teeth_sun;
	//rot_teeth_ring = teeth_ring / 2 - rot_teeth_planet;
	rot_teeth_ring = teeth_ring / 2 - rot_teeth_planet + ((teeth_planet + teeth_sun) % 2 == 0 ? 0 : 0.5);
	rot_teeth_planets = rot_teeth_ring + 0.5;
	//rot_teeth_planets = rot_teeth_ring + ((teeth_planet + teeth_sun) % 2 == 0 ? 0 : 0);

	r_pitch1 = gear_pitch_rad(teeth_planet, pitch);
	r_pitch2 = gear_pitch_rad(teeth_ring, pitch);

	// sun
	gear(
		contact_angle = contact_angle,
		h = dim[2],
		helix = -helix,
		herringbone = herringbone,
		r_hole = dim[0] / 2,
		pitch = pitch,
		teeth = teeth_sun,
		tolerance = tolerance,
		center = center);

	rotate([0, 0, -rot_teeth_planets / teeth_sun * 360]) {

		// planets
		for (i = [0 : planets - 1])
		let(a = 360 / planets * i)
		rotate([0, 0, a])
		translate([r_pitch2 - r_pitch1, 0])
		rotate([0, 0, (rot_teeth_planet + (a / 360 * teeth_sun)) * 360 / teeth_planet])
		gear(
			contact_angle = contact_angle,
			h = dim[2],
			helix = helix,
			herringbone = herringbone,
			pitch = pitch,
			teeth = teeth_planet,
			tolerance = tolerance,
			center = center);

		// ring
		rotate([0, 0, -rot_teeth_ring / teeth_ring * 360])
		gear(
			contact_angle = contact_angle,
			h = dim[2],
			helix = -helix,
			herringbone = herringbone,
			inside = dim[1] / 2,
			pitch = pitch,
			teeth = teeth_ring,
			tolerance = tolerance,
			center = center);
	}
}

*gear(
	h = 5,
	pitch = 2,
	r_hole = 1,
	teeth = 12
);

*gear(
	h = 5,
	inside = 10,
	pitch = 2,
	teeth = 26
);

*gear_pair(
	h_pinion = 4,
	h_spur = 4,
	teeth_pinion = 12,
	teeth_spur = 32,
	tolerance = 0.1
);

*planetary_gear_bearing(
	dim = [16, 45, 10],
	pitch = 4,
	planets = 6,
	teeth_sun = 18,
	tolerance = 0.15
);
