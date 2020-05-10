

HOT_END_B3_PICO_DIM = [14.3, 43]; // [dia., h]
HOT_END_B3_PICO_COOLING_ZONE_DIM = [HOT_END_B3_PICO_DIM[0], 23]; // [w, h]
HOT_END_B3_PICO_X_OFFSET = HOT_END_B3_PICO_DIM[0] / 4;

module 3d_printer_hot_end_b3_pico() {
	fin_thickness = 0.6;

	// tube
	cylinder(h = HOT_END_B3_PICO_DIM[1], r = 2);

	translate([HOT_END_B3_PICO_X_OFFSET, 0]) {

		// heating block
		cylinder(h = HOT_END_B3_PICO_DIM[1] - HOT_END_B3_PICO_COOLING_ZONE_DIM[1], r = HOT_END_B3_PICO_DIM[0] / 2);

		// cooling block
		translate([0, 0, HOT_END_B3_PICO_DIM[1] - fin_thickness])
		for (z = [0 : 10])
		translate([0, 0, -z * HOT_END_B3_PICO_COOLING_ZONE_DIM[1] / 11])
		cylinder(h = fin_thickness, r = HOT_END_B3_PICO_DIM[0] / 2);

		*translate([0, 0, HOT_END_B3_PICO_DIM[1] - HOT_END_B3_PICO_COOLING_ZONE_DIM[1]])
		cylinder(h = HOT_END_B3_PICO_COOLING_ZONE_DIM[1], r = HOT_END_B3_PICO_DIM[0] / 2);

		// thermistor cable
		translate([0, -HOT_END_B3_PICO_DIM[0] / 2,  2.5 + 2.5 / 2])
		rotate([0, 120])
		translate([-HOT_END_B3_PICO_DIM[0] / 2, 0])
		rotate_extrude(angle = -90)
		translate([HOT_END_B3_PICO_DIM[0] / 2, 0])
		circle(2.5 / 2);
	}

}

*3d_printer_hot_end_b3_pico();
