
mode="default";

include <components/keys.scad>

use <components/holes.scad>
include <components/bracket.scad>

acrylic_thickness = 3.0;
steel_thickness = 1.6;
stack_fudge = 0.01;
depth=100;
plate_size=plateholesize(overlap=0);
top_size = [220, plate_size[1]];
bendangle=30;
bendradius=1.0 + steel_thickness;
platespacing = ((PI * (bendangle/180)) / (PI * bendradius)) + ((PI * (bendangle/180)) / (PI * (bendradius - steel_thickness)));
bracketspacing = bracket_short;
platemargin = 10;
columns = 6;

module keyplate(h=1.6, margin=platemargin, mountdistance, xkeys=columns, ykeys=4, drilled=true, fillet_radius=2, keys=true) {
    //1.6 mm steel
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

        if (keys) {
            translate([margin, margin, -h])
                keygrid(2 * h, xkeys, ykeys, drilled);
        }
        if (drilled) {
            //mounting holes
            for (x=[0,1]) {
                for (y=[0,1]) {
                translate([mountdistance + (x * (width - (2 * mountdistance))),
                           mountdistance + (y * (height - (2 * mountdistance))), -h])
                    //3.26 diameter for 4-40 screws
                    cylinder(d=3.45, h=2*h, $fs=1);
                }
            }
        }
    }
}


module keyplate_with_brackets(h=1.6, margin=platemargin, mountdistance=bracketspacing, xkeys=columns, ykeys=4, drilled=true, fillet_radius=2, keys=true) {
    union() {
        keyplate(h, margin, mountdistance, xkeys, ykeys, drilled, fillet_radius, keys);

        //add brackets so we can easily line up our holes
        for (x=[0,1]) {
            for (y=[0,1]) {
                xdistance=(x * plate_size[0]);
                ydistance=y * plate_size[1];
                rotate([0, 0, 0])
                translate([xdistance + (1 - (2 * x)) * mountdistance,
                           ydistance,
                            - steel_thickness])

                    //rotate([180, 0, 90 + y * 180])
                    rotate([0, 90, 90 + y * 180])
                    bracket();

            }
        }
    }
}


module topplate(h=1.6, width, height, mountdistancex, mountdistancey, drilled=true, fillet_radius=2) {

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
            for (x=[0,1,2]) {
                for (y=[0,1]) {
                    translate([mountdistancex + (x * ((width - (2 * mountdistancex)) /2)),
                                    mountdistancey + (y * (height - (2 * mountdistancey))), -h])
                        cylinder(d=3.45, h=2*h, $fs=1);
                }
            }
        }

        translate([20, 15, -h])     jsmount(2 * h);
        translate([width * 3 / 4, height / 2, -h]) buttoncluster(2 * h);
    }

}

module topplate_with_brackets(h=1.6, width, height,  mountdistancex=bracketspacing+2, mountdistancey=bracketspacing, drilled=true, fillet_radius=2) {
    union() {
        topplate(h, width, height, mountdistancex, mountdistancey, drilled, fillet_radius);

        //add brackets so we can easily line up our holes
        for (x=[-1, 0, 1]) {
            for (y=[0,1]) {
                xdistance=(x * ((width/2) - mountdistancex));
                ydistance=y * plate_size[1];
                rotate([0, 0, 0])
                translate([width/2 + xdistance,
                           ydistance,
                            - steel_thickness])

                    //rotate([180, 0, 90 + y * 180])
                    rotate([0, 90, 90 + y * 180])
                    bracket();

            }
        }
    }
}

module side(h=1.6, bottom, top, height, fillet_radius=steel_thickness, chin=20, notches=true, drilled=true) {
    color("grey")
    linear_extrude(height=h) {

        difference() {
            hull() {
                translate([0, -chin, 0]) circle(r=fillet_radius, $fs=1);
                translate([bottom, -chin, 0]) circle(r=fillet_radius, $fs=1);
                translate([0, 0, 0]) circle(r=fillet_radius, $fs=1);
                translate([bottom, 0, 0]) circle(r=fillet_radius, $fs=1);
                translate([(bottom - top)/2, height, 0]) circle(r=fillet_radius, $fs=1);
                translate([(bottom - top)/2 + top, height, 0]) circle(r=fillet_radius, $fs=1);
            };
            if (notches) {
                rotate([0, 0, 30])
                    translate([(keyspacing + keysize)/2 + (keyspacing * 3), 0, 0])
                    square(14, center=true);
                translate([(bottom - top)/2 + top, height, 0])
                    rotate([0, 0, -30])
                    translate([(keyspacing + keysize)/2 + (keyspacing * 3), 0, 0])
                    square(14, center=true);

            };
            if (drilled) {

                for (side=[0,1]) {
                    translate([side * bottom, 0]) scale([1 - (2 * side), 1, 1]) rotate([0, 0, bendangle]) for (x=[0,1]) {
                            translate([(plate_size[0] * x) + ((1 + (-2 * x)) * bracketspacing),
                                        -bracket_long]) circle(d=3.45, $fs=1);
                    }
                }
                for (x=[-1, 0, 1]) {
                     translate([bottom / 2 + (x * (top / 2)) - (x * (bracketspacing + 2)),
                               height - bracket_long])
                        circle(d=3.45, $fs=1);
                     translate([bottom / 2 + (x * (bottom / 2)) - (x * bracketspacing),
                               bracket_short - chin])
                        circle(d=3.45, $fs=1);
                }
            }
        };
    };
}

module bottom(h=1.6, mountdistancex, mountdistancey, width, height, fillet_radius=steel_thickness, drilled=true) {
    color("grey")
    linear_extrude(height=h) {

        difference() {
            hull() {
                
                for (x=[0,1]) {
                    for (y=[0,1]) {
                        translate([((width - (2 * fillet_radius)) * x) + fillet_radius,
                                ((height - (2 * fillet_radius)) * y) + fillet_radius, -h/2])
                                circle(r=fillet_radius, $fs=1);
                    }
                }
            };
            if (drilled) {

            for (x=[0,1,2]) {
                for (y=[0,1]) {
                    translate([mountdistancex + (x * ((width - (2 * mountdistancex)) /2)),
                                    mountdistancey + (y * (height - (2 * mountdistancey))), -h])
                        circle(d=3.45, $fs=1);
                }
            }
        }
        };
    };
}


module bottom_with_brackets(h=1.6, width, height,  mountdistancex=bracketspacing, mountdistancey=bracketspacing+2, drilled=true, fillet_radius=2) {
    union() {
        bottom(h, mountdistancex, mountdistancey, width, height, fillet_radius, drilled);

        //add brackets so we can easily line up our holes
        for (x=[-1, 0, 1]) {
            for (y=[0,1]) {
                xdistance=(x * ((width/2) - mountdistancex));
                ydistance=y * plate_size[1];
                rotate([0, 0, 0])
                translate([width/2 + xdistance,
                           ydistance,
                            steel_thickness])

                    //rotate([180, 0, 90 + y * 180])
                    rotate([0, 0, 90 + y * 180])
                    bracket();

            }
        }
    }
}


if (mode == "default") {
    tx=cos(bendangle) * plate_size[0] + top_size[0];
    tz=sin(bendangle) * plate_size[0];
    
    translate([0, 0, 0])
        rotate([0, -bendangle, 0])
    translate([0, 0, bendradius - (steel_thickness/2)])
        keyplate_with_brackets(steel_thickness, mountdistance=bracketspacing);
    translate([tx, 0, tz])
        rotate([0, bendangle, 0])
	translate([0, 0, bendradius - (steel_thickness/2)])
        keyplate_with_brackets(steel_thickness, mountdistance=bracketspacing);
    
    
    translate([0, 0, -20 - steel_thickness]) 
        bottom_with_brackets(steel_thickness, 
                             mountdistancex=bracketspacing,  
                             mountdistancey=bracketspacing + 1.1, 
                             width=cos(bendangle)*plate_size[0] * 2 + top_size[0], 
                             height=plate_size[1], drilled=true);

   for (x=[0,1]) {
        for (y=[0,1]) {
            for (side=[0, 1]) {
                xdistance=((x * plate_size[0])  +
                    (1 - (2 * x)) * bracketspacing);
                ydistance=y * plate_size[1];
                translate([xdistance * cos(bendangle),
                           ydistance,
                           xdistance * sin(bendangle)])
                    rotate([-90 + (y * 180), 90 - bendangle, 0]) bracket();
            }
        }
    }
    translate([cos(bendangle) * plate_size[0], 0, sin(bendangle) * plate_size[0] + bendradius - (steel_thickness/2)])
        topplate_with_brackets(steel_thickness, width=top_size[0], height=top_size[1]);


    for (y=[0,1]) {
        translate([0, (plate_size[1] + steel_thickness) * y, 0]) rotate([90, 0, 0]) side(bottom=cos(bendangle)*plate_size[0] * 2 + top_size[0], top=top_size[0], height=sin(bendangle) * plate_size[0], notches=(y == 1));
    }
    
}
else if (mode == "exportkeyplate") {
    projection(cut=true) keyplate(steel_thickness, mountdistance=bracketspacing);
}
else if (mode == "exportarcadeplate") {
    projection(cut=true) topplate(steel_thickness, width=top_size[0], height=top_size[1], mountdistancex=bracketspacing, mountdistancey=bracketspacing+2);    
}
else if (mode == "exportsplitbottom") {
    projection(cut=true) keyplate(steel_thickness, mountdistance=bracketspacing, drilled=true, keys=false);
}
else if (mode == "exportbottom") {
    projection(cut=true) bottom(steel_thickness, mountdistancex=bracketspacing, mountdistancey=bracketspacing+1.1, width=cos(bendangle)*plate_size[0] * 2 + top_size[0], height=plate_size[1]);
}
else if (mode == "exportfront") {
    projection(cut=true) side(bottom=cos(bendangle)*plate_size[0] * 2 + top_size[0], top=top_size[0], height=sin(bendangle) * plate_size[0], notches=false);
}
else if (mode == "exportback") {
    projection(cut=true) side(bottom=cos(bendangle)*plate_size[0] * 2 + top_size[0], top=top_size[0], height=sin(bendangle) * plate_size[0], notches=true);
}
else {
    assert(false, "Invalid rendering mode");
}
