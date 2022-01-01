dosmall = 0;
doobs = 0;


numrows = dosmall ? 3 : 11;
numcols = dosmall ? 3 : 11;

smallkeyoff = (numrows < 4) ? 0.0 : 0.5;
riboff = smallkeyoff * 4;

tol=0.1;
off  = 22;
xextra = 2.6;
yextra = 1.8;

boltoff = 5.5;

ribthick = 2;

coverhi = 7;
mpthick = 1;

yside = (numrows-1)/2;
xside = (numcols-1)/2;
s3 = sqrt(3);
s2 = sqrt(2);

kext = off*2;

kwid = off*(xside*2+xextra);
khei = off*(yside*2*s3/2+yextra);

skiptri = 2;

scrx = -kwid/2-kext+25;
scry = -khei/2+57;
scrz = 7-mpthick;

if (doobs == 1) {
    rotate([0,180,0]) keyplaneleft();
} else if (doobs == 2) {
    rotate([0,180,0]) keyplaneright();
} else if (doobs == 3) {
    rotate([0,180,0]) keycoverleft();
} else if (doobs == 4) {
    rotate([0,180,0]) keycoverright();
} else if (doobs == 5) {
    keyholderleft();
} else if (doobs == 6) {
    keyholderright();
} else if (doobs == 7) {
    keycap();
} else if (doobs == 8) {
    trikeycap();
} else if (doobs == 9) {
    keyplaneconnector();
} else if (doobs == 10) {
    coverconnector();
} else {
    *keycover();
    *color("green") translate([0,0,-1.1]) {
        *translate([ 0,0,0]) keyplaneleft();
        translate([-0,0,0]) keyplaneright();
    }
    color("lightgreen") translate([0,0,-1.05]) {
        *keyholderleft();
        keyholderright();
    }
    *color("lightblue") translate([0,0, mpthick-0.9]) {
        *translate([ 0,0,0]) keycoverleft();
        translate([-0,0,0]) keycoverright();
    }
    *color("blue") {
        translate([0,0,-4.2]) keyplaneconnector();
        translate([0,0,-4.2]) mirror([0,1,0]) keyplaneconnector();
    }
    *color("blue") translate([0,0,-0.9]) {
        coverconnector();
        mirror([0,1,0]) coverconnector();
    }

    color("yellow") translate([scrx,scry,scrz]) screen();
    *keycaps();
    *wires();
    *bolts();
}

module screen()
{
    hlx = 40;
    hly = 84.7;
    hld = 3;
    difference() {
        union() {
            translate([0,0,-3.3/2]) cube([37,79,3.3], true);
            translate([0,0,-3.3+1.6/2]) cube([46,91,1.6], true);
            translate([0,0,-5/2]) cube([30,70,5], true);
            translate([0,-40,-3.3-6.2/2]) cube([23,8,6.2], true);
        }
        for (x=[-1,1], y=[-1,1]) {
            translate([x*hlx/2,y*hly/2,-5]) cylinder(5,hld/2,hld/2,$fn=32);
        }
    }
}

module coverconnector()
{
    thi = coverhi-mpthick-0.2;
    hei = 5.4;
    wid = (off-10)-0.2;
    
    thick = 1;
    // kw = kwid+2.2+kext;
    kh = khei+2.2;
    // tothi = hi+dpt+thick;
    bevel = 8;
    
    difference() {
        translate([-kext/2,khei/2-1.1-hei/2,-thi/2+7-0.1])
            cube([wid,hei,thi], true);
        translate([-kext/2,(kh-thick-1)/2, 7]) rotate([45,0,0])
          cube([wid+0.2, bevel/s2+0.1, bevel/s2+0.1], true);
        // Connector pins
        for ( x = [-off/8-kext/2,off/8-kext/2],
              y = [-(khei/2-4),(khei/2-4)]) {
            translate([x,y,2.9]) scale([1,2,1]) cylinder(4.1,1.1,1.1,false,$fn=60);
        }
    }
}

module keyplaneconnector()
{
    dia=yextra+off*s3/4-ribthick;
    hole=4;
    thick=1;
    length=off*2;
    difference() {
        translate([-off*1.25, khei/2-dia/2,thick/2])
            cube([length,dia-0.2,thick], true);
        translate([-off*0.5, khei/2-boltoff,thick/2])
            cylinder(thick+0.1, hole/2, hole/2, true, $fn=60);
        translate([-off*1.5, khei/2-boltoff,thick/2])
            cylinder(thick+0.1, hole/2, hole/2, true, $fn=60);
        // Connector pins
        for ( x = [-off-kext/2,-kext/2],
              y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
             translate([x,y,thick/2]) cylinder(thick+0.1,2,2, true, $fn=60);
        }
    }
}

module keyholderleft()
{
    difference() {
        intersection() {
            keyholder();
            translate([kwid/2+tol,0,0])
                cube([kwid+kext, khei+1, 40], true);
        }
        for (col = [-yside:2:yside]) {
            translate([-off, off*col*s3/2, 0]) {
                cube([18+tol*2,18+tol*2,40], true);
            }
        }
    }
}

module keyholderright()
{
    difference() {
        intersection() {
            keyholder();
            union() {
                translate([-kwid/2-kext-tol,0,0])
                    cube([kwid+kext, khei+1, 40], true);
                for (col = [-yside:2:yside]) {
                    translate([-off, off*col*s3/2, 0]) {
                        cube([18,18,40], true);
                    }
                }
            }
        }
    }
}

module keyplaneleft()
{
    difference() {
        intersection() {
            keyplane();
            translate([kwid/2-off/4+tol,0,0])
                cube([kwid+kext, khei+1, 40], true);

        }
        translate([-kext/2-off/4+tol,-(khei/2-5),-1]) rotate([0,0,0])
            cylinder(2.2,2,2, true, $fn=4);
        translate([-kext/2-off/4+tol, (khei/2-5),-1]) rotate([0,0,0])
            cylinder(2.2,2,2, true, $fn=4);
        
        for (col = [-yside+0.5:2:yside+0.5]) {
            translate([-kext/2-off/4-0.1+tol,col*off*s3/2,-4]) rotate([0,90,0])
                cylinder(1.1,1.1,0, false, $fn=4);
        }

    }
    
    for (col = [-yside-0.5:2:yside+0.5]) {
        translate([-kext/2-off/4+tol,col*off*s3/2,-4]) rotate([0,-90,0])
            cylinder(1,1,0, false, $fn=4);
    }
    translate([-kext/2-off/4+tol,-(khei/2-1.5),-1]) rotate([0,-90,0])
        cylinder(1,1,0, false, $fn=4);
    translate([-kext/2-off/4+tol, (khei/2-1.5),-1]) rotate([0,-90,0])
        cylinder(1,1,0, false, $fn=4);

}

module keyplaneright()
{
    difference() {
        intersection() {
            keyplane();
            translate([-kwid/2-kext-off/4-tol,0,0])
                cube([kwid+kext, khei+1, 40], true);

        }
        for (col = [-yside-0.5:2:yside+0.5]) {
            translate([-kext/2-off/4+0.1-tol,col*off*s3/2,-4]) rotate([0,-90,0])
                cylinder(1.1,1.1,0, false, $fn=4);
        }
        translate([-kext/2-off/4+0.1-tol,-(khei/2-1.5),-1]) rotate([0,-90,0])
            cylinder(1.1,1.1,0, false, $fn=4);
        translate([-kext/2-off/4+0.1-tol, (khei/2-1.5),-1]) rotate([0,-90,0])
            cylinder(1.1,1.1,0, false, $fn=4);

    }
    translate([-kext/2-off/4-tol,-(khei/2-5),-1]) rotate([0,0,0])
        cylinder(2,2,2, true, $fn=4);
    translate([-kext/2-off/4-tol, (khei/2-5),-1]) rotate([0,0,0])
        cylinder(2,2,2, true, $fn=4);
    
    for (col = [-yside+0.5:2:yside+0.5]) {
        translate([-kext/2-off/4-tol,col*off*s3/2,-4]) rotate([0,90,0])
            cylinder(1,1,0, false, $fn=4);
    }

}

module keycoverleft()
{
    chi = coverhi-mpthick;
    thk = 2;
    conhi = 16;

    difference() {
        intersection() {
            keycover();
            translate([kwid/2+tol,0,0])
                cube([kwid+kext, khei+4, 100], true);
        }
        translate([-kext/2+tol, (khei/2-5),chi+0.5]) rotate([0,0,0])
            cylinder(1.1,1,1, true, $fn=4);
        translate([-kext/2+tol,-(khei/2+0.1),chi-5]) rotate([90,0,0])
            cylinder(thk+0.1,2,2, true, $fn=4);
        translate([-kext/2+tol, (khei/2)+1.2,-conhi/2-2])
            rotate([90,0,0]) cylinder(1.2,conhi/2,conhi/2,$fn=4);      
    }
    translate([-kext/2+tol,-(khei/2-5),chi+0.5]) rotate([0,0,0])
        cylinder(1,1,1, true, $fn=4);
    difference() {
        translate([-kext/2+tol, (khei/2+0.1),chi-5]) rotate([90,0,0])
            cylinder(thk,2,2, true, $fn=4);
        translate([-kext/2+tol, (khei/2+0.1)-0.505,-5/2])
            cube([5,1.01,5], true);
    }
    translate([-kext/2+tol,-(khei/2)-1.1,-conhi/2-2])
        rotate([-90,0,0]) cylinder(1,conhi/2,conhi/2,$fn=4);

}

module keycoverright()
{
    chi = coverhi-mpthick;
    thk = 2;
    conhi = 16;

    difference() {
        intersection() {
            keycover();
            translate([-kwid/2-kext-tol,0,0])
                cube([kwid+kext, khei+4, 100], true);
        }
        translate([-kext/2-tol,-(khei/2-5),chi+0.5]) rotate([0,0,0])
            cylinder(1.1,1,1, true, $fn=4);
        translate([-kext/2-tol, (khei/2+0.1),chi-5]) rotate([90,0,0])
            cylinder(thk+0.1,2,2, true, $fn=4);
        translate([-kext/2-tol,-(khei/2)-1.2,-conhi/2-2])
            rotate([-90,0,0]) cylinder(1.2,conhi/2,conhi/2,$fn=4);
    }
    
    translate([-kext/2-tol, (khei/2-5),chi+0.5]) rotate([0,0,0])
        cylinder(1,1,1, true, $fn=4);
    difference() {
        translate([-kext/2-tol,-(khei/2+0.1),chi-5]) rotate([90,0,0])
            cylinder(thk,2,2, true, $fn=4);
        translate([-kext/2-tol,-(khei/2+0.1)+0.505,-5/2])
            cube([5,1.01,5], true);
    }
    translate([-kext/2-tol, (khei/2)+1.1,-conhi/2-2])
        rotate([90,0,0]) cylinder(1,conhi/2,conhi/2,$fn=4);

}

module keycaps()
{
    // Normal hex keys
    for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
        translate([off*row, off*col*s3/2, 0]) {
            color("brown") cherryswitch();
            color("orange") rgbmodule();
            color("white") translate([0,0,5.1]) keycap();
        }
    }
    // Side triangle keys
    for (col = [-yside:2:yside]) {
        xcol = off*s3*((floor((col+2)/4))*1.5+smallkeyoff)-7+14*(floor(col/2+yside)%2);
        translate([-kwid/2-off*s3/2, xcol, 0]) {
            color("brown") smallswitch();
            color("grey") translate([0,0,5.1])
                rotate([0,0,180*(floor(col/2+1)%2)]) trikeycap();
        }
    }
}

module wires()
{
    color("blue") matrix_x();
    color("blue") matrix_y();
}

module bolts()
{
    color("gray") translate([-(kwid/2-boltoff)-kext,-(khei/2-boltoff),-6]) bolt();
    color("gray") translate([ (kwid/2-boltoff),     -(khei/2-boltoff),-6]) bolt();
    color("gray") translate([-(kwid/2-boltoff)-kext, (khei/2-boltoff),-6]) bolt();
    color("gray") translate([ (kwid/2-boltoff),      (khei/2-boltoff),-6]) bolt();
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

module keycover()
{
    thick = 2;
    ythick = 1;
    dia=off+1;
    hi=coverhi-mpthick;
    dpt=20;
    
    kw = kwid+thick*2+0.2+kext;
    kh = khei+thick*2+0.2;
    tothi = hi+dpt+thick;
    bevel = 8;
    translate([0,0,hi]) difference() {
        translate([-kext/2,0,0]) union() {
            translate([0,0,-dpt-hi]) keycover_box();
            // Bolthole cubes
            for ( x = [-(kwid/2-boltoff+kext/2),(kwid/2-boltoff+kext/2),
                       -off/2,off/2],
                  y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
                translate([x,y,-hi/2])
                    cube([10,10,hi],true);

            }
        }
        
        // Main hex keys
        for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
            translate([off*row, off*col*s3/2, -hi-0.1])
                linear_extrude(height=thick+hi+0.2)
                polygon([for (a=[60:60:360]) [sin(a)*dia/s3, cos(a)*dia/s3]]);
        }
        
        // Side triangle keys
        o = 5;
        d = 22;
        for (col = [-yside+skiptri*2:2:yside]) {
            xcol = off*s3*((floor((col+2)/4))*1.5+smallkeyoff)-7+14*(floor(col/2+yside)%2);
            translate([-kwid/2-off*s3/2, xcol, -hi])
                linear_extrude(height=thick+hi+0.1)
                rotate([0,0,180*(floor(col/2+1)%2)]) 
                polygon([for (a=[60:120:360]) each [
                    [sin(a-o)*d/s3, cos(a-o)*d/s3],
                    [sin(a+o)*d/s3, cos(a+o)*d/s3]]]);
        }
        
        // Screen
        translate([scrx,scry,0]) cube([29,67,3], true);
        
        // Bolt holes
        for ( x = [-(kwid/2-boltoff)-kext,(kwid/2-boltoff),
                   -off/2-kext/2,off/2-kext/2],
              y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
            translate([x,y,-(hi-3.7)]) {
                translate([0,0,-3.9]) cylinder(5.2,2,2, false, $fn=60);
                translate([0,-2*sign(y),-2.5/2]) cube([6,10,2.5], true);
            }
        }
        /*
        conhi = dpt-5;
        // Side connector
        translate([-kext/2, (kh/2-1.5),-dpt-hi+conhi/2])
            cube([30+tol,1.4,conhi+tol*2], true);
        translate([-kext/2,-(kh/2-1.5),-dpt-hi+conhi/2])
            cube([30+tol,1.4,conhi+tol*2], true);
        */
    }
    /*
    // Side connector pins
    for (x=[-10,10], y=[3,12]) {
        translate([-kext/2+x, (kh/2-0.7),-dpt+y])
            rotate([90,0,0]) cylinder(1.2, 2, 1, $fn=4);
        translate([-kext/2+x,-(kh/2-0.7),-dpt+y])
            rotate([-90,0,0]) cylinder(1.2, 2, 1, $fn=4);        
    }
    */
    
    // Sacrificial layers for bolt holes
    for ( x = [-(kwid/2-boltoff)-kext,(kwid/2-boltoff),
               -off/2-kext/2,off/2-kext/2],
          y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
        translate([x,y,1.1]) {
            #cube([8,8,0.2], true);
        }

    }
    
    // Connector pins
    for ( x = [-off/8-kext/2,off/8-kext/2],
          y = [-(khei/2-4),(khei/2-4)]) {
        translate([x,y,hi-3]) scale([1,2,1]) cylinder(3.1,1,1,false,$fn=60);
        translate([x,y,hi-4]) scale([1,2,1]) cylinder(1,0.2,1,false,$fn=60);
    }
}

module keycover_box()
{
    thick = 2;
    ythick = 1;
    dia=off+1;
    hi=coverhi-mpthick;
    dpt=20;
    
    kw = kwid+thick*2+0.2+kext;
    kh = khei+thick*2+0.2;
    tothi = hi+dpt+thick;
    bevel = 6;
    hbev = 1;
    ibev = 5;
    o1 = thick*2;
    o2 = thick*2 + thick;
    o3 = thick*2 + thick + ibev;
    polyhedron(
        points=concat(
            brect(kw-o3,kh-o3,dpt+hi,0),
            brect(kw-o2,kh-o2,dpt+hi-ibev/2,0),
            brect(kw-o2,kh-o2,dpt,0),
            brect(kw-o1,kh-o1,dpt,0),
            brect(kw-o1,kh-o1,0,0),
            brect(kw,kh,0,hbev),
            brect(kw,kh,hi+dpt+thick/2-bevel/2,hbev),
            brect(kw-bevel,kh-bevel,hi+dpt+thick/2,0)
        ),
        faces=concat(
            topface(8,0),
            nquads(8,0),
            nquads(8,8),
            nquads(8,16),
            nquads(8,24),
            nquads(8,32),
            nquads(8,40),
            nquads(8,48),
            botface(8,56)
        ),
        convexity=4
    );
}

function brect(w,h,z,b) = [
    [ w/2,-h/2+b,z], [ w/2-b,-h/2,z],
    [-w/2+b,-h/2,z], [-w/2,-h/2+b,z],
    [-w/2, h/2-b,z], [-w/2+b, h/2,z],
    [ w/2-b, h/2,z], [ w/2, h/2-b,z]
    ];

module trikeycap(thick=2, dia=20)
{
    rd = dia/s3;
    difference() {
        polyhedron( points = concat(
            triangle(dia-4, 3),
            triangle(dia-2, 2),
            triangle(dia-2, 0),
            triangle(dia, 0),
            triangle(dia, 3),
            triangle(dia-2, 4),
            triangle(dia-6, 5),
            triangle(6, 6)
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
    stx = 4;
    sty = 4;
    pwx = 1.9;
    pwy = 2.4;
    
    translate([0,0,1.5]) difference() {
        cube([stx, sty, 3], true);
        cube([pwx, pwy, 3.1], true);
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
    pwy = 1.1;
    
    btx = 3.9;
    bty = 3.9;
    
    translate([0,0,2.6]) difference() {
        rotate([0,0,360/16]) cylinder(5.2, btx/2+0.6, btx/2+0.6, true, $fn=8);
        cube([pwx, bty, 5.201], true);
        cube([btx, pwy, 5.201], true);
    }
    
    *for (x=[-1,1], y=[-1,1]) {
        translate([x*(pwx+stx)/2, y*(pwy+sty)/2, 2.6]) cube([stx,sty,5.2], true);
    }
}

function triangle(d, h, o=5) = [for (a=[60:120:360]) each [
    [sin(a-o)*d/s3, cos(a-o)*d/s3, h], [sin(a+o)*d/s3, cos(a+o)*d/s3, h]]];

function hexagon(d, h) = [for (a=[60:60:360]) [sin(a)*d/s3, cos(a)*d/s3, h]];
    
function botface(n, o) = [[for (i=[0:n-1]) o+i]];
    
function topface(n, o) = [[for (i=[n-1:-1:0]) o+i]];
    
function nquads(n, o) = [for (i=[0:n-1]) each [
    [i+o, (i+1)%n+o, (i+1)%n+n+o], [i+o, (i+1)%n+n+o, i+n+o] ]];

module smallswitch()
{
    of = 2.5;
    bw = 5.9;
    bh = 5.3;
    ph = 3.3;
    sw = 2.9;
    sl = 3.6;
    sh = 2.3;
    s2w = 1.9;
    s2l = 2.4;
    s2h = 2.6;
    translate([0,0,bh/2-of]) cube([bw,bw,bh], true);
    for (x=[-2.3,2.3], y=[-2,0,2])
        translate([x,y,(ph-bh)/2-of]) cube([0.2,0.5,ph], true);
    translate([0,0,bh+sh/2-of]) cube([sw,sl,sh], true);
    translate([0,0,bh+sh+s2h/2-of]) cube([s2w,s2l,s2h], true);
}

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


module keyholder(off=off, thick=mpthick, kthick=1, rh=6, skthick=1.6)
{
    tkthick = 3.8;
    lcl = 7;
    lch = 5;
    lct = 1.2;
    translate([0,0,0]) difference() {
        union() {
            translate([-kext/2, 0, thick/2]) cube([kwid+kext, khei, thick], true);

            // Normal hex keys
            for (col = [-yside:yside],
                 row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
                translate([off*row, off*col*s3/2, 1]) {
                    cube([18,18,2], true);
                    translate([0,7+lct,0]) rotate([90,0,0])
                      linear_extrude(height=lct) polygon([
                        [-5,0],[-3,lch],[3,lch],[5,0]
                      ]);
                    // translate([0,(14+lct)/2,lch/2]) cube([lcl,lct,lch], true);
                }
            }
            
            // Triangle keys
            for (col = [-yside+skiptri*2:2:yside]) {
                xcol = off*s3*((floor((col+2)/4))*1.5+smallkeyoff)-7+14*(floor(col/2+yside)%2);
                translate([-kwid/2-off*s3/2, xcol, (tkthick)/2+0.2])
                    cube([12, 14, tkthick+0.4], true);
            }

        }
        
        // Normal hex keys
        for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
            translate([off*row, off*col*s3/2, thick/2-0.01/2])
                cube([16,16,thick+0.01], true);
            translate([off*row, off*col*s3/2 ,0.999])
                rotate([0,0,45]) cylinder(1.002,16/s2,(16-2)/s2, $fn=4);

        }
        
        // Side triangle keys
        for (col = [-yside+skiptri*2:2:yside]) {
            xcol = off*s3*((floor((col+2)/4))*1.5+smallkeyoff)-7+14*(floor(col/2+yside)%2);
            translate([-kwid/2-off*s3/2, xcol, 0]) {
                translate([0,0,(tkthick)/2-0.001])
                    cube([6, 6, tkthick+0.002], true);
                translate([0,0,tkthick-0.001])
                    rotate([0,0,45]) cylinder(0.4+0.002,6/s2,(6-0.8)/s2, $fn=4);
            }
        }
        
        // Bolt holes
        for ( x = [-(kwid/2-boltoff)-kext,(kwid/2-boltoff),
                   -off/2-kext/2,off/2-kext/2],
              y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
             translate([x,y,0]) cylinder(2.5,2,2, true, $fn=60);
        }
    }

}

module keyplane(off=off, thick=2, kthick=1.4, rh=6, skthick=1.6)
{
    translate([0,0,-thick/2]) difference() {
        union() {
            translate([-kext/2, 0, 0]) cube([kwid+kext, khei, thick], true);
            translate([-kwid/2-off*s3/2, 0, -0.3])
                cube([10, khei, thick+0.6], true);
        }
        
        // Normal hex keys
        for (col = [-yside:yside], row = [-(xside+((col+yside)%2)/2):xside+((col+yside)%2)/2]) {
            translate([off*row, off*col*s3/2, 0]) cube([14, 14, thick+0.1], true);
            translate([off*row, off*col*s3/2, -kthick]) cube([16,16,thick+0.1], true);
        }
        
        // Side triangle keys
        for (col = [-yside:2:yside]) {
            xcol = off*s3*((floor((col+2)/4))*1.5+smallkeyoff)-7+14*(floor(col/2+yside)%2);
            translate([-kwid/2-off*s3/2, xcol, 0]) {
                translate([0,0,(thick-skthick)/2+0.1])
                    cube([6, 6, skthick+0.2], true);
                translate([-2.3,0,-0.3]) cube([0.4, 6, thick+0.7], true);
                translate([ 2.3,0,-0.3]) cube([0.4, 6, thick+0.7], true);
            }
        }
        
        // Bolt holes
        for ( x = [-(kwid/2-boltoff)-kext,(kwid/2-boltoff),
                   -off/2-kext/2,off/2-kext/2],
              y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
             translate([x,y,0]) cylinder(2.5,2,2, true, $fn=60);
        }
    }
    // Connector pins
    for ( x = [-off-kext/2,-kext/2],
          y = [-(khei/2-boltoff),(khei/2-boltoff)]) {
         translate([x,y,-1.2/2-thick]) cylinder(1.2,1.9,1.9, true, $fn=60);
         translate([x,y,-1.2-1/2-thick]) cylinder(1,1,1.9, true, $fn=60);
    }

    
    // horizontal ribs
    for (col = [-yside-0.5:yside+0.5]) {
        translate([0, off*col*s3/2, -rh/2]) cube([kwid, ribthick, rh], true);
        for (row = [-xside-1:xside]) {
            translate([off*row+off/4, off*col*s3/2, -rh-2]) wireclip_y();
        }
    }
    // Extra horizontal ribs
    for (col = concat([for (x = [-yside-0.5+riboff:3:yside+0.5]) x], [-yside-0.5])) {
        translate([-kwid/2-kext/2, off*col*s3/2, -rh/2])
            cube([kext, ribthick, rh], true);
    }
    
    // Vertical ribs
    for (col = [-yside:yside], row = [-(xside+0.5+((col+yside)%2)/2):xside+0.5+((col+yside)%2)/2]) {
        translate([off*row, off*col*s3/2, -rh/2]) cube([ribthick, off*s3/2, rh], true);
        translate([off*row, off*col*s3/2-2.1-(3.3*((col+yside+1)%2)), -rh]) wireclip_x();
    }
}

module wireclip_x()
{
    rotate([0,0,90]) wireclip_y();
}

module wireclip_y(wid=ribthick, dia=0.8, thick=0.8, hei=1.5)
{
    r = dia/2;
    t = thick;
    op = 0.2;
    *rotate([-90,0,0]) translate([0,0,-wid/2])
      linear_extrude(height=wid) polygon([
        [-t-r,-3],[-t-r,hei],[-r,hei],[-op,hei-r],[-op,r*3],[-r,r*2],[-r,0],
        [r,0],[r,r*2],[op,r*3],[op,hei-r],[r,hei],[t+r,hei],[t+r,-3]
    ]);
    difference() {
        translate([0,0,hei/2]) cube([dia+2*thick,wid,hei+3], true);
        translate([0,0,-r]) rotate([90,0,0]) cylinder(wid+0.2, r, r, true, $fn=20);
        translate([0,0,-r]) rotate([90,0,0]) cylinder(wid+0.2, r+0.2, 0, true, $fn=20);
        translate([0,0,-r]) rotate([90,0,0]) cylinder(wid+0.2, 0, r+0.2, true, $fn=20);
    }
}
