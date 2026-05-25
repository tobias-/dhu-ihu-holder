// ============================================================
//  Screen Holder Panel
//  Flat 3D-printable panel with a screen window, one round
//  mounting hole, and four square holes around the window.
// ============================================================

// ---------- Parameters ----------

panel_w = 170.0;      // outer panel width [mm]
panel_h = 210.0;      // outer panel height [mm]
panel_t = 10.0;       // panel thickness [mm]

window_w = 150.0;     // screen opening width [mm]
window_h = 120.0;     // screen opening height [mm]
window_x = (panel_w - window_w) / 2; // window left edge from panel left [mm]
window_y = (panel_h - window_h) / 2; // window top edge from panel top [mm]

round_hole_d = 5.0;   // round mounting hole diameter [mm]
round_hole_x = panel_w - 72.5; // round hole centre from panel left [mm]
round_hole_y = 38.0;  // round hole centre from panel top [mm]

square_hole_size = 11.5;  // square hole side length [mm]
square_spacing_x = 135.0; // square hole centre-to-centre X spacing [mm]
square_spacing_y = 149.0; // square hole centre-to-centre Y spacing [mm]

screen_tilt_angle = 25.0;     // approximate backward screen tilt from vertical [deg]
stand_side_angle = 90.0 - 22.5; // reduced from a 90 degree right-triangle stand [deg]
stand_width = 8.0;            // width of each side stand [mm]
stand_inset = 1.0;            // stand inset from left/right panel edges [mm]
stand_attach_h = panel_h * 0.75; // vertical height attached to panel back [mm]
stand_depth = stand_attach_h * tan(screen_tilt_angle);
stand_foot_y = stand_depth / tan(stand_side_angle);
stand_plate_depth = 150.0;    // solid angled plate extension out from panel back [mm]
stand_plate_t = 10.0;         // solid angled plate thickness [mm]
stand_plate_low_y = -8.0;     // low end extends past the holder edge in Y [mm]
stand_plate_y = stand_plate_depth / tan(stand_side_angle);
stand_plate_rise = panel_t + stand_plate_depth;
stand_plate_top_y0 = stand_plate_low_y + stand_plate_t;
stand_plate_run = stand_plate_y - stand_plate_low_y;
stand_plate_len = sqrt(stand_plate_run * stand_plate_run + stand_plate_rise * stand_plate_rise);
stand_plate_slope = stand_plate_rise / stand_plate_run;
side_stand_plate_z = (stand_attach_h - stand_plate_top_y0 + stand_plate_slope * panel_t)
    / (stand_plate_slope + 1 / stand_plate_slope);
side_stand_plate_y = stand_plate_top_y0 + side_stand_plate_z / stand_plate_slope;
stop_gap = 40.0;              // room between side-stand tip and stop along plate [mm]
stop_h = 100.0;               // stop height upward from the plate [mm]
stop_t = 5.0;                 // stop thickness along the plate [mm]
stop_y = side_stand_plate_y + stop_gap * stand_plate_run / stand_plate_len;
show_change_markers = true;   // preview markers for the last edited feature

window_cx = window_x + window_w / 2;
window_cy = window_y + window_h / 2;

$fn = 64;
eps = 0.1;

// ---------- Coordinate helpers ----------

function y_from_top(y) = panel_h - y;
function rect_y_from_top(y, h) = panel_h - y - h;

// ---------- Derived hole centres ----------

square_centres = [
    [window_cx - square_spacing_x / 2, window_cy - square_spacing_y / 2],
    [window_cx + square_spacing_x / 2, window_cy - square_spacing_y / 2],
    [window_cx - square_spacing_x / 2, window_cy + square_spacing_y / 2],
    [window_cx + square_spacing_x / 2, window_cy + square_spacing_y / 2]
];

// ---------- Main body ----------

module panel_body() {
    difference() {
        cube([panel_w, panel_h, panel_t]);

        // Screen window, positioned from the top-left panel corner.
        translate([window_x, rect_y_from_top(window_y, window_h), -eps])
            cube([window_w, window_h, panel_t + 2 * eps]);

        // Round mounting hole, matching the drill jig's 5 mm hole.
        translate([round_hole_x, y_from_top(round_hole_y), -eps])
            cylinder(d = round_hole_d, h = panel_t + 2 * eps);

        // Four square holes centred around the window centre.
        for (centre = square_centres) {
            translate([
                centre[0] - square_hole_size / 2,
                rect_y_from_top(centre[1] - square_hole_size / 2, square_hole_size),
                -eps
            ])
                cube([square_hole_size, square_hole_size, panel_t + 2 * eps]);
        }
    }
}

module side_stand(x0) {
    x1 = x0 + stand_width;

    polyhedron(
        points = [
            [x0, stand_plate_top_y0, -eps],
            [x0, stand_attach_h, panel_t],
            [x0, side_stand_plate_y, side_stand_plate_z],
            [x1, stand_plate_top_y0, -eps],
            [x1, stand_attach_h, panel_t],
            [x1, side_stand_plate_y, side_stand_plate_z]
        ],
        faces = [
            [0, 2, 1],
            [3, 4, 5],
            [0, 3, 5, 2],
            [2, 5, 4, 1],
            [1, 4, 3, 0]
        ]
    );
}

module stand_plate() {
    polyhedron(
        points = [
            [0, stand_plate_low_y, -eps],
            [0, stand_plate_top_y0, -eps],
            [0, stand_plate_y + stand_plate_t, panel_t + stand_plate_depth],
            [0, stand_plate_y, panel_t + stand_plate_depth],
            [panel_w, stand_plate_low_y, -eps],
            [panel_w, stand_plate_top_y0, -eps],
            [panel_w, stand_plate_y + stand_plate_t, panel_t + stand_plate_depth],
            [panel_w, stand_plate_y, panel_t + stand_plate_depth]
        ],
        faces = [
            [0, 3, 2, 1],
            [4, 5, 6, 7],
            [0, 4, 7, 3],
            [3, 7, 6, 2],
            [2, 6, 5, 1],
            [1, 5, 4, 0]
        ]
    );
}

function stand_plate_top_z(y) =
    (y - stand_plate_top_y0) * stand_plate_slope;

module plate_stop() {
    normal_y = stand_plate_rise / stand_plate_len;
    normal_z = -stand_plate_run / stand_plate_len;
    z0 = stand_plate_top_z(stop_y);
    z1 = stand_plate_top_z(stop_y + stop_t);

    polyhedron(
        points = [
            [0, stop_y, z0],
            [0, stop_y + stop_t, z1],
            [0, stop_y + stop_t + normal_y * stop_h, z1 + normal_z * stop_h],
            [0, stop_y + normal_y * stop_h, z0 + normal_z * stop_h],
            [panel_w, stop_y, z0],
            [panel_w, stop_y + stop_t, z1],
            [panel_w, stop_y + stop_t + normal_y * stop_h, z1 + normal_z * stop_h],
            [panel_w, stop_y + normal_y * stop_h, z0 + normal_z * stop_h]
        ],
        faces = [
            [0, 3, 2, 1],
            [4, 5, 6, 7],
            [0, 4, 7, 3],
            [3, 7, 6, 2],
            [2, 6, 5, 1],
            [1, 5, 4, 0]
        ]
    );
}

module change_marker() {
    for (x = [
        stand_inset,
        stand_inset + stand_width,
        panel_w - stand_inset - stand_width,
        panel_w - stand_inset
    ]) {
        color("magenta")
            translate([
                x,
                side_stand_plate_y,
                side_stand_plate_z
            ])
                sphere(r = 3);

        color("magenta")
            translate([
                x,
                side_stand_plate_y - 18,
                side_stand_plate_z
            ])
                rotate([-90, 0, 0])
                    cylinder(h = 15, r1 = 1.2, r2 = 0.2);
    }
}

union() {
    panel_body();

    stand_plate();
    color("blue")
        plate_stop();

    color("red") {
        side_stand(stand_inset);
        side_stand(panel_w - stand_inset - stand_width);
    }

    if (show_change_markers)
        change_marker();
}
