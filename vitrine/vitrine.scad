doitem = "";

s2 = 1.5;  // Very round to get nice even sizes

acryl_thick = 3;  // acrylic wall thickness
tape_thick = 0.5;

conn_thick = 3;    // Connector thickness
conn_width = 20;  // Connector width
conn_depth = 23;  // Connector depth

hinge_type = 1;

if (doitem == "corner_outside") { edgeconnector_outside_corner(); }
if (doitem == "corner_inside")  { edgeconnector_inside_corner(); }
if (doitem == "edge_inside")    { edgeconnector_inside(); }
if (doitem == "corner_hinge")   { rotate([180,0,0]) edgeconnector_outside_hinge(); }
if (doitem == "hinge_inside")   { rotate([0,90,0]) hingeconnector_inside(); }
if (doitem == "hinge_outside")  { rotate([180,0,0]) hingeconnector_outside(); }


if (doitem == "") {
    color("#8a5") edgeconnector_outside_hinge();
    color("#58a") edgeconnector_inside();

    color("#8a5") rotate([0,-90,-90]) hingeconnector_outside();
    color("#58a") rotate([0,-90,-90]) hingeconnector_inside();

    *color("#bcd") rotate([0,-90,-90]) translate([-2,-2,0]) cylinder(40, 3, 3, $fn=48);
    *color("#ee5") rotate([0,-90,-90]) translate([-2,-2,0]) {
        cylinder(6, 2.5, 2.5, $fn=48);
        translate([0,0,6]) cylinder(1.8, 5, 5, $fn=48);
    }

    *color("#99a4") acryl_plates();
}

module hingeconnector_outside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick, nub=1, tol=0.1, cp=48)
{
    cof = ct/s2+1+tol;
    xi = cof-0.5-tol;
    xo = xi-ct + (hinge_type==2 ? -1 : hinge_type==3 ? ct+1 : ct);
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
                    [cd,yo+ct], [cd,yo], [xi,yo], [xi,yi],
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
    xi = cof-0.5;
    xo = xi-ct;
    yi = -0.5;
    yo = tt+at-tol;
    ict = ct-1;
    difference() {
        translate([0,0,cof]) rotate([0,0,90]) linear_extrude(height=cw, convexity=5) {
            polygon([
                [xi,yi], [xi, yo], [xi+0.5, yo], [xi+0.5,0], [cd-1,0], [cd-1,yi]
            ]);
        }
        translate([-0.01,cd-1,cw+cof]) rotate([0,90,0]) linear_extrude(height=0.52) polygon([
            [3.4,0.1],[-0.1,-3.4],[-0.1,0.1]
        ]);
    }
    translate([0,0,cof-0.5]) rotate([0,0,90]) linear_extrude(height=0.5, convexity=5) {
        polygon([
            [xi,yi], [xi, yo], [cd-1,yo], [cd-1,yi]
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
    difference() {
        translate([0,0,-tp+cof-ht]) rotate([0,0,90]) linear_extrude(height=ht, convexity=5) {
            yi = 0;
            ym = at;
            yo = ym+ct;
            xi = ct/s2;
            xo = cd;
            polygon([[-yo-tt,0],[-yo-tt,-xo],[1,-xo], [1,2], [-4.5,2]]);
        }
        translate([2.8,-8, -1.6]) rotate([-90,90,0]) difference() {
            cube([8, 8, 10]);
            translate([0,0,-0.01]) cylinder(10.02, 5, 5, $fn=48);
        }
        translate([11,-6.5,-6.5]) rotate([0,90,0]) rotate([0,0,45]) cube([3, 3, 26], true);

        xi = cof-0.5-tol;
        xo = xi-ct + (hinge_type==2 ? -1 : hinge_type==3 ? ct+1 : ct);
        yi = -0.5;
        yo = yi+0.5+tt+at;
        ict = 1.5;
        tpt = hinge_type==1 ? 2 : 5;
        cmid = ((yi-ict)+(yo+ct))/2;

        rotate([-90,0,0]) translate([xo,cmid,cof-tpt-5]) cylinder(5.01, 2.7, 2.7, $fn=48);

    }
    outside_nubs(ct, cw);
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

function swapxy(ar) = [for (i=[len(ar)-1:-1:0]) [-ar[i].y, -ar[i].x]];
function mirxy(ar) = concat(ar, swapxy(ar));

module acryl_plates(aw = 300, ah = 300, at = acryl_thick, tt = tape_thick,
        ct = conn_thick, cw = conn_width, tol=0.1)
{
    cof = ct/s2+1+tol;
    zof = at+tt;
    *translate([-tt,-cof,0]) rotate([0,0,180]) cube([at, ah, aw]);
    *mirror([1,1,0]) rotate([0,0,180]) translate([tt,ct/s2+1+tol,0]) cube([at, ah, aw]);

    translate([cof,cof,-zof]) cube([aw, ah, at]);
    mirror([1,0,-1]) translate([cof,cof,-zof]) cube([aw, ah, at]);
    mirror([0,1,-1]) translate([cof,cof,-zof]) cube([aw, ah, at]);
}

