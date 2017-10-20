// ****************************************************************************
// 5x3" prop

include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/bh_lib.scad>;
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/Components/_constants.scad>;

/*
helix:

x(h) = r * cos(h)
y(h) = r * sin(h)
z(h) = slope * r * h

helix angle:

a = atan(2 * PI * rad / 

*/

module prop(d, p, hole_rad, hub_height, hub_rad = false, blades = 2) {
	
	hub_rad = hub_rad != false ? hub_rad : hole_rad * 2;
	
	module Xblade(d, p, h) {
		
		translate([h * 0.75, -h, -p / 2])
		intersection() {
			helix(p, d, a = 180);
			
			// define blade shape:
			
			translate([-h / 2, h, p / 2 - h * 0.25])
			hull() {
				translate([-h * 0.25, 0, h / 2])
				cube([h, 0.01, h], true);
				
				translate([-h * 0.25, d * 0.2, h / 2])
				sphere(h * 0.9);
				
				*translate([-h * 0.25, d * 0.125, h / 2])
				sphere(h * 1.5);
				
				translate([-h * 0.25, d * 0.4, h / 2])
				sphere(h);
				
				translate([-h * 0.25, d / 2 - h * 0.75, h / 2])
				sphere(h * 0.75);
			}
		}
		
		// sphere hull experiment:
		#
		translate([p / 4, 0, p / 2])
		sphere(p / 2);
		
		#
		translate([p / 4, d / 4, p])
		sphere(p);
		
		// size check
		//#cube([1, d / 2, 1]);
	}
	
	module helix(h, r, thickness = 0.4, a = 360) {
		
		steps = a;
		
		for (step = [0 : steps - 1])
			translate([0, 0, (h / steps) * step])
			rotate([0, 0, (a / steps) * step])
			hull() {
				translate([r / 2, 0, 0])
				cube([r, thickness, thickness], true);
				
				rotate([0, 0, a / steps])
				translate([r / 2, 0, h / steps])
				cube([r, thickness, thickness], true);
			}
	}
	
	difference() {
		union() {
			for (i = [0 : blades - 1])
			rotate([0, 0, 360 / blades * i])
			translate([0, hub_rad, 0])
			blade(d / 2, p, hub_height);
			
			cylinder(h = hub_height, r = hub_rad);
		}
		
		translate([0, 0, -0.1])
		cylinder(h = hub_height + 0.2, r = hole_rad);
	}
}

module blade(r = 1, p = 1) {

/*
x(h) = r * cos(h)
y(h) = r * sin(h)
z(h) = p * r * h

a = atan(pitch / (PI * 2 * r))
//*/
	
	/* spiral of points:
	for (a = [0 : 359]) {
		translate([
			r * cos(a),
			r * sin(a),
			a / 359 * p
		])
		cube(0.1, true);
	}
	//*/
	
	module arc(a, r, thickness) {
		$fa = 0.1;
		difference() {
			segment(a, r);
			segment(a, r - thickness);
		}
	}
	
	slope_to_rad_fudge = 0.5;
	a_seg_max = p / r * r * 0.75;
	a_seg_min = r * 0.025;
	
	rotate([-90, 0, -90])
	for (i = [0 : r - 1])
		translate([0, 0, i])
		linear_extrude(1) {
			a = atan(p / (PI * 2 * i));
			
			// slope
			*#
			translate([0, -2, 0])
			rotate([0, 0, -a])
			translate([1.5, 0, 0])
			square([3, 0.4], true);
			
			// arc
			
			aseg = a_seg_max - (90 - a) / 90 * (a_seg_max - a_seg_min) + a_seg_min;
			r = (90 - a) * slope_to_rad_fudge;
			//r = 100 / a;
			
			translate([0, -r, 0])
			rotate([0, 0, 90])
			scale([1, -1, 1])
			arc(
				aseg,
				//90,
				r, 0.5);
		}
}

$fs = 0.1;
//prop(60, 40, 1.5 / 2, 3.5, 2, 2);
//prop(5 * MMPI, 4.5 * MMPI, 2, 5);
prop(60, 20, 0.75, 3, 2);

translate([0, 10, 0])
prop(60, 40, 0.75, 3, 2);

*translate([20, 0, 0])
prop(60, 30, 0.75, 3, 2);
