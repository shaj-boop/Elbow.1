// Elbow-1 — open single-joint elbow assist
// Print PETG, 0.2 mm, 5 perimeters, 40% gyroid.
// MX-28AT body: 35.6 x 50.6 x 35.5 mm (ROBOTIS).
// Units: millimetres. Origin: assembly midline.

$fn = 64;

part = "assembly"; // cuff_upper | cuff_forearm | horn_adapter | loadcell_bracket | extrusion_clip | dummy_mx28 | assembly

// --- MX-28AT ---
mx_w = 35.6;
mx_h = 50.6;
mx_d = 35.5;
horn_r_holes = 8.0;     // M2 holes on MX horn
horn_od = 22.0;
horn_screw = 3.2;

// --- 2020 ---
ext = 20;
ext_slot = 6.2;

// --- load cell 20 kg aluminium bar (typical) ---
lc_l = 75;
lc_w = 12.7;
lc_h = 12.7;
lc_hole = 4.3;
lc_hole_inset = 15;

// --- cuffs (adult) ---
upper_id = 96;
fore_id  = 80;
cuff_t   = 4.2;
cuff_w   = 32;
web_w    = 25;
web_t    = 3.2;

module mx28_dummy() {
    color("#2a2a2a")
        cube([mx_w, mx_d, mx_h], center=true);
    color("#c9a227")
        translate([0, mx_d/2 + 1.2, mx_h*0.18])
            rotate([90,0,0])
                cylinder(h=2.4, d=horn_od, center=true);
}

module horn_adapter() {
    // Sits on MX horn, presents a 2020-facing plate with 4x M3.
    difference() {
        union() {
            cylinder(h=6, d=horn_od + 4);
            translate([0,0,6])
                hull() {
                    cylinder(h=1, d=horn_od + 4);
                    translate([0, 14, 8])
                        cube([22, 8, 16], center=true);
                }
            translate([0, 16, 14])
                cube([22, 10, 22], center=true);
        }
        // horn screw
        translate([0,0,-1]) cylinder(h=20, d=horn_screw);
        // 4x M2 on horn
        for (a = [0:90:270])
            rotate([0,0,a])
                translate([horn_r_holes, 0, -1])
                    cylinder(h=20, d=2.3);
        // 2020 pocket
        translate([0, 22, 14])
            cube([ext + 0.4, 12, ext + 0.4], center=true);
        // M3 through 2020
        translate([0, 16, 14])
            rotate([90,0,0])
                cylinder(h=30, d=3.3, center=true);
        // M3 nut trap
        translate([0, 12, 14])
            rotate([90,0,0])
                cylinder(h=3.2, d=6.2, center=true, $fn=6);
    }
}

module cuff(inner) {
    outer = inner + 2*cuff_t;
    split = 18;
    difference() {
        union() {
            cylinder(h=cuff_w, d=outer);
            // 2020 boss
            translate([outer/2 + 6, 0, cuff_w/2])
                cube([16, 28, cuff_w], center=true);
        }
        translate([0,0,-1]) cylinder(h=cuff_w+2, d=inner);
        // split for flex / webbing close
        translate([0, -outer/2, cuff_w/2])
            cube([split, outer, cuff_w+2], center=true);
        // webbing slots
        for (z = [8, cuff_w-8]) {
            translate([-inner/4, inner/2 - 2, z])
                rotate([90,0,0])
                    hull() {
                        translate([-web_w/2 + 1.5, 0, 0]) cylinder(h=20, d=web_t);
                        translate([ web_w/2 - 1.5, 0, 0]) cylinder(h=20, d=web_t);
                    }
        }
        // M3 pair into 2020 boss
        translate([outer/2 + 6, 8, cuff_w/2])
            rotate([0,90,0]) cylinder(h=24, d=3.3, center=true);
        translate([outer/2 + 6,-8, cuff_w/2])
            rotate([0,90,0]) cylinder(h=24, d=3.3, center=true);
        // 2020 pocket in boss
        translate([outer/2 + 12, 0, cuff_w/2])
            cube([ext+0.3, ext+0.3, cuff_w+2], center=true);
    }
}

module cuff_upper()    { cuff(upper_id); }
module cuff_forearm()  { cuff(fore_id); }

module loadcell_bracket() {
    wall = 4;
    difference() {
        translate([0,0,0])
            cube([lc_l + 8, lc_w + 12, lc_h + wall + 8], center=true);
        // pocket
        translate([0,0, wall/2])
            cube([lc_l + 0.4, lc_w + 0.4, lc_h + 0.4], center=true);
        // through for wiring
        cube([20, lc_w + 14, 6], center=true);
        // M4 holes matching bar
        for (x = [-lc_l/2 + lc_hole_inset, lc_l/2 - lc_hole_inset])
            translate([x, 0, 0])
                cylinder(h=40, d=lc_hole, center=true);
        // M3 to 2020 on the back
        for (y = [-8, 8])
            translate([0, y, 0])
                rotate([0,90,0])
                    cylinder(h=40, d=3.3, center=true);
    }
}

module extrusion_clip() {
    difference() {
        cube([28, 28, 16], center=true);
        cube([ext+0.35, ext+0.35, 18], center=true);
        rotate([90,0,0]) cylinder(h=40, d=3.3, center=true);
        rotate([0,90,0]) cylinder(h=40, d=3.3, center=true);
        // slot mouths
        translate([0, ext/2 + 4, 0]) cube([ext_slot, 10, 18], center=true);
    }
}

module assembly() {
    // two MX-28 as agonist / antagonist about the elbow axis
    translate([0,  28, 0]) rotate([0,90,0]) mx28_dummy();
    translate([0, -28, 0]) rotate([0,90,180]) mx28_dummy();
    color("#d8d2c4") {
        translate([-70, 0, 42]) rotate([90,0,90]) cuff_upper();
        translate([ 78, 0, 36]) rotate([90,0,90]) cuff_forearm();
        translate([0, 28, mx_h/2 + 8]) horn_adapter();
        translate([0,-28, mx_h/2 + 8]) rotate([0,0,180]) horn_adapter();
        translate([0, 0, -36]) loadcell_bracket();
        translate([-40, 0, 10]) extrusion_clip();
        translate([ 40, 0, 10]) extrusion_clip();
    }
    // 2020 spars (visual)
    color("#8a8a8a") {
        translate([-48, 0, 10]) cube([80, 20, 20], center=true);
        translate([ 52, 0, 10]) cube([70, 20, 20], center=true);
    }
}

if (part == "cuff_upper")       cuff_upper();
else if (part == "cuff_forearm") cuff_forearm();
else if (part == "horn_adapter") horn_adapter();
else if (part == "loadcell_bracket") loadcell_bracket();
else if (part == "extrusion_clip") extrusion_clip();
else if (part == "dummy_mx28")   mx28_dummy();
else                            assembly();
