// ****************************************************************************
// Propellor

include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/bh_lib.scad>;
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/polyhole.scad>;
include </Users/brandon/Google Drive/Documents/3D/OpenSCAD/Components/_constants.scad>;

/*
helix:

x(h) = r * cos(h)
y(h) = r * sin(h)
z(h) = slope * r * h

angle(r) = atan(pitch / (PI * 2 * r))

*/

module prop(d, p, hole_rad, hub_height, hub_rad = false, thickness = 0.5, blades = 2) {
	
	hub_rad = hub_rad ? hub_rad : hole_rad * 3;
	
	module blade(r = 1, p = 1, h = 1, w = 1) {
		
		thicken_pct = 100 / 100;
		step = $fs;
		steps = r / step;
		
		rotate([0, 90, 0]) {
			intersection() {
				
				translate([0, 0, r / 2])
				cube([w, h, r], true);
				
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
	
	module hub() {
		
		*translate([0, hub_height / 2, 0])
		rotate([90, 0, 0])
		linear_extrude(hub_height)
		rounded_square([hub_rad * 2, hub_rad * 2], 1, true);
		
		end_r = hub_rad;//hole_rad;
		end_skew = 0;//hub_rad / 4;
		
		rotate([90, 0, 0])
		hull() {
			for (y = [0 : 1])
			scale([1, y == 0 ? 1 : -1, y == 0 ? -1 : 1])
			translate([0, 0, hub_height / 2 - 0.1])
			linear_extrude(0.1)
			hull() {
				for (x = [-1, 1])
					scale([x, x, 1]) {
						translate([hub_rad - end_r + end_skew, hub_rad - end_r])
						circle(end_r);
						
						translate([hub_rad - end_r - end_skew, -(hub_rad - end_r)])
						circle(end_r);
					}
			}
		}
	}
	
	intersection() {
		
		// shape the ends
		end_r = 1;
		end_skew = hub_rad / 4;
		rotate([90, 0, 0])
		translate([0, 0, -hub_height / 2])
		linear_extrude(hub_height)
		hull() {
			for (x = [0 : 1])
				scale([x == 0 ? -1 : 1, x == 0 ? -1 : 1, 1]) {
					translate([d / 2 - end_r, hub_rad - end_r])
					circle(end_r);
					
					translate([d / 2 - end_r - end_skew, -(hub_rad - end_r)])
					circle(end_r);
				}
		}
		
		difference() {
			union() {
				// blades
				for (i = [0 : blades - 1])
					rotate([0, 0, 360 / blades * i])
					blade(d / 2, p, hub_height, hub_rad * 2, 0.1);
				
				// hub
				hub();
			}
			
			// shaft hole
			rotate([90, 0, 0])
			translate([0, 0, -(hub_height + 0.2) / 2])
			//cylinder(h = hub_height + 0.2, r = hole_rad)
			linear_extrude(hub_height + 0.2)
			polyhole(hole_rad)
			;
		}
	}
}

//*
$fs = 1;

// 60x10mm
prop(60, 10, 0.75, 3.75, 3);

// 5x3"
*prop(
	d = 5 * MMPI,
	p = 3 * MMPI,
	hole_rad = 2.5,
	hub_height = 5,
	hub_rad = 7,
	thickness = 0.75
);

// 5x3" x 3 - can't do if printing them sideways!
*prop(5 * MMPI, 3 * MMPI, 2.5, 6, 5, blades = 3);

//*/
