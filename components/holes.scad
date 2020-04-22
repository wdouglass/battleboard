
module drillhole(h,r,fn=180) {
    fudge = (1+1/cos(180/fn))/2;
    cylinder(h=h,r=r*fudge,$fn=fn);
}

module keygrid(h=1.6) {
    keysize=14;
    keyspacing=19.05;

    module key(h) {
        hull() {
            for (x=[0,1]) {
                for (y=[0,1]) {
                    translate([0.5 + (13 * x), 0.5 + (13 * y), 0])
                        cylinder(r=0.5, h=h);
                };
            };
        };
    }

    module mountingholes(h) {
        for (x=[0,1]) {
            for (y=[0,1]) {
                translate([(keyspacing + keysize)/2 + (4 * keyspacing * x),
                           (keyspacing + keysize)/2 + (2 * keyspacing * y), 0])
                    drillhole(r=1.2, h=h);
            }
        }
        translate([(keyspacing + keysize)/2 + 2 * keyspacing, (keyspacing + keysize)/2 + keyspacing, 0])
            drillhole(r=1.2, h=h);
    }

    mountingholes(h);
    for(x=[0:5]) {
        for (y=[0:3]) {
            translate([x * 19.05, y * 19.05, 0])
                key(h);
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
