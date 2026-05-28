// ============================================================
//  Screen Holder Panel
//  Holder replica panel with screen stand geometry.
// ============================================================

// ---------- Parameters ----------

panel_w = 205.0;          // outer panel width [mm]
show_full_holder = true;  // include stand, stop, and braces
panel_h_uncropped = 265.0; // original full holder panel height [mm]
panel_crop_top = 8.5;     // material removed from the yellow plate top edge [mm]
panel_crop_bottom = 8.5;  // material removed from the yellow plate bottom edge [mm]
panel_h_full = panel_h_uncropped - panel_crop_top - panel_crop_bottom;
panel_h_plate_only = panel_h_full;
panel_h = show_full_holder ? panel_h_full : panel_h_plate_only;
panel_t_full = 10.0;  // full holder panel thickness [mm]
panel_t_plate_only = 0.6; // plate-only panel thickness [mm]
panel_t = show_full_holder ? panel_t_full : panel_t_plate_only;

show_labels = true;
label_size = 6.0;
label_depth = 0.35;
label_gap = 1.5;          // labels hover outside the plate [mm]
label_color = "red";      // OpenSCAD preview color

window_x = 15.0;      // screen opening left edge from panel left [mm]
window_y = 58.5;      // screen opening top edge from panel top [mm]
window_w = 170.0;     // screen opening width [mm]
window_h = 125.0;     // screen opening height [mm]

// [label, x, y-from-top, diameter]
holder_holes = [
    ["H1", 30.0,   20.0,  8.0],
    ["H2", 175.5,  20.0,  8.0],
    ["H11", 170.0, 32.5,  8.0],
    ["H10", 35.0,  32.5,  8.0],
    ["H3", 72.5,   37.0,  6.0],
    ["H4", 48.0,   45.0,  7.0],
    ["H5", 150.0,  45.0,  7.0],
    ["H6", 48.0,  198.5,  7.0],
    ["H7", 157.0, 198.5,  7.0],
    ["H8", 48.5,  217.0,  7.0],
    ["H9", 150.5, 217.0,  7.0]
];

screen_tilt_angle = 25.0;     // approximate backward screen tilt from vertical [deg]
stand_side_angle = 90.0 - screen_tilt_angle; // reduced from a 90 degree right-triangle stand [deg]
stand_width = 8.0;            // width of each side stand [mm]
stand_inset = 0.0;            // stand inset from left/right panel edges [mm]
stand_attach_h = panel_h * 0.9; // vertical height attached to panel back [mm]
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
tunnel_h = 150.0;             // clear tunnel height target [mm]
stop_h = tunnel_h;             // stop height upward from the plate [mm]
inside_label_text = "III";      // roman numeral on the inside of the yellow plate
inside_label_y = 20.0;          // label center from top edge of the yellow plate [mm]
inside_label_size = 20.0;       // text height [mm]
inside_label_depth = 1.0;       // raised text depth [mm]
inside_label_font = "Liberation Serif:style=Bold";
tunnel_w = 45.0;              // retained light-blue reach from the original tunnel geometry [mm]
blue_rect_start_y = side_stand_plate_y;
blue_rect_end_y = stand_plate_y + stand_plate_t - 5.0 - tunnel_w * stand_plate_run / stand_plate_len;
blue_cutout_depth = 10.0;    // notch depth from the light-blue end along the plate [mm]
blue_cutout_h = 30.0;        // notch height along the light-blue end [mm]
blue_cutout_offset = (stop_h - blue_cutout_h) / 2;
blue_cutout_start_y = blue_rect_end_y - blue_cutout_depth * stand_plate_run / stand_plate_len;
gray_tender_len = 18.0;      // gray hook body length along the plate [mm]
gray_tender_t = stand_width + 5.0; // gray peg support extends 5 mm lower for stability [mm]
gray_tender_anchor = 0.5;    // slight overlap keeps the tender joined to the light-blue body [mm]
gray_tender_start_y = blue_rect_end_y - gray_tender_anchor * stand_plate_run / stand_plate_len;
gray_tender_end_y = blue_rect_end_y + gray_tender_len * stand_plate_run / stand_plate_len;
gray_tender_offset = stop_h - gray_tender_t;
desired_peg_spacing = 135.0; // target center-to-center peg spacing [mm]
gray_support_w = (panel_w - 2 * stand_inset + stand_width - desired_peg_spacing) / 2;
gray_pin_d = 6.4;            // round pin sized to pass a 7 mm hole [mm]
gray_pin_len = 3.2;          // straight pin length through the mating plate [mm]
gray_pin_embed = 1.0;        // overlap keeps the pin manifold with the tender body [mm]
gray_pin_top_margin = 1.0;   // keeps the peg close to the top of the support [mm]
gray_pin_center_offset = gray_tender_offset + gray_tender_t - gray_pin_d / 2 - gray_pin_top_margin;
gray_hook_base_d = 6.8;      // conical hook base wraps over the round pin [mm]
gray_hook_tip_d = 5.0;       // tapered hook tip diameter [mm]
gray_hook_reach = 5.0;       // tapered hook extends beyond the round pin [mm]
gray_hook_rise = 5.0;        // tapered hook rises diagonally at about 45 degrees [mm]
gray_hook_cap_len = 0.8;     // short caps used to hull the tapered hook [mm]

$fn = 64;
eps = 0.1;

// ---------- Coordinate helpers ----------

function cropped_y_from_top(y) = y - panel_crop_top;
function y_from_top(y) = panel_h - cropped_y_from_top(y);
function rect_y_from_top(y, h) = panel_h - cropped_y_from_top(y) - h;
function mirrored_x(x) = panel_w - x;
function mirrored_rect_x(x, w) = panel_w - x - w;
function hole_label(h) = h[0];
function hole_x(h) = h[1];
function hole_y(h) = h[2];
function hole_d(h) = h[3];

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
    label == "H10" ? 8 :
    label == "H11" ? -16 :
    8;

// ---------- Main body ----------

module panel_body() {
    difference() {
        cube([panel_w, panel_h, panel_t]);

        // Screen window, positioned from the top-left panel corner.
        translate([mirrored_rect_x(window_x, window_w), rect_y_from_top(window_y, window_h), -eps])
            cube([window_w, window_h, panel_t + 2 * eps]);

        // Holder replica mounting holes, positioned from the top-left panel corner.
        for (hole = holder_holes) {
            translate([mirrored_x(hole_x(hole)), y_from_top(hole_y(hole)), -eps])
                cylinder(d = hole_d(hole), h = panel_t + 2 * eps);
        }
    }
}

module label_from_top_left(txt, x, y) {
    color(label_color)
        translate([x, y_from_top(y), -label_gap])
            rotate([180, 0, 180])
                linear_extrude(height = label_depth)
                    text(
                        txt,
                        size = label_size,
                        halign = "center",
                        valign = "center"
                    );
}

module holder_labels() {
    for (hole = holder_holes) {
        label_from_top_left(
            hole_label(hole),
            mirrored_x(hole_x(hole) + label_dx(hole_label(hole))),
            hole_y(hole)
        );
    }

    label_from_top_left("W1", mirrored_x(window_x + 10), window_y + 8);
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
    top_end_y = blue_rect_end_y;
    bottom_end_y = blue_rect_end_y - stand_plate_t;
    end_z = stand_plate_top_z(top_end_y);

    polyhedron(
        points = [
            [0, stand_plate_low_y, -eps],
            [0, stand_plate_top_y0, -eps],
            [0, top_end_y, end_z],
            [0, bottom_end_y, end_z],
            [panel_w, stand_plate_low_y, -eps],
            [panel_w, stand_plate_top_y0, -eps],
            [panel_w, top_end_y, end_z],
            [panel_w, bottom_end_y, end_z]
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

module panel_inside_top_label() {
    color("white")
        translate([
            panel_w / 2,
            y_from_top(inside_label_y),
            panel_t - eps
        ])
            linear_extrude(height = inside_label_depth + eps)
                text(
                    inside_label_text,
                    size = inside_label_size,
                    font = inside_label_font,
                    halign = "center",
                    valign = "center"
                );
}

module sloped_wall(x0, x1, y0, y1, h, base_offset = 0) {
    normal_y = stand_plate_rise / stand_plate_len;
    normal_z = -stand_plate_run / stand_plate_len;
    z0 = stand_plate_top_z(y0);
    z1 = stand_plate_top_z(y1);

    polyhedron(
        points = [
            [x0, y0 + normal_y * base_offset, z0 + normal_z * base_offset],
            [x0, y1 + normal_y * base_offset, z1 + normal_z * base_offset],
            [x0, y1 + normal_y * (base_offset + h), z1 + normal_z * (base_offset + h)],
            [x0, y0 + normal_y * (base_offset + h), z0 + normal_z * (base_offset + h)],
            [x1, y0 + normal_y * base_offset, z0 + normal_z * base_offset],
            [x1, y1 + normal_y * base_offset, z1 + normal_z * base_offset],
            [x1, y1 + normal_y * (base_offset + h), z1 + normal_z * (base_offset + h)],
            [x1, y0 + normal_y * (base_offset + h), z0 + normal_z * (base_offset + h)]
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

module blue_rectangle(x0) {
    x1 = x0 + stand_width;

    difference() {
        sloped_wall(x0, x1, blue_rect_start_y, blue_rect_end_y, stop_h);
        sloped_wall(
            x0 - eps, x1 + eps,
            blue_cutout_start_y, blue_rect_end_y + eps,
            blue_cutout_h + 2 * eps, blue_cutout_offset - eps
        );
    }
}

module gray_tender(x_outer, inward_dir) {
    x0 = inward_dir > 0 ? x_outer : x_outer - gray_support_w;
    x1 = inward_dir > 0 ? x_outer + gray_support_w : x_outer;
    x_mid = inward_dir > 0 ? x1 - stand_width / 2 : x0 + stand_width / 2;
    tangent_angle = -atan2(stand_plate_run, stand_plate_rise);
    tender_end_z = stand_plate_top_z(gray_tender_end_y);
    normal_y = stand_plate_rise / stand_plate_len;
    normal_z = -stand_plate_run / stand_plate_len;

    union() {
        sloped_wall(
            x0, x1,
            gray_tender_start_y, gray_tender_end_y,
            gray_tender_t, gray_tender_offset
        );
        translate([
            x_mid,
            gray_tender_end_y + normal_y * gray_pin_center_offset,
            tender_end_z + normal_z * gray_pin_center_offset
        ])
            rotate([tangent_angle, 0, 0])
                union() {
                    translate([0, 0, -gray_pin_embed])
                        cylinder(d = gray_pin_d, h = gray_pin_len + gray_pin_embed);

                    hull() {
                        translate([0, 0, gray_pin_len - gray_hook_cap_len])
                            cylinder(d = gray_hook_base_d, h = gray_hook_cap_len);
                        translate([0, gray_hook_rise, gray_pin_len + gray_hook_reach - gray_hook_cap_len])
                            cylinder(d = gray_hook_tip_d, h = gray_hook_cap_len);
                    }
                }
    }
}

union() {
    color("yellow")
        panel_body();

    if (show_labels)
        holder_labels();
    panel_inside_top_label();

    if (show_full_holder) {
        color("green")
            stand_plate();
        color("lightblue") {
            blue_rectangle(stand_inset);
            blue_rectangle(panel_w - stand_inset - stand_width);
        }
        color("gray") {
            gray_tender(stand_inset, 1);
            gray_tender(panel_w - stand_inset, -1);
        }

        color("red") {
            side_stand(stand_inset);
            side_stand(panel_w - stand_inset - stand_width);
        }
    }
}
