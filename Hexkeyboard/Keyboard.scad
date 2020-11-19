off  = 22;
numrows = 3;
numcols = 3;

xextra = 2.6;
yextra = 1.8;

boltoff = 5.5;

yside = (numrows-1)/2;
xside = (numcols-1)/2;
s3 = sqrt(3);
s2 = sqrt(2);

kwid = off*(xside*2+xextra);
khei = off*(yside*2*s3/2+yextra);

doobs = 0;

if (doobs == 1) {
    rotate([0,180,0]) keyplane();
} else if (doobs == 2) {
    rotate([0,180,0]) keycover();
} else if (doobs == 3) {
    keycap();
} else {
    color("green") translate([0,0,-1.1]) keyplane();
    color("lightblue") translate([0,0,-0.9]) keycover();

    for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
        translate([off*row, off*col*s3/2, 0]) {
            color("brown") cherryswitch();
            color("orange") rgbmodule();
            translate([0,0,5.1]) keycap();
        }
    }
    color("blue") matrix_x();
    color("blue") matrix_y();
    
    color("gray") translate([-(kwid/2-boltoff),-(khei/2-boltoff),-6]) bolt();
    color("gray") translate([ (kwid/2-boltoff),-(khei/2-boltoff),-6]) bolt();
    color("gray") translate([-(kwid/2-boltoff), (khei/2-boltoff),-6]) bolt();
    color("gray") translate([ (kwid/2-boltoff), (khei/2-boltoff),-6]) bolt();
}

module bolt(dia=3, head=6, length=11.2, thick=1.4)
{
    translate([0,0,length/2]) cylinder(length, dia/2, dia/2, true, $fn=60  );
    cylinder(thick, head/2, head/2, true, $fn=60);
}

module matrix_x(thick=0.4)
{
    for (col = [-yside:yside]) {
        translate([0, off*col*s3/2-2.1-(3.3*((col+yside+1)%2)), -7.4])
            rotate([0,90,0]) cylinder(kwid-10, thick/2, thick/2, true, $fn=10);
    }
}

module matrix_y(thick=0.4)
{
    for (row = [-xside-1:xside]) {
        translate([off*row+off/4, 0, -9.4])
            rotate([90,0,0]) cylinder(khei-10, thick/2, thick/2, true, $fn=10);
    }
}

module keycover(thick=1, dia=off+1, hi=7, dpt=10)
{
    kw = kwid+2.2;
    kh = khei+2.2;
    tothi = hi+dpt+thick;
    bevel = 8;
    translate([0,0,hi]) difference() {
        intersection() {
          union() {
            translate([0,0,thick/2]) cube([kw,kh,thick], true);
            translate([-(kw-thick)/2, 0, (-hi-dpt)/2])
              cube([thick, kh, hi+dpt], true);
            translate([ (kw-thick)/2, 0, (-hi-dpt)/2])
              cube([thick, kh, hi+dpt], true);
            translate([0, -(kh-thick)/2, (-hi-dpt)/2])
              cube([kw, thick, hi+dpt], true);
            translate([0,  (kh-thick)/2, (-hi-dpt)/2])
              cube([kw, thick, hi+dpt], true);
            
            translate([-(kw-thick-1)/2, 0, -hi/2]) cube([thick+1, kh, hi], true);
            translate([ (kw-thick-1)/2, 0, -hi/2]) cube([thick+1, kh, hi], true);
            translate([0, -(kh-thick-1)/2, -hi/2]) cube([kw, thick+1, hi], true);
            translate([0,  (kh-thick-1)/2, -hi/2]) cube([kw, thick+1, hi], true);
              
            translate([-(kw-thick-1)/2, 0, 0]) rotate([0,45,0])
              cube([bevel/s2, kh, bevel/s2], true);
            translate([ (kw-thick-1)/2, 0, 0]) rotate([0,45,0])
              cube([bevel/s2, kh, bevel/s2], true);
            translate([0, -(kh-thick-1)/2, 0]) rotate([45,0,0])
              cube([kw, bevel/s2, bevel/s2], true);
            translate([0,  (kh-thick-1)/2, 0]) rotate([45,0,0])
              cube([kw, bevel/s2, bevel/s2], true);
              
            translate([-(kwid/2-boltoff),-(khei/2-boltoff),-3.5])
              cube([10,10,7],true);
            translate([ (kwid/2-boltoff),-(khei/2-boltoff),-3.5])
              cube([10,10,7],true);
            translate([-(kwid/2-boltoff), (khei/2-boltoff),-3.5])
              cube([10,10,7],true);
            translate([ (kwid/2-boltoff), (khei/2-boltoff),-3.5])
              cube([10,10,7],true);
 
          }
          translate([0,0,-(hi+dpt-thick+bevel/2)/2]) rotate([45,0,0])
            cube([kw+0.1,(kh+tothi-bevel/2)/s2,(kh+tothi-bevel/2)/s2],true);
          translate([0,0,-(hi+dpt-thick+bevel/2)/2]) rotate([0,45,0])
            cube([(kw+tothi-bevel/2)/s2,kh+0.1,(kw+tothi-bevel/2)/s2],true);
          translate([0,0,-(hi+dpt-thick)/2]) rotate([0,0,45])
            cube([(kw+kh-2)/s2,(kw+kh-2)/s2,tothi+0.1],true);
          
        }
        for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
            translate([off*row, off*col*s3/2, -hi]) linear_extrude(height=thick+hi+0.1)
                polygon([for (a=[60:60:360]) [sin(a)*dia/s3, cos(a)*dia/s3]]);
        }
        translate([-(kwid/2-boltoff),-(khei/2-boltoff),-3.3]) {
            cylinder(7.6,2,2, true, $fn=60);
            translate([ 2,0,-2.5/2]) cube([10,6,2.5], true);
        }
        translate([ (kwid/2-boltoff),-(khei/2-boltoff),-3.3]) {
            cylinder(7.6,2,2, true, $fn=60);
            translate([-2,0,-2.5/2]) cube([10,6,2.5], true);

        }
        translate([-(kwid/2-boltoff), (khei/2-boltoff),-3.3]) {
            cylinder(7.6,2,2, true, $fn=60);
            translate([ 2,0,-2.5/2]) cube([10,6,2.5], true);
        }
        translate([ (kwid/2-boltoff), (khei/2-boltoff),-3.3]) {
            cylinder(7.6,2,2, true, $fn=60);
            translate([-2,0,-2.5/2]) cube([10,6,2.5], true);
        }

    }


}

module keycap(thick=2, dia=off-1)
{
    rd = dia/s3;
    difference() {
        polyhedron( points = concat(
            hexagon(dia-4, 5),
            hexagon(dia-2, 4),
            hexagon(dia-2, 0),
            hexagon(dia, 0),
            hexagon(dia, 5),
            hexagon(dia-5, 7),
            hexagon(dia-7, 7),
            hexagon(4, 6)
        ), faces = concat(
            topface(6,0),
            nquads(6,0),
            nquads(6,6),
            nquads(6,12),
            nquads(6,18),
            nquads(6,24),
            nquads(6,30),
            nquads(6,36),
            botface(6,42)
        ), convexity=3);
    }
    stx = 2.8;
    sty = 1.6;
    pwx = 0.9;
    pwy = 1.2;
    
    for (x=[-1:2:1], y=[-1:2:1]) {
        translate([x*(pwx+stx)/2, y*(pwy+sty)/2, 2.6]) cube([stx,sty,5.2], true);
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
    
    translate([ 4,-2.5,-6-3/2]) scale([1,1/3,1]) cylinder(3, 0.4, 0.4, true, $fn=10);
    translate([-2.4,-5,-6-3/2]) scale([1,1/3,1]) cylinder(3, 0.4, 0.4, true, $fn=10);
}

module rgbmodule()
{
    translate([0,4+12.5/2,-9.2]) {
        cube([8.8, 12.5,1.1], true);
        translate([0,-1.5,-1.5+0.55]) cube([6,5,3], true);
    }
}

module keyplane(off=off, thick=2, kthick=1.6, rh=6)
{
    translate([0,0,-thick/2]) difference() {
        cube([kwid, khei, thick], true);
        for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
            translate([off*row, off*col*s3/2, 0]) cube([14, 14, thick+0.1], true);
            translate([off*row, off*col*s3/2, -kthick]) cube([16,16,thick+0.1], true);
        }
        translate([-(kwid/2-boltoff),-(khei/2-boltoff),0]) {
            cylinder(2.5,2,2, true, $fn=60);
        }
        translate([ (kwid/2-boltoff),-(khei/2-boltoff),0]) {
            cylinder(2.5,2,2, true, $fn=60);

        }
        translate([-(kwid/2-boltoff), (khei/2-boltoff),0]) {
            cylinder(2.5,2,2, true, $fn=60);
        }
        translate([ (kwid/2-boltoff), (khei/2-boltoff),0]) {
            cylinder(2.5,2,2, true, $fn=60);
        }


    }
    for (col = [-yside-0.5:yside+0.5]) {
        translate([0, off*col*s3/2, -rh/2]) cube([kwid, 2, rh], true);
        for (row = [-xside-1:xside]) {
            translate([off*row+off/4, off*col*s3/2, -rh-2]) wireclip_y();
        }
    }
    for (col = [-yside:yside], row = [-(xside+0.5+((col+yside)%2)/2):xside+0.5+((col+yside)%2)/2]) {
        translate([off*row, off*col*s3/2, -rh/2]) cube([2, off*s3/2, rh], true);
        translate([off*row, off*col*s3/2-2.1-(3.3*((col+yside+1)%2)), -rh]) wireclip_x();
    }
}

module wireclip_x()
{
    rotate([0,0,90]) wireclip_y();
}

module wireclip_y(wid=2, dia=0.6, thick=0.8, hei=1.5)
{
    r = dia/2;
    t = thick;
    op = 0.2;
    rotate([-90,0,0]) translate([0,0,-wid/2]) linear_extrude(height=wid) polygon([
        [-t-r,-3],[-t-r,hei],[-r,hei],[-op,hei-r],[-op,r*3],[-r,r*2],[-r,0],
        [r,0],[r,r*2],[op,r*3],[op,hei-r],[r,hei],[t+r,hei],[t+r,-3]
    ]);
}