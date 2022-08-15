rHollowCenter = 13;
rBlades = 35;
lWall = 2.6;
hSpool = 62;
hIntersect = 5;

module endOfConfigsNop() {}

cadFix = 0.005;
$fn = 250;

rCenter = rHollowCenter + lWall;
hHalfSpool = (hSpool + hIntersect) / 2;
lGap = 0.06;



module baseBody() {
    cylinder(lWall, r = rBlades);
    cylinder(hHalfSpool, r = rCenter);
}

module body() {
    difference() {
        baseBody();
        translate([0, 0, - cadFix])
            cylinder(hHalfSpool + 2 * cadFix, r = rHollowCenter);
        translate([rHollowCenter, 0, 0])
            sphere(5);
    }
}

module bodyWithOuterIntersect() {
    difference() {
        body();
        translate([0, 0, (hSpool - hIntersect) / 2])
            cylinder(hHalfSpool, r = rHollowCenter + lWall / 2 + lGap);
    }
}

module bodyWithInnerIntersect() {
    difference() {
        body();
        translate([0, 0, (hSpool - hIntersect) / 2])
            difference() {
                cylinder(hHalfSpool, r = rCenter + cadFix);
                cylinder(hHalfSpool, r = rHollowCenter + lWall / 2 - lGap);
            }
    }
}

module windingAdapter() {
    difference() {
        cylinder(hSpool, r1 = rHollowCenter + lGap, r2 = rHollowCenter - 2 * lGap);
        translate([0,0,-cadFix])
            cylinder(hSpool + 2*cadFix, d=7.2, $fn=6);
    }
}

//bodyWithInnerIntersect();
//bodyWithOuterIntersect();
windingAdapter();

module paintBodyWithOuterIntersectForTotal() {
    color("red")
        translate([0, 0, hSpool + cadFix])
            rotate([180, 0, 0])
                bodyWithOuterIntersect();
}