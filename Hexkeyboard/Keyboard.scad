off  = 22;
side = 2;
s3 = sqrt(3);

doobs = 2;

if (doobs == 1) {
    rotate([0,180,0]) keyplane();
} else if (doobs == 2) {
    keycap();
} else {
    translate([0,0,-1.1]) keyplane();
    for (col = [-side+1:side-1], row = [-(side-1-abs(col)/2):side-1-abs(col)/2]) {
        translate([off*row, off*col*s3/2, 0]) {
            cherryswitch();
            translate([0,0,5.1]) keycap();
        }
    }
}

module keycap(thick=2, dia=21.5)
{
    rd = dia/s3;
    difference() {
        polyhedron( points = concat(
            hexagon(dia, 0),
            hexagon(dia, 5),
            hexagon(dia-4, 7),
            hexagon(dia-6, 7),
            hexagon(4, 6)
        ), faces = concat(
            topface(6,0),
            nquads(6,0),
            nquads(6,6),
            nquads(6,12),
            nquads(6,18),
            botface(6,24)
        ), convexity=3);
        /*
        union() {
            linear_extrude(height=4) {
                polygon([for (a=[60:60:360]) [rd*sin(a), rd*cos(a)]]);
            }
            translate([0,0,4]) linear_extrude(height=2, scale=((dia-3)/dia)) {
                polygon([for (a=[60:60:360]) [rd*sin(a), rd*cos(a)]]);
            }
        }
        */
        translate([0,0,-0.1]) linear_extrude(height=5, scale=11.5/13.7) square([13.7,13.7], true);
    }
    stx = 2.8;
    sty = 1.6;
    pwx = 0.9;
    pwy = 1.2;
    
    for (x=[-1:2:1], y=[-1:2:1]) {
        translate([x*(pwx+stx)/2, y*(pwy+sty)/2, 2.5]) cube([stx,sty,5], true);
    }
}

function hexagon(d, h) = [for (a=[60:60:360]) [sin(a)*d/s3, cos(a)*d/s3, h]];
    
function botface(n, o) = [[for (i=[0:n-1]) o+i]];
    
function topface(n, o) = [[for (i=[n-1:-1:0]) o+i]];
    
function nquads(n, o) = [for (i=[0:n-1]) each [
    [i+o, (i+1)%n+o, (i+1)%n+n+o], [i+o, (i+1)%n+n+o, i+n+o] ]];

module cherryswitch()
{
    translate([0,0,-3]) cube([13.9,13.9,6], true);
    translate([0,0,-0.5]) cube([15.5,15.5,1], true);
    difference() {
        linear_extrude(height=5, scale=10/13.7) square([13.7,13.7], true);
        translate([0,0,5/2]) cube([7.7,5.9,5.1], true);
    }
    translate([0,0,5+(3.5/2)]) cube([3.9,1.2,3.5], true);
    translate([0,0,5+(3.5/2)]) cube([0.9,3.9,3.5], true);
    translate([0,0,5/2]) cube([7.5,5.7,5], true);
    translate([0,0,-6-3/2]) cylinder(3, 3.4/2, 3.7/2, true, $fn=20);
}

module keyplane(off=off, side=side, thick=3, kthick=1.6, rh=6, hi=10)
{
    kwid = off*(side*2-0.5);
    khei = off*(side*2*s3/2-0.2);
    translate([0,0,-thick/2]) difference() {
        cube([kwid, khei, thick], true);
        for (col = [-side+1:side-1], row = [-(side-1-abs(col)/2):side-1-abs(col)/2]) {
            translate([off*row, off*col*s3/2, 0]) cube([14, 14, thick+0.1], true);
            translate([off*row, off*col*s3/2, -kthick]) cube([16,16,thick+0.1], true);
        }
    }
    for (col = [-side+0.5:side-0.5]) {
        translate([0, off*col*s3/2, -rh/2]) cube([kwid, 2, rh], true);
    }
    for (col = [-side+1:side-1], row = [-(side-0.5-abs(col)/2):side-0.5-abs(col)/2]) {
        translate([off*row, off*col*s3/2, -rh/2]) cube([2, off*s3/2, rh], true);
    }
    translate([-(kwid-thick)/2, 0, -hi/2]) cube([thick, khei, hi], true);
    translate([ (kwid-thick)/2, 0, -hi/2]) cube([thick, khei, hi], true);
    translate([0, -(khei-thick)/2, -hi/2]) cube([kwid, thick, hi], true);
    translate([0,  (khei-thick)/2, -hi/2]) cube([kwid, thick, hi], true);
}