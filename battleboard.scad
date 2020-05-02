
mode="default";

include <components/keys.scad>

use <components/holes.scad>

module plate(h=1.6, margin=10, mountdistance=4, xkeys=6, ykeys=4, drilled=true) {
    //1.6 mm steel
    fillet_radius=2;
    width=(margin * 2) + ((xkeys - 1) * keyspacing + keysize);
    height=(margin * 2) + ((ykeys - 1) * keyspacing + keysize);
    color("grey", 0.5)
    difference() {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([((width - (2 * fillet_radius)) * x) + fillet_radius,
                               ((height - (2 * fillet_radius)) * y) + fillet_radius, -h/2])
                            cylinder(r=fillet_radius, h=h, $fs=0.1);
                }
            }
        };


        if (drilled) {
            translate([margin, margin, -h])
                keygrid(2 * h, xkeys, ykeys);
            //mounting holes
            
            for (x=[0,1]) {
                for (y=[0,1]) {
                translate([mountdistance + (x * (width - (2 * mountdistance))), 
                           mountdistance + (y * (height - (2 * mountdistance))), -h])
                    cylinder(r=1.2, h=2*h, $fs=0.1);
                }
            }
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

        translate([(width - plate_hole_width) / 2, (height - plate_hole_height) / 2, depth - thickness/2])
            platehole(r=inner_fillet_radius, thickness=thickness * 2);
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
