// ============================================================
//  Corner Drill Jig
//  L-shaped jig that registers against a metal sheet corner
//  and guides a 5 mm drill bit to the exact position.
// ============================================================

// ---------- Parameters ----------

hole_d    = 6.0;   // nominal drill bit diameter [mm]
clearance = 0.2;   // radial clearance added to guide hole [mm]

// Distance from each flange's inner wall to the hole centre
hole_x    = 37.0;  // distance from flange-A (the "left" wall) [mm]
hole_y    = 72.5;  // distance from flange-B (the "bottom" wall) [mm]

plate_h   =  8;    // total height of the guide plate [mm]
flange_h  =  5;    // depth the flanges extend BELOW the plate (grips sheet edge) [mm]
flange_w  =  4;    // wall thickness of each flange [mm]

margin_x  = 15;    // extra plate material beyond hole centre in X [mm]
margin_y  = 15;    // extra plate material beyond hole centre in Y [mm]

label_text  = "II"; // roman numeral marking on the short outer side
label_size  = 10;   // label height [mm]
label_width =  2.4; // horizontal scale for blockier roman numerals
label_depth =  2.0; // raised label thickness [mm]
label_embed =  0.05;// overlap into side face for a single solid
label_font  = "Liberation Serif:style=Bold";

// ---------- Derived dimensions ----------

// Total plate footprint:
//   X: flange_w (left wall) + hole_x + margin_x
//   Y: flange_w (bottom wall) + hole_y + margin_y
plate_x = flange_w + hole_x + margin_x;
plate_y = flange_w + hole_y + margin_y;

guide_r = (hole_d + clearance) / 2;

$fn = 64;

// ---------- Main body ----------

difference() {
    union() {
        // Flat guide plate (sits on top of the sheet)
        cube([plate_x, plate_y, plate_h]);

        // Flange A — along the left edge (registers against sheet edge in X)
        translate([0, 0, -flange_h])
            cube([flange_w, plate_y, flange_h]);

        // Flange B — along the bottom edge (registers against sheet edge in Y)
        translate([0, 0, -flange_h])
            cube([plate_x, flange_w, flange_h]);

        // Raised roman numeral on the opposite short, high outer side
        translate([plate_x / 2, label_embed, (plate_h - flange_h) / 2])
            rotate([90, 0, 0])
                linear_extrude(height = label_depth)
                    scale([label_width, 1, 1])
                        text(label_text, size = label_size, font = label_font,
                             halign = "center", valign = "center");
    }

    // Drill guide hole — centred at (hole_x, hole_y) from the inner corner
    //   inner corner = (flange_w, flange_w) in plate coordinates
    translate([flange_w + hole_x, flange_w + hole_y, -1])
        cylinder(r = guide_r, h = plate_h + 2);
}
