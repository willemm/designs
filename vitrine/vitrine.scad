doitem = "";

s2 = 1.5;  // Very round to get nice even sizes

acryl_thick = 3;  // acrylic wall thickness
tape_thick = 0.5;

conn_thick = 3;    // Connector thickness
conn_width = 20;  // Connector width
conn_depth = 23;  // Connector depth

sideoff = 300+6/s2+2.2;

hinge_type = 1;

if (doitem == "corner_outside") { edgeconnector_outside_corner(); }
if (doitem == "corner_inside")  { edgeconnector_inside_corner(); }
if (doitem == "edge_inside")    { edgeconnector_inside(); }
if (doitem == "corner_hinge")   { rotate([180,0,0]) edgeconnector_outside_hinge(); }
if (doitem == "hinge_inside")   { rotate([0,90,0]) hingeconnector_inside(); }
if (doitem == "hinge_outside")  { rotate([180,0,0]) hingeconnector_outside(); }
if (doitem == "magnet_inside")   { rotate([0,-90,-90]) magnetconnector_inside(); }
if (doitem == "magnet_outside")  { rotate([180,0,0]) magnetconnector_outside(); }
if (doitem == "plug_holder")  { edgeholder_plug(); }
if (doitem == "plug_cap")  { edgeholder_cap(); }


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

    *color("#8a5") rotate([0,-90,-90]) magnetconnector_outside();
    *color("#58a") rotate([0,-90,-90]) magnetconnector_inside();

    *color("#8a5") rotate([0,0,0]) magnetconnector_outside();
    *color("#8a5") rotate([90,0,90]) magnetconnector_outside();

    *#color("#8a5") mirror([1,-1,0]) rotate([0,-90,-90]) magnetconnector_outside();

    *color("#8a5") translate([0,0,100]) edgeholder_plug();
    *color("#8a57") translate([0,0,100+0.1]) render(convexity=6) edgeholder_cap();
    *color("#8a57") translate([0,0,100+0.1]) edgeholder_cap();

    *color("#454") translate([0,0,23]) mirror([0,0,1]) barrelplug();

    *color("#8a5") edgeconnector_outside_corner();
    *color("#58a") edgeconnector_inside_plug();

    *color("#cb5") translate([0,0,0]) ledpanel_holder_back();
    *color("#5ac") translate([0,sideoff,0]) mirror([0,1,0]) ledpanel_holder_back();
    *color("#5ac") translate([sideoff,0,0]) mirror([1,0,0]) ledpanel_holder_front();
    *color("#cb5") translate([sideoff,sideoff,0]) rotate([0,0,180]) ledpanel_holder_front();
    color("#5ac") ledpanel_holder_front();

    *color("#8a5") magnetconnector_outside();
    *color("#8a55") hingeconnector_outside();
    *color("#8a5") rotate([90,0,90]) edgeconnector_outside_hinge();

    ledpanel();
    color("#7c94") acryl_plates();
}

module ledpanel_holder_front(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    rw = 295;
    pw = 242;
    zof = 5;
    xof = cof+(300-295)/2;
    ridge = 25;
    over = 2;
    sidelen = (aw+cof*2)/2;
    outs = -at-tt-ct;

    difference() {
        union() {
            translate([2,0,0]) ledpanel_holder_side(aw-4, ah, at, tt, ct, cw, zof, tol);
            mirror([-1,1,0]) rotate([0,90,0]) translate([0,0,5])
                linear_extrude(height=sidelen-5, convexity=5) polygon([
                    [zof+tol, xof-tol], [zof+tol, xof+over], [zof+ct, xof+over],
                    [zof+ct, 0], [zof-13-ct, 0], [zof-13-ct, ridge-1],
                    [zof-13, ridge-1], [zof-13, xof-tol]
                ]);

            translate([0,0,2]) linear_extrude(height=cof+cw-2) polygon([
                [0, outs], [0, cof-tol],
                [cof-tol, 0], [cof-tol, outs]
            ]);
            rotate([90,0,90]) outside_hinge_thing(xh=1.5);
        }
        translate([2, aw/2+cof-21, 1-12/2]) cube([5.5-4,21.01,12]);
        translate([-0.01, -7, 1]) cube([2.01, 31, 35]);
    }
}

module ledpanel_holder_back(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    zof = 5;
    outs = -at-tt-ct;
    cof = ct/s2+1+tol;

    ledpanel_holder_side(aw, ah, at, tt, ct, cw, zof, tol);
    mirror([-1,1,0]) ledpanel_holder_side(aw, ah, at, tt, ct, cw, zof, tol);

    translate([0,0,-zof-ct]) linear_extrude(height=zof+ct+cof+cw) polygon([
        [0, outs], [outs, 0], [outs, cof-tol], [0, cof-tol],
        [cof-tol, 0], [cof-tol, outs]
    ]);
    translate([0,0,cof+cw]) linear_extrude(height=9.4) polygon([
        [0, 0], [cof-tol, -tt], [0, -tt], [-tt, 0], [-tt, cof-tol]
    ]);
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
        [zof+ct-8, outs], [-cof-cw, outs], [-cof-cw, -at-tt], [-cof+tol, -at-tt],
        [-cof+tol, 0], [-cof-cw, 0], [-cof-cw-tt, -tt], [zof-13-ridge-tt+1, -tt],
        [zof-13-ridge-tt+1, 1-tt], [zof-13-1, ridge-1], [zof-13, ridge-1], [zof-13, xof-tol] ] ;

    difference() {
        rotate([0,90,0]) linear_extrude(height=sidelen, convexity=5) polygon(ridgepoly);
        translate([aw/2+cof-21, 12, 12]) rotate([45,0,0]) cube([21.01,3,10]);
        translate([aw/2+cof-21, 12, 12]) rotate([-45,0,0]) translate([5, -5, 2]) cylinder(6, 1.6, 1.6, $fn=48);
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
        translate([11,-7.5,-5.5]) rotate([0,90,0]) rotate([0,0,45]) cube([6, 3, 26], true);

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

function swapxy(ar) = [for (i=[len(ar)-1:-1:0]) [-ar[i].y, -ar[i].x]];
function mirxy(ar) = concat(ar, swapxy(ar));

// Rotate around a given point
module crotate(ang, point) {
    translate(point) rotate(ang) translate(-point) children();
}
