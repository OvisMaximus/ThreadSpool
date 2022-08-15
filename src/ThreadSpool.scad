rHollowCenter = 13;
rBlades = 35;
lWall = 2.6;
hSpool = 62;
hIntersect = 5;
dSixEdgeKey = 7.5;
lThreadLock = 5;
wThreadLock = 2;

module endOfConfigsNop() {}

cadFix = 0.005;
$fn = 250;

rCenter = rHollowCenter + lWall;
hHalfSpool = (hSpool + hIntersect) / 2;
lGap = 0.06;


module wedge(wSmall, wLarge, length, height) {
    linear_extrude(height)
        polygon([
            [0,wSmall/2], 
            [length, wLarge/2], 
            [length, wLarge/-2], 
            [0,wSmall/-2]
        ]);
}

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
        translate([rBlades - lThreadLock, 0, -cadFix])
            wedge(wThreadLock * .7, wThreadLock * 1.1, lThreadLock, lWall + 2 * cadFix);
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
    hWindingAdapter = hSpool / 2;
    difference() {
        cylinder(hWindingAdapter, r1 = rHollowCenter + 3 * lGap, r2 = rHollowCenter - 3 * lGap);
        translate([0,0,-cadFix])
            cylinder(hWindingAdapter + 2*cadFix, d=dSixEdgeKey, $fn=6);
    }
}

module paintBodyWithOuterIntersectForTotal() {
    color("red", alpha = 0.5)
        translate([0, 0, hSpool + cadFix])
            rotate([180, 0, 0])
                bodyWithOuterIntersect();
}

bodyWithInnerIntersect();
//bodyWithOuterIntersect();
//paintBodyWithOuterIntersectForTotal();
//windingAdapter();
