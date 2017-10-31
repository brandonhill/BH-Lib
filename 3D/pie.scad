// ****************************************************************************
// Pie (linear extruded segment)

use <../2D/segment.scad>;

module pie(a = 90, r = 1, h = 1, center = true) {
	linear_extrude(h, center = center)
	segment(a, r);
}
