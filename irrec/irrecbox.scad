
ircap();
*render(convexity=10) ircap();
*color("#ac44") render(convexity=10) irbox();
*#digispark();

module ircap()
{
    thi = 1.2;
    hi = 10.4;
    wid = 18.5 - 0.2;
    len = 24.5 + thi*2;

    ridge = 0.8;

    difference() {
        union() {
            translate([0, -wid/2, 0]) rotate([-90,0,0])
                linear_extrude(height=wid, convexity=5) polygon([
                [24.5/2+thi, 0.1], [24.5/2, 0.1],
                [24.5/2, -1.8], [24.5/2-5, -1.8],
                [-24.5/2+5, -4.4], [-24.5/2+0.1, -4.4],
                [-24.5/2+0.1, -hi], [-24.5/2+0.1+5, -hi],
                [24.5/2+thi, -6.2],
            ]);
            
            translate([-(len)/2+thi+0.1, -(wid)/2, 4.4]) polyhedron(convexity=6,
                points = [
                    [0, 0, 0], [ridge, -ridge, ridge], [0, 0, 2*ridge],
                    [len-thi-0.1, 0, 0], [len-thi-0.1, -ridge, ridge], [len-thi-0.1, 0, 2*ridge]
                ],
                faces = [
                    [0,2,1],
                    [1,3,0], [1,4,3], [2,4,1], [2,5,4], [0,5,2], [0,3,5],
                    [5,3,4]
                ]);
            mirror([0,1,0]) translate([-(len)/2+thi+0.1, -(wid)/2, 4.4]) polyhedron(convexity=6,
                points = [
                    [0, 0, 0], [ridge, -ridge, ridge], [0, 0, 2*ridge],
                    [len-thi-0.1, 0, 0], [len-thi-0.1, -ridge, ridge], [len-thi-0.1, 0, 2*ridge]
                ],
                faces = [
                    [0,2,1],
                    [1,3,0], [1,4,3], [2,4,1], [2,5,4], [0,5,2], [0,3,5],
                    [5,3,4]
                ]);
            translate([24.5/2+thi/2-0.1, 7, -0.1]) mirror([0,0,1]) cylinder(0.4, thi/2-0.1, 0, $fn=4);
            translate([24.5/2+thi/2-0.1,-7, -0.1]) mirror([0,0,1]) cylinder(0.4, thi/2-0.1, 0, $fn=4);
        }
        translate([0, -(wid-thi*2)/2, 0]) rotate([-90,0,0])
            linear_extrude(height=wid-thi*2, convexity=5) polygon([
            [24.5/2-1, -1.79], [24.5/2-5, -1.79],
            [-24.5/2, -4.2],
            [-24.5/2, -hi+thi], [-24.5/2+0.1+5, -hi+thi],
            [24.5/2-1, -6.6+thi],
        ]);
        translate([24.5/2, 0, 4.7/2-0.11]) cube([thi+2, 9, 4.7], true);
    }
}

module irbox()
{
    thi = 1.2;
    hi = 7.5 + 1.8 + thi*2 + 1;
    wid = 18.5 + thi*2;
    len = 24.5 + thi*2;

    ridge = 0.85;

    difference() {
        union() {
            translate([-24.5/2-3.6/2, 0, hi/2+1.6-1.8-thi-1]) cube([3.6, wid, hi], true);
            translate([0, 0, -(thi+1)/2-0.2]) cube([len, wid, thi+1], true);
            translate([0, -wid/2-2+thi, 0]) rotate([-90,0,0])
                linear_extrude(height=2, convexity=6) polygon([
                    [-len/2-2.4, 2.4], [len/2, 2.4],
                    [len/2, -6.2], [-len/2+6.3, -hi+2.4],
                    [-len/2-2.4, -hi+2.4]
                ]);
            translate([0, wid/2-thi, 0]) rotate([-90,0,0])
                linear_extrude(height=2, convexity=6) polygon([
                    [-len/2-2.4, 2.4], [len/2, 2.4],
                    [len/2, -6.2], [-len/2+6.3, -hi+2.4],
                    [-len/2-2.4, -hi+2.4]
                ]);
            translate([-24.5/2, -wid/2+thi, -0.2+2.0]) linear_extrude(height=2.5, convexity=5) polygon([
                [5,0], [0,4], [0,0]
            ]);
            translate([-24.5/2, wid/2-thi, -0.2+2.0]) linear_extrude(height=2.5, convexity=5) polygon([
                [5,0], [0,-4], [0,0]
            ]);
        }
        translate([-24.5/2-3.6/2, 1.5-6.2/2, 1.6+7.5/2]) cube([3.61, 6.6, 7.9], true);
        translate([-24.5/2-1.8/2+4/2, 1.5-6.2/2, -(1.7+1.2)/2+1.5]) cube([4+1.81, 6.4, 1.7+1.21], true);
        translate([0,0,-1.2]) linear_extrude(height=1.21, convexity=5) polygon([
            [-24.5/2+4, -4.8], [-24.5/2+2, 1.5],
            [-24.5/2+2+9.3, 9.3], [-24.5/2+2+9+9.3, 9.3],
        ]);
        translate([-24.5/2, -wid/2+thi, 0]) rotate([-90,0,0])
            linear_extrude(height=wid-thi*2, convexity=5) polygon([
                [0.4,-1], [0.4,-1.8], [5,-1.8-2.5+1], [5,-1]
        ]);

        translate([-(len)/2+thi+0.1, -(wid)/2+thi, 4.3]) polyhedron(convexity=6,
            points = [
                [0, 0.01, 0], [0, -ridge, ridge], [0, 0.01, 2*ridge],
                [len-thi, 0.01, 0], [len-thi, -ridge, ridge], [len-thi, 0.01, 2*ridge]
            ],
            faces = [
                [0,2,1],
                [1,3,0], [1,4,3], [2,4,1], [2,5,4], [0,5,2], [0,3,5],
                [5,3,4]
            ]);
        mirror([0,1,0]) translate([-(len)/2+thi+0.1, -(wid)/2+thi, 4.3]) polyhedron(convexity=6,
            points = [
                [0, 0.01, 0], [0, -ridge, ridge], [0, 0.01, 2*ridge],
                [len-thi, 0.01, 0], [len-thi, -ridge, ridge], [len-thi, 0.01, 2*ridge]
            ],
            faces = [
                [0,2,1],
                [1,3,0], [1,4,3], [2,4,1], [2,5,4], [0,5,2], [0,3,5],
                [5,3,4]
            ]);

            translate([24.5/2+thi/2-0.1, 7, -0.1]) mirror([0,0,1]) cylinder(0.55, thi/2+0.1, 0, $fn=4);
            translate([24.5/2+thi/2-0.1,-7, -0.1]) mirror([0,0,1]) cylinder(0.55, thi/2+0.1, 0, $fn=4);
    }

}

module digispark()
{
    union() {
        translate([0, 0, 1.4/2]) cube([24.5, 18.5, 1.8], true);
        translate([24.5/2-5.5/2, 0, 4/2]) cube([5.5, 7.5, 4], true);
        translate([-24.5/2-3.6/2, 1.5-6.2/2, 1.6+7.5/2]) cube([3.6, 6.2, 7.5], true);
    }
}

