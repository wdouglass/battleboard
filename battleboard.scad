
mode="default";

include <components/keys.scad>

use <components/holes.scad>

module keyplate(h=1.6, margin=10, mountdistance=4, xkeys=6, ykeys=4, drilled=true) {
    //1.6 mm steel
    fillet_radius=2;
    size = plateholesize(margin, xkeys, ykeys, overlap=0);
    width=size[0];
    height=size[1];
    color("grey", 0.5)
    difference() {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([((width - (2 * fillet_radius)) * x) + fillet_radius,
                               ((height - (2 * fillet_radius)) * y) + fillet_radius, -h/2])
                            cylinder(r=fillet_radius, h=h, $fs=1);
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
                    cylinder(r=1.2, h=2*h, $fs=1);
                }
            }
        }
    }
}

module topplate(h=1.6, width, height,  mountdistance=4) {
    
    fillet_radius=2;
  
    color("grey", 0.5)
    difference() {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([((width - (2 * fillet_radius)) * x) + fillet_radius,
                               ((height - (2 * fillet_radius)) * y) + fillet_radius, -h/2])
                            cylinder(r=fillet_radius, h=h, $fs=1);
                }
            }
        };
        
        for (x=[0,1]) {
            for (y=[0,1]) {
            translate([mountdistance + (x * (width - (2 * mountdistance))),
                       mountdistance + (y * (height - (2 * mountdistance))), -h])
                cylinder(r=1.2, h=2*h, $fs=1);
            }
        }
        translate([15, 15, -h]) jsmount(2 * h);
        translate([width * 3 / 4, height / 2, -h]) buttoncluster(2 * h);
    }

}

module side(h=1.6, bottom, top, height) {
    fillet_radius=2;
    
    hull() {
        translate([fillet_radius, fillet_radius, 0]) cylinder(r=fillet_radius, h=h, $fs=1);
        translate([bottom, fillet_radius, 0]) cylinder(r=fillet_radius, h=h, $fs=1);
        translate([fillet_radius + (bottom - top)/2, height, 0]) cylinder(r=fillet_radius, h=h, $fs=1);
        translate([fillet_radius + (bottom - top)/2 + top, height, 0]) cylinder(r=fillet_radius, h=h, $fs=1);
    };
}

acrylic_thickness = 5.88;
steel_thickness = 1.6;
stack_fudge = 0.01;
depth=100;
if (mode == "exportplate") {
    projection(cut=true) keyplate();
}
else if (mode == "exporttop") {

     projection(cut=true) topplate();
}
else if (mode == "default") {
    plate_size=plateholesize(overlap=0);
    top_size = [220, plate_size[1]];
    platespacing = 0.5;
    rotate([0, -30, 0]) 
        keyplate(steel_thickness);
    translate([cos(30) * plate_size[0] + top_size[0] + 2 * platespacing, 0, sin(30) * plate_size[0]]) 
        rotate([0, 30, 0]) 
        keyplate(steel_thickness);
    
    translate([cos(30) * plate_size[0] + platespacing, 0, sin(30) * plate_size[0]])
        topplate(width=top_size[0], height=top_size[1]);
    *rotate([90, 0, 0]) side(bottom=cos(30)*plate_size[0] * 2 + top_size[0], top=top_size[0], height=sin(30) * plate_size[0]);
}
else {
    assert(false, "Invalid rendering mode");
}
