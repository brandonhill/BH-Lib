
use <../../../../3D/cylinder true.scad>

NOZZLE_B3_PICO_NUT_DIM = [6, 4]; // [dia., h]
NOZZLE_B3_PICO_HEIGHT = 9;
NOZZLE_B3_PICO_HEIGHT_THREADS = 7;

module 3d_printer_nozzle_b3_pico() {

	translate([0, 0, -NOZZLE_B3_PICO_HEIGHT]) {

		// tip
		cylinder_true(h = NOZZLE_B3_PICO_HEIGHT - NOZZLE_B3_PICO_NUT_DIM[1], r1 = 0, r2 = NOZZLE_B3_PICO_NUT_DIM[0] / 2, center = false, $fn = 6);

		// base
		translate([0, 0, NOZZLE_B3_PICO_HEIGHT - NOZZLE_B3_PICO_NUT_DIM[1]])
		cylinder_true(h = NOZZLE_B3_PICO_NUT_DIM[1], r = NOZZLE_B3_PICO_NUT_DIM[0] / 2, center = false, $fn = 6);
	}

	// threads
	cylinder(h = NOZZLE_B3_PICO_HEIGHT_THREADS, r = NOZZLE_B3_PICO_NUT_DIM[0] / 2 * 0.8);
}

*3d_printer_nozzle_b3_pico();
