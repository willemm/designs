// Holes in perfboard
// holesp = 2.54;
holesp = 2.54;
holedia = 1;
boardth = 1.2;
ewid = 10;

numbut = 5;

ledsp = holesp * 4;
ledz = boardth+0.5;

butsp = holesp * 12;

xsof = 0.15;
butdia = holesp * 8;

facetnutthi = 7.5;
facetnutwid = 10;
facetnuthei = 6;
boltrad = 3/2+0.2;

backboltoff = 6.5;

*mirror([0,0,1]) sidefacet();
*whiteside();
*backendfront();
*backendback();
*button();
*rotate([0,90,0]) cubeedgeblack();
*rotate([0,-90,0]) cubeedgewhite();

*rotate([0,90,0]) cubebackedges();
*bottomsidepart();

*color("#eee") translate([0,0,ledz+1.8]) backendfront();
*color("#444") cubebackedges();

/*
intersection() {
    rotate([0,atan(sqrt(2)),0]) rotate([0,0,-45]) {
        minkowski() {
            cube(20, true);
            sphere(1, $fn=60);
        }
    }
    cylinder(20, 10, 10, $fn=120);
}
*/

rotate([0,atan(sqrt(2)),0]) rotate([0,0,-45]) {
    color("#333") cubecorner();
    *cubecornernut();

    cubeside();
    rotate([90,90,0]) cubeside();
    rotate([-90,0,90]) cubeside();
}

*render() translate([0,0,-0.1]) for (an=[0:120:240]) rotate([0,0,an])
    bottomsidepart();

color("#333") translate([0,0,-1]) bottomside();
*psu();

module cubeside() {
    zof = -2.3;
    xof = xsof*butsp;
    bof = 10;
    
    translate([0,0,zof]) {
        cubeedgeswhite(xof, bof, zof);
        cubeedgesblack(xof, bof, zof);
        color("#333") cubebackedges(xof, bof, zof);

        whiteside(xof, bof, zof);
        sidefacets(zof, bof, zof);

        *cubebacknuts(xof, bof, zof);
        *cubeedgenuts(xof, bof, zof);
        buttonseries(xof, bof, zof);
        *partseries(xof, bof, zof);
        *color("#beb") render(convexity=5) translate([0, 0, ledz+1.8]) backendfront();
        *color("#beb") translate([0, 0, ledz+1.8]) backendfront();
        *color("#8c8") translate([0, 0, ledz-1.8-0.1]) backendback();
    }
}

module psu(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    echo("RCX = ", rcx);
    rcz = (cz-2*cxy)/sqrt(3);
    color("#543") translate([0,0,rcz+43/2-19]) cube([158, 98, 43], true);
}

/* 
 Cube is rotated so diagonal is towards Z axis
 Position of cube corner before rotation:

*/
module bottomside(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.2)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    /*
    // Position of cube corners before rotation (backedge far corner)
    cc = [cxy, cxy, cz];

    // Check position
    *#rotate([0,atan(sqrt(2)),0]) rotate([0,0,-45]) translate(cc) sphere(0.001,$fn=10);

    // cc1 = [(cc[0]+cc[1])/sqrt(2), (cc[0]-cc[1])/sqrt(2), cc[2]];
    cc1 = [cxy*sqrt(2), 0, cz];

    // Check position
    *#rotate([0,atan(sqrt(2)),0]) translate(cc1) sphere(0.01,$fn=10);

    san = sqrt(2/3);
    can = sqrt(1/3);
    // cc2 = [cc1[0]*can+cc1[2]*san, cc1[1], -cc1[0]*san+cc1[2]*can];
    cc2 = [cxy*sqrt(2)*sqrt(1/3) + cz*sqrt(2/3), 0, cz*sqrt(1/3) - cxy*sqrt(4/3)];

    // #translate(cc2) sphere(0.01,$fn=10);
    */

    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    // #translate([rcx, 0, rcz]) sphere(1,$fn=10); // THis hits the corner
    // translate([0,0,rcz-10]) cylinder(10, rcx, rcx, $fn=192);

    cbof = bof+zof+2;
    //color("#333")
    cw = cxy+cbof+tol;
    ct = bof+2+tol;
    bothi = 22;
    render(convexity=4)
    difference() {
        union() {
            difference() {
                intersection() {
                    translate([0,0,rcz-bothi]) cylinder((-rcz)/2+bothi+bof, rcx+1.3, rcx+1.3, $fn=240);
                    rotate([0,180+atan(sqrt(2)),0]) rotate([0,0,135]) {
                        translate([-zof+2.3, -zof+2.3, -zof+2.3]) minkowski() {
                            cube(cxy+cxy/2);
                            sphere(bof+4.3, $fn=120);
                        }
                    }
                }
                translate([0,0,rcz-bothi-0.1]) cylinder((-rcz)/2+bothi-1.9, rcx-5, rcx-5, $fn=6);
            }
            for (an=[0:120:240]) rotate([0,0,an])
            rotate([0,180+atan(sqrt(2)),0]) rotate([0,0,135]) {
                translate([-cbof-0.1,-cbof-0.1,-cbof-0.1]) {
                    bottomsupport(cw, ct);
                }
            }
            // For connecting bottom in 3 parts
            for (an=[0:120:240]) rotate([0,0,an]) {
                translate([rcx-7, 0, rcz-bothi+7.3]) cube([10,35,14.6], true);
            }
        }
        connh = 10;
        for (an=[0:120:240]) rotate([0,0,an]) {
            translate([rcx-5, 0, rcz-bothi+connh/2-0.1]) {
                cube([2,10,connh+0.1], true);
                translate([0, 5,0]) cube([6,2,connh+0.1], true);
                translate([0,-5,0]) cube([6,2,connh+0.1], true);
            }
        }
        rotate([0,180+atan(sqrt(2)),0]) rotate([0,0,135]) {
            // translate([-cbof-0.1,-cbof-0.1,-cbof-0.1]) cube(cxy+cbof+0.2);
            translate([-cbof-0.1,-cbof-0.1,-cbof-0.1]) {
                cube([cw, cw, ct]);
                cube([cw, ct, cw]);
                cube([ct, cw, cw]);
                cube(cw-10);
            }
        }
        botboltoff = (numbut+0.5)*butsp-ewid/2-3;
        for (an=[0:120:240]) rotate([0,0,an])
        rotate([0,180+atan(sqrt(2)),0]) rotate([0,0,135]) {
            for (y=[1:2:numbut-1]) {
                translate([botboltoff, (y+0.5)*butsp, 2.3]) cylinder(2.2, boltrad, boltrad, $fn=32);
                translate([(y+0.5)*butsp, botboltoff, 2.3]) cylinder(2.2, boltrad, boltrad, $fn=32);
            }
        }
    }
}

module bottomsidepart(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.2)
{
    bothi = 22;
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);

    holeof = rcx/sqrt(3);

    render(convexity=4)
    difference() {
        intersection() {
            bottomside(xof,bof,zof,tol);
            translate([-(rcx+2),0,rcz-bothi-0.1]) cylinder(-rcz, rcx+2, rcx+2, $fn=6);
        }
        for (m=[0,1], z=[[2.5,2],[2.5,17.5],[10,12]]) mirror([0,m,0]) {
            rotate([0,0,60]) translate([-rcx-1.3 + z[0], 0, rcz-bothi + z[1]])
                rotate([-90,0,0]) translate([0,0,-0.1]) cylinder(10.1, 0.5, 0.5, $fn=8);
        }
    }
}

module bottomsupport(cw, ct)
{
    tt = ct+2;
    yw = 14;
    for (m=[0,1]) mirror([-m,m,0])
        translate([cw,cw,0]) rotate([90,0,0])
            linear_extrude(height=cw-12) polygon([
                [0.4,0.4],[yw,tt],[-12,tt],[-12,10]
            ]);
    cut=9.8;
    polyhedron(
        points=[[cw,cw,tt],[cw+yw,cw,tt],
            [cw+yw,cw+cut,tt],[cw+cut,cw+yw,tt],
            [cw,cw+yw,ct+2],[cw,cw,2]],
        faces=[[1,0,2],[2,0,3],[3,0,4],
            [0,1,5],[1,2,5],[2,3,5],[3,4,5],[4,0,5]]);
    polyhedron(
        points=[[0.4,cw-0.1,ct-0.2],[ct,cw-0.1,ct],[ct-0.2,cw,0.4],[5,cw+6,5],[ct,cw+yw-1,ct]],
        faces=[[0,1,2],[0,2,3],[1,0,4],[2,1,4],[3,2,4],[0,3,4]]);
}

module buttonseries(xof, bof, zof)
{
    color("#eee") {
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, ledz+9.101]) button();
        }
    }
}

module partseries(xof, bof, zof)
{
    for (x=[0:numbut-1], y=[0:numbut-1]) {
        translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) buttonset();
    }
}

module cubeedgeswhite(xof, bof, zof)
{
    color("#eee")
    for (x=[0:numbut-1]) {
        translate([xof+x*butsp,xof,-(zof+xof)]) cubeedgewhite(xof, bof, zof);
    }
}

module cubeedgewhite(xof=xsof*butsp, bof=10, zof=-2.3, thi=1, cp=16)
{
    sd = butsp-xof*2;
    rd = bof+zof+xof;
    an = 90/cp;
    an2 = 45/cp;
    ss = 2*(cp+1);
    ss2 = 2*(cp)+1;
    ins1 = 2*ss;
    ins2 = 2*ss+2*ss2;
    ic1 = [0, ss-1, ss, 2*ss-1];
    ic2 = [ss+ss/2-1, ss+ss/2, ss/2-1, ss/2];
    polyhedron(convexity=5,
        points = concat(
            xarc(0, 0, 0,  rd,     360, 270, -an),
            xarc(0, 0, 0,  rd+thi, 270, 360,  an),
            xarc(sd, 0, 0, rd,     360, 270, -an),
            xarc(sd, 0, 0, rd+thi, 270, 360,  an),
            zarc(sd/2, sd/2, rd, butdia/2, 225, 135, -an2),
            zarc(sd/2, sd/2, rd+thi, butdia/2, 225, 135, -an2),
            yarc(sd/2, -rd, -sd/2, butdia/2, 405, 315, -an2),
            yarc(sd/2, -(rd+thi), -sd/2, butdia/2, 405, 315, -an2),
            []
        ), faces = concat(
            qface(0, ss, ss, 0, ss/2-2),
            qface(0, ss, ss, ss/2, ss-2),
            fqfacei(0, cp+1, ss-1),
            bqfacei(ss, cp+1, ss-1),

            qface(ins1, ss2, ss2, 0, ss2-2),
            [[ins1, ins1+ss2, ic1[1]], [ins1, ic1[1], ic1[0]]],
            [[ins1+ss2*2-1, ins1+ss2-1, ic1[3]], [ins1+ss2-1, ic1[2], ic1[3]]],
            [[ic1[0], ic1[2], ins1+ss2/2]],
            fanface(ic1[0], ins1, ins1+ss2/2-1),
            fanface(ic1[2], ins1+ss2/2, ins1+ss2-1),
            [[ic1[3], ic1[1], ins1+ss2/2+ss2]],
            fanface(ic1[1], ins1+ss2, ins1+ss2+ss2/2-1, 0),
            fanface(ic1[3], ins1+ss2+ss2/2, ins1+ss2+ss2-1, 0),

            qface(ins2, ss2, ss2, 0, ss2-2),
            [[ins2, ins2+ss2, ic2[1]], [ins2, ic2[1], ic2[0]]],
            [[ins2+ss2*2-1, ins2+ss2-1, ic2[3]], [ins2+ss2-1, ic2[2], ic2[3]]],
            [[ic2[0], ic2[2], ins2+ss2/2]],
            fanface(ic2[0], ins2, ins2+ss2/2-1),
            fanface(ic2[2], ins2+ss2/2, ins2+ss2-1),
            [[ic2[3], ic2[1], ins2+ss2/2+ss2]],
            fanface(ic2[1], ins2+ss2, ins2+ss2+ss2/2-1, 0),
            fanface(ic2[3], ins2+ss2+ss2/2, ins2+ss2+ss2-1, 0),

            []
        ));
}

module cubeedgesblack(xof, bof, zof)
{
    color("#333") for (x=[1:numbut-1]) {
        translate([butsp*(x-0.5)+ewid/2, xof, -(zof+xof)]) cubeedgeblack(xof, bof, zof);
    }
}

module cubeedgeblack(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.2)
{
    sd = xof*2-0.2;
    difference() {
        union() {
            // Outside
            cubeedge(sd = butsp-ewid, thi = 1.0, rd=bof+zof+xof+1);
            // Middle
            translate([butsp/2-ewid/2-sd/2, 0, 0]) cubeedge(sd = sd, thi = 1.0+tol, rd=bof+zof+xof-tol);
            // Inside
            cubeedgeinside(butsp-ewid, bof-2.8, rd=bof+zof+xof-tol);

            // Outer pieces
            for (m=[0,1]) mirror([0,m,m]) {
                translate([butsp/2-ewid/2,-xof,bof+zof+xof+1])
                    edgefacet(thi=1,xof=xsof*holesp*12-0.0101);
                translate([butsp/2-ewid/2,-xof,bof+zof-0.5])
                    edgefacet(thi=xof+0.5-tol,xof=xsof*holesp*12-0.0101);
            }
        }
        nhsz = (6/2)+(butsp-ewid)/2;
        rotate([45,0,0]) {
            translate([nhsz/2-0.01, 0, 10.8]) cube([nhsz+0.02, 5.5, 2.6], true);
            translate([(butsp-ewid)/2, 0, 6.5]) cylinder(6.7, boltrad, boltrad, $fn=32);
        }
        // Hole to push nut back out
        rotate([45,0,0]) rotate([0,90,0]) translate([-10.8, 0, (butsp-ewid)/2+0.01]) rotate([0,0,45]) cylinder((butsp-ewid)/2, 1.3*sqrt(2), 1.3*sqrt(2), $fn=4);
    }
}

module cubeedgeinside(sd, ins, rd=10, cp=16)
{
    an = 90/cp;
    rotate([0,90,0]) linear_extrude(height=sd, convexity=5) polygon(concat(
        arc(0, 0, rd, 180, 270, an),
        [[-ins,0],[-ins,-ins+2.5],[-ins+2.5,-ins+2.5],[-ins+2.5,-ins],[0,-ins]]
    ));
}

module cubecorner(xof=xsof*butsp, bof=10, zof=-2.3, cp=16, tol=0.2)
{
    sd = (butsp-ewid)/2-xof;
    /*
     * Run along triangle.
     * three coords, x,y,z (triangle subdivide from [90,0,0],[0,90,0],[0,0,90])
     * As seen from bottom line:
     *   z = sin(a1), zf=cos(a1) (z coord, scaling factor)
     *   x = zf*cos(a2), y = zf*sin(a2)
     *
     *   xyz plane: x+y+z = 1, map c1=[0..1], c2=[0..1]:
     *   z = c1
     *   x = (1-c1)*c2
     *   y = (1-c1)*(1-c2)
     *
     *  Just hack it, do sine of x, y, z and then scale to a sphere
     *
     * Faces:  triangular numbers
     */
    an = 90/cp;
    rd = xof+bof+zof+2;
    pqsphere = concat(
        // Sphere corner
        [[0,0,rd]], // Avoid div by zero on zi=0
        [for (zi=[1:cp], pi=[0:zi])
            let(zf=zi/cp, z=1-zf, xy=pi/zi, x=zf*xy, y=zf*(1-xy),
                xc=sin(90*x), yc=sin(90*y), zc=sin(90*z),
                sf = sqrt(1/(xc*xc+yc*yc+zc*zc)))
            [xc*sf*rd, yc*sf*rd, zc*sf*rd]
        ],
        []
    );
    fqsphere = concat(
        [for (c1=[1:cp], c2=[0:c1-1])
            let(bs=c1*(c1+1)/2)
            [bs+c2, bs+c2+1, bs+c2-c1]
        ],
        [for (c1=[1:cp-1], c2=[0:c1-1])
            let(bs=c1*(c1+1)/2)
            [bs+c2+1, bs+c2, bs+c2+c1+2]
        ],
        []
    );
    parcs = concat(
        // Extended sphere arcs
        xyzarcs(rd,   -sd, cp),
        xyzarcs(rd-1, -sd, cp),
        xyzarcs(rd-1,   0, cp),
        xyzarcs(rd-2-tol,   0, cp),
        xyzarcs(rd-2-tol, -sd, cp),
        []
    );
    csp = len(pqsphere);
    car = cp+1;

    fqarcs = concat(
        [for (i=[0:cp-1]) each [
            [csp-cp+i, csp-cp+i-1, csp+i+1], [csp-cp+i-1, csp+i, csp+i+1] ]],
        [for (i=[1:cp])
            let (si=(i*(i+1)/2)-1, si2=si+i+1)
            each [ [si, si2, csp+car+i], [si, csp+car+i, csp+car+i-1] ]],
        [for (i=[1:cp])
            let (si=(i*(i-1)/2), si2=si+i)
            each [ [si2, si, csp+car*2+i], [si, csp+car*2+i-1, csp+car*2+i] ]],
        []
    );
    fqsides = [for (o=[0:11]) each qfacei(csp+car*o, car, car*3, (o%3==1)?1:0)];

    br = rd-2-tol;
    bro = 1;
    pqback = [
        [-bro,-sd,br], [-sd,-bro,br],
        [-sd,br,-bro], [-bro,br,-sd],
        [br,-bro,-sd], [br,-sd,-bro]
    ];
    cbk = len(pqsphere)+len(parcs);
    bp = [csp+car*13, csp+car*14, csp+car*14+cp,
        csp+car*12, csp+car*12+cp, csp+car*13+cp,
        cbk, cbk+1, cbk+2, cbk+3, cbk+4, cbk+5];
    fqback = concat(
        [for (i=[0:5]) each [[bp[i], bp[i+6], bp[(i+1)%6+6]],[bp[i], bp[(i+1)%6+6], bp[(i+1)%6]] ]],
        [[bp[6], bp[8], bp[7]], [bp[6], bp[9], bp[8]],
         [bp[6], bp[11], bp[9]], [bp[9], bp[11], bp[10]],
         [csp+car*13, csp+car*14, csp+car*10],
         [csp+car*12+cp, csp+car*13+cp, csp+car*9+cp],
         [csp+car*14+cp, csp+car*12, csp+car*9] ],
        [[csp+car*12, csp+car*12+cp, csp+car*12+cp/2]],
        [for (i=[1:cp/2]) [csp+car*12, csp+car*12+i, csp+car*12+i-1]],
        [for (i=[cp/2+1:cp]) [csp+car*12+cp, csp+car*12+i, csp+car*12+i-1]],
        [[csp+car*13+cp, csp+car*13, csp+car*13+cp/2]],
        [for (i=[1:cp/2]) [csp+car*13, csp+car*13+i-1, csp+car*13+i]],
        [for (i=[cp/2+1:cp]) [csp+car*13+cp, csp+car*13+i-1, csp+car*13+i]],
        [[csp+car*14, csp+car*14+cp, csp+car*14+cp/2]],
        [for (i=[1:cp/2]) [csp+car*14, csp+car*14+i, csp+car*14+i-1]],
        [for (i=[cp/2+1:cp]) [csp+car*14+cp, csp+car*14+i, csp+car*14+i-1]],
        []
    );

    cp2 = 32;
    an2 = 90/cp2;
    hrd = butdia/2;
    esta = asin((ewid/2)/hrd);
    cnf = floor((90-(esta*2)) / an2);
    sta = an2 * (cp2-cnf) / 2;  // recalc so it's an integer number of steps
    xo = butsp/2-xof;
    pinst = concat(
        zarc(-xo, -xo, rd,   hrd, sta, 90-sta, an2),
        zarc(-xo, -xo, rd-1, hrd, sta, 90-sta, an2),
        yarc(-xo, rd,   -xo, hrd, 90-sta, sta, -an2),
        yarc(-xo, rd-1, -xo, hrd, 90-sta, sta, -an2),
        xarc(rd,   -xo, -xo, hrd, sta, 90-sta, an2),
        xarc(rd-1, -xo, -xo, hrd, sta, 90-sta, an2),
        []
    );
    cpi = len(pqsphere)+len(parcs)+len(pqback);
    sphc1 = cp*(cp+1)/2;
    sphc2 = cp*(cp+1)/2+cp;
    finst = concat(
        face_inset( [0, csp+car*2, csp+car*1],
                    [csp+car*8, csp+car*5, csp+car*4], cpi, cnf),
        face_inset( [sphc1, csp+car*0, csp+car*2+cp],
                    [csp+car*8+cp, csp+car*3, csp+car*5+cp], cpi+2*(cnf+1), cnf),
        face_inset( [sphc2, csp+car*1+cp, csp+car*0+cp],
                    [csp+car*7+cp, csp+car*4+cp, csp+car*3+cp], cpi+4*(cnf+1), cnf),
        []
    );

    xyzof = (br-sd-1)/3;

    points = concat(pqsphere, parcs, pqback, pinst);
    faces = concat(fqsphere, fqarcs, fqsides, fqback, finst);

    // echo("POINTS", points, "FACES", faces);

    // color("#333")
    translate([xof,xof,-xof]) rotate([0,0,180])
    difference() {
        union() {
            difference() {
                polyhedron(points=points, faces=faces, convexity=6);
                difference() {
                    cube([14.5,14.5,14.5], true);
                    // Backfill
                    translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) {
                        translate([0,0,4]) cylinder(4, 8, 8, $fn=6);
                    }
                }
            }
            cdi = sqrt(6*6+8*8)/sqrt(3)*2;
            //#translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) rotate([0,0,30]) cylinder(9.5, cdi/2, cdi/2, $fn=6);
            translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) translate([0,0,4.75]) cube([6, 8, 9.5], true);
        }
        translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) {
            translate([0,0,-0.01]) cylinder(7.01, boltrad, boltrad, $fn=32);
            translate([5,0,1.2+1.4]) cube([6.1+10, 5.5, 2.8], true);
            translate([8,0,1.2]) cube([5, 5.5, 2.8], true);
        }
    }

    // Sacrificial support layer
    translate([xof,xof,-xof]) rotate([0,0,180])
    translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) {
        #translate([0,0,1.2+2.8+0.1]) cube([4, 4, 0.2], true);
    }
}

// top corners (mid, near, far), bottom corners, curve offset, curve length
function face_inset(t, b, o, l) = concat(
    [[t[0], o, t[1]], [t[0], t[2], o+l]],
    [for (i=[0:l-1]) [o+i+1, o+i, t[0]]],

    [[b[0], b[1], o+l+1], [b[2], b[0], o+l+l+1]],
    [for (i=[0:l-1]) [o+l+i+1, o+l+i+2, b[0]]],

    [[o,   b[1], t[1]], [o, o+l+1, b[1]],
     [o+l, t[2], b[2]], [o+l+l+1, o+l, b[2]]],
    qfacei(o, l+1, l+1)
);

function xyzarcs(rd, sd, cp) = concat(
    [for (xy=[0:cp]) [sin(xy*90/cp)*rd, cos(xy*90/cp)*rd, sd]],
    [for (xz=[0:cp]) [sin(xz*90/cp)*rd, sd, cos(xz*90/cp)*rd]],
    [for (yz=[0:cp]) [sd, sin(yz*90/cp)*rd, cos(yz*90/cp)*rd]],
    []
);

module cubeedgenuts(xof, bof, zof)
{
    enof = 1.3+0.6;
    color("#773") for (x=[1:numbut-1]) {
        translate([x*butsp, -enof, -zof+enof]) rotate([45,0,0]) {
            translate([0,0,1.6]) cube([5.5,5.5,2.4], true);

            translate([0,0,-6.3]) cylinder(10, 1.5, 1.5, $fn=32);
            translate([0,0,-7.3]) cylinder(1,2.9,2.9, $fn=32);
        }
    }
}

module cubecornernut(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.1)
{
    br = xof+bof+zof-tol;
    sd = (butsp-ewid)/2-xof;
    xyzof = (br-sd-1)/3;
    color("#773")
    translate([xof,xof,-xof]) rotate([0,0,180])
    translate([xyzof,xyzof,xyzof]) rotate([0,atan(sqrt(2)),45]) {
        translate([0,0,-2]) cylinder(8, 1.5, 1.5, $fn=32);
        translate([0,0,-2.5]) cylinder(1, 2.9, 2.9, $fn=32);

        translate([0,0,2.5]) cube([5.5,5.5,2.4], true);
    }
}

module cubebacknuts(xof = xsof*butsp, bof = 10, zof = -2.3)
{
    color("#773")
    for (y=[1:numbut-1]) translate([numbut*butsp-backboltoff, y*butsp, 0]) {
        translate([0,0,6.2+2.4/2]) cube([5.5,5.5,2.4], true);

        translate([0,0,6.2-7.5]) cylinder(10, 1.5, 1.5, $fn=32);
        translate([0,0,6.2-8.5]) cylinder(1,2.9,2.9, $fn=32);
    }

    botboltoff = (numbut+0.5)*butsp-ewid/2-3;
    color("#773")
    for (y=[1:2:numbut-1]) translate([botboltoff, (y+0.5)*butsp, 0]) {
        translate([0,0,2.1+2.4/2]) cube([5.5,5.5,2.4], true);

        translate([0,0,2.1-4.4]) cylinder(8, 1.5, 1.5, $fn=32);
        translate([0,0,2.1-5.4]) cylinder(1,2.9,2.9, $fn=32);
    }
}

module cubebackedges(xof = xsof*butsp, bof = 10, zof = -2.3, tol=0.2)
{
    union() {
        cubebackedge(xof, bof, zof);
        translate([0,-zof, -zof]) mirror([0,1,1]) cubebackedge(xof, bof, zof);

        sd = butsp-ewid;
        translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0, rd=bof+zof+xof+1);
        translate([numbut*butsp-xof, xof, -(zof+xof)]) cubeedge(sd = butsp/2-ewid/2+xof, thi = 1.2, rd=bof+zof+xof-.2);
        // translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0, rd=bof+zof+xof-1.2);

        // Inside
        translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedgeinside(butsp-ewid, bof-2.8, rd=bof+zof+xof-tol);
    }
}

module cubebackedge(xof, bof, zof, tol=0.2, cp=32)
{
    xo = butsp/2; // offset of hole centers
    backwid = butsp-ewid/2;
    endofs = (numbut-0.5)*butsp;
    whiteof = butsp/2-xof+tol;
    backof = butsp/2+tol;

    an = 90/cp;
    rd = butdia/2;
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps

    // Edge with cutouts for buttons
    for (z=[1/*,-1.2*/]) translate([(numbut-0.5)*butsp, 0, bof+z]) linear_extrude(height=1, convexity=4)
        polygon(concat(
            [[ewid/2,xof], [backwid,xof], [backwid,endofs+backwid]],
            [for (x=[numbut-1:-1:0]) each arc( 0, butsp*(x+0.5), rd, (x==numbut-1?45:sta), 180-sta, an)]
        ));

    // Middle bit of edge
    translate([(numbut-0.5)*butsp, 0, bof-0.2])
        linear_extrude(height=1.2) polygon([
            [whiteof,xof], [backwid,xof], [backwid, endofs+backwid], [whiteof, endofs+whiteof]
        ]);

    // Back bit of edge
    translate([(numbut-0.5)*butsp, 0, 0]) difference() {
        linear_extrude(height=bof) polygon([
            [backof,xof], [backwid,xof], [backwid, endofs+backwid], [backof, endofs+backof]
        ]);
        // Bolt holes
        for (y=[1:2:numbut-1]) {
            translate([backwid-3, (y+0.5)*butsp, -0.01]) cylinder(8, boltrad, boltrad, $fn=32);
            translate([backwid-3, (y+0.5)*butsp, 2.0+2.6/2]) cube([5.5+0.501, 5.5, 2.6], true);
        }
    }
    // Back corner
    translate([(numbut)*butsp+tol, -1, 0])
        cube([backwid-backof,6,5], false);

    // TODO: Magic number 5.075
    // Under bit at beginning
    translate([butsp*(numbut),0,bof-5.075]) rotate([0,0,90]) {
        cornerfacet(thi=xof+0.5-tol, xof=4.499, yof=-0.2);
    }

    // under bits between leds
    for (x=[1:numbut-1]) {
        translate([butsp*(numbut),butsp*x,bof-5.075]) rotate([0,0,90]) {
            difference() {
                edgefacet(thi=xof+0.5-tol, xof=-0.2);
                translate([0, backboltoff, -0.01]) cylinder(5, boltrad, boltrad, $fn=32);
                translate([0, backboltoff+0.5, 1.2+2.6/2]) cube([5.5, 5.5+1.4, 2.6], true);
                for (m=[0,1]) mirror([m,0,0])
                    translate([8.2, -tol, -0.01]) rotate([0,-90,0])
                        linear_extrude(height=4.4) polygon([ [0,0],[0,3],[3,0] ]);
            }
        }
    }
}

module whiteside(xof=xsof*butsp, bof=10, zof=-2.3, nh=numbut, thi=1, eof=0.5-xsof, cp=64)
{
    wid = butsp * (nh-1+2*eof);
    hr = holesp*4;
    an = 360/cp;

    tcs = cp*nh*nh;
    ns = 2*(nh-1);
    tcr = tcs+ns*4;

    color("#eee") translate([0,0,bof])
    linear_extrude(height=thi, convexity=5) polygon(points=concat(
        [for (x=[0:nh-1], y=[0:nh-1]) each circle((x+0.5)*butsp, (y+0.5)*butsp, hr, an)],
        ssquare(xof, butsp*nh-xof, nh-1, butsp, butsp-xof, butsp+xof),
        [for (x=[1:nh-1], y=[1:nh-1]) each rect(x*butsp, y*butsp, facetnutwid, facetnuthei)],
        []
    ), paths=[concat(
        ws_corner(cp, cp/2, 0, 3, tcs+2*ns, tcs),
        [for (x=[1:nh-2]) each ws_corner(cp, cp*3/4, nh*x, 2, tcs+2*x-1, tcs+2*x)],
        ws_corner(cp, cp/2, nh*(nh-1), 2, tcs+ns-1, tcs+3*ns),
        [for (x=[1:nh-2]) each ws_corner(cp, cp*3/4, nh*(nh-1)+x, 1, tcs+3*ns+2*x-1, tcs+3*ns+2*x)],
        ws_corner(cp, cp/2, nh*nh-1, 1, tcs+4*ns-1, tcs+2*ns-1),
        [for (x=[nh-2:-1:1]) each ws_corner(cp, cp*3/4, nh*x+nh-1, 0, tcs+ns+2*x, tcs+ns+2*x-1)],
        ws_corner(cp, cp/2, nh-1, 0, tcs+ns, tcs+3*ns-1),
        [for (x=[nh-2:-1:1]) each ws_corner(cp, cp*3/4, x, 3, tcs+2*ns+2*x, tcs+2*ns+2*x-1)],
        []
    ),
        for (x=[1:nh-2],y=[1:nh-2]) [for (i=[0:cp-1]) (x+y*nh)*cp+i],
        for (i=[0:(nh-1)*(nh-1)-1]) [for (s=[0:3]) tcr+i*4+s]
    ]);
}

// Circle part with edge parts
// offset, quadrant, number of points
function ws_corner(cp, ns, o, q, s1, e1) = concat(
    [s1],
    [for (i=[0:ns]) o*cp+(i+cp*(q*2+1)/8)%cp],
    [e1]
);

// Square with multiple points on sides
// start, end, number of steps, step size, offset1, offset2
function ssquare(x1, x2, n, s, o1, o2) = concat(
    [for (x=[0:n-1]) each [[x*s+o1,x1], [x*s+o2,x1]]],
    [for (x=[0:n-1]) each [[x*s+o1,x2], [x*s+o2,x2]]],
    [for (y=[0:n-1]) each [[x1,y*s+o1], [x1,y*s+o2]]],
    [for (y=[0:n-1]) each [[x2,y*s+o1], [x2,y*s+o2]]],
    []
);

// Rectangle
// x center y center, width, height
function rect(x, y, w, h) = [
    [x-w/2,y-h/2], [x-w/2,y+h/2], [x+w/2,y+h/2], [x+w/2,y-h/2]
];

function circle(x,y,d,an) = [
    for (a = [0:an:360-an]) [x+d*sin(a),y+d*cos(a)]
];

module whiteside2(xof=xsof*holesp*12, bof=10, zof=-2.3)
{
    color("#eee") translate([0,0,bof])
    difference() {
        translate([xof,xof,0]) perfboard(numbut, numbut, 1, holesp * 12, holesp * 8, 0.5-xsof, 64);
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([(x)*butsp, (y)*butsp, 0]) cube([facetnutwid,facetnuthei,2.02], true);
        }
        translate([0, 0, -0.01]) linear_extrude(height=1.02) polygon([
            [xof-0.01,xof-0.01], [(butsp-xof)+0.01,xof-0.01], [xof-0.01,(butsp-xof)+0.01]
        ]);
        for (x=[1:numbut-1]) {
            translate([x*butsp, 0, -0.01]) linear_extrude(height=1.02) polygon([
                [xof-0.01,xof-0.01], [(butsp-xof)+0.01,xof-0.01], [butsp/2,(butsp/2)]
            ]);
        }
        mirror([-1,1,0]) for (x=[1:numbut-1]) {
            translate([x*butsp, 0, -0.01]) linear_extrude(height=1.02) polygon([
                [xof-0.01,xof-0.01], [(butsp-xof)+0.01,xof-0.01], [butsp/2,(butsp/2)]
            ]);
        }
    }
}

module sidefacets(xof, bof, zof)
{
    color("#333") for (x=[1:numbut-1], y=[1:numbut-1]) {
        translate([butsp*x,butsp*y,11]) sidefacet();
    }
}

module backendback(nb = numbut, thi = 3.6)
{
    cwid = butsp-8;
    swid = 20;
    twid = 10;
    bwid = 3;
    union() {
        for (x=[1:nb-1], y=[1:nb-1]) {
            translate([x*butsp, y*butsp, 0]) backend_back_midpiece(thi, cwid, swid, twid, bwid);
        }
        for (x=[0:nb-1], y=[0:nb-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) backend_back_butpiece(thi, cwid, swid, twid, bwid);
        }
        for (x=[1:nb-1]) {
            translate([x*butsp, 0, 0]) backend_back_edgepiece(0, thi, cwid, swid, twid, bwid);
            translate([x*butsp, nb*butsp, 0]) backend_back_edgepiece(180, thi, cwid, swid, twid, bwid);
        }
        for (y=[1:nb-1]) {
            translate([0, y*butsp, 0]) backend_back_edgepiece(270, thi, cwid, swid, twid, bwid);
            translate([nb*butsp, y*butsp, 0]) backend_back_edgepiece(90, thi, cwid, swid, twid, bwid);
        }
        for (x=[0,1], y=[0,1]) {
            rot = x*90-y*90+x*y*180;
            translate([x*nb*butsp, y*nb*butsp]) backend_back_cornerpiece(rot, thi, cwid, swid, twid, bwid);
        }
    }
}

module backendback_old(sd = numbut*butsp, thi = 3.6)
{
    cwid = butsp-8;
    swid = 20;
    twid = 10;
    bwid = 3;
    difference() {
        union() {
            for (x=[1:numbut-1], y=[1:numbut-1]) {
                // Large middle bits
                translate([x*butsp, y*butsp, 0]) {
                    translate([-cwid/2, -cwid/2, 0]) cube([cwid, cwid, thi]);
                    stubpyra(swid, swid, 11.2, 11.2, 8);
                }
            }
            for (x=[0:numbut-1], y=[0:numbut-1], an=[0:90:270]) {
                translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) rotate([0,0,an]) {
                    // Beams around buttons
                    translate([2.8, -4, 0]) cube([bwid, 8, thi]);

                    // wsled supports
                    translate([ledsp,  4, 0]) cylinder(3, 1.6, 1.6, $fn=4);
                    translate([ledsp, -4, 0]) cylinder(3, 1.6, 1.6, $fn=4);
                }
            }
            // Extra bits under buttons
            for (x=[0:numbut-1], y=[0:numbut-1]) {
                translate([(x+0.5)*butsp-6/2, (y+0.5)*butsp-3/2, 0]) cube([6,3,2]);
                translate([(x+0.5)*butsp-3/2+2.0, (y+0.5)*butsp-6/2, 0]) cube([1.0,6,2]);
            }
            // Edge bits
            for (x=[1:numbut-1], y=[0,numbut]) {
                yo = y*butsp+(cwid/4+1)*(y>0?-1:1);
                translate([x*butsp, yo, thi/2]) cube([cwid,cwid/2-2,thi], true);
            }
            // Edge bits
            for (x=[0,numbut], y=[1:numbut-1]) {
                xo = x*butsp+(cwid/4+1)*(x>0?-1:1);
                translate([xo, y*butsp, thi/2]) cube([cwid/2-2,cwid,thi], true);
            }
            // Corner bits
            for (x=[0,numbut], y=[0,numbut]) {
                xo = x*butsp+(cwid/4+1)*(x>0?-1:1);
                yo = y*butsp+(cwid/4+1)*(y>0?-1:1);
                translate([xo, yo, thi/2]) cube([cwid/2-2,cwid/2-2,thi], true);
            }
        }
        // Cutouts for middle bits (with bolt holes)
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([x*butsp, y*butsp, -1]) stubpyra(swid, swid, twid, twid, 11.3-facetnutthi);
            translate([x*butsp, y*butsp, 11.3-facetnutthi-1.01]) cylinder(2.02, boltrad, boltrad, $fn=32);
            translate([x*butsp, y*butsp, 11.2-facetnutthi+4.6/2]) cube([facetnutwid, facetnuthei, 4.6], true);
        }
        // Round cutout for wsleds
        for (x=[0:numbut-1], y=[0:numbut-1], an=[0:90:270]) {
            xo = (x+0.5)*butsp + cos(an)*ledsp;
            yo = (y+0.5)*butsp + sin(an)*ledsp;
            translate([xo, yo, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        }
        // Button cutout
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) {
                translate([-3.5,-3.5,1.4]) cube([7,7,thi-1.4+0.01]);
            }
        }
        hl = 2*bwid+6;
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            // Holes for wsled wiring
            translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) {
                *for (x=[-1,1], y=[-1,1]) {
                    translate([x*3.15-0.351, y*2.0-1.5, 1.2]) cube([0.702,3.0,0.601]);
                }
                // Extra cutout (lower) to push the wire through in a straight line
                for (x=[0,1], y=[0,1]) {
                    mirror([x,0,0]) mirror([0,y,0])
                    translate([(bwid+2.8), 3.9, -0.001]) {
                        linear_extrude(height=1.001) polygon([
                        // [0,-0.3], [3.76,-0.3], [3.16,0.3], [0,0.3]
                        [0,-0.3], [9.5,-0.3], [9.5,0.3], [0,0.3]
                        ]);
                        translate([0,0,1]) rotate([0,90,0]) cylinder(9.5, 0.3, 0.3, $fn=4);
                    }
                }

                // Lower ducts (aligned with button pins)
                for (x=[-1:1]) {
                    translate([0, x*3.9, 0.6]) cube([hl, 0.6, 0.801], true);
                }

                // Extra cutout (higher) to push the wire through in a straight line
                for (x=[0,1], y=[0,1]) {
                    mirror([x,0,0]) mirror([0,y,0])
                    translate([4.2, (bwid+2.8), 1.2])
                        linear_extrude(height=2.401) polygon([
                        // [-0.3,0], [-0.3,3.76], [0.3,3.16], [0.3,0]
                        [-0.3,0], [-0.3,9.5], [0.3,9.5], [0.3,0]
                        ]);
                }

                // Higher ducts (across button pins, with offset middle)
                for (x=[-4.2,1,4.2]) {
                    translate([ x, 0, 1.6]) cube([0.6, hl, 0.801], true);
                }

                // Diagonal holes to cross connect gnd and 5v
                for (x=[0,1], y=[0,1]) {
                    mirror([x,0,0]) mirror([0,y,0])
                    rotate([0,0,45]) translate([0, 8.48, 1.6]) cube([7, 0.6, 0.801], true);
                }
            }
        }

        // Edge bolts
        for (x=[1:numbut-1]) {
            translate([x*butsp, 0, 2.5]) rotate([45,0,0]) {
                translate([0,0,-7]) cylinder(3.5, 3.4, 3.4, $fn=32);
                translate([0,0,-4]) cylinder(3.5, boltrad, boltrad, $fn=32);
            }
            translate([0, x*butsp, 2.5]) rotate([0,-45,0]) {
                translate([0,0,-7]) cylinder(3.5, 3.4, 3.4, $fn=32);
                translate([0,0,-4]) cylinder(3.5, boltrad, boltrad, $fn=32);
            }
        }

        // Bottom side cut off a bit
        bcut = 0.6;
        btl = 0.01;
        rotate([0,90,0]) linear_extrude(height=numbut*butsp) polygon([
            [-bcut-btl,2-btl],[btl,2+bcut+btl],[btl,2-btl]
        ]);
        rotate([90,0,180]) linear_extrude(height=numbut*butsp) polygon([
            [-2-bcut-btl,0-btl],[-2+btl,0+bcut+btl],[-2+btl,0-btl]
        ]);

        // Corner bolt
        xof = xsof*butsp;
        cdi = 10.8;  // Magic number
        translate([xof, xof, -xof+2.4])
        rotate([0,-atan(sqrt(2)),45]) {
            translate([0,0,3.0]) cylinder(8, cdi/2, cdi/2, $fn=6);
            translate([0,0,1]) cylinder(3, boltrad, boltrad, $fn=32);
            translate([0,0,-2]) cylinder(3.8, 3.4, 3.4, $fn=32);
        }
    }
    // Sacrificial layer
    for (x=[1:numbut-1], y=[1:numbut-1]) {
        #translate([x*butsp, y*butsp, 11.3-facetnutthi-1+0.1]) cube([6,6,0.2], true);
    }
}

// One piece of the backendback, so it can be prerendered
// (Hopefully it will only be rendered once)
module backend_back_midpiece(thi = 3.6, cwid = butsp-8, swid = 20, twid = 10, bwid = 3)
{
    render(convexity=5) difference() {
        union() {
            // Large middle bit
            translate([-cwid/2, -cwid/2, 0]) cube([cwid, cwid, thi]);
            stubpyra(swid, swid, 11.2, 11.2, 8);

            // wsled supports
            for (an=[0:90:270], x=[-1,1]) rotate([0,0,an]) {
                translate([x*(butsp/2-ledsp), butsp/2 - 4, 0]) cylinder(3, 1.6, 1.6, $fn=4);
            }
        }
        // Cutouts for middle bits (with bolt holes)
        translate([0, 0, -1]) stubpyra(swid, swid, twid, twid, 11.3-facetnutthi);
        translate([0, 0, 11.3-facetnutthi-1.01]) cylinder(2.02, boltrad, boltrad, $fn=32);
        translate([0, 0, 11.2-facetnutthi+4.6/2]) cube([facetnutwid, facetnuthei, 4.6], true);

        // Round cutout for wsleds
        for (an=[0:90:270], y=[-1,1]) rotate([0,0,an]) {
            translate([butsp/2,y*(butsp/2-ledsp), 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        }

        // Extra cutouts to push the wire through straight
        wireducts(cwid);

        // Diagonal holes to cross connect gnd and 5v
        // Calculate chord to wsled supports
        // dhoff = avg of butsp/2-4+1.6 and butsp/2-ledsp;
        dhoff = (butsp/2 - (ledsp+4)/2 + 0.8) * sqrt(2);
        for (an=[45:90:315]) {
            rotate([0,0,an]) translate([0, dhoff+0.4, 1.6]) cube([7, 0.8, 0.8], true);
        }
    }
    // Sacrificial layer
    #translate([0, 0, 11.3-facetnutthi-1+0.1]) cube([6,6,0.2], true);
}

// Piece that button sits in
module backend_back_butpiece(thi = 3.6, cwid = butsp-8, swid = 20, twid = 10, bwid = 3)
{
    render(convexity=5) difference() {
        union() {
            for (an=[0:90:270]) {
                rotate([0,0,an]) {
                    // Beams around buttons
                    translate([2.8, -11.6/2, 0]) cube([bwid, 11.6, thi]);
                }
            }
            // Extra bits under buttons
            translate([-6/2, -3/2, 0]) cube([6,3,2]);
            translate([-3/2+2.0, -6/2, 0]) cube([1.0,6,2]);
        }
        // Round cutout for wsleds
        for (an=[0:90:270]) rotate([0,0,an]) {
            translate([ledsp, 0, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        }
        // Button cutout
        translate([-3.5,-3.5,1.4]) cube([7,7,thi-1.4+0.01]);

        hl = 2*bwid+6;
        // Holes for wsled wiring
        // Lower ducts (aligned with button pins)
        for (x=[-3.85,0,3.85]) {
            translate([0, x, 0.6]) cube([hl, 0.7, 0.801], true);
        }

        // Higher ducts (across button pins, with offset middle)
        for (x=[-4.25,1,4.25]) {
            translate([ x, 0, 1.6]) cube([0.7, hl, 0.801], true);
        }
    }
}

// Pieces along the edge
module backend_back_edgepiece(rot = 0, thi = 3.6, cwid = butsp-8, swid = 20, twid = 10, bwid = 3)
{
    rotate([0,0,rot]) render(convexity=5) difference() {
        union() {
            // Box bit
            translate([0, cwid/4+1, thi/2]) cube([cwid,cwid/2-2,thi], true);

            // wsled supports
            for (x=[-1,1]) {
                translate([x*(butsp/2-ledsp), butsp/2 - 4, 0]) cylinder(3, 1.6, 1.6, $fn=4);
                translate([x*(butsp/2-4), butsp/2-ledsp, 0]) cylinder(3, 1.6, 1.6, $fn=4);
            }
        }

        // Round cutout for wsleds
        for (x=[-1,1]) {
            translate([x*(butsp/2-ledsp), butsp/2, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
            translate([x*(butsp/2), butsp/2-ledsp, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        }

        // Diagonal holes to cross connect gnd and 5v
        // Calculate chord to wsled supports
        // dhoff = avg of butsp/2-4+1.6 and butsp/2-ledsp;
        dhoff = (butsp/2 - (ledsp+4)/2 + 0.8) * sqrt(2);
        for (an=[-45:90:45]) {
            rotate([0,0,an]) translate([0, dhoff+0.4, 1.6]) cube([7, 0.8, 0.8], true);
        }

        rotate([0,0,-(rot % 180)]) wireducts(cwid);

        if (rot == 0 || rot == -90 || rot == 270) {
            // Edge bolt
            translate([0, 0, 2.5]) rotate([45,0,0]) {
                translate([0,0,-7.4]) cylinder(3.5, 3.4, 3.4, $fn=32);
                translate([0,0,-4]) cylinder(3.5, boltrad, boltrad, $fn=32);
            }

            // Bottom side cut off a bit
            bcut = 0.6;
            btl = 0.01;
            rotate([0,90,0]) translate([0,0,-cwid/2-0.001]) linear_extrude(height=cwid+0.002) polygon([
                [-bcut-btl,2-btl],[btl,2+bcut+btl],[btl,2-btl]
            ]);
        } else {
            // Backend bolt
            translate([0, backboltoff, -0.01]) cylinder(8.501, boltrad, boltrad, $fn=32);
        }
    }
}

module backend_back_cornerpiece(rot = 0, thi = 3.6, cwid = butsp-8, swid = 20, twid = 10, bwid = 3)
{
    rotate([0,0,rot]) render(convexity=5)
    difference() {
        union() {
            // Box bit
            translate([cwid/4+1, cwid/4+1, thi/2]) cube([cwid/2-2,cwid/2-2,thi], true);

            // wsled supports
            translate([(butsp/2-ledsp), butsp/2 - 4, 0]) cylinder(3, 1.6, 1.6, $fn=4);
            translate([(butsp/2-4), butsp/2-ledsp, 0]) cylinder(3, 1.6, 1.6, $fn=4);
        }
        // Round cutout for wsleds
        translate([(butsp/2-ledsp), butsp/2, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);
        translate([(butsp/2), butsp/2-ledsp, 2.2]) cylinder(thi-2.19, 5.5, 5.5, $fn=64);

        // Diagonal holes to cross connect gnd and 5v
        // Calculate chord to wsled supports
        // dhoff = avg of butsp/2-4+1.6 and butsp/2-ledsp;
        dhoff = (butsp/2 - (ledsp+4)/2 + 0.8) * sqrt(2);
        rotate([0,0,-45]) translate([0, dhoff+0.4, 1.6]) cube([7, 0.8, 0.8], true);

        // Extra cutouts to push the wire through straight
        rotate([0,0,-rot]) wireducts(cwid);

        if (rot == 0) {
            // Corner bolt
            xof = xsof*butsp;
            cdi = 10.8;  // Magic number
            translate([xof, xof, -xof+2.4])
            rotate([0,-atan(sqrt(2)),45]) {
                translate([0,0,3.0]) cylinder(8, cdi/2, cdi/2, $fn=6);
                translate([0,0,1]) cylinder(3, boltrad, boltrad, $fn=32);
                translate([0,0,-2]) cylinder(3.8, 3.4, 3.4, $fn=32);
            }
        }
        if (rot == 0 || rot == 270 || rot == -90) {
            // Bottom side cut off a bit
            bcut = 0.6;
            btl = 0.01;
            rotate([0,90,0]) translate([0,0,-0.001]) linear_extrude(height=cwid/2+0.002) polygon([
                [-bcut-btl,2-btl],[btl,2+bcut+btl],[btl,2-btl]
            ]);
        }
        if (rot == 0 || rot == 90 || rot == -270) {
            // Bottom side cut off a bit
            bcut = 0.6;
            btl = 0.01;
            rotate([90,0,180]) translate([0,0,-0.001]) linear_extrude(height=cwid/2+0.002) polygon([
                [-2-bcut-btl,0-btl],[-2+btl,0+bcut+btl],[-2+btl,0-btl]
            ]);
        }
    }
}

module wireducts(cwid)
{
    // Extra cutout (lower) to push the wire through in a straight line
    for (y=[-1,1]) {
        translate([0, y*(butsp/2-3.85), -0.001]) {
            translate([0,0,0.5]) cube([cwid+0.001, 0.7, 1.001], true);
            translate([-cwid/2-0.001,0,1]) rotate([0,90,0]) cylinder(cwid+0.002, 0.35, 0.35, $fn=4);
        }
    }

    // Extra cutout (higher) to push the wire through in a straight line
    for (x=[-1,1]) {
        translate([x*(butsp/2-4.25), 0, 1.2]) {
            translate([0,0,2.401/2]) cube([0.7, cwid+0.001, 2.401], true);
        }
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

            for (x=[1:numbut-1], m=[0,1], xy=[0,1]) mirror([-xy,xy,0])
                translate([x*butsp, numbut*butsp, 0]) {
                    mirror([m,0,0]) translate([-4, 0, thi]) rotate([0,-90,0])
                        linear_extrude(height=4) polygon([ [0,0],[0,-3.2],[3.2,0] ]);
            }
        }
        for (x=[0:numbut-1], y=[0:numbut-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp, -ledz-(8-gap)]) buttonholes();
        }
        for (x=[1:numbut-1], y=[1:numbut-1]) {
            translate([(x)*butsp, (y)*butsp, -0.01]) stubpyra(18,18,10,10,gap+0.0-thi+0.01);
            translate([(x)*butsp, (y)*butsp, gap+1-thi]) cube([facetnutwid,facetnuthei+0.2,2.02], true);
        }
        // Bolt hole cutout
        for (x=[1:numbut-1]) {
            translate([x*butsp, 0, -1.2]) rotate([45,0,0]) {
                translate([0,0,-0.2]) cylinder(2.2, boltrad+0.2, boltrad+0.2, $fn=32);
            }
            translate([0, x*butsp, -1.2]) rotate([0,-45,0]) {
                translate([0,0,-0.2]) cylinder(2.2, boltrad+0.2, boltrad+0.2, $fn=32);
            }
            translate([x*butsp, numbut*butsp-backboltoff, -0.01]) {
                cylinder(thi+0.02, boltrad+0.2, boltrad+0.2, $fn=32);
            }
            translate([numbut*butsp-backboltoff, x*butsp, -0.01]) {
                cylinder(thi+0.02, boltrad+0.2, boltrad+0.2, $fn=32);
            }
        }
        xof = xsof*butsp;
        cdi = 11.5;  // Magic number
        translate([xof, xof, -xof-1.2])
        rotate([0,-atan(sqrt(2)),45]) {
            translate([0,0,2]) cylinder(8, cdi/2, cdi/2, $fn=6);
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

module cornerfacet(sd = holesp * 48, thi=1, rd=butdia/2, cp=32, xof=xsof*holesp*12, yof=xsof*holesp*12)
{
    an = 90/cp;
    xo = butsp/2; // offset of hole centers
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps

    // TODO: Magic numbers!
    linear_extrude(convexity=5, height=thi) polygon(concat(
        [[ xof, xo-ewid/2], [xof,yof],[ xo-ewid/2, yof ]],
        arc( xo, xo, rd, 180+sta, 270-sta, an),
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
                zcircle(0, 0, 0, butdia/2 - 0.4-0.8, an),
                zcircle(0, 0, 0, butdia/2 - 0.4, an),
                dome(0, 0, 2, hi-1.5, butdia/2 - 0.4 -3, 3, an, lc, 1),
                []),
            faces = concat(
                [tface(0, cp)],
                [bface(cp*(lc*2+1), cp)],
                [for (l=[0:lc*2]) each qface(l*cp, cp, cp)],
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
        zssquare(wid,hei,w+1,h+1,0),
        [for (x=[0:w-1], y=[0:h-1]) each zcircle((x+eof)*hsp, (y+eof)*hsp, 0, hr, an)],
        zssquare(wid,hei,w+1,h+1,thi),
        [for (x=[0:w-1], y=[0:h-1]) each zcircle((x+eof)*hsp, (y+eof)*hsp, thi, hr, an)]
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
function zssquare(w,h,ws,hs,z) = concat(
    [for (i=[0:ws-1])  [i*(w/ws),0,z]],
    [for (i=[0:hs-1])  [w,i*(h/hs),z]],
    [for (i=[ws:-1:1]) [i*(w/ws),h,z]],
    [for (i=[hs:-1:1]) [0,i*(h/hs),z]]
);

function zcircle(x,y,z,d,an) = [
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
    zcircle(x, y, z+(i*h/lc), d2 + d * sqrt(1 - (i*fac/lc)*(i*fac/lc)), an)
];

// faces
// start offset, number of sides, offset of next
function qface(s, n, o, so=0, eo=0) = [for (i=[so:(eo==0?n-1:eo)]) each [
    [s+(i+1)%n,s+(i+1)%n+o,s+i],
    [s+(i+1)%n+o,s+i+o,s+i]
]];

// faces, inverted
// start offset, number of faces, offset of next, direction
function qfacei(s, n, o, di=1) = [for (i=[0:n-2]) each [
    [s+i+di,s+i+1+o,s+i+(1-di)],
    [s+i+di+o,s+i+(1-di)+o,s+i]
]];



// face fan
// fixed point, start, end, dir
function fanface(p, s, e, d=1) = [for (i=[s:e]) [p, i+d, i+(1-d)]];

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
function yarc(x, y, z, rd, st, ed, an) = [for (a=[st:an:ed]) [ x+rd*sin(a), y, z+rd*cos(a) ]];

// Part of a circle
// x, y, z, radius, start, end, an
function zarc(x, y, z, rd, st, ed, an) = [for (a=[st:an:ed]) [ x+rd*sin(a), y+rd*cos(a), z ]];

// Part of a 2d circle
// x, y, radius, start, end, an
function arc(x, y, rd, st, ed, an) = [for (a=[st:an:ed]) [ x+rd*sin(a), y+rd*cos(a) ]];
