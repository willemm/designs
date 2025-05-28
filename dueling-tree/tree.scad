off = 15;
side = 25;
blen = 80;
pin = 10;
boltdia = 6;
pthi = 26;

targethi = 160;
targetwid = 250;
targetdia = 240;
targethoff = 250;
tthi = 19;

targetoff = 110;
firstoff = 250;

duelingtree();

module duelingtree()
{
    color("#b95") pole();

    tstep = targethi + targetoff;

    rots = [0, 180, 0, 150, 0, 180];
    for (o = [0,1,2,3,4,5]) {
        translate([0, 0, firstoff + o*tstep]) hinge();
        rotate([0, 0, -rots[o]]) translate([0, 0, firstoff + o*tstep]) target();
    }
}

module pole()
{
    hi = 1800;
    wid = 140;
    thi = pthi;

    translate([-wid/2, off, 0]) cube([wid, thi, hi]);
}

module hinge()
{
    hi = targethi;
    thi = 3;
    nut = 8;

    translate([0, off, 0]) pivotbracket();
    translate([0, off, hi]) mirror([0, 0, 1]) pivotbracket();

    translate([0, 0, -thi-nut]) color("#ccc") cylinder(hi+(thi+nut)*2, pin/2, pin/2, $fn=24);
    translate([0, 0, -thi-nut]) nut(pin);
    translate([0, 0, hi+thi+nut]) mirror([0, 0, 1]) nut(pin);

    translate([-(blen/2-10), off-thi-nut, -(side+thi)/2]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, -(side+thi)/2]) hingebolt();

    translate([-(blen/2-10), off-thi-nut, hi+(side+thi)/2]) hingebolt();
    translate([+(blen/2-10), off-thi-nut, hi+(side+thi)/2]) hingebolt();
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
    off = pin;
    color("#889") rotate([0, -90, 180]) translate([0, 0, -off])
    linear_extrude(height=blen) {
        polygon([
            [0, -so], [bside, -so], [bside, -si], [thi, -si],
            [thi, si], [bside, si], [bside, so], [0, so]
        ]);
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
    color("#889") rotate([180, 90, 0]) translate([0, 0, -blen/2])
    linear_extrude(height=blen) {
        polygon([
            [0, 0], [0, side], [thi, side],
            [thi, thi], [side, thi], [side, 0]
        ]);
    }
}
