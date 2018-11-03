/******************************************************************************
 * Colours
 */

// named
COLOUR_BLACK = "black";
COLOUR_BLUE = [0, 0.5, 0.8];
COLOUR_BLUE_DARK = [0, 0.25, 0.4];
COLOUR_BROWN = [0.5, 0.25, 0];
COLOUR_BROWN_LIGHT = [0.75, 0.5, 0];
COLOUR_COPPER = [0.75, 0.4, 0];
COLOUR_GOLD = [1, 0.8, 0];
COLOUR_GREEN = [0, 0.8, 0];
COLOUR_GREEN_DARK = [0, 0.4, 0];
COLOUR_GREY = [0.5, 0.5, 0.5];
COLOUR_GREY_DARK = [0.15, 0.15, 0.15];
COLOUR_ORANGE = [1, 0.5, 0];
COLOUR_PURPLE = [0.6, 0, 0.6];
COLOUR_RED = [0.8, 0, 0];
COLOUR_RED_DARK = [0.25, 0, 0];
COLOUR_WHITE = "white";
COLOUR_YELLOW = [1, 0.8, 0];

// materials
COLOUR_CF = [0.25, 0.25, 0.25];
COLOUR_PCB = [0, 0.5, 0];
COLOUR_STEEL = [0.9, 0.9, 0.9];
COLOUR_WOOD = [1, 0.85, 0.6];

// make alpha from opaque
function alpha(c, a = 1) = [c[0], c[1], c[2], a];
