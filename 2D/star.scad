/******************************************************************************
 * Star
 */

include <../helpers.scad>;

module star(r, n = 5, inset = 0.5) {
	polygon([ for (i = [0 : n * 2 - 1])
		rotate_point_z([0, r * (i % 2 == 0 ? 1 : 1 - clamp(inset, 0, 1))], 360 / (n * 2) * i)
	]);
}

/*

star(2, inset = 0.6175);

*star(2, 10, inset = 0.1);

*star(2, 27, inset = 0.95);

//*/
