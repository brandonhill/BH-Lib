/******************************************************************************
 * Nema 17 stepper motor
 */

include <../../Engineering/constants.scad>;

STEPPER_MOTOR_NEMA17_DIM = [42, 42, 42];
STEPPER_MOTOR_NEMA17_FLANGE_DIM = [22, 2]; // [dia., height]
STEPPER_MOTOR_NEMA17_SCREW_DIM = SCREW_M3_SOCKET_DIM;
STEPPER_MOTOR_NEMA17_SCREW_SPACING = 31;
STEPPER_MOTOR_NEMA17_SHAFT_DIM = [5, 15]; // [dia., height]

module stepper_motor_nema17() {
	stepper_motor(
		dim = STEPPER_MOTOR_NEMA17_DIM,
		flange_dim = STEPPER_MOTOR_NEMA17_FLANGE_DIM,
		screw_dim = STEPPER_MOTOR_NEMA17_SCREW_DIM,
		screw_hole_spacing = STEPPER_MOTOR_NEMA17_SCREW_SPACING,
		shaft_dim = STEPPER_MOTOR_NEMA17_SHAFT_DIM
	);
}

module pos_stepper_motor_nema17_screws(places = [1, 1, 1, 1]) {
	pos_stepper_motor_screws(
		spacing = STEPPER_MOTOR_NEMA17_SCREW_SPACING,
		places = places)
	children();
}
