
include <all.scad>;

$fs = 0.5;

translate([0, 0, 6])
color(COLOUR_STEEL)
screw(
	dim = SCREW_M3_SOCKET_DIM,
	h = 18,
	pitch = THREAD_PITCH_M3_COARSE,
	socket = "hex",
	threaded = true
);

translate([0, 0, -10])
color(COLOUR_STEEL)
nut(NUT_M3_DIM);

gear_pair(
	h_pinion = 4,
	h_spur = 4,
	r_hole_pinion = 1.6,
	r_hole_spur = 1,
	spokes_pinion = 5,
	teeth_pinion = 32,
	teeth_spur = 12,
	tolerance = 0.1
);

translate([0, 40])
rotate([0, 0, -120])
truss(
	dim = [60, 20, 2.5],
	flat = false,
	type = "x",
	walls = 0.5
);

translate([15, 15])
scale(0.5)
rotate([0, 0, 0])
rotate_extrude(angle = 180)
show_half([0, 0, -90], 2d = true)
bezier(
	points = [
		[0, 3],
		[20, -5],
		[30, 45],
		[0, 30] ],
	n = 30
);