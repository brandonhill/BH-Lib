/******************************************************************************
 * Generic battery
 */

include <../../../3D/rounded cube.scad>;

module batt_generic(dim = [100, 30, 5]) {
	translate([-dim[0], -dim[1] / 2, 0])
	rounded_cube(dim, 1);
}
