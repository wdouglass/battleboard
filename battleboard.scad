
mode="default";

include <components/keys.scad>

use <components/holes.scad>

module keyplate(h=1.6, margin=10, mountdistance=4, xkeys=6, ykeys=4, drilled=true) {
    //1.6 mm steel
    fillet_radius=2;
    size = plateholesize(margin, xkeys, ykeys, overlap=0);
    width=size[0];
    height=size[1];
    color("grey")
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
  
    color("grey")
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
plate_size=plateholesize(overlap=0);
top_size = [220, plate_size[1]];
bendangle=30.0;
bendradius=0.5 + steel_thickness;
platespacing = ((PI * (bendangle/180)) / (PI * bendradius)) + ((PI * (bendangle/180)) / (PI * (bendradius - steel_thickness)));
if (mode == "exportplate") {
    projection(cut=true) union() {
        keyplate(steel_thickness);
        translate([plate_size[0] + platespacing, 0, 0])
            topplate(width=top_size[0], height=top_size[1]);
        translate([plate_size[0] + top_size[0] + (platespacing * 2), 0, 0])
            keyplate(steel_thickness);
    }
    //connective tissue
    for (x=[0,1]) {
        for (y=[0,1]) {
            translate([plate_size[0] + (platespacing / 2) + (x * (top_size[0] + (platespacing / 2))),
	              (plate_size[1] * (y + 1)) / 3,
		      0])
	        square(size=7, center=true);
	}
    }
}
else if (mode == "default") {
    translate([0, 0, 0]) 
        rotate([0, -bendangle, 0]) 
	translate([0, 0, bendradius - (steel_thickness/2)])
        keyplate(steel_thickness);
    translate([cos(bendangle) * plate_size[0] + top_size[0], 0, sin(bendangle) * plate_size[0]]) 
        rotate([0, bendangle, 0])
	translate([0, 0, bendradius - (steel_thickness/2)])
        keyplate(steel_thickness);


    translate([cos(bendangle) * plate_size[0], 0, sin(bendangle) * plate_size[0] + bendradius - (steel_thickness/2)])
        topplate(width=top_size[0], height=top_size[1]);
	

    for (x=[0,1]) {
        for (y=[0,1]) {
	    color("grey") translate([cos(bendangle) * plate_size[0]  + (x * (top_size[0])),
                      (plate_size[1] * (y + 1)) / 3,
		      sin(bendangle) * plate_size[0]])
		      rotate([90, 0, 0])
		          difference() {
		          cylinder(r=bendradius, h=7, center=true, $fs=0.1);
		          cylinder(r=bendradius - steel_thickness, h=8, center=true, $fs=0.1);
			  translate([0, 0, -5])
			      mirror([x,0,0])
                              rotate([0, 0, 210])
			      translate([0, -(bendradius-steel_thickness), 0])			      
			      cube([10, 10, 10]);
			      
			  translate([-10 * x, -10 + (bendradius - steel_thickness), -5]) cube([10, 10, 10]);}
		      
	}
    }
    *rotate([90, 0, 0]) side(bottom=cos(bendangle)*plate_size[0] * 2 + top_size[0], top=top_size[0], height=sin(bendangle) * plate_size[0]);
}
else {
    assert(false, "Invalid rendering mode");
}
