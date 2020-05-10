

GROOVE_MOUNT_DIM = [12, 16]; // inner dia, outer, dia
GROOVE_MOUNT_HEIGHT = 4.64;
GROOVE_MOUNT_HEIGHT_COLLAR_BOT = 1.5;
GROOVE_MOUNT_HEIGHT_COLLAR_TOP = 4.76;

module groove_mount(
		collar_bot = GROOVE_MOUNT_HEIGHT_COLLAR_BOT,
		offset = 0,
	) {

	// bottom collar
	translate([0, 0, -offset])
	cylinder(h = collar_bot + offset * 2, r = GROOVE_MOUNT_DIM[1] / 2 + offset);

	// groove (inset)
	translate([0, 0, collar_bot])
	cylinder(h = GROOVE_MOUNT_HEIGHT, r = GROOVE_MOUNT_DIM[0] / 2);

	// top collar
	translate([0, 0, collar_bot + GROOVE_MOUNT_HEIGHT - offset])
	cylinder(h = GROOVE_MOUNT_HEIGHT_COLLAR_TOP + offset * 2, r = GROOVE_MOUNT_DIM[1] / 2 + offset);
}

*groove_mount();
