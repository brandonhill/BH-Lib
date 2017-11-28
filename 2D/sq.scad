/******************************************************************************
 * Convenience module for `square`.
 * - centred by default
 * - handles dimension arrays > 2
 */

module sq(dim, center = true) {
	d = dim[1] >= 0 ? dim : [dim, dim];
	square([d[0], d[1]], center);
}
