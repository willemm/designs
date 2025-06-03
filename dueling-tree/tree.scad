off = 28.5;
side = [40, 20];
blen = 60;
tlen = 80;
pin = 10;
boltdia = 6;
boltoff = 12;
pthi = 26;

targethi = 160;
targetwid = 250;
targetdia = 240;
targethoff = 250;
tthi = 19;

polehi = 1600;
targetoff = 110;
firstoff = polehi-1550;

angle = 5;

rotate([-angle, 0, 0]) {
    foot();
    duelingtree();
}

module duelingtree()
{
    color("#b95") pole();

    tstep = targethi + targetoff;

    rots = [0, 180, 0, 140, 0, 180];
    for (o = [0,1,2,3,4,5]) {
        translate([0, 0, firstoff + o*tstep]) hinge();
        rotate([0, 0, -rots[o]]) translate([0, 0, firstoff + o*tstep]) target();
    }
}

module pole()
{
    hi = polehi;
    wid = 140;
    thi = pthi;

    translate([-wid/2, off, 0]) cube([wid, thi, hi]);
}

module foot()
{
    ovl = 280;
    hi = 550;
    wid = 140;
    thi = 16;
    clen = 1000;
    cwid = 40;
    llen = 1000;
    lwid = 40;

    slen = 560;
    swid = 20;
    sthi = 60;

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
    // Longbar
    color("#b95") translate([0, off+pthi+thi+5, -hi+ovl+19]) rotate([angle, 0, 0]) difference() {
        translate([-thi/2, -pthi-thi-5-llen/2, -19]) cube([thi, llen, lwid]);
        translate([-thi/2-0.1, 0, 0]) rotate([0, 90, 0]) cylinder(thi+0.2, 10/2, 10/2, $fn=24);
    }
    // Longbar pivot
    color("#889") translate([-thi/2-tol, off+pthi+thi, -hi+ovl]) beugel();
    color("#889") translate([thi/2+tol+10, off+pthi+thi, -hi+ovl]) beugel();
    // Support
    color("#b95") translate([-sthi/2, off+pthi+thi, ovl-20]) rotate([-64, 0, 0]) difference() {
        cube([sthi, slen, swid]);
        translate([(sthi-thi)/2-0.2, slen-50, -0.1]) cube([thi+tol, 50.1, swid+0.2]);
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

    translate([0, 0, -0.5]) pivotbracket();
    translate([0, 0, hi+0.5]) mirror([0, 0, 1]) pivotbracket();

    translate([0, 0, -thi-nut]) nut(pin);
    translate([0, 0, hi+thi+nut]) mirror([0, 0, 1]) nut(pin);

    translate([-(blen/2-10), off-thi-nut, -boltoff-0.5]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, -boltoff-0.5]) hingebolt();

    translate([-(blen/2-10), off-thi-nut, hi+boltoff+0.5]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, hi+boltoff+0.5]) hingebolt();

    translate([0, 0, -thi-nut]) color("#ccc") cylinder(hi+(thi+nut)*2, pin/2, pin/2, $fn=24);
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
    thi = 3;
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
