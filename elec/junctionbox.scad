
wid = 120;
len = 150;
hei = 50;

topnut = 1;

th = 2;

tubeth = 20;
wireth = 12;

topholes = 4;
topholeof = 16;

leftholes = 4;

wth = topnut ? 12 : 16;
whi = topnut ? 32 : 22;
wof = topnut ? 10 : 0;
win = topnut ? 4 : 0;
wof2 = topnut ? 10+((tubeth-wireth)/2)+1 : 0;

slitw = 24;

translate([0,0,hei+0.1]) boxcover();
junctionbox();

translate([topholeof+38.25, len-7.1,whi-7]) rotate([-90,0,0]) slitclamp(14,6);
translate([topholeof+38.25, len-17.1,whi-7]) rotate([-90,0,0]) slitclamp(18,4,2);

module slitclamp(hi = 20, ind=4, slp=1.5, th=1.0)
{
    w = slitw-0.4;
    *color("#8af") translate([-w/2,0,0]) cube([w, hi, th]);

    color("#8af") linear_extrude(height=th) polygon([
        [-w/2,0],[w/2,0],[w/2,hi],[ind*slp,hi],[0,hi-ind],[-ind*slp,hi],[-w/2,hi]
    ]);
}

module boxcover()
{
    cof = th*sqrt(2);
    tol = th+0.2;
    difference() {
        union() {
            // base
            linear_extrude(height=th) polygon([
                [0,cof],[cof,0],[wid-cof,0],[wid,cof],[wid,len-cof],[wid-cof,len],[cof,len],[0,len-cof]
            ]);
            // Hinge/lip edge (bottom wall)
            translate([tol,tol,0]) rotate([0,90,0]) linear_extrude(height=wid-tol*2) polygon([
                [0,5],[5,0],[8,0],[8,2],[0,10]
            ]);
            // Top wall
            translate([0,len-th-tol,0]) rotate([-90,0,0]) linear_extrude(height=th) polygon([
                [tol,0],[wid-tol,0],[wid-tol,5],[tol,5]
            ]);

            // Left wall
            translate([tol,0,0]) rotate([0,90,0]) linear_extrude(height=th) polygon([
                [0,tol+5],[0,len-tol],[5,len-tol],[5,tol]
            ]);
            // Right wall
            translate([wid-tol-th,0,0]) rotate([0,90,0]) linear_extrude(height=th) polygon([
                [0,tol+5],[0,len-tol],[5,len-tol],[5,tol]
            ]);
            // Corner bevels
            translate([wid-cof*1.85,len-cof*0.85,-5]) rotate([0,0,225]) cube([th, th*2, 5]);
            translate([cof*0.85,len-cof*1.85,-5]) rotate([0,0,315]) cube([th, th*2, 5]);

            // Closing screw post
            translate([wid/2-5,len-tol,0]) rotate([0,90,0]) linear_extrude(height=10) polygon([
                [0,0],[5,0],[11,-0.5],[11,-6],[9,-8],[0,-10]
            ]);

            // Reinforcing ribs
            translate([0,len/3,-5]) linear_extrude(height=5) polygon([
                [3,-wid/3-1],[wid-3,wid/3-1],[wid-3,wid/3+1],[3,-wid/3+1]
            ]);
            translate([0,len*2/3,-5]) linear_extrude(height=5) polygon([
                [3,-wid/3-1],[wid-3,wid/3-1],[wid-3,wid/3+1],[3,-wid/3+1]
            ]);
            translate([0,len/3,-5]) linear_extrude(height=5) polygon([
                [3,wid/3-1],[wid-3,-wid/3-1],[wid-3,-wid/3+1],[3,wid/3+1]
            ]);
            translate([0,len*2/3,-5]) linear_extrude(height=5) polygon([
                [3,wid/3-1],[wid-3,-wid/3-1],[wid-3,-wid/3+1],[3,wid/3+1]
            ]);
            translate([wid/3-th,0,0]) rotate([0,90,0]) linear_extrude(height=th) polygon([
                [0,tol+5],[0,len-tol],[5,len-tol],[5,tol]
            ]);
            translate([wid*2/3,0,0]) rotate([0,90,0]) linear_extrude(height=th) polygon([
                [0,tol+5],[0,len-tol],[5,len-tol],[5,tol]
            ]);
        }
        // Corner bevels
        translate([cof,0,      -8.1]) rotate([0,0, 45]) translate([0,-2,0]) cube([4.7, th*2+4, 8.1]);
        translate([wid,cof,    -8.1]) rotate([0,0,135]) translate([0,-2,0]) cube([4.7, th*2+4, 8.1]);
        translate([wid-cof,len,-8.1]) rotate([0,0,225]) translate([0,-2,0]) cube([3.3, th*2+4, 8.1]);
        translate([0,len-cof,  -8.1]) rotate([0,0,315]) translate([0,-2,0]) cube([3.3, th*2+4, 8.1]);
        // Closing screw hole
        translate([wid/2,len,-7]) rotate([90,0,0]) cylinder(9,2,2,$fn=60);
    }
}

module junctionbox()
{
    thwid = wid-topholeof-th;
    lhwid = len-2*wth;
    cof = th*sqrt(2);
    difference() {
        union() {
            // Bottom/backside
            translate([th,th,0]) cube([wid-th*2, len-th*2, th]);
            // Left wall
            translate([0,cof,0]) cube([th, len-cof*2, hei]);
            // Right wall
            translate([wid-th,cof,0]) cube([th, len-cof*2, hei]);
            // Bottom wall
            translate([cof,0,0]) cube([wid-cof*2, th, hei]);
            // Top wall
            translate([cof,len-th,0]) cube([wid-cof*2, th, hei]);

            // Corner bevels
            translate([cof,0,0]) rotate([0,0,45]) cube([th, th*2, hei]);
            translate([wid,cof,0]) rotate([0,0,135]) cube([th, th*2, hei]);
            translate([wid-cof,len,0]) rotate([0,0,225]) cube([th, th*2, hei]);
            translate([0,len-cof,0]) rotate([0,0,315]) cube([th, th*2, hei]);

            // Top tube holder, bottom
            translate([topholeof,len-wth-th,0]) wireholder(thwid, wth, whi, topholes, tubeth);
            // Top wire holder, bottom
            translate([topholeof,len-wth-wth-th+win,0]) wireholder(thwid, wth-win, whi, topholes, wireth, wof2, slito=-2);

            // Left tube holder, bottom
            translate([wth+th,th,0]) rotate([0,0,90]) wireholder(lhwid, wth, whi, leftholes, tubeth);
            // Left wire holder, bottom
            translate([wth*2+th-win,th,0]) rotate([0,0,90]) wireholder(lhwid, wth-win, whi, leftholes, wireth, wof2, slito=-2);
            // Filler
            translate([th,len-wth-wth,0]) cube([topholeof-th, wth+wth-th, whi]);

            // Mounting hole filler
            translate([wid,0,0]) linear_extrude(height=whi, convexity=5) polygon([
                [-20,0],[-20,16],[-14,22],[0,22],[0,th*2],[-th*2,0]
            ]);

            /*
            // Left wall hinge/cover holder
            translate([th,th,hei]) rotate([-90,0,0]) linear_extrude(height=len-th*2) polygon([
                [0,0],[0,5],[5,0]
            ]);
            */
            // Bottom wall hinge/cover holder
            translate([th,th,hei]) rotate([0,90,0]) linear_extrude(height=wid-th*2) polygon([
                [0,0],[0,5],[5,0]
            ]);
        }
        // Top wall holes
        for (x = [(thwid/topholes)/2+topholeof:thwid/topholes:wid]) {
            translate([x,len-th-0.01,whi-tubeth/2-wof]) rotate([-90,0,0])
                cylinder(th+0.02, tubeth/2, tubeth/2, $fn=60);
        }
        // Left wall holes
        for (y = [(lhwid/leftholes)/2:lhwid/leftholes:lhwid]) {
            translate([-0.01, y+th, whi-tubeth/2-wof]) rotate([0,90,0])
                cylinder(th+0.02, tubeth/2, tubeth/2, $fn=60);
        }
        // Mounting holes
        //   Top left
        translate([10, len-12, -0.01]) cylinder(whi+0.02, 3, 3, $fn=60);
        translate([10, len-12, 10]) cylinder(whi-10+0.02, 6, 6, $fn=60);
        //   Bottom right
        translate([wid-10, 12, -0.01]) cylinder(whi+0.02, 3, 3, $fn=60);
        translate([wid-10, 12, 10]) cylinder(whi-10+0.02, 6, 6, $fn=60);

        // Closing screw hole
        translate([wid/2,len+0.01,hei-7]) rotate([90,0,0]) cylinder(th+0.02,1.7,1.7,$fn=60);
    }
    *for (x = [(thwid/topholes)/2+topholeof:thwid/topholes:wid]) {
        translate([x,len-th-12,whi-12-wof]) rotate([-90,0,0])
            cylinder(20, 16/2, 16/2, $fn=60);
    }
}

module wireholder(wid, len, hei, numwires, wiredia, wireof=wof, slitl=1.2, slith=0, slito=-4)
{
    if (topnut) {
        slitl = (slitl == 0) ? len/2 : slitl;
        slith = (slith == 0) ? wiredia*0.95+wireof : slith;
        // slitw = wiredia+4;
        difference() {
            cube([wid, len, hei]);
            for (x = [(wid/numwires)/2:wid/numwires:wid]) {
                // Hole
                translate([x,-0.01,hei-wiredia/2-wireof]) rotate([-90,0,0])
                    cylinder(len+0.02, wiredia/2,wiredia/2,$fn=60);
                // Holes for screwdown bit
                translate([x, len-slitl/2+slito, hei-slith]) cylinder(slith+0.01, 1.7, 1.7, $fn=60);
                // Slit for screwdown bit
                translate([x-slitw/2,len-slitl+slito,hei-slith]) cube([slitw, slitl+0.01, slith+10+0.01]);

                *#translate([x, len-slitl/2+slito, hei-8]) cylinder(8, 2, 2, $fn=60);
            }
        }
    } else {
        slitl = (slitl == 0) ? len/2 : slitl;
        slith = (slith == 0) ? hei/2 : slith;
        difference() {
            cube([wid, len, hei]);
            for (x = [(wid/numwires)/2:wid/numwires:wid]) {
                // Hole
                translate([x,-0.01,hei-wiredia/2]) rotate([-90,0,0])
                    cylinder(len+0.02, wiredia/2,wiredia/2,$fn=60);
                translate([x-wiredia/2,-0.01,hei-wiredia/2]) cube([wiredia, len+0.02, wiredia/2+0.01]);
                // Holes for screwdown bit
                translate([x-15, len-slitl/2+slito, 0]) cylinder(hei-wiredia/2+0.01, 2, 2, $fn=60);
                translate([x+15, len-slitl/2+slito, 0]) cylinder(hei-wiredia/2+0.01, 2, 2, $fn=60);
            }
            // Slit for screwdown bit
            translate([-0.01,len-slitl+slito,hei-slith]) cube([wid+0.02, slitl+0.01, slith+0.01]);
        }
    }
}
