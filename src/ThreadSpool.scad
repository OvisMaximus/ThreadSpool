rHollowCenter = 13;
rBlades = 35;
lWall = 2.6;
hSpool = 62;
hIntersect = 5;
dSixEdgeKey = 7.45;
lThreadLock = 5;
wThreadLock = 2;

which_part = 0; //[0: Spool part 1, 1: Spool part 2, 2: Complete Spool as overview, 3: winding adapter]

module endOfConfigsNop() {}

cadFix = 0.05;
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

module testNut() {
    hWindingAdapter = 4;
    difference() {
        cylinder(hWindingAdapter, r = 4.5);
        translate([0,0,-cadFix])
            cylinder(hWindingAdapter + 2*cadFix, d=dSixEdgeKey, $fn=6);
    }
}

module windingAdapter() {
    hWindingAdapter = hSpool / 2;
    lSpeiche = 5;
    difference() {
        cylinder(hWindingAdapter, r1 = rHollowCenter + 3 * lGap, r2 = rHollowCenter - 3 * lGap);
        translate([0,0,-cadFix])
            cylinder(hWindingAdapter + 2*cadFix, d=dSixEdgeKey, $fn=6);
        for(i = [30:60:360]) {
            rotate([0,0,i]) {
                translate([rHollowCenter - lWall - lSpeiche, 0, - cadFix])
                    wedge(4, 9, lSpeiche, hWindingAdapter + 2 * cadFix);
                translate([rHollowCenter - lWall * .65 , 0, - cadFix])
                    rotate([0,0,180])
                        wedge(4, 9, 1, hWindingAdapter + 2 * cadFix);
            }
        }
    }
}

module paintBodyWithOuterIntersectForTotal() {
    color("red", alpha = 0.5)
        translate([0, 0, hSpool + cadFix])
            rotate([180, 0, 0])
                bodyWithOuterIntersect();
}

if(which_part==0) {
    bodyWithInnerIntersect();
} else if(which_part==1) {
    bodyWithOuterIntersect();
} else if(which_part==2) {
    bodyWithInnerIntersect();
    paintBodyWithOuterIntersectForTotal();
} else {
    windingAdapter();
}




