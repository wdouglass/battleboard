$fs = 0.01;

mode="default";

use <components/holes.scad>

module plate(h=1.6, drilled=true) {
    //1.6 mm steel
    fillet_radius=5;
    width=500;
    height=100;
    color("grey", 0.5)
    difference() {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([((width - (2 * fillet_radius)) * x) + fillet_radius,
                               ((height - (2 * fillet_radius)) * y) + fillet_radius, -h/2])
                            cylinder(r=fillet_radius, h=h);
                }
            }
        };


        if (drilled) {
            translate([0 + 114, 15, -h])
                keygrid(2 * h);
            translate([164 + 114, 15, -h])
                keygrid(2 * h);
            translate([410, 16, -h])
                jsmount(2*h);
            translate([60, 50, -h])
                buttoncluster(2*h);
            translate([250, 50, -h])
                buttoncluster(2*h, false);
        }
    }
}

module box(width=700, height=140, depth=100, thickness=5.588) {
    inner_fillet_radius=5.0;
    plate_hole_width=490;
    plate_hole_height=90;
    color("blue", 0.5)
    difference() {
        cube([width, height, depth]);
        translate([thickness, thickness, thickness]) cube([width-(2 * thickness),
                                                           height-(2 * thickness),
                                                           depth-(2 * thickness)]);

        translate([(width - plate_hole_width) / 2, (height - plate_hole_height) / 2, 0])
            hull() {
                for (x=[0,1]) {
                    for (y=[0,1]) {
                        translate([((plate_hole_width - (2 * inner_fillet_radius)) * x) + inner_fillet_radius,
                                   ((plate_hole_height - (2 * inner_fillet_radius)) * y) + inner_fillet_radius, depth-thickness * 2])
                                cylinder(r=inner_fillet_radius, h=3 * thickness);
                    }
                }
            };
    }
}


acrylic_thickness = 5.88;
steel_thickness = 1.6;
stack_fudge = 0.01;
depth=100;
if (mode == "exportplate") {
    projection(cut=true) plate();
}
else if (mode == "exporttop") {

     projection(cut=true) translate([0,0,-(depth - (acrylic_thickness/2))]) box();
}
else if (mode == "default") {
    translate([100, 20, depth - acrylic_thickness - (steel_thickness/2) - stack_fudge])
        plate(steel_thickness);
    box(thickness=acrylic_thickness);
}
else {
    assert(false, "Invalid rendering mode");
}
