doitem = "panelholder_conn";

s2 = 1.5;  // Very round to get nice even sizes

acryl_thick = 3;  // acrylic wall thickness
tape_thick = 0.5;

conn_thick = 3;    // Connector thickness
conn_width = 20;  // Connector width
conn_depth = 23;  // Connector depth

sideoff = 300+6/s2+2.2;

hinge_type = 1;

if (doitem == "corner_outside")     { edgeconnector_outside_corner(); }
if (doitem == "corner_inside")      { edgeconnector_inside_corner(); }
if (doitem == "edge_inside")        { edgeconnector_inside(); }
if (doitem == "corner_hinge")       { rotate([180,0,0]) edgeconnector_outside_hinge(); }
if (doitem == "corner_magnet")      { rotate([180,0,0]) edgeconnector_outside_magnet(); }
if (doitem == "hinge_inside")       { rotate([0,90,0]) hingeconnector_inside(); }
if (doitem == "hinge_outside")      { rotate([180,0,0]) hingeconnector_outside(); }
if (doitem == "magnet_inside")      { rotate([0,-90,-90]) magnetconnector_inside(); }
if (doitem == "magnet_outside")     { rotate([180,0,0]) magnetconnector_outside(); }
if (doitem == "panelholder_back")   { ledpanel_holder_back(); }
if (doitem == "panelholder_hinge")  { mirror([1,0,0]) ledpanel_holder_hinge(); }
if (doitem == "panelholder_magnet") { ledpanel_holder_magnet(); }
if (doitem == "panelholder_rgb")    { ledpanel_holder_rgb(); }
if (doitem == "panelholder_cap")    { rotate([90,0,0]) ledpanel_holder_cap(); }
if (doitem == "panelholder_inside") { rotate([-90,0,0]) ledpanel_holder_inside(); }
if (doitem == "panelholder_conn")   { rotate([45,0,0]) ledpanel_holder_connector(); }
if (doitem == "panelholder_fconn")  { rotate([0,90,0]) ledpanel_front_connector(); }
if (doitem == "plug_holder")        { edgeholder_plug(); }
if (doitem == "plug_cap")           { edgeholder_cap(); }


if (doitem == "") {
    *color("#8a5") edgeconnector_outside_corner();
    *color("#58a") edgeconnector_inside_corner();

    *color("#8a5") edgeconnector_outside_hinge();
    *color("#58a") edgeconnector_inside();

    *color("#8a5") rotate([0,-90,-90]) hingeconnector_outside();
    *color("#58a") rotate([0,-90,-90]) hingeconnector_inside();

    *color("#bcd") rotate([0,-90,-90]) translate([-2,-2,0]) cylinder(40, 3, 3, $fn=48);
    *color("#ee5") rotate([0,-90,-90]) translate([-2,-2,0]) {
        cylinder(6, 2.5, 2.5, $fn=48);
        translate([0,0,6]) cylinder(1.8, 5, 5, $fn=48);
    }

    *#color("#58a") translate([0,0,-4]) mirror([0,0,1]) rotate([0,-90,-90]) hingeconnector_inside();

    color("#8a5") edgeconnector_outside_magnet();
    *color("#58a") edgeconnector_inside();

    *color("#8a54") render(convexity=6) rotate([0,-90,-90]) magnetconnector_outside();
    *color("#58a") rotate([0,-90,-90]) magnetconnector_inside();

    *color("#8a5") rotate([0,0,0]) magnetconnector_outside();
    *color("#8a5") rotate([90,0,90]) magnetconnector_outside();

    *color("#8a5") mirror([1,-1,0]) rotate([0,-90,-90]) magnetconnector_outside();

    *color("#8a5") translate([0,0,100]) edgeholder_plug();
    *color("#8a57") translate([0,0,100+0.1]) render(convexity=6) edgeholder_cap();
    *color("#8a57") translate([0,0,100+0.1]) edgeholder_cap();

    *color("#454") translate([0,0,23]) mirror([0,0,1]) barrelplug();

    *color("#8a5") edgeconnector_outside_corner();
    *color("#58a") edgeconnector_inside_plug();

    *color("#cb5") translate([0,0,0]) ledpanel_holder_rgb();
    *color("#5ac") translate([0,sideoff,0]) mirror([0,1,0]) ledpanel_holder_back();
    *color("#5ac") translate([sideoff,0,0]) mirror([1,0,0]) ledpanel_holder_hinge();
    *color("#cb5") translate([sideoff,sideoff,0]) rotate([0,0,180]) ledpanel_holder_magnet();
    *color("#5ac") ledpanel_holder_hinge();
    *color("#5ac") ledpanel_holder_magnet();

    *color("#58a") rotate([0,0,0]) ledpanel_holder_inside();
    *color("#85a") ledpanel_holder_connector();
    *color("#85a") translate([sideoff,0,0]) mirror([1,0,0]) ledpanel_front_connector();

    *color("#973") translate([0,0,0]) ledpanel_holder_cap();

    *color("#8a5") magnetconnector_outside();
    *color("#8a55") hingeconnector_outside();
    *color("#8a5") rotate([90,0,90]) edgeconnector_outside_hinge();

    *color("#8a5") translate([130.1,0,0]) rotate([90,0,90]) magnetconnector_outside();

    *ledpanel();
    *rgbcontroller();
    color("#7c94") acryl_plates();
}

module ledpanel_front_connector(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, zof = 5, tol=0.1)
{
    cof = ct/s2+1+tol;
    translate([2, aw/2+cof-21, 1-12/2]) {
        translate([0.2, 0.5, 0.3]) cube([5.5-4.4, 40, 11.4]);
    }
}

module ledpanel_holder_connector(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, zof = 5, tol=0.1)
{
    cof = ct/s2+1+tol;
    translate([aw/2+cof-21, 12, 12]) difference() {
        translate([0.0, 0.2, 0.2]) rotate([45,0,0]) cube([41, 2.6, 9.6]);
        rotate([-45,0,0]) translate([4.5, -5, 0]) cylinder(3, 1.2, 1.2, $fn=48);
        rotate([-45,0,0]) translate([41-4.5, -5, 0]) cylinder(3, 1.2, 1.2, $fn=48);
    }
}

module ledpanel_holder_inside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    xi = cof;
    xo = xi-ct;
    yi = tt+at+tt+0.5;
    yo = tt+tol;
    difference() {
        translate([cof,0,0]) rotate([0,90,0]) linear_extrude(height=149.5, convexity=5) {
            polygon([
                [-cof,-tt+0.2], [-cof-cw,-tt+0.2], [-cof-cw, 0.5], [-cof+1, 0.5],
                [-cof+1, -tt-at], [-cof, -tt-at]
            ]);
        }
        translate([cof-0.01, -tt-0.01, cof]) cube([cd+0.01,tt+0.01,cw+0.01]);
        translate([cof+149.5-cd, -tt-0.01, cof]) cube([cd+0.01,tt+0.01,cw+0.01]);
    }
}

module ledpanel_holder_cap()
{
    cable = 6;
    hi = 17;
    translate([115, -24, -5.8]) {
        difference() {
            cube([20, hi, 35.8]);
            translate([-0.01, 4, 3]) cube([15.01, 13.51, 30]);
            translate([15-0.01,hi,25]) rotate([0,90,0]) {
                linear_extrude(height=5.02, convexity=5) polygon(concat(
                    [ for (an=[90:5:270]) [ sin(an)*cable/2, -cable/2+cos(an)*cable/2 ]],
                    [[-cable/2, 0.01], [ cable/2, 0.01]]
                ));
            }
            translate([10,4.01,18]) rotate([90,0,0]) cylinder(4.02, 1.2, 1.2, $fn=48);
        }
        translate([17.5,17.0,25-cable/2-0.4]) intersection() {
            rotate([84,0,0]) cylinder(cable+1, 1, 1, $fn=4);
            translate([-1.0,-cable-1,0]) cube([2.0, cable+1, 1.6]);
        }
        translate([15.6,17.0,25+cable/2+0.4]) intersection() {
            rotate([96,0,0]) cylinder(cable+1, 1, 1, $fn=4);
            translate([-0.6,-cable-1,-1.6]) cube([1.6, cable+1, 1.6]);
        }
        translate([19.4,17.0,25+cable/2+0.4]) intersection() {
            rotate([96,0,0]) cylinder(cable+1, 1, 1, $fn=4);
            translate([-1.0,-cable-1,-1.6]) cube([1.6, cable+1, 1.6]);
        }
        // translate([15.6,17.0,25+cable/2+0.3]) rotate([95,0,0]) cylinder(cable+1, 1, 1, $fn=4);
        // translate([19.4,17.0,25+cable/2+0.3]) rotate([95,0,0]) cylinder(cable+1, 1, 1, $fn=4);
    }
}

module ledpanel_holder_rgb(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    ledpanel_holder_back();
    hlen = 97;
    translate([38,-26.2,-8]) {
        difference() {
            union() {
                cube([hlen, 22.5, 40]);
                translate([0,22,0]) cube([hlen, 6, 6]);
            }
            translate([3, 2.1, 2]) cube([hlen-2.99, 17.6, 36.4]);
            translate([-0.01, 11, 20]) rotate([0,90,0]) linear_extrude(height=3.02, convexity=5)
                polygon(concat(
                    [for (an=[  0:5:180]) [10+5*sin(an), 5*cos(an)]],
                    [for (an=[180:5:360]) [-10+5*sin(an), 5*cos(an)]]
                ));
            translate([87,4.01,20.2]) rotate([90,0,0]) cylinder(4.02, 1.6, 1.6, $fn=48);
        }
    }
}

module ledpanel_holder_hinge(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    outs = -at-tt-tol;

    ledpanel_holder_front();
    translate([0,0,2]) linear_extrude(height=cof+cw-2) polygon([
        [2, outs], [2, 1+tol],
        [cof-tol, 1+tol], [cof-tol, outs]
    ]);
    difference() {
        rotate([90,0,90]) outside_hinge_thing(xh=1.5, cd=30);
        translate([0,0,-8.01]) linear_extrude(height=9.02, convexity=5) polygon([
            [0.01,30.01],[-6.51,30.01],[-6.51,30-6.51]
        ]);
    }
}

module ledpanel_holder_magnet(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    edg = 3.9;
    sd = 6.5;
    bx = 5.2;
    sb = 8;

    ict = ct+2.9-tol;
    bev = 6.4;

    difference() {
        union() {
            ledpanel_holder_front(cut=2.5+0.2, top=-8.01);
            translate([0,0,-sb]) linear_extrude(height=cw+cof+sb, convexity=5) polygon([
                [cof-tol,cof-tol-tol],[-edg+tol,-edg],[-edg+tol,-bx],
                [-edg+tol+sd-bx, -sd], [cof-tol,-sd]
            ]);
            translate([0,-sd,0]) difference() {
                mirror([0,-1,1]) linear_extrude(height=cw+cof+sd+5, convexity=5) polygon([
                    [cof-tol,cof-tol-tol],[-edg+tol,-edg],[-edg+tol,-bx],
                    [-edg+tol+sb-bx, -sb], [cof-tol,-sb]
                ]);
                translate([0, cw+cof+sd, -sb-0.01]) linear_extrude(height=sb+0.01, convexity=5)
                    polygon([ [-3.81,5.7],[2.2,5.7],[-3.81,-0.01] ]);
            }
        }
        translate([cof-8.01,0,0]) rotate([0,90,0]) linear_extrude(height=8.02, convexity=5) polygon([
            [sb+0.01,1.51],[sb+0.01,-sd-0.01],[-0.01,-sd-0.01]
        ]);
        mirror([-1,0,1]) translate([tt+ict-1.7-bev,cw/2+ct/2,cof-ct-1.8]) rotate([0,-45,0]) translate([0,0,2/2]) cube([5,10,2.01], true);
        mirror([-1,1,0]) translate([tt+ict-1.7-bev,cof-ct-1.8,cw/2+ct/2]) rotate([0,0,45]) translate([0,2/2,0]) cube([5,2.01,10], true);
    }
}

module ledpanel_holder_front(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, cut=2, top=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    rw = 295;
    pw = 242;
    zof = 5;
    xof = cof+(300-295)/2;
    ridge = 25;
    over = 2;
    sidelen = (aw+cof*2)/2;

    difference() {
        union() {
            translate([1.5,0,0]) ledpanel_holder_side(aw-3.0, ah, at, tt, ct, cw, zof, tol);
            mirror([-1,1,0]) rotate([0,90,0]) translate([0,0,5])
                linear_extrude(height=sidelen-5, convexity=5) polygon([
                    [zof+tol, xof-tol], [zof+tol, xof+over], [zof+ct, xof+over],
                    [zof+ct, 0], [zof-13-ct, 0], [zof-13-ct, ridge-1],
                    [zof-13, ridge-1], [zof-13, xof-tol]
                ]);

        }
        translate([2, aw/2+cof-21, 1-12/2]) cube([5.5-4,21.01,12]);
        translate([-0.01, -7, top])
            linear_extrude(height=41, convexity=5) polygon([
                [0,0], [cut+0.01,0], [cut+0.01, 31], [0,31+cut+0.01]
            ]);
    }
}

module ledpanel_holder_back(aw = 301, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    zof = 5;
    outs = -at-tt-ct;
    cof = ct/s2+1+tol;

    difference() {
        union() {
            ledpanel_holder_side(aw, ah, at, tt, ct, cw, zof, tol);
            mirror([-1,1,0]) ledpanel_holder_side(aw, ah, at, tt, ct, cw, zof, tol);

            translate([0,0,-zof-ct]) linear_extrude(height=zof+ct+cof+cw) polygon([
                [0, outs], [outs, 0], [outs, cof-tol], [0, cof-tol],
                [cof-tol, 0], [cof-tol, outs]
            ]);
            translate([0,0,cof+cw]) linear_extrude(height=9.4) polygon([
                [0.5, 0.5], [cof-tol, 0.5], [cof-tol, -tt], [0.5, -tt],
                [-tt, 0.5], [-tt, cof-tol], [0.5, cof-tol]
            ]);
        }
        translate([-6.51,0,0]) rotate([0,90,0]) linear_extrude(height=14.52, convexity=5) polygon([
            [8.01,1.51],[8.01,-6.51],[-0.01,-6.51]
        ]);
        mirror([1,-1,0]) translate([-6.51,0,0]) rotate([0,90,0]) linear_extrude(height=14.52, convexity=5) polygon([
            [8.01,1.51],[8.01,-6.51],[-0.01,-6.51]
        ]);
    }
}

module ledpanel_holder_side(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, zof = 5, tol=0.1)
{
    cof = ct/s2+1+tol;
    rw = 295;
    pw = 242;
    xof = cof+(300-295)/2;
    ridge = 25;
    over = 2;
    sidelen = (aw+cof*2)/2;
    outs = -at-tt-ct;
    ridgepoly = [
        [zof+tol, xof-tol], [zof+tol, xof+over], [zof+ct, xof+over], [zof+ct, outs+8],
        [zof+ct-8, outs], [-cof-cw, outs], [-cof-cw, -at-tt], [-cof+tol+1, -at-tt],
        [-cof+tol+1, 0.5], [-cof-cw, 0.5], [-cof-cw-tt-0.5, -tt], [zof-13-ridge-tt+1, -tt],
        [zof-13-ridge-tt+1, 1-tt], [zof-13-1, ridge-1], [zof-13, ridge-1], [zof-13, xof-tol] ] ;

    difference() {
        rotate([0,90,0]) translate([0,0,0.5]) linear_extrude(height=sidelen-0.5, convexity=5) polygon(ridgepoly);
        translate([aw/2+cof-21, 12, 12]) rotate([45,0,0]) cube([21.01,3,10]);
        translate([aw/2+cof-21, 12, 12]) rotate([-45,0,0]) translate([5, -5, -4]) cylinder(12, 1.6, 1.6, $fn=48);
    }
}

module ledpanel(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    rw = 295;
    pw = 242;
    zof = 5;
    translate([cof, cof, -zof]) {
        color("#eee") translate([aw/2, aw/2, 0]) linear_extrude(height=12.5, convexity=5) {
            polygon([[-rw/2,-rw/2], [rw/2, -rw/2], [rw/2, rw/2], [-rw/2, rw/2],
                     [-pw/2,-pw/2], [pw/2, -pw/2], [pw/2, pw/2], [-pw/2, pw/2]],
                    [[0,1,2,3],[4,5,6,7]]);
        }
        color("#ddd") translate([aw/2, aw/2, 0]) linear_extrude(height=11, convexity=5) {
            square(pw, true);
        }
        color("#333") translate([20, 51, 0]) {
            translate([0,0,-8]) cylinder(8, 5, 7, $fn=24);
            translate([0,0,-16]) cylinder(16, 3, 3, $fn=24);
        }
    }
}

module edgeconnector_inside_plug(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_in_poly(cd, ct, at, tt)));
    }
    translate([0,0,-tt]) rotate([0,0,90]) linear_extrude(height=cof+tt, convexity=5) {
        polygon(mirxy(edgecon_in_bot(cd, ct, at, tt)));
    }
    translate([0,0,cof+cw-3]) rotate([0,0,90]) linear_extrude(height=3, convexity=5) {
        polygon(mirxy(edgecon_in_plug_poly(cd, ct, at, tt)));
    }
    inside_nubs(ct, cw);
}

module edgeholder_cap(at = acryl_thick, ct = conn_thick, cd = 7, cw = 15, tt=tape_thick,
                co=5, od=9, tol=0.1)
{
    cof = ct/s2+1+tol;
    xi = cof+tol;
    xo = cof-1-tol;
    yi = 0;
    xe = ct*2*sqrt(2);
    ys = cw/2+xo+1;
    hw = 2.6;
    xs = cw+xo;
    tw = xs+ct;
    ht = tw-1;

    translate([0,0,cw]) difference() {
        intersection() {
            rotate([0,0,90]) linear_extrude(height=tw+0.01, convexity=5) {
                polygon(mirxy(plugcon_out_poly(cd, ct, at, tt, co, od)));
            }
            rotate([0,-90,-45]) translate([0,0,-ys]) linear_extrude(height=ys*2, convexity=5) {
                polygon(concat([[xs+ct,xe], [xs+ct,ct]],
                    //[[xs+ct+4,ct],[2,-xs]],
                    [for (an=[0:2:90]) [2+cos(an)*(xs+ct-2), ct+sin(an)*(-ct-xs+0.9)]],
                [[-0.001,-xs+0.9], [-0.001,xe]]));
            }
        }
        rotate([0,-90,-45]) translate([0,0,-hw]) linear_extrude(height=hw*2, convexity=5) {
            polygon([[ht,xe], [ht,-xs+5+(ht)], [-0.01,-xs+5-0.01],
                [-0.01,-3-0.01], [5,-3+5], [5,xe]]);
        }
        difference() {
            translate([-co,-co,-0.01]) cylinder(1.21, 7.9, 7.9, $fn=48);
            translate([-co,-co,-0.02]) cylinder(1.23, 6.9, 6.9, $fn=48);
        }
        /*
        translate([-co,-co,ct]) cylinder(cw-ct+0.01, 7, 7, $fn=48);
        translate([-co,-co,-0.01]) rotate([0,0,45]) intersection() {
            cylinder(ct+0.02, 4, 4, $fn=48);
            translate([0,0,4]) cube([6.6, 8.1, 8.1], true);
        }
        */
    }
}

module edgeholder_plug(at = acryl_thick, ct = conn_thick, cd = 7, cw = 15, tt=tape_thick,
                co=5, od=9, tol=0.1)
{
    cof = ct/s2+1+tol;
    xi = cof+tol;
    xo = cof-1-tol;
    yi = 0;

    difference() {
        union() {
            translate([0,0,0]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
                polygon(mirxy(plugcon_out_poly(cd, ct, at, tt, co, od)));
            }
            translate([-co,-co,cw]) cylinder(1, 7.8, 7.8, $fn=48);
        }
        translate([-co,-co,ct]) cylinder(cw-ct+1+0.01, 7, 7, $fn=48);
        translate([-co,-co,-0.01]) rotate([0,0,-45]) intersection() {
            cylinder(ct+0.02, 4, 4, $fn=48);
            translate([0,0,4]) cube([6.6, 8.1, 8.1], true);
        }
    }

}
module barrelplug(co=5) {
    translate([-co,-co,0]) rotate([0,0,-45]) {
        translate([0,0,-4]) cylinder(4, 5, 5, $fn=48);
        translate([0,0,0]) intersection() {
            cylinder(8, 3.8, 3.8, $fn=48);
            translate([0,0,4]) cube([6.5, 8, 8.1], true);
        }
        translate([-1.1, 2.4, 8]) cube([2.2, 0.4, 6]);
        translate([-1.1,-2.4, 8]) cube([2.2, 0.4, 4.5]);
    }
}

function plugcon_out_poly(cd, ct, at, tt, co, od, tol=0.1) = (
    let (yi = 0
        ,ym = at+tt
        ,yo = ym+ct
        ,xi = ct/s2+1
        ,xo = cd
        )
    concat([ [xi, yi+tt-ct], [xo,yi+tt-ct], [xo,yi+tt], [xi, yi+tt], [xi, ym], [xo, ym], [xo, yo-1] ],
        [for (an=[135:5:225]) [-co+od*sin(an), co-od*cos(an)]])
);


module magnetconnector_outside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1, cp=48)
{
    cof = ct/s2+1+tol;
    xi = cof+tol;
    xo = cof-1-tol;
    xa = cd+tol;
    yi = 0.5;
    yo = at+tt+tol;
    ict = ct+2.9-tol;
    bev = 6.4;
    bbev = 1.4;

    cutsz = bev*sqrt(2);
    bcutsz = bbev*sqrt(2);
    cutln = at+ct+ct+tt;
    cutwd = cw+at+ict;


    difference() {
        union() {
            translate([0,0,cof-1]) rotate([0,0,90]) linear_extrude(height=cd-2, convexity=5) {
                polygon([
                    [xo,yo+1], [xa-1,yo+1], [xa-1,yo], [xa,yo],
                    [xa,yo+ct], [xo-ict+bbev,yo+ct], [xo-ict, yo+ct-bbev],
                    [xo-ict,yi-ct+bev], [xo-ict+bev,yi-ct], [xa,yi-ct],
                    [xa,yi], [xi,yi], [xi,yi-1], [xo,yi-1]
                ]);
            }
            translate([0,0,cof-ict-tol-1]) rotate([0,0,90]) linear_extrude(height=ict+1+tol-0.7, convexity=5) {
                polygon([
                    [xa,yo+ct], [xo-ict+bbev,yo+ct], [xo-ict, yo+ct-bbev],
                    [xo-ict,yi-ct+bev], [xo-ict+bev,yi-ct], [xa,yi-ct],
                ]);
            }
        }
        translate([cutln/2-at-tt-ct,cof-ict-1-tol,cof-ict-1-tol]) rotate([45,0,0]) cube([cutln+0.01,bcutsz,bcutsz+0.01], true);
        translate([-at-tt-ct-tol,cutwd/2-ict/2-1,cof-ict-1-tol]) rotate([0,45,0]) cube([bcutsz+0.01,cutwd+0.01,bcutsz], true);
        translate([ct-tt,cutwd/2-ict/2-1,cof-ict-1.1]) rotate([0,-45,0]) cube([cutsz,cutwd+0.01,cutsz], true);
        *translate([ct-tt-0.5-2/sqrt(2)-2,cutwd-ct,cof-ct+0.5+2/sqrt(2)-2]) rotate([0,-45,0]) cube([3,3,2], true);
        translate([tt+ict-1.7-bev,cw/2+ct/2,cof-ct-1.8]) rotate([0,-45,0]) translate([0,0,2/2]) cube([5,10,2.01], true);
        translate([tt+ict-1.7-bev,cof-ct-1.8,cw/2+ct/2]) rotate([0,0,45]) translate([0,2/2,0]) cube([5,2.01,10], true);
    }
    translate([-at-tt-1.1,cd-0.9,cw+cof]) rotate([0,90,0]) linear_extrude(height=tt+0.0) polygon([
        [3,0],[0,-3],[0,0]
    ]);
}

module magnetconnector_inside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    xi = cof;
    xo = xi-ct;
    yi = tt+at+tt+0.5;
    yo = tt+tol;
    difference() {
        translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=cd-cof+0.5, convexity=5) {
            polygon([
                [xi-nub,yi], [xi-nub, yo-1], [xi, yo-1], [xi,yi-0.5], [cd-1,yi-0.5], [cd-1,yi]
            ]);
        }
        translate([-yi-0.01,cd-1,cd]) rotate([0,90,0]) linear_extrude(height=0.52) polygon([
            [3.4,0.1],[-0.1,-3.4],[-0.1,0.1]
        ]);
    }
    translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=0.5, convexity=5) {
        polygon([
            [xi-nub,yi], [xi-nub, yo], [cd-1,yo], [cd-1,yi]
        ]);
    }
}


module hingeconnector_outside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1, cp=48)
{
    cof = ct/s2+1+tol;
    xi = cof-1-tol;
    xo = xi-ct + (hinge_type==2 ? -1 : hinge_type==3 ? ct+1 : ct+0.5);
    yi = -0.5;
    yo = yi+0.5+tt+at;
    ict = 1.5;

    tpt = hinge_type==1 ? 2 : 5;

    cmid = ((yi-ict)+(yo+ct))/2;
    crad = ((yi-ict)-(yo+ct))/2;

    difference() {
        union() {
            translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=cw+0.5, convexity=5) {
                polygon(concat([
                    //[xo, yi-ict], [xo,yo+ct],
                    [cd,yo+ct], [cd,yo], [xi+1+tol*2,yo], [xi+1+tol*2,yo+1], [xi,yo+1], [xi,yi],
                    [cd-1, yi], [cd-1, tt-tol], [cd, tt-tol], [cd, yi-ict],
                ], [for (an=[0:360/cp:180]) [xo+sin(an)*crad, cmid+cos(an)*crad]]
                ));
            }
            translate([0,0,cof-tpt]) rotate([0,0,90]) linear_extrude(height=tpt-0.5, convexity=5) {
                polygon(concat([
                    //[xo,yi-ict], [xo,yo+ct],
                    [cd,yo+ct], [cd,yi-ict],
                ], [for (an=[0:360/cp:180]) [xo+sin(an)*crad, cmid+cos(an)*crad]]
                ));
            }
            if (hinge_type == 1) {
                translate([-cmid,xo,cof-tpt-4]) cylinder(4.1, 2.5, 2.5, $fn=cp);
                translate([-cmid,xo,cof-tpt-5]) cylinder(1, 1.8, 2.5, $fn=cp);
            }
        }
        if (hinge_type == 2) {
            translate([-cmid,xo,cof-tpt-0.01]) cylinder(cw+ct+0.02, 3, 3, $fn=cp);
        }
        if (hinge_type == 3) {
            translate([-cmid,xo,cof-tpt-0.01]) cylinder(tpt-1, 3, 3, $fn=cp);
        }
    }
    translate([-0.0,cd-1,cw+cof]) rotate([0,90,0]) linear_extrude(height=tt+0.0) polygon([
        [3,0],[0,-3],[0,0]
    ]);
}

module hingeconnector_inside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    xi = cof;
    xo = xi-ct;
    yi = -0.5;
    yo = tt+at-tol;
    ict = ct-1;
    difference() {
        translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=cw+0.5, convexity=5) {
            polygon([
                [xi-nub,yi], [xi-nub, yo+1], [xi, yo+1], [xi,0], [cd-1.2,0], [cd-1.2,yi]
            ]);
        }
        translate([-0.01,cd-1,cw+cof]) rotate([0,90,0]) linear_extrude(height=0.52) polygon([
            [3.4,0.1],[-0.1,-3.4],[-0.1,0.1]
        ]);
    }
    translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=0.5, convexity=5) {
        polygon([
            [xi-nub,yi], [xi-nub, yo], [cd-1.2,yo], [cd-1.2,yi]
        ]);
    }
}

module edgeconnector_inside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_in_poly(cd, ct, at, tt)));
    }
    inside_nubs(ct, cw);
    translate([0,0,26.2]) mirror([0,0,1]) inside_nubs(ct, cw);
}

module edgeconnector_inside_corner(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_in_poly(cd, ct, at, tt)));
    }
    translate([0,0,-tt]) rotate([0,0,90]) linear_extrude(height=cof+tt, convexity=5) {
        polygon(mirxy(edgecon_in_bot(cd, ct, at, tt)));
    }
    inside_nubs(ct, cw);
}

module inside_nubs(ct, cw, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    cx = ct/s2+ct*3-tol-nub;
    cy = ct+nub;
    translate([cx, cy, cw+cof-nub/sqrt(2)-nub/2-0.1]) rotate([135,0,-45])
        translate([-0.1,0,0]) cube([nub*sqrt(2)+0.2,nub,nub]);
    translate([cy, cx, cw+cof-nub/sqrt(2)-nub/2-0.1]) rotate([-45,0,135])
        translate([-0.1,0,0]) cube([nub*sqrt(2)+0.2,nub,nub]);
}

module edgeconnector_outside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;

    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_innie(cd, ct, at, tt)));
    }
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_poly(cd, ct, at, tt)));
    }
    outside_nubs(ct, cw);
}

module edgeconnector_outside_magnet(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, tp=0.6, ht=8.6, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;

    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_innie(cd, ct, at, tt)));
    }
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_poly(cd, ct, at, tt)));
    }
    ebot = [[0, at+ct+tt], [cd,at+ct+tt], [cd, -ct/s2+tol], [ct/s2-tol, -ct/s2+tol]];
    *translate([0,0,-tp*2+cof]) rotate([0,0,90]) linear_extrude(height=tp, convexity=5) {
        polygon(mirxy(ebot));
    }
    ebot2 = [[0, at+ct+tt], [cd,at+ct+tt], [cd, -ct/s2-0.4]];
    translate([0,0,-tp+cof]) rotate([0,0,90]) linear_extrude(height=tp, convexity=5) {
        polygon(mirxy(ebot2));
    }
    edg = 3.9;
    sd = 6.5;
    bx = 5.2;
    sb = 6.5;
    ict = ct+2.9-tol;
    bev = 6.4;

    difference() {
        union() {
            mirror([1,-1,0]) mirror([-1,0,1]) translate([0,0,-sb]) {
                linear_extrude(height=cw+cof+sd-tol, convexity=5) polygon([
                    [cof-tol,cof-tol-tol-0.5], [cof-tol-0.5,cof-tol-tol-0.5],[-edg+tol,-edg],[-edg+tol,-bx],
                    [-edg+tol+sb-bx, -sb], [cof-tol,-sb]
                ]);
            }
            mirror([-1,0,1]) translate([0,0,-sb]) {
                linear_extrude(height=cw+cof+sd-tol, convexity=5) polygon([
                    [cof-tol,cof-tol-tol-0.5], [cof-tol-0.5,cof-tol-tol-0.5],[-edg+tol,-edg],[-edg+tol,-bx],
                    [-edg+tol+sb-bx, -sb], [cof-tol,-sb]
                ]);
            }
        }
        translate([0,0,cof-7.51]) rotate([0,0,-90]) linear_extrude(height=8.02, convexity=5) polygon([
            [sb+0.01,0.01],[sb+0.01,-sd-0.01],[-0.01,-sd-0.01]
        ]);
        translate([-4.4,-4.4,cof-7.51]) rotate([0,45,45]) cube([6,12,5], true);
        mirror([-1,0,1]) translate([tt+ict-1.7-bev,cw/2+ct/2,cof-ct-1.8]) rotate([0,135,0]) translate([0,0,2/2]) cube([5,10,2.01], true);
        mirror([-1,0,1]) translate([tt+ict-1.7-bev,cof-ct-1.8,cw/2+ct/2]) rotate([0,0,-135]) translate([0,2/2,0]) cube([5,2.01,10], true);
    }
    outside_nubs(ct, cw);
}

module edgeconnector_outside_hinge(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, tp=1, ht=8.6, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;

    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_innie(cd, ct, at, tt)));
    }
    translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
        polygon(mirxy(edgecon_out_poly(cd, ct, at, tt)));
    }
    translate([0,0,-tp+cof]) rotate([0,0,90]) linear_extrude(height=tp, convexity=5) {
        polygon(mirxy(edgecon_out_bot(cd, ct, at, tt)));
    }
    outside_nubs(ct, cw);
    outside_hinge_thing(at, ct, cw, cd, tt, tp, ht, nub, tol);
}

module outside_hinge_thing(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, tp=1, ht=8.6, nub=1, tol=0.1, xh=0)
{
    cof = ct/s2+1+tol;
    difference() {
        translate([0,0,-tp+cof-ht]) rotate([0,0,90]) linear_extrude(height=ht, convexity=5) {
            yi = 0;
            ym = at;
            yo = ym+ct+xh;
            xi = ct/s2;
            xo = cd;
            polygon([[-yo-tt,6-yo],[-yo-tt,-xo],[1,-xo], [1,2], [-4.5,2]]);
        }
        translate([2.8,-8, -1.6]) rotate([-90,90,0]) difference() {
            cube([8, 8, 10]);
            translate([0,0,-0.01]) cylinder(10.02, 5, 5, $fn=48);
        }
        translate([(cd+3)/2-2,-7.5,-5.5]) rotate([0,90,0]) rotate([0,0,45]) cube([6, 3, cd+3], true);

        xi = cof-0.5-tol;
        xo = xi-ct + (hinge_type==2 ? -1 : hinge_type==3 ? ct+1 : ct);
        yi = -0.5;
        yo = yi+0.5+tt+at;
        ict = 1.5;
        tpt = hinge_type==1 ? 2 : 5;
        cmid = ((yi-ict)+(yo+ct))/2;

        rotate([-90,0,0]) translate([xo,cmid,cof-tpt-5]) cylinder(5.01, 2.7, 2.7, $fn=48);

    }
}

module edgeconnector_outside_corner(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, tol=0.1)
{
    cof = ct/s2+1+tol;

    difference() {
        translate([0,0,-tt]) rotate([0,0,90]) linear_extrude(height=cw+cof+tt, convexity=5) {
            polygon(mirxy(edgecon_out_innie(cd, ct, at, tt)));
        }

        c1 = ct/s2*sqrt(2);
        c2 = (2*ct/s2-tol)*sqrt(2);
        c3 = (3*ct/s2-tol)*sqrt(2)+0.01;

        intersection() {
            translate([cof,cof,-tt]) rotate([90,0,45]) translate([0,0,-c1/2-0.01])
                linear_extrude(height=c1+0.02) polygon([
                    [-0.01,-0.01], [c3,-0.01], [c3,c3]
                ]);
            translate([cof,cof,-tt-0.01]) cube([c3,c3,c3+0.02]);
        }
        translate([cof+c3/sqrt(2),cof+c3/sqrt(2),-tt]) rotate([90,0,-45])
            linear_extrude(height=c1+0.1) {
                polygon([
                    [c1/2,-0.01], [c1/2,c3], [c1/2+c2+0.1,c3+c2+0.1], [c1/2+c2+0.1,-0.01]
                ]);
                polygon([
                    [-c1/2,-0.01], [-c1/2,c3], [-(c1/2+c2+0.1),c3+c2+0.1], [-(c1/2+c2+0.1),-0.01]
                ]);
            }
    }
    difference() {
        union() {
            translate([0,0,-tt]) rotate([0,0,90]) linear_extrude(height=cw+cof+tt, convexity=5) {
                polygon(mirxy(edgecon_out_poly(cd, ct, at, tt)));
            }
            translate([0,0,-at-tt]) rotate([0,0,90]) linear_extrude(height=at, convexity=5) {
                polygon(mirxy(edgecon_out_mid(cd, ct, at, tt)));
            }
            translate([0,0,-at-tt-ct]) rotate([0,0,90]) linear_extrude(height=ct, convexity=5) {
                polygon(mirxy(edgecon_out_bot(cd, ct, at, tt)));
            }
        }
        cutsz = (at+tt+ct)*sqrt(2);
        cutln = at+tt+ct+cw+ct;
        translate([cutln/2-at-tt-ct,-at-tt-ct,-at-tt-ct]) rotate([45,0,0]) cube([cutln+0.01,cutsz,cutsz], true);
        translate([-at-tt-ct,cutln/2-at-tt-ct,-at-tt-ct]) rotate([0,45,0]) cube([cutsz,cutln+0.01,cutsz], true);
    }
    outside_nubs(ct, cw);
}

module outside_nubs(ct, cw, nub=1, tol=0.1)
{
    cof = ct/s2+1+tol;
    cx = ct/s2+ct*3-tol/2-nub;
    cy = ct+nub+tol/2;
    ns = nub-0.2;
    translate([cx, cy, cw+cof-nub/sqrt(2)]) rotate([90,0,-45])
        translate([nub-0.3,0,0]) rotate([0,0,45]) cylinder(ns/sqrt(2), ns, 0, $fn=4);
    translate([cy, cx, cw+cof-nub/sqrt(2)]) rotate([90,0,-45])
        translate([-nub+0.3,0,0]) rotate([0,0,45]) cylinder(ns/sqrt(2), ns, 0, $fn=4);
}

function edgecon_in_plug_poly(cd, ct, at, tt, nub=1, tol=0.1) = (
    let (yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        ,ro = 5
        )
    concat(
        [ for (an=[130:-5:0]) [ -ro+7*cos(an), +ro+7*sin(an) ] ],
        [ [xi+tol-1, yi+at+tt-tol], [xi+tol-1, yi+1], [xi+tol+1, yi+tt]
        , [xi+tol+1, yi+at+tt-tol] ],
        [ for (an=[0:5:130]) [ -ro+10*cos(an), +ro+10*sin(an) ] ]
        )
);

function edgecon_in_poly(cd, ct, at, tt, nub=1, tol=0.1) = (
    let (yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xo-2, yi-ct], [xo, yi-ct+2], [xo, yi], [xi+tol+2, yi], [xi+tol+2, yi+tt], [xi+tol+1, yi+tt]
    , [xi+tol+1, yi+at+tt-tol], [xi+tol-1, yi+at+tt-tol], [xi+tol-1, yi+1]
    , [xi+ct*2, yi-ct*2+tol], [xi+ct*3-tol-nub, yi-ct-nub]
    , [xi+ct*3-tol-nub, yi-ct], [xo-ct*s2-2, yi-ct] ]
);

function edgecon_in_bot(cd, ct, at, tt, nub=1, tol=0.1) = (
    let (yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xo-2, yi-ct], [xo, yi-ct+2], [xo, ym+tt-tol]
    , [xi+tol-1, ym+tt-tol], [xi+tol-1, yi+1]
    , [xi+ct*2, yi-ct*2+tol], [xi+ct*3-tol-nub, yi-ct-nub], [xi+ct*3-tol-nub, yi-ct], [xo-ct*s2-2, yi-ct] ]
);

function edgecon_out_poly(cd, ct, at, tt, tol=0.1) = (
    let (yi = 0
        ,ym = at+tt
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xi-1, yi+1], [xi-1, ym], [xo, ym], [xo, yo], [0, yo] ]
);

function edgecon_out_innie(cd, ct, at, tt, tol=0.1) = (
    let (yi = 0
        ,ym = at+tt
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xi+ct*3+ct/s2, yi-ct-ct/s2], [xi+ct*3+ct/s2, yi-ct-tol]
    , [xi+ct*3-tol, yi-ct-tol], [xi+ct*2, yi-ct*2], [xi-2, yi+2] ]
);

function edgecon_out_mid(cd, ct, at, tt, tol=0.1) = (
    let (yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [[0,yo+tt],[xo,yo+tt],[xo,yi-xi-1-tol],[-(yi-xi-1-tol),yi-xi-1-tol]]
);

function edgecon_out_bot(cd, ct, at, tt, tol=0.1) = (
    let (yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [[0,yo+tt],[xo,yo+tt],[xo,yi-xi-1-tol]]
);

module acryl_plates(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    zof = at+tt;
    *translate([-tt,-cof,0]) rotate([0,0,180]) cube([at, ah, aw]);
    *mirror([1,1,0]) rotate([0,0,180]) translate([tt,ct/s2+1+tol,0]) cube([at, ah, aw]);

    *translate([cof,cof,-zof]) cube([aw, ah, at]);
    mirror([1,0,-1]) translate([cof,cof,-zof]) cube([aw, ah, at]);
    mirror([0,1,-1]) translate([cof,cof,-zof]) cube([aw, ah, at]);
}

module rgbcontroller()
{
    translate([41,-6.5-17.5,30]) rotate([0,90,0]) {
        difference() {
            color("#ccc") cube([36, 17.5, 73.5]);
            color("#888") translate([14, 8.5, -0.01]) cylinder(10.01, 5.5/2, 5.5/2, $fn=48);
            color("#8c8") translate([3,5,73.5-4]) cube([30, 7.5, 4.01]);
        }
    }
}

function swapxy(ar) = [for (i=[len(ar)-1:-1:0]) [-ar[i].y, -ar[i].x]];
function mirxy(ar) = concat(ar, swapxy(ar));

// Rotate around a given point
module crotate(ang, point) {
    translate(point) rotate(ang) translate(-point) children();
}
