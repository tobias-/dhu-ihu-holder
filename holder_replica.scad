// Front plate from photo measurements
// Units: mm
//
// Coordinate system for measurements:
// - origin = top-left of plate
// - x = right
// - y = down

$fn = 96;

// -------- Parameters --------

plate_w = 200;
plate_h = 265;   // guessed
plate_t = 3;

show_labels = true;
label_size = 6;
label_depth = 0.35;
label_gap = 1.5;          // labels hover 1.5 mm above the plate
label_color = "red";      // OpenSCAD preview color

// Main window
window_x = 15;
window_y = 58.5;
window_w = 170;
window_h = 125;

// Holes:
// [x, y-from-top, diameter, label]
holes = [
    ["H1", 30,    20,    8],
    ["H2", 170,   20,    8],

    ["H3", 72.5,  38,    6],

    ["H4", 48,    45,    7],
    ["H5", 152,   45,    7],

    ["H6", 48,    198.5, 7],
    ["H7", 152,   198.5, 7],

    ["H8", 48.5,  217,   7],
    ["H9", 145.5, 217,   7],
];

// Label positions, offset from each hole center.
// [label, dx, dy-from-top-coordinate]
label_offsets = [
    ["H1",  8,  0],
    ["H2", -16, 0],

    ["H3",  8,  0],

    ["H4",  8,  0],
    ["H5", -16, 0],

    ["H6",  8,  0],
    ["H7", -16, 0],

    ["H8",  8,  0],
    ["H9", -16, 0],
];

// -------- Helpers --------

function y_from_top(y) = plate_h - y;

module hole_from_top_left(x, y, d) {
    translate([x, y_from_top(y)])
        circle(d = d);
}

module rect_from_top_left(x, y, w, h) {
    translate([x, plate_h - y - h])
        square([w, h]);
}

module label_from_top_left(txt, x, y) {
    color(label_color)
        translate([x, y_from_top(y), plate_t + label_gap])
            linear_extrude(height = label_depth)
                text(
                    txt,
                    size = label_size,
                    halign = "center",
                    valign = "center"
                );
}

function hole_label(h) = h[0];
function hole_x(h)     = h[1];
function hole_y(h)     = h[2];
function hole_d(h)     = h[3];

function label_dx(label) =
    label == "H1" ? 8 :
    label == "H2" ? -16 :
    label == "H3" ? 8 :
    label == "H4" ? 8 :
    label == "H5" ? -16 :
    label == "H6" ? 8 :
    label == "H7" ? -16 :
    label == "H8" ? 8 :
    label == "H9" ? -16 :
    8;

// -------- 2D profile --------

module faceplate_2d() {
    difference() {
        square([plate_w, plate_h]);

        // W1: main rectangular window
        rect_from_top_left(window_x, window_y, window_w, window_h);

        // H1-H9
        for (h = holes) {
            hole_from_top_left(hole_x(h), hole_y(h), hole_d(h));
        }
    }
}

// -------- 3D model --------

module faceplate_base() {
    linear_extrude(height = plate_t)
        faceplate_2d();
}

module hole_labels() {
    for (h = holes) {
        label_from_top_left(
            hole_label(h),
            hole_x(h) + label_dx(hole_label(h)),
            hole_y(h)
        );
    }

    // Optional window label
color(label_color)
    translate([window_x + 10, y_from_top(window_y + 8), plate_t + label_gap])
        linear_extrude(height = label_depth)
            text("W1", size = label_size, halign = "center", valign = "center");
}

module faceplate() {
    union() {
        faceplate_base();

        if (show_labels)
            hole_labels();
    }
}

faceplate();