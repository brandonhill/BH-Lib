// molex "picoblade" 1.25mm plug

module picoblade(n = 4) {

	$fs = 0.1;

	// from spec
	DEPTH = 3.95;
	FLANGE_WIDTH = 0.65;
	HEIGHT = 3.2;
	PLUG_HEIGHT = 2.3;
	PLUG_PITCH = 1.25;
	PLUG_SIDE = 0.85;
	PLUG_SPACE = 0.9;

	// interpret
	FLANGE_HEIGHT = 0.75;
	LENGTH = PLUG_SIDE * 2 + PLUG_PITCH * (n - 1);
	PLUG_HOLE_WIDTH = 0.35;
	PLUG_SIDES = 0.675;

	// guess
	PIN_HOLE_WIDTH = 1;
	PIN_HOLE_HEIGHT = 1.5;

	// flange
	module flange() {

		r = (HEIGHT - PLUG_HEIGHT) / 2;

		linear_extrude(FLANGE_HEIGHT)
		rounded_square([
			FLANGE_WIDTH * 2 + LENGTH,
			HEIGHT,
			FLANGE_HEIGHT
		], r);
	}

	// body
	module body() {
		cube([
			LENGTH,
			PLUG_HEIGHT,
			DEPTH
		]);
	}

	// rib
	module rib() {

		d = FLANGE_WIDTH / 2;

		cube([d, d, DEPTH - FLANGE_HEIGHT]);
	}

	module ribs() {
		rib();

		translate([LENGTH + FLANGE_WIDTH / 2, 0, 0])
		rib();
	}

	module housing() {
		union() {
			flange();

			translate([FLANGE_WIDTH, (HEIGHT - PLUG_HEIGHT) / 2, 0])
			body();

			translate([FLANGE_WIDTH / 2, HEIGHT / 2 - FLANGE_WIDTH / 4, FLANGE_HEIGHT])
			ribs();
		}
	}

	module pin_hole() {
		translate([0, 0, (DEPTH - 0.5) / 2 - 1])
		cube([PIN_HOLE_WIDTH, PIN_HOLE_HEIGHT, DEPTH - 0.5 + 2], true);

		translate([0, -0.2, DEPTH / 2 - 1])
		cube([PLUG_HOLE_WIDTH, 1, DEPTH + 2], true);
	}

	difference() {
		housing();
		translate([FLANGE_WIDTH + PLUG_SIDE, HEIGHT / 2, 0])
		for (i = [0 : n - 1]) {
			translate([PLUG_PITCH * i, 0, 0])
			pin_hole();
		}
	}
}

*picoblade();
