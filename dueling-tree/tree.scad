off = 28.5;
side = [40, 20];
blen = 80;
tlen = 80;
pin = 10;
boltdia = 6;
boltoff = 12;
spacing = 1.5;

targethi = 140;
targetwid = 320;
targetdia = 250;
targethoff = targetwid+30;
tthi = 16;

targetstep = targetdia + 20;

pthi = 26;
polehi = 1100;
polehi2 = 1100;
poleovl = 280;
firstoff = 350;

angle = 8;

if (1) {
    rotate([-angle, 0, 0]) {
        foot();
        duelingtree();
    }
} else {
    platehi = 1220;
    platewid = 610;
    sawst = targetdia/2-targethi/2;
    sawoff = (platehi-targetdia)/5;
    translate([0, 9, 0]) color("#862") cube([platewid, 15, platehi]);
    for (o = [0, 2, 4]) {
        translate([platewid-targethoff-targetdia/2, 0, sawst+sawoff*o]) targetboard();
    }
    for (o = [1, 3, 5]) {
        translate([targethoff+targetdia/2, 0, sawst+sawoff*o]) rotate([0,0,180]) targetboard();
    }
}

module duelingtree()
{
    color("#b95") pole();

    rots = [0, 180, 180, 0, 0, 180];
    hoffs = [0, 0, pthi, pthi, pthi, pthi];
    for (o = [0,1,2,3,4,5]) {
        translate([0, -hoffs[o], firstoff + o*targetstep]) {
            hinge();
            rotate([0, 0, -rots[o]]) target();
        }
    }
}

module pole()
{
    wid = 140;

    translate([-wid/2, off, 0]) cube([wid, pthi, polehi]);

    translate([-wid/2, off-pthi, polehi-poleovl]) cube([wid, pthi, polehi2]);
}

module foot()
{
    hi = 550;
    ovl = hi;
    wid = 140;
    thi = 16;

    cthi = 16;
    clen = 1200;
    cwid = 130;

    llen = 1200;
    lwid = 40;
    lthi = 25;

    slen = 560;
    swid = 25;
    sthi = 40;
    soff = slen-50;

    tol = 0.5;

    if (false) {
        // Foot
        color("#a85") difference() {
            translate([-wid/2, off+pthi, -hi+ovl]) cube([wid, pthi, hi]);
            translate([-(thi)/2-tol, off+pthi-0.1, -hi+ovl-0.1]) cube([thi+tol*2, pthi+0.2, cwid+0.1]);
        }
        // Crossbar
        /*
        color("#974") {
            translate([-clen/2, off+pthi*2, -hi+ovl]) cube([clen/2-thi/2-tol, thi, cwid]);
            translate([thi/2+tol, off+pthi*2, -hi+ovl]) cube([clen/2-thi/2-tol, thi, cwid]);
            translate([-wid/2, off+pthi*2, -hi+ovl+cwid]) cube([wid, thi, cwid]);
        }
        */
        color("#974") {
            lx = clen/2;
            sx = wid/2;
            ly = wid;
            sy = cwid;
            hy = cwid+2;
            cx = thi/2+tol;
            lsdif = ly-sy;
            translate([0, off+pthi*2+thi, -hi+ovl]) rotate([90, 0, 0]) linear_extrude(height=thi, convexity=6) polygon([
                [-lx, 0], [-lx, sy], [-sx-lsdif, sy], [-sx, ly],
                [sx, ly], [sx+lsdif, sy], [lx, sy], [lx, 0],
                [cx, 0], [cx, hy], [-cx, hy], [-cx, 0]
            ]);
        }
    }
    if (false) {
        color("#974") {
            sx = wid/2;
            ly = wid;
            sy = cwid;
            hy = cwid+2;
            cx = thi/2+tol;
            lx = sx+ly-sy;
            translate([0, off+pthi+thi, -hi+ovl]) rotate([90, 0, 0]) linear_extrude(height=thi, convexity=6) polygon([
                [-lx, 0], [-lx, sy], [-sx, ly], [-sx, hi],
                [sx, hi], [sx, ly], [lx, sy], [lx, 0],
                [cx, 0], [cx, hy], [-cx, hy], [-cx, 0]
            ]);
        }
        color("#a85") {
            cbof = (thi/2)+10+tol*2;
            translate([-clen/2, off+pthi+thi, -hi+ovl]) cube([clen/2-cbof, thi, cwid]);
            translate([cbof, off+pthi+thi, -hi+ovl]) cube([clen/2-cbof, thi, cwid]);
        }
    } else if (false) {
        color("#a85") translate([-clen/2, off+pthi, -hi+ovl+cwid+3]) cube([clen, cthi, cwid]);
        color("#974") translate([-clen/2, off, -hi+ovl]) cube([cwid*2, pthi, cwid+cwid+3]);
        color("#974") translate([clen/2-cwid*2, off, -hi+ovl]) cube([cwid*2, pthi, cwid+cwid+3]);
    } else {
        lx = clen/2;
        ly = cwid;
        sx = lthi/2+tol;
        sy = lwid+tol+4;
        color("#a85") translate([0, off+pthi+cthi, -hi+ovl]) rotate([90, 0, 0])
            linear_extrude(height=cthi, convexity=6) polygon([
                [lx, 0], [lx, ly], [-lx, ly], [-lx, 0],
                [-sx, 0], [-sx, sy], [sx, sy], [sx, 0],
            ]);
    }
    // Longbar
    color("#b95") translate([0, off+pthi+5, -hi+ovl+19]) rotate([angle, 0, 0]) difference() {
        translate([-lthi/2, -pthi-thi-5-llen/2, -19]) cube([lthi, llen, lwid]);
        translate([-lthi/2-0.1, 0, 0]) rotate([0, 90, 0]) cylinder(lthi+0.2, 10/2, 10/2, $fn=24);
    }
    // Longbar pivot
    if (false) {
        color("#889") translate([-lthi/2-tol, off+pthi, -hi+ovl]) beugel();
        color("#889") translate([lthi/2+tol+10, off+pthi, -hi+ovl]) beugel();
    }
    // Support
    if (false) {
        color("#b95") translate([-sthi/2, off+pthi, ovl+20]) rotate([angle*1.5-72, 0, 0]) difference() {
            cube([sthi, slen, swid]);
            translate([(sthi-lthi)/2-0.2, soff, -0.1]) cube([lthi+tol, 50.1, swid+0.2]);
        }
    } else {
        ofrad = 25;
        ofan = asin((sthi/2)/ofrad);
        color("#b95") translate([-swid/2, off+pthi+sthi/2, ovl+20]) rotate([angle*1.5-72+90, 0, 0]) {
            rotate([0,90,0]) linear_extrude(height=swid, convexity=4) difference() {
                polygon(concat(
                    [for (a=[ 90-ofan: ofan/20:90+ofan]) [slen-ofrad+sin(a)*(ofrad), cos(a)*(ofrad)]],
                    [for (a=[180: 5:360]) [     sin(a)*(sthi/2), cos(a)*(sthi/2)]]
                ));
                circle(5, $fn=48);
            }
        }
        // Beugel boven
        color("#889") translate([swid/2, off+pthi+sthi/2, ovl+20]) beugel_boven();
        color("#889") translate([-swid/2, off+pthi+sthi/2, ovl+20]) mirror([1,0,0]) beugel_boven();
    }
}

module beugel_boven()
{
    bside = side;
    blen = 40;
    thi = 2;
    boff = 20;
    color("#889")
    render(convexity=10) difference() {
        translate([0, -boff, -blen/2])
        linear_extrude(height=blen, convexity=6) polygon([
                [0, 0], [0, bside.x], [thi, bside.x],
                [thi, thi], [bside.y, thi], [bside.y, 0]
            ]);
        translate([-0.1, 0, 0]) rotate([0, 90, 0])
            cylinder(thi+0.2, pin/2+0.2, pin/2+0.2, $fn=24);
        translate([boltoff, -boff+thi+0.1, 0]) rotate([90, 0, 0])
            cylinder(thi+0.2, boltdia/2, boltdia/2, $fn=24);
    }
}

module beugel()
{
    rotate([0, -90, 0]) {
        pbdia = 10;
        pbwid = 10;
        pblen = 38;
        pbthi = 1;
        pbs1 = (pblen-pbwid)/2;
        pbs2 = (pblen+pbwid)/2;
        linear_extrude(height=pbwid, convexity=4) polygon(concat(
            [[0, 0], [0, pbthi], [pbs1-pbthi, pbthi]],
            [for (a=[-90: 5:90]) [pblen/2+sin(a)*(pbdia/2+pbthi), pbdia/2+cos(a)*(pbdia/2+pbthi)]],
            [[pbs2+pbthi, pbthi], [pblen, pbthi], [pblen, 0], [pbs2, 0]],
            [for (a=[90:-5:-90]) [pblen/2+sin(a)*(pbdia/2), pbdia/2+cos(a)*(pbdia/2)]],
            [[pbs1, 0]]
        ));
    }
}

module hinge()
{
    hi = targethi;
    thi = 3;
    nut = 8;

    translate([0, 0, -spacing]) pivotbracket();
    translate([0, 0, hi+spacing]) mirror([0, 0, 1]) pivotbracket();

    translate([0, 0, -thi-nut]) nut(pin);
    translate([0, 0, hi+thi+nut]) mirror([0, 0, 1]) nut(pin);

    translate([-(blen/2-10), off-thi-nut, -boltoff-spacing]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, -boltoff-spacing]) hingebolt();

    translate([-(blen/2-10), off-thi-nut, hi+boltoff+spacing]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, hi+boltoff+spacing]) hingebolt();

    translate([0, 0, -thi-nut]) color("#ccc") cylinder(hi+(thi+nut)*2, pin/2, pin/2, $fn=24);

    color("#000") translate([0, 0, -(spacing-(spacing-1)/2)]) linear_extrude(height=1) difference() {
        circle(20/2);
        circle(10.2/2);
    }
    color("#000") translate([0, 0, hi+((spacing-1)/2)]) linear_extrude(height=1) difference() {
        circle(20/2);
        circle(10.2/2);
    }
}

module target()
{
    targetbracket();
    translate([0, 0, targethi]) mirror([0, 0, 1]) targetbracket();
    targetboard();
}

module targetboard()
{
    bthi = 2;
    color("#db6") translate([pin/2+2, -tthi/2, bthi]) cube([targetwid, tthi, targethi-bthi*2]);
    translate([targethoff, 0, targethi/2]) rotate([90, 0, 0]) {
        color("#db6") translate([0, 0, -tthi/2]) cylinder(tthi, targetdia/2, targetdia/2, $fn=120);
        translate([0, 0, -tthi/2-25]) circles();
        translate([0, 0, tthi/2]) circles();
    }
}

module circles()
{
    tcth = 25;
    r1 = targetdia/2;
    r2 = r1*0.75;
    r3 = r1*0.5;
    r4 = r1*0.25;
    color("#333") ccircle(tcth, r1, r2);
    color("#55f") ccircle(tcth, r2, r3);
    color("#f55") ccircle(tcth, r3, r4);
    color("#fe7") ccircle(tcth, r4, 0);
}

module ccircle(tcth, r1, r2) {
    linear_extrude(height = tcth) {
        difference() {
            circle(r1, $fn=120);
            if (r2 > 0) { circle(r2, $fn=120); }
        }
    }
}

module targetbracket()
{
    thi = 2;
    bside = tthi + thi*2;
    so = bside/2;
    si = so-thi;
    soff = bside/2;
    color("#889")
    render(convexity=10) difference() {
        rotate([0, -90, 180]) translate([0, 0, -soff])
        linear_extrude(height=tlen, convexity=6) polygon([
                [0, -so], [bside, -so], [bside, -si], [thi, -si],
                [thi, si], [bside, si], [bside, so], [0, so]
            ]);
        translate([0, 0, -0.1]) cylinder(thi+0.2, pin/2+0.2, pin/2+0.2, $fn=24);
    }
}

module hingebolt()
{
    thi = 3;
    nut = 8;
    color("#ccc") rotate([-90,0,0]) union() {
        cylinder(pthi+thi+nut, boltdia/2, boltdia/2, $fn=24);
        translate([0, 0, pthi+thi+nut]) cylinder(2, 10, 10, $fn=24);
        nut();
    }
}

module nut(dia = 6, nut = 8, thi = 6)
{
    odia = dia * 2;
    color("#ccc") translate([0, 0, nut-thi]) cylinder(thi, odia/2, odia/2, $fn=6);
}

module pivotbracket()
{
    thi = 2;
    color("#889")
    render(convexity=10) difference() {
        rotate([180, 90, 0]) translate([0, -off, -blen/2])
        linear_extrude(height=blen, convexity=6) polygon([
                [0, 0], [0, side.x], [thi, side.x],
                [thi, thi], [side.y, thi], [side.y, 0]
            ]);
        translate([0, 0, -thi-0.1]) cylinder(thi+0.2, pin/2+0.2, pin/2+0.2, $fn=24);
        translate([-(blen/2-10), off+0.1, -boltoff]) rotate([90, 0, 0])
            cylinder(thi+0.2, boltdia/2, boltdia/2, $fn=24);
        translate([(blen/2-10), off+0.1, -boltoff]) rotate([90, 0, 0])
            cylinder(thi+0.2, boltdia/2, boltdia/2, $fn=24);
    }
}
