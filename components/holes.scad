
include <keys.scad>

function plateholesize(platemargin=10, xkeys=6, ykeys=4, overlap=5) =
    [((platemargin - overlap) * 2) + ((xkeys - 1) * keyspacing + keysize),
     ((platemargin - overlap) * 2) + ((ykeys - 1) * keyspacing + keysize)];

module platehole(thickness=1.6, r, platemargin=10, xkeys=6, ykeys=4, overlap=5) {
    margin=platemargin - overlap;
    size=plateholesize(platemargin, xkeys, ykeys, overlap);
    width=size[0];
    height=size[1];

    hull() {
        for (x=[0,1]) {
            for (y=[0,1]) {
                translate([((width - (2 * r)) * x) + r,
                           ((height - (2 * r)) * y) + r, -thickness / 2])
                    cylinder(r=r, h=thickness);
            }
        }
    };
}

module drillhole(h,r,fn=90) {
    fudge = (1+1/cos(180/fn))/2;
    cylinder(h=h,r=r*fudge,$fn=fn);

}

module keygrid(thickness=1.6, w=6, h=4, drilled=true) {

    module key(thickness) {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([0.5 + (13 * x), 0.5 + (13 * y), 0])
                        cylinder(r=0.5, h=thickness, $fs=0.15);
                };
            };
        };
    }

    module mountingholes(thickness) {
        for (x=[0,1]) {
            for (y=[0,1]) {
                translate([(keyspacing + keysize)/2 + ((w-2) * keyspacing * x),
                           (keyspacing + keysize)/2 + ((h-2) * keyspacing * y), 0])
                    drillhole(r=1.2, h=thickness);
            }
        }
        translate([(keyspacing + keysize)/2 + floor((w-2)/2) * keyspacing, (keyspacing + keysize)/2 + keyspacing, 0])
            drillhole(r=1.2, h=thickness);
    }

    if (drilled) mountingholes(thickness);

    for(x=[0:w-1]) {
        for (y=[0:h-1]) {
            translate([x * 19.05, y * 19.05, 0])
                key(thickness);
        }
    };
};

module dogbone(size=[1, 1, 1], radius=0.2) {
    cube(size=size);
    offset=sqrt(pow(radius, 2)/2);
    for (x=[offset, size[0] - offset]) {
        for (y=[offset, size[1] - offset]) {
            translate([x, y, 0]) cylinder(h=size[2], r=radius);
        }
    }
}

module jsmount(h=1.6) {
    //mount for HAPP style joystick (i think? measured these values from what i have...)

    centersize=16;
    boltsize=3;
    width=75.075;
    height=64.55;

    for(x=[0,1]) {
        for (y=[0,1]) {
            translate([x * width, y * height, 0])
                drillhole(r=boltsize, h=h);
        }
    }
    translate([width/2, height/2, 0])
        drillhole(r=centersize, h=h);

}

module buttonmount(h=1.6) {
    //mount for 28mm arcade buttons

    radius=14;
    drillhole(r=radius, h=h);
}

module buttoncluster(h=1.6, left=true) {
    vert = 20;
    horiz = 30;
    translate([0, vert, 0])
        buttonmount(h);
    translate([0, -vert, 0])
        buttonmount(h);
    if (left) {
        translate([horiz, 0, 0])
            buttonmount(h);
        translate([-horiz, 0, 0])
            buttonmount(h);
    }
}
