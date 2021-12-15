// Holes in perfboard
// holesp = 2.54;
holesp = 2.54;
holedia = 1;
boardth = 1.2;
ewid = 10;

numbut = 3;

ledsp = holesp * 4;
ledz = boardth+0.5;

butsp = holesp * 12;

xsof = 0.15;
butdia = holesp * 8;

facetnutthi = 7.5;
facetnutwid = 10;
facetnuthei = 6;
boltrad = 3/2+0.2;

*mirror([0,0,1]) sidefacet();
*whiteside();
*backendfront();
*backendback();
*button();
*rotate([0,-90,0]) cubeedgeblack();

cubeside();
*rotate([90,90,0]) cubeside();
*rotate([-90,0,90]) cubeside();

module cubeside() {
    zof = -2.3;
    xof = xsof*butsp;
    bof = 10;
    
    translate([0,0,zof]) {
        cubeedgewhite(xof, bof, zof);
        cubeedgesblack(xof, bof, zof);
        cubebackedges(xof, bof, zof);

        whiteside(xof, bof, zof);
        sidefacets(zof, bof, zof);

        cubeedgenuts( xof, bof, zof);
        buttonseries(xof, bof, zof);
        color("#beb") translate([0, 0, ledz+1.8]) backendfront();
        color("#8c8") translate([0, 0, ledz-1.8-0.1]) backendback();
    }
}

module buttonseries(xof, bof, zof)
{
    for (x=[0:numbut-1], y=[0:numbut-1]) {
        translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) buttonset();
    }
}

module cubeedgewhite(xof, bof, zof)
{
    color("#eee")
    for (x=[0:numbut-1]) {
        translate([xof+x*butsp,xof,-(zof+xof)]) cubeedge(sd = butsp-xof*2, rd=10+zof+xof);
    }
}

module cubeedgesblack(xof, bof, zof)
{
    // TODO: This needs to be come one thing for all three sides
    color("#333") translate([xof, xof, -(zof+xof)]) cubeedge(sd = (butsp-ewid)/2-xof, thi = 1.0, rd=bof+zof+xof+1);

    color("#333") for (x=[1:numbut-1]) {
        translate([butsp*(x-0.5)+ewid/2, 0, 0]) cubeedgeblack(xof, bof, zof);
    }
}

module cubeedgeblack(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.2)
{
    sd = xof*2-0.2;
    union() {
        // Outside
        translate([0, xof, -(zof+xof)]) cubeedge(sd = butsp-ewid, thi = 1.0, rd=bof+zof+xof+1);
        // Middle
        translate([butsp/2-ewid/2-sd/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0+tol, rd=bof+zof+xof-tol);
        // Inside
        translate([0,xof,-(zof+xof)]) cubeedgeinside(butsp-ewid, bof-2.8, rd=bof+zof+xof-tol);

        // Outer pieces
        translate([butsp/2-ewid/2,0,bof+1]) edgefacet(thi=1);
        translate([butsp/2-ewid/2,-bof-1-zof-1,-zof]) rotate([-90,0,0]) edgefacet(thi=1);

        // Inner pieces
        translate([butsp/2-ewid/2,0,bof-1]) edgefacet(thi=1-tol);
        translate([butsp/2-ewid/2,-bof-1-zof+1+tol,-zof]) rotate([-90,0,0]) edgefacet(thi=1-tol);
    }
}

module cubeedgeinside(sd, ins, rd=10, cp=16)
{
    an = 90/cp;
    rotate([0,90,0]) linear_extrude(height=sd) polygon(concat(
        arc(0, 0, rd, 180, 270, an),
        [[-ins,0],[-ins,-ins],[0,-ins]]
    ));
    /*
    polyhedron(convexity=5,
        points = concat(
            [[0,  0, ins], [0,  -ins, ins], [0,  -ins, 0]],
            xarc(0, 0, 0, rd, 270, 360, an),
            [[sd, 0, ins], [sd, -ins, ins], [sd, -ins, 0]],
            xarc(sd, 0, 0, rd, 270, 360, an),
            []
        ), faces = concat(
            qface(0, ss, ss),
            fqfacei(0, cp+1, ss-1),
            bqfacei(ss, cp+1, ss-1),
            []
    ));
    */
}

module cubeedgenuts(xof, bof, zof)
{
    enof = 1.3+0.6;
    #color("#773") for (x=[1:numbut]) {
        ao = (2*x)*holesp*6;
        translate([ao, -enof, -zof+enof]) rotate([45,0,0])
            translate([0,0,1.2]) cube([5.5,5.5,2.6], true);
        translate([ao, -enof, -zof+enof]) rotate([45,0,0]) {
            translate([0,0,-7]) cylinder(10, 1.5, 1.5, $fn=32);
            translate([0,0,-8]) cylinder(1,2.9,2.9, $fn=32);
        }
    }
}

module cubebackedges(xof, bof, zof)
{
    color("#333") {
        cubebackedge(xof, bof, zof);
        translate([0,-zof, -zof]) mirror([0,1,1]) cubebackedge(xof, bof, zof);

        sd = butsp-ewid;
        translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0, rd=bof+zof+xof+1);
        translate([numbut*butsp-xof, xof, -(zof+xof)]) cubeedge(sd = butsp/2-ewid/2+xof, thi = 1.2, rd=bof+zof+xof-.2);
        translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0, rd=bof+zof+xof-1.2);
    }
}

module cubebackedge(xof, bof, zof, cp=32)
{
    xo = butsp/2; // offset of hole centers
    backwid = butsp-ewid/2;
    endofs = (numbut-0.5)*butsp;
    whiteof = butsp/2-xof;

    an = 90/cp;
    rd = butdia/2;
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps
    for (z=[1,-1.2]) translate([(numbut-0.5)*butsp, 0, bof+z]) linear_extrude(height=1, convexity=4)
        polygon(concat(
            [[ewid/2,xof], [backwid,xof], [backwid,endofs+backwid]],
            [for (x=[numbut-1:-1:0]) each arc( 0, butsp*(x+0.5), rd, (x==numbut-1?45:sta), 180-sta, an)]
        ));

    translate([(numbut-0.5)*butsp, 0, bof-0.2])
        linear_extrude(height=1.2) polygon([
            [whiteof,xof], [backwid,xof], [backwid, endofs+backwid], [whiteof, endofs+whiteof]
        ]);
}

module whiteside(xof=xsof*holesp*12, bof=10, zof=-2.3)
{
    color("#eee") translate([0,0,bof])
    difference() {
        translate([xof,xof,0]) perfboard(numbut, numbut, 1, holesp * 12, holesp * 8, 0.5-xsof, 64);
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([(x)*butsp, (y)*butsp, 0]) cube([facetnutwid,facetnuthei,2.02], true);
        }
    }
}

module sidefacets(xof, bof, zof)
{
    color("#333") for (x=[1:numbut-1], y=[1:numbut-1]) {
        translate([butsp*x,butsp*y,11]) sidefacet();
    }
}

module backendback(sd = numbut*butsp, thi = 3.6)
{
    cwid = butsp-8;
    swid = 20;
    twid = 10;
    bwid = 3;
    difference() {
        union() {
            for (x=[1:numbut-1], y=[1:numbut-1]) {
                translate([x*butsp, y*butsp, 0]) {
                    translate([-cwid/2, -cwid/2, 0]) cube([cwid, cwid, thi]);
                    stubpyra(swid, swid, 11.2, 11.2, 8);
                }
            }
            for (x=[0:numbut-1], y=[0:numbut-1], an=[0:90:270]) {
                translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) rotate([0,0,an]) {
                    translate([2.8, -4, 0]) cube([bwid, 8, thi]);
                    translate([ledsp,  4, 0]) cylinder(3, 1, 1, $fn=4);
                    translate([ledsp, -4, 0]) cylinder(3, 1, 1, $fn=4);
                }
            }
            for (x=[0:numbut-1], y=[0:numbut-1]) {
                translate([(x+0.5)*butsp-6/2, (y+0.5)*butsp-3/2, 0]) cube([6,3,2]);
                translate([(x+0.5)*butsp-3/2+2.0, (y+0.5)*butsp-6/2, 0]) cube([1.0,6,2]);
            }
            for (x=[1:numbut-1], y=[0,numbut]) {
                yo = y*butsp+(cwid/4+1)*(y>0?-1:1);
                translate([x*butsp, yo, thi/2]) cube([cwid,cwid/2-2,thi], true);
            }
            for (x=[0,numbut], y=[1:numbut-1]) {
                xo = x*butsp+(cwid/4+1)*(x>0?-1:1);
                translate([xo, y*butsp, thi/2]) cube([cwid/2-2,cwid,thi], true);
            }
            for (x=[0,numbut], y=[0,numbut]) {
                xo = x*butsp+(cwid/4+1)*(x>0?-1:1);
                yo = y*butsp+(cwid/4+1)*(y>0?-1:1);
                translate([xo, yo, thi/2]) cube([cwid/2-2,cwid/2-2,thi], true);
            }
        }
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([x*butsp, y*butsp, -1]) stubpyra(swid, swid, twid, twid, 11.3-facetnutthi);
            translate([x*butsp, y*butsp, 11.3-facetnutthi-1.01]) cylinder(2.02, boltrad, boltrad, $fn=32);
            translate([x*butsp, y*butsp, 11.2-facetnutthi+4.6/2]) cube([facetnutwid, facetnuthei, 4.6], true);
        }
        for (x=[0:numbut-1], y=[0:numbut-1], an=[0:90:270]) {
            xo = (x+0.5)*butsp + cos(an)*ledsp;
            yo = (y+0.5)*butsp + sin(an)*ledsp;
            translate([xo, yo, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        }
        hl = 2*bwid+6;
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) {
                translate([-3.5,-3.5,1.4]) cube([7,7,thi-1.4+0.01]);
                *for (x=[-1,1], y=[-1,1]) {
                    translate([x*3.15-0.351, y*2.0-1.5, 1.2]) cube([0.702,3.0,0.601]);
                }
                if (0) {
                translate([-hl/2,  3.9, 0.5]) rotate([0,90,0]) cylinder(hl, 0.49, 0.49, $fn=6);
                translate([-hl/2, -3.9, 0.5]) rotate([0,90,0]) cylinder(hl, 0.49, 0.49, $fn=6);
                translate([-hl/2,    0, 0.5]) rotate([0,90,0]) cylinder(hl, 0.49, 0.49, $fn=6);

                translate([ 3.9, -hl/2, 1.5]) rotate([-90,0,0]) cylinder(hl, 0.49, 0.49, $fn=6);
                translate([-3.9, -hl/2, 1.5]) rotate([-90,0,0]) cylinder(hl, 0.49, 0.49, $fn=6);
                translate([   1, -hl/2, 1.5]) rotate([-90,0,0]) cylinder(hl, 0.49, 0.49, $fn=6);
                } else {

                for (x=[0,1], y=[0,1]) {
                    mirror([x,0,0]) mirror([0,y,0])
                    translate([(bwid+2.8), 3.9, -0.001])
                        linear_extrude(height=1.001) polygon([
                        [0,-0.3], [3.76,-0.3], [3.16,0.3], [0,0.3]
                        ]);
                }

                for (x=[-1:1]) {
                    translate([0, x*3.9, 0.6]) cube([hl, 0.6, 0.801], true);
                }

                for (x=[0,1], y=[0,1]) {
                    mirror([x,0,0]) mirror([0,y,0])
                    translate([3.9, (bwid+2.8), 1.2])
                        linear_extrude(height=2.401) polygon([
                        [-0.3,0], [-0.3,3.76], [0.3,3.16], [0.3,0]
                        ]);
                }

                for (x=[-3.9,1,3.9]) {
                    translate([ x, 0, 1.6]) cube([0.6, hl, 0.801], true);
                }
                }
            }
        }
    }
    // Sacrificial layer
    for (x=[1:numbut-1], y=[1:numbut-1]) {
        #translate([x*butsp, y*butsp, 11.3-facetnutthi-1+0.1]) cube([6,6,0.2], true);
    }
}

module backendfront(sd = numbut*butsp, thi = 1.4, gap=6.4)
{
    difference() {
        union() {
            cube([sd, sd, thi]);
            for (x=[0:numbut-1], y=[0:numbut-1]) {
                translate([(x+0.5)*butsp, (y+0.5)*butsp, thi]) stubpyra(14,14,7,7,5.6-thi);

                if (thi < 1.4) for (an=[0:90:270]) {
                    xo = (x+0.5)*butsp + cos(an)*ledsp;
                    yo = (y+0.5)*butsp + sin(an)*ledsp;
                    translate([xo, yo, thi]) stubpyra(10,10,6,6,gap-5.1-thi);
                }
            }
            for (x=[1:numbut-1], y=[1:numbut-1]) {
                translate([x*butsp, y*butsp, thi]) stubpyra(20,20,12,12,gap-thi);
            }
            /*
            for (x=[1,numbut-1]) {
                translate([x*butsp,              5, thi]) stubpyra(20,10,12,6,7.7-thi);
                translate([x*butsp, numbut*butsp-5, thi]) stubpyra(20,10,12,6,7.7-thi);
            }
            for (y=[1,numbut-1]) {
                translate([             5, y*butsp, thi]) stubpyra(10,20,6,12,7.7-thi);
                translate([numbut*butsp-5, y*butsp, thi]) stubpyra(10,20,6,12,7.7-thi);
            }
            translate([             5,              5, thi]) stubpyra(10,10,6,6,7.7-thi);
            translate([numbut*butsp-5,              5, thi]) stubpyra(10,10,6,6,7.7-thi);
            translate([             5, numbut*butsp-5, thi]) stubpyra(10,10,6,6,7.7-thi);
            translate([numbut*butsp-5, numbut*butsp-5, thi]) stubpyra(10,10,6,6,7.7-thi);
            */
        }
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, -ledz-(8-gap)]) buttonholes();
        }
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([(x)*butsp, (y)*butsp, -0.01]) stubpyra(18,18,10,10,gap+0.0-thi+0.01);
            translate([(x)*butsp, (y)*butsp, gap+1-thi]) cube([facetnutwid,facetnuthei+0.2,2.02], true);
        }
    }
}

module stubpyra(x1=14, y1=14, x2=7, y2=7, z=4.2)
{
    polyhedron(convexity = 3,
        points = [
            [-x1/2,-y1/2,0], [-x1/2, y1/2,0], [ x1/2, y1/2,0], [ x1/2,-y1/2,0],
            [-x2/2,-y2/2,z], [-x2/2, y2/2,z], [ x2/2, y2/2,z], [ x2/2,-y2/2,z],
        ],
        faces = concat(
            [tface(0,4)],
            qface(0,4,4),
            [bface(4,4)]
        )
    );
}

module buttonholes(thi=6.4, tol=0.2, cut=0.01)
{
    translate([0, 0, ledz+thi/2]) cube([7+tol,7+tol,thi], true);
    translate([0, 0, ledz+thi+1]) cube([5+tol,5+tol,2+cut], true);
    translate([0, 0, ledz+thi+0.1-cut]) cube([7+tol,5+tol,0.2+cut], true);

    /*
    translate([-ledsp, 0, ledz]) wsled(tol=tol, cut=cut);
    translate([ ledsp, 0, ledz]) wsled(tol=tol, cut=cut);
    translate([0, -ledsp, ledz]) wsled(tol=tol, cut=cut);
    translate([0,  ledsp, ledz]) wsled(tol=tol, cut=cut);
    */
    for (an=[0:90:270]) rotate([0,0,an]) {
        translate([-ledsp, 0, ledz+2.5]) cube([5, 5, 2], true);
        translate([-ledsp, 0, ledz+2.09]) cube([5, 9, 1.01], true);
        translate([-ledsp, 1.5, ledz+2.09]) cube([9, 2, 1.01], true);
        translate([-ledsp,-1.5, ledz+2.09]) cube([9, 2, 1.01], true);
    }
}

module cubeedge(sd = holesp * 48, thi = 1, rd=10, cp=16)
{
    an = 90/cp;
    ss = 2*(cp+1);
    polyhedron(convexity=5,
        points = concat(
            xarc(0, 0, 0,  rd,     360, 270, -an),
            xarc(0, 0, 0,  rd+thi, 270, 360,  an),
            xarc(sd, 0, 0, rd,     360, 270, -an),
            xarc(sd, 0, 0, rd+thi, 270, 360,  an),
            []
        ), faces = concat(
            qface(0, ss, ss),
            fqfacei(0, cp+1, ss-1),
            bqfacei(ss, cp+1, ss-1),
            []
        ));
}

module edgefacet(sd = holesp * 48, thi=1, rd=butdia/2, cp=32, xof=xsof*holesp*12)
{
    an = 90/cp;
    xo = butsp/2; // offset of hole centers
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps
    ss = (cnf+1)*2+2;

    // TODO: Magic numbers!
    polyhedron(convexity=5,
        points = concat(
            [[ xo-ewid/2, xof, thi]],
            zarc( xo,  xo, thi, rd, 180+sta, 270-sta, an),
            zarc(-xo,  xo, thi, rd,  90+sta, 180-sta, an),
            [[-xo+ewid/2, xof, thi]],
            [[ xo-ewid/2, xof,   0]],
            zarc( xo,  xo,   0, rd, 180+sta, 270-sta, an),
            zarc(-xo,  xo,   0, rd,  90+sta, 180-sta, an),
            [[-xo+ewid/2, xof,   0]],
            []
        ),
        faces = concat(
            [tface( 0, ss)],
            qface( 0, ss, ss),
            [bface(ss, ss)],
            []
        ));
}

module sidefacet(sd = holesp * 48, thi=1, rd=butdia/2, cp=32)
{
    an = 90/cp;
    xo = butsp/2; // offset of hole centers
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps
    ss = (cnf+1)*4;

    ngap = 0.9;
    difference() {
        union() {
            polyhedron(convexity=5,
                points = concat(
                    zarc(-xo, -xo, thi, rd,   0+sta,  90-sta, an),
                    zarc( xo, -xo, thi, rd, 270+sta, 360-sta, an),
                    zarc( xo,  xo, thi, rd, 180+sta, 270-sta, an),
                    zarc(-xo,  xo, thi, rd,  90+sta, 180-sta, an),
                    zarc(-xo, -xo,   0, rd,   0+sta,  90-sta, an),
                    zarc( xo, -xo,   0, rd, 270+sta, 360-sta, an),
                    zarc( xo,  xo,   0, rd, 180+sta, 270-sta, an),
                    zarc(-xo,  xo,   0, rd,  90+sta, 180-sta, an),
                    []
                ),
                faces = concat(
                    [tface( 0, ss)],
                    qface( 0, ss, ss),
                    [bface(ss, ss)],
                    []
                ));
            translate([0,0,-(facetnutthi-ngap)/2]) cube([facetnutwid-0.2,facetnuthei-0.2,facetnutthi-ngap], true);
        }
        translate([0,0,-7.51]) cylinder(7.41, boltrad, boltrad, $fn=32);
        translate([0,0,-3.9]) cube([5.5, facetnuthei+0.01, 2.6], true);
    }
    // sacrificial layer
    #translate([0,0,-4-1.2-0.1]) cube([4, 4, 0.2], true);
}

module buttonset()
{
    color("#eee") translate([0,0,ledz+9.101]) button();

    color("#acf") translate([0, 0, ledz]) switch();
    color("#767") translate([-ledsp, 0, ledz]) wsled();
    color("#767") translate([ ledsp, 0, ledz]) wsled();
    color("#767") translate([0, -ledsp, ledz]) wsled();
    color("#767") translate([0,  ledsp, ledz]) wsled();
}

module button(ptol1=0.4, ptol2=0.0, show=false)
{
    // cylinder(5, butdia/2-0.5, butdia/2-0.5, $fn=160);
    cp = 60;
    an = 360/cp;
    lh = 0.5;
    hi = 6.5;
    lc = hi/lh;
    
    hc = 4.6;
    htol = ptol2;
    xtol = ptol1;
    hw1 = 2.2+htol;
    hw2 = 1.6+htol+xtol;
    hh1 = 3.2+htol;
    hh2 = 2.6+htol+xtol;
    union() {
        translate([0,0,5-hi]) polyhedron(convexity=5,
            points = concat(
                dome(0, 0, 2, hi-2.5, butdia/2 - 0.4 -3.8, 3, an, lc, 1, -1),
                circle(0, 0, 0, butdia/2 - 0.4-0.8, an),
                circle(0, 0, 0, butdia/2 - 0.4, an),
                dome(0, 0, 2, hi-1.5, butdia/2 - 0.4 -3, 3, an, lc, 1),
                []),
            faces = concat(
                [tface(0, cp)],
                [bface(cp*(lc*2+1), cp)],
                [for (l=[0:lc*2+1]) each qface(l*cp, cp, cp)],
                []
            ));
        difference() {
            translate([-hc/2,-hc/2,0]) cube([hc,hc,5.1]);
            translate([-hw2/2,-hh2/2,-0.01]) cube([hw2,hh2,3.01]);
            translate([-hw1/2,-hh1/2,-0.01]) cube([hw1,hh1,1.01]);
            translate([0,0,0.999]) stubpyra(hw1,hh1,hw2,hh2,0.3);
            translate([0,0,2.001]) stubpyra(hw2,hh2,hw1,hh1,0.3);
            translate([-hw1/2,-hh1/2,2]) cube([hw1,hh1,1]);
        }
        if (show) {
            translate([-5,-2.5,5.1]) linear_extrude(height=0.2)
                text(str(ptol1*10,"|",(ptol2*10)), 5);
        }
    }
    // Supports
    for (x=[0,1]) mirror([x,0,0]) {
        for (y=[0,1]) mirror([0,y,0]) {
            #translate([-hc/2, -hc/2, 5-hi]) cube([1.2,0.7,hi-5]);
        }
        #translate([-hc/2, -hc/2, 5-hi]) cube([1.2,hc,hi-5.4]);
    }
}

module switch()
{
    swi = [7,7,6.6];

    nub = [0.4,2,0.4];
    stem = [4,4,2.5];
    mid = [1.5,2.5,2.5];
    ped1 = [2,3,0.7];
    ped2 = [2,3,0.7];

    pin = [0.6,0.3,3.6];

    translate([0,0,swi[2]/2])   cube(swi, true);
    translate([0,0,swi[2]+stem[2]/2]) cube(stem, true);
    for (x=[-1,1], y=[-1,1]) {
        translate([x*(swi[0]-nub[0])/2, y*(swi[1]-nub[1])/2, -nub[2]/2]) cube(nub,true);
    }
    translate([0,0,swi[2]+stem[2]+mid[2]/2]) cube(mid, true);
    translate([0,0,swi[2]+stem[2]+ped1[2]/2]) cube(ped1, true);
    translate([0,0,swi[2]+stem[2]+mid[2]-ped2[2]/2]) cube(ped2, true);

    for (x=[-1,0,1], y=[-1,1]) {
        translate([x*2, y*2.5, -pin[2]/2]) cube(pin, true);
    }
}

module wsled(tol=0, cut=0)
{
    wsdia = 9/2;
    wssz = 4.9;
    wsbt = 1.3;
    wsthi = 2.9;
    translate([0,0,wsthi/2+0.35]) cube([wssz+tol, wssz+tol, wsthi+cut], true);
    translate([0,0,-cut/2+0.35]) cylinder(wsbt+cut, wsdia+tol, wsdia+tol, $fn=64);
}


module perfboard(w,h, thi=boardth, hsp = holesp, hdi = holedia, eof=1, cp=16)
{
    wid = hsp * (w-1+eof*2);
    hei = hsp * (h-1+eof*2);
    hr = hdi/2;

    an = 360/cp;
    lo = 2*(w+h+2);
    l2 = lo + cp*w*h;
    lo2 = l2+lo;
    points = concat(
        ssquare(wid,hei,w+1,h+1,0),
        [for (x=[0:w-1], y=[0:h-1]) each circle((x+eof)*hsp, (y+eof)*hsp, 0, hr, an)],
        ssquare(wid,hei,w+1,h+1,thi),
        [for (x=[0:w-1], y=[0:h-1]) each circle((x+eof)*hsp, (y+eof)*hsp, thi, hr, an)]
    );
    polyhedron(convexity = 5, points = points, faces = concat(
        // [[0,1,2,3],[l2+3,l2+2,l2+1,l2+0]],
        nquads(0, lo, l2), // Outside
        [for (p=[lo:cp:l2-1]) each nquads(p, cp, l2)], // Hole insides

        // Front face between holes
        [for (x=[0:w-2], y=[0:h-1]) each 
            fquads(cp, lo+cp*(y+h*x), lo+cp*(y+h*(x+1)), 0, 0, cp*0.5)],
        // Back face between holes
        [for (x=[0:w-2], y=[0:h-1]) each 
            bquads(cp, lo2+cp*(y+h*x), lo2+cp*(y+h*(x+1)), 0, 0, cp*0.5)],

        // Front face between hole sides
        fhquads(lo,  cp, w, h),
        bhquads(lo2, cp, w, h),

        // Front face between holes, vertical
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*0), lo+cp*(y+1+h*0), cp*0.75, cp*0.75, cp*0.25)],
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*(w-1)), lo+cp*(y+1+h*(w-1)), 0, cp*0.5, cp*0.25)],

        // Back face between holes, vertical
        [for (y=[0:h-2]) each
            bquads(cp, lo2+cp*(y+h*0), lo2+cp*(y+1+h*0), cp*0.75, cp*0.75, cp*0.25)],
        [for (y=[0:h-2]) each
            bquads(cp, lo2+cp*(y+h*(w-1)), lo2+cp*(y+1+h*(w-1)), 0, cp*0.5, cp*0.25)],

        fsquads(0 , cp, w, h),
        bsquads(l2, cp, w, h),

        fcornerdart(0,  cp, w, h),
        bcornerdart(l2, cp, w, h),
        []
    ));
}

// Square with multiple points on sides
// width, height, side steps, z coord
function ssquare(w,h,ws,hs,z) = concat(
    [for (i=[0:ws-1])  [i*(w/ws),0,z]],
    [for (i=[0:hs-1])  [w,i*(h/hs),z]],
    [for (i=[ws:-1:1]) [i*(w/ws),h,z]],
    [for (i=[hs:-1:1]) [0,i*(h/hs),z]]
);

function circle(x,y,z,d,an) = [
    for (a = [0:an:360-an]) [x+d*sin(a),y+d*cos(a),z]
];

// Faces of side of layers
// start offset, number, layer offset
function nquads(s, n, o) = [for (i=[0:n-1]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

// Faces, between holes (sets)
// set size, set 1 offset, set 2 offset, start 1, start 2, size, direction
function fquads(ss, o1, o2, s1, s2, sz, di=0) = [for (i=[0:sz-1]) each [
    [o1+(s1+i+di)%ss, o1+(s1+i+1-di)%ss, o2+(s2+ss-i-1+di)%ss],
    [o1+(s1+i+di)%ss, o2+(s2+ss-i-1+di)%ss, o2+(s2+ss-i-di)%ss]
]];
function bquads(ss, o1, o2, s1, s2, sz, di=1) = fquads(ss, o1, o2, s1, s2, sz, di);

// Square set faces
// base offset, set size, wid, hei, offset left, offset right, direction
function fhquads(lo, ss, w, h, o1 = 0, o2 = 0.5, di=0) = [for (x=[0:w-2], y=[0:h-2]) each [
    [lo + ss*(y+h*(x+1-di)+o1), lo + ss*(y+1+h*(x+1-di)+o2), lo + ss*(y+1+h*(x+di)+o2)],
    [lo + ss*(y+h*(x+1-di)+o1), lo + ss*(y+1+h*(x+  di)+o2), lo + ss*(y+  h*(x+di)+o1)]
]];
function bhquads(lo, ss, w, h, o1 = 0, o2 = 0.5, di=1) = fhquads(lo, ss, w, h, o1, o2, di);

// Square set, one side
// base offset, set size, side size, side offset, edge offset, side jump, direction
function fvquads(lo, ss, sd, so, eo, sj=1, di=0) = [for (i=[0:sd-2]) each [
    [lo + ss*(so + (i+di)*sj), i+eo + di  , i+eo + 1-di],
    [lo + ss*(so + (i+di)*sj), i+eo + 1-di, lo + ss*(so + (i+1-di)*sj)]
]];

// Corner triangle
// base offset, set size, set offset, edge offset, edge set size, set offset, inside set offset, direction
function fvcorner(lo, ss, eo, es, so, io, di=0) = [
    [lo+es + ss*so+(ss*(io+0.25))%ss, lo+(eo+es+di-1)%es, lo+(eo+es-di)%es],
    [lo+es + ss*so+(ss*(io     ))%ss, lo+eo+di, lo+eo+1-di]
];

// Square set, sides 
// base offset, set size, wid, hei, direction
function fsquads(lo, ss, w, h, di=0) = concat(
    // Side faces
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=w, so=0.5,          eo=lo+1,       sj= h, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=w, so=h*w-1,        eo=lo+w+h+3,   sj=-h, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=h, so=(w-1)*h+0.25, eo=lo+w+2,     sj= 1, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=h, so=h-1+0.75,     eo=lo+w+h+w+4, sj=-1, di=di),
    // Corner triangles
    fvcorner(lo=lo, ss=ss, eo=0,       es=2*(w+h+2), so=0,       io=0.5,  di=di),
    fvcorner(lo=lo, ss=ss, eo=w+1,     es=2*(w+h+2), so=h*(w-1), io=0.25, di=di),
    fvcorner(lo=lo, ss=ss, eo=h+w+2,   es=2*(w+h+2), so=h*w-1,   io=0,    di=di),
    fvcorner(lo=lo, ss=ss, eo=w+h+w+3, es=2*(w+h+2), so=h-1,     io=0.75, di=di)
);
function bsquads(lo, ss, w, h, di=1) = fsquads(lo, ss, w, h, di);

// Corner dart triangle
// base offset, set offset, steps, edge offset, direction
function fcornertri(lo, so, ss, eo, di=0) = [for (a=[0:ss*0.25-1]) each [
    [eo, lo+(so*ss+a+di)%ss, lo+(so*ss+a+1-di)%ss]
]];

// Corner dart triangle set
// base offset, set size, wid, hei, direction
function fcornerdart(lo, ss, w, h, di=0) = concat(
    fcornertri(lo=lo+2*(w+h+2),              so=0.5,  ss=ss, eo=lo + 0,       di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h*(w-1)), so=0.25, ss=ss, eo=lo + w+1,     di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h*w-1),   so=0,    ss=ss, eo=lo + h+w+2,   di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h-1),     so=0.75, ss=ss, eo=lo + w+h+w+3, di=di)
);
function bcornerdart(lo, ss, w, h, di=1) = fcornerdart(lo, ss, w, h, di);


// dome
// x, y, height, diameter, circle steps, layer count, direction
// (z/h)^2 + (D/d)^2 = 1
// (D/d)^2 = 1 - (z/h)^2
// D/d = sqrt(1 - (z/h)^2)
// D = d * sqrt(1 - (z/h)^2)
function dome(x, y, z, h, d, d2, an, lc, fac=1, dr=1) = [for (i=[(dr>0?0:lc-1):dr:(dr<0?0:lc-1)]) each
    circle(x, y, z+(i*h/lc), d2 + d * sqrt(1 - (i*fac/lc)*(i*fac/lc)), an)
];

// faces
// start offset, number of sides, offset of next
function qface(s, n, o) = [for (i=[0:n-1]) each [
    [s+(i+1)%n,s+(i+1)%n+o,s+i],
    [s+(i+1)%n+o,s+i+o,s+i]
]];

// faces, second layer ordering inverted
function bqfacei(s, n, o, di=0) = [for (i=[0:n-2]) each [
    [s+(i+1-di),s+o-(i+1-di),s+i+di],
    [s+o-(i+1-di),s+o-i-di,s+i+di]
]];
function fqfacei(s, n, o, di=1) = bqfacei(s, n, o, di);

// top/bottom face
function bface(o, n) = [for (p=[0:n-1]) p+o];
function tface(o, n) = [for (p=[n-1:-1:0]) p+o];

// Part of a circle
// x, y, z, radius, start, end, an
function xarc(x, y, z, rd, st, ed, an) = [for (a=[st:an:ed]) [ x, y+rd*sin(a), z+rd*cos(a) ]];

// Part of a circle
// x, y, z, radius, start, end, an
function zarc(x, y, z, rd, st, ed, an) = [for (a=[st:an:ed]) [ x+rd*sin(a), y+rd*cos(a), z ]];

// Part of a 2d circle
// x, y, radius, start, end, an
function arc(x, y, rd, st, ed, an) = [for (a=[st:an:ed]) [ x+rd*sin(a), y+rd*cos(a) ]];
