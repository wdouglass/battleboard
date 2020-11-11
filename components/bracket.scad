bracket_size = [9.3, 6.2, 8.7];
steel_thickness = 1.6;
drill_offset = bracket_size[1] / 2;
bracket_short=5;
bracket_long=6.1;

module bracket() {
    translate([0, -drill_offset, 0]) {
        difference() {
            union() {
                cube([bracket_size[0], bracket_size[1], steel_thickness]);
                cube([steel_thickness, bracket_size[1], bracket_size[2]]);
            }
            translate([6.1, drill_offset, -0.1]) cylinder(h=2.0, r=1.0, $fs=0.1);
            rotate([0, -90, 0]) translate([5, 3.1, -1.9]) cylinder(h=2.0, r=1.0, $fs=0.1);
            difference() {
                translate([-0.1, -0.1, -0.1]) cube([steel_thickness + 0.1, 6.4, steel_thickness + 0.1]);
                rotate([-90, 0, 0]) translate([steel_thickness, -steel_thickness, 0]) cylinder(h=6.4, r=steel_thickness, $fs=0.1);
            }
        }
    }
}
