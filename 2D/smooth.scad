/************************************************************
 * Smooth the edges of 2D shapes
 */

module smooth(r) {
	offset(r = r)
	offset(r = -r)
	children();
}

module smooth_acute(r = 0, dim = [1000, 1000]) {

	module blank() {
		render()
		square(dim, true);
	}

	smooth(r)
	difference() {

		blank();

		smooth(r)
		difference() {

			blank();

			children();
		}
	}
}
