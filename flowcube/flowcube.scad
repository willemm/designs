doitem = "footdisc";
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

botholeoff = 100;

backboltoff = 6.5;

foothi = 20;

pluginset = 16;
plugoffset = 52;

poleholehi = 70;

vertpc = 0;

connhi = 49;
connrad = 20;

fplughi = 30;
fpshi = 111;

boxx = 79.2;
boxy = 51.2;

stalkseed = [146,252,324,516];
//connpos = [20,40,70,0];
connpos = [20,46,0,38,0];

if (doitem == "sidefacet"   )   { mirror([0,0,1]) sidefacet(); }
if (doitem == "side"        )   { whiteside(); }
if (doitem == "backendfront")   { backendfront(); }
if (doitem == "backendback" )   { backendback(); }
if (doitem == "backendguide")   { rotate([180,0,0]) backendguide(); }
if (doitem == "button"      )   { button(); }
if (doitem == "edgeblack"   )   { rotate([0, 90,0]) cubeedgeblack(); }
if (doitem == "edgewhite"   )   { rotate([0,-90,0]) cubeedgewhite(); }
if (doitem == "backedge"    )   { rotate([0, 90,0]) cubebackedges(); }
if (doitem == "bottomside"  )   { bottomsidepart(); }
if (doitem == "bottomplate1")   { bottomplate1(); }
if (doitem == "bottomplate2")   { rotate([0, 0, 90]) bottomplate2(); }
if (doitem == "bottomplate3")   { bottomplate3(); }
if (doitem == "plugcase")       { rotate([0, 90, 0]) plugcase(); }
if (doitem == "bottomfoot")     { rotate([180,0,0]) bottomfoot(); }
if (doitem == "strip")          { cube([75,8,1]); }

// TODO: Do this differently

if (doitem == "bottomblob")  { rotate([180,0,60]) bottomblob(); }
if (doitem == "pipeholetpl")    { rotate([180,0,0]) pipeholetpl(); }

if (doitem == "footblob1")  { footblob(seed=stalkseed[0], conn=connpos[0], cp=480); }
if (doitem == "footblob2")  { footblob(seed=stalkseed[1], conn=connpos[1], cp=480); }
if (doitem == "footblob3")  { footblob(seed=stalkseed[2], conn=connpos[2], cp=480); }
if (doitem == "footblob4")  { footblob(seed=stalkseed[3], conn=connpos[3], cp=480); }
if (doitem == "footblob5")  { footblob(seed=stalkseed[3], conn=connpos[4], cp=480); }
if (doitem == "footmid")    { footmidtwo(cp=480); }
if (doitem == "foothandle") { rotate([0,90,0]) foothandle(cp=480, an=0); }
if (doitem == "footdisc")   { footmiddisc(cp=480); }
if (doitem == "footconn")   { footconnector(); }
if (doitem == "poleshell")  { poleshell(cp=480); }
// if (doitem == "stickdisc")  { footstickdisc(cp=240); }
if (doitem == "stickfoot")  { rotate([90,0,0]) footstickfoot(cp=240); }
if (doitem == "brakesub")   { brakediscsub(cp=240); }
if (doitem == "test")  { stalks(seed=252, conn=0, cp=480); }
if (doitem == "") {

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

*rotate([0,atan(sqrt(2)),0]) rotate([0,0,-45]) cubecorner();

*cubeside();

*rotate([0,atan(sqrt(2)),0]) rotate([0,0,-45]) {
    *color("#333") cubecorner();
    *cubecornernut();

    cubeside();
    rotate([90,90,0]) cubeside();
    rotate([-90,0,90]) cubeside();
}

*color("#333") translate([0,0,-0.1]) for (an=[0:120:240]) rotate([0,0,an])
    render(convexity=6) bottomsidepart();

*color("#666") for(an=[0:120:240]) rotate([0,0,an])
    bottomsideconnect();

*color("#333") translate([0,0,-1]) bottomside();

*color("#666") bottomfeet();

*color("#666") bottomplate();

*color("#777") plugcase();

*color("#696") render(convexity=5) bottomplate1();
*translate([5,2.5,0]) color("#669") render(convexity=5) bottomplate2();
*translate([0,5,0]) color("#966") render(convexity=5) bottomplate3();


*color("#5954") translate([boxx+20-250/2, boxy+3-200/2,-208]) cube([250,200,2],true);
*color("#5594") translate([boxx-30+200/2,          0,-208]) cube([200,250,2],true);
*color("#9554") translate([boxx+20-250/2, boxy-10+200/2,-208]) cube([250,200,2],true);

*color("#cd5") bottomblob(cp=120);
*color("#fe5") rotate([0,0,120]) bottomblob(cp=120);
*color("#fe5") rotate([0,0,240]) bottomblob(cp=120);

*color("#f5a") pipeholetpl();

*color("#fe5") bottomblobmid();
*color("#cd5") rotate([0,0,240]) bottomring();
*color("#cd5") rotate([0,0,0]) bottomblobside();
*color("#fe5") rotate([0,0,120]) bottomblobside();
*color("#fe5") rotate([0,0,240]) bottomblobside();

*color("#5554") translate([0, 0, -240]) cube([250,200,2],true);
*color("#5954") rotate([0,0, 60]) translate([35, -70,-200]) cube([250,200,2],true);
*color("#5594") rotate([0,0,150]) translate([0, -100,-200]) cube([250,200,2],true);
*color("#9554") rotate([0,0,270]) translate([0, -100,-200]) cube([250,200,2],true);


botoffset = 860;

*color("#dd3") translate([0,0,-botoffset]) footblob(seed=stalkseed[0], conn=connpos[0]);
*color("#ad3") rotate([0,0,90]) translate([0,0,-botoffset]) footblob(seed=stalkseed[1], conn=connpos[1]);
*color("#dd3") rotate([0,0,180]) translate([0,0,-botoffset]) footblob(seed=stalkseed[2], conn=connpos[2]);
*color("#ad3") rotate([0,0,270]) translate([0,0,-botoffset]) footblob(seed=stalkseed[3], conn=connpos[3]);

*color("#4dd") translate([0,0,-botoffset]) footconnector();

*color("#ad3") translate([0,0,-botoffset+0.1]) footmid();

*color("#cf3") translate([0,0,-botoffset+0.1]) footstickdisc();

*color("#fc3") translate([0,0,-botoffset+0.1]) footstickfoot();

color("#ae3") translate([0,0,-botoffset+0.1]) footmiddisc();

*color("#fc3") translate([0,0,-botoffset+0.1]) foothandle();
*color("#ae3") translate([0,0,-botoffset+0.1]) footmidtwo();


*rotate([0,0,20]) translate([190-28,0,-botoffset+fplughi]) powerplug_f();

*color("#9554") rotate([0,0,90]) translate([60, -98,-848]) cube([250,200,2],true);

*color("#444") translate([0,0,-botoffset+208]) poleshell();

*color("#888") translate([0,0,-botoffset+59+0.2]) standpole();

*translate([0,0,-botoffset]) brakedisc();

*translate([0,0,-botoffset]) brakediscsub();


*psu();
*if (vertpc) { powerplug(); } else { powerplug_h(); }
*mcp();
*rotate([90,0,0]) mcpback();
*esp();

}

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
        *buttonseries(xof, bof, zof);
        *partseries(xof, bof, zof);
        *color("#beb") render(convexity=5) translate([0, 0, ledz+1.8]) backendfront();
        *color("#beb") translate([0, 0, ledz+1.8]) backendfront();
        *color("#8c8") translate([0, 0, ledz-1.8-0.1]) backendback();
        *color("#8cc") translate([0, 0, ledz-1.8-0.2]) backendguide();
    }
}

module esp(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    ihr = (rcx-5) * sqrt(3)/2;

    ln = 25.6;
    wd = 34.4;
    th = 2.0;
    translate([52, -ihr+3, rcz+5]) rotate([-90,0,0])  {
        color("#559") translate([0,0,th/2+12]) cube([ln, wd, th], true);
        color("#873") translate([0*2.54,-4*2.54,1.6/2]) cube([12*2.54, 18*2.54, 1.6], true);

        color("#ddd") translate([-5*2.54, -10*2.54, 1.6+7/2]) cube([5.8, 15.0, 7], true);
        color("#333") translate([-4.5*2.54, 1*2.54, 1.6+9/2]) cube([2.54, 8*2.54, 9], true);
        color("#333") translate([+4.5*2.54, 1*2.54, 1.6+9/2]) cube([2.54, 8*2.54, 9], true);
    }
}

module mcp(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    ihr = (rcx-5) * sqrt(3)/2;

    ln = 65.6;
    wd = 19.2;
    th = 1.5;
    translate([2, -ihr+3, rcz-2.5]) rotate([-90,0,0])  {
        difference() {
            color("#595") translate([0,0,th/2]) cube([ln, wd, th], true);
            translate([-(ln/2 -  5.0), (wd/2 - 6.6), -0.01]) cylinder(1.52, 1.7, 1.7, $fn=24);
            translate([ (ln/2 - 16.8), (wd/2 - 6.6), -0.01]) cylinder(1.52, 1.7, 1.7, $fn=24);
        }
        color("#ddd") translate([-ln/2+22.5/2, -wd/2-0.8+5.9/2, 1.6+7/2]) cube([22.5, 5.9, 7], true);
        color("#ddd") translate([-ln/2+22.5/2+25.4, -wd/2-0.8+5.9/2, 1.6+7/2]) cube([22.5, 5.9, 7], true);
        color("#ddd") translate([ ln/2-5.8/2-1.3, -wd/2-0.8+12.6/2, 1.6+7/2]) cube([5.8, 12.6, 7], true);
    }
}

module mcpback(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    ihr = (rcx-5) * sqrt(3)/2;

    ln = 65.6;
    wd = 19.2;
    th = 2;

    ex = 7;
    ey = 3;
    translate([2, -ihr+3, rcz-2.5]) rotate([-90,0,0])  {
        difference() {
            color("#333") translate([-ex/2, ey/2, -th/2]) cube([ln-ex, wd-ey, th], true);
            translate([-(ln/2 -  5.0), (wd/2 - 6.6), -th-0.01]) cylinder(th+0.02, 1.7, 1.7, $fn=24);
            translate([ (ln/2 - 16.8), (wd/2 - 6.6), -th-0.01]) cylinder(th+0.02, 1.7, 1.7, $fn=24);
        }
    }
}

module powerplug_h(bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);

    bothi = 23;

    translate([-plugoffset, 0, rcz-bothi-2-0.2 - 8]) rotate([90,0,-90]) {
        color("#543") difference() {
            translate([0,0,4.2/2]) cube([35, 15, 4.2], true);
            translate([ 14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
            translate([-14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
        }
        color("#543") translate([0,0,-0.9]) {
            minkowski() {
                cylinder(14.6, 12.5/2, 12.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
        }
        color("#cce") translate([ 4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);
        color("#cce") translate([-4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);

        pluglen = 32.5;
        color("#975") translate([0, 0, -pluglen]) {
            minkowski() {
                cylinder(pluglen, 10.5/2, 10.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
            translate([0, -4, 7.5]) rotate([90,0,0]) cylinder(20, 7.5, 5, $fn=48);
        }
    }
}

module powerplug_f()
{
    rotate([90,0,-90]) {
        color("#543") difference() {
            translate([0,0,4.2/2]) cube([35, 15, 4.2], true);
            translate([ 14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
            translate([-14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
        }
        color("#543") translate([0,0,-0.9]) {
            minkowski() {
                cylinder(14.6, 12.5/2, 12.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
        }
        color("#cce") translate([ 4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);
        color("#cce") translate([-4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);

        pluglen = 32.5;
        color("#975") translate([0, 0, -pluglen]) {
            minkowski() {
                cylinder(pluglen, 10.5/2, 10.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
            *translate([0, -4, 7.5]) rotate([90,0,0]) cylinder(20, 7.5, 5, $fn=48);
        }
    }
}


module powerplug(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);

    bothi = 23;

    translate([0,52+15/2,rcz-bothi-2-0.2 + pluginset]) {
        color("#543") difference() {
            translate([0,0,4.2/2]) cube([35, 15, 4.2], true);
            translate([ 14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
            translate([-14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
        }
        color("#543") translate([0,0,-0.9]) {
            minkowski() {
                cylinder(14.6, 12.5/2, 12.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
        }
        color("#cce") translate([ 4.2, 2.7, 18]) cube([3.3, 0.7, 8], true);
        color("#cce") translate([-4.2, 2.7, 18]) cube([3.3, 0.7, 8], true);

        if (1) {
        pluglen = 32.5;
        color("#654") translate([0, 0, -pluglen]) {
            minkowski() {
                cylinder(pluglen, 10.5/2, 10.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
            translate([0, -4, 7.5]) rotate([90,0,0]) cylinder(20, 7.5, 5, $fn=48);
        }
        } else {
        pluglen = 26;
        color("#654") translate([0, 0, -pluglen]) {
            minkowski() {
                cylinder(pluglen, 10.5/2, 10.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
            translate([6, 0, 4.5]) rotate([0,90,0]) cylinder(20, 4.5, 4, $fn=48);
        }
        }
    }
}

module psu(xof=xsof*butsp, bof=10, zof=-2.3)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    // echo("RCX = ", rcx);
    rcz = (cz-2*cxy)/sqrt(3);
    color("#543") translate([16/2,0,rcz+43/2-23+6.1]) cube([158 - 16, 98, 43], true);
    color("#543") translate([0,0,rcz+12/2-23+6.1]) cube([158, 98, 12], true);
}

module bottomfeet(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    ihr = (rcx-5) * sqrt(3)/2;
    bothi = 25;
    for (an=[0:60:300]) rotate([0,0,an]) translate([0, ihr+3, rcz-bothi]) bottomfoot();
}

module bottomfoot(fh=foothi, cp=48)
{
    an = 360/cp;
    polyhedron(convexity=5,
        points = concat(
            zcircle(0, 0, 0, 14, an),
            zcircle(0, 0, -2, 14, an),
            zcircle(0, 0, -foothi, 10, an),
            zcircle(0, 0, -foothi, 5, an),
            zcircle(0, 0, -2, 5, an),
            zcircle(0, 0, -2, boltrad, an),
            zcircle(0, 0, 0, boltrad, an),
            []
        ), faces = concat(
            [for (z=[0:5]) each nquads(z*cp, cp, cp)],
            nquads(6*cp, cp, -6*cp),
            []
        ));
}

module bottomfoothole(fh=foothi, tol=0.4, cp=48)
{
    an = 360/cp;
    polyhedron(convexity=5,
        points = concat(
            zcircle(0, 0, 0.01, 14+tol, an),
            zcircle(0, 0, -2-tol, 14+tol, an),
            zcircle(0, 0, -foothi-tol, 10+tol, an),
            []
        ), faces = concat(
            [bface(0, cp)],
            [for (z=[0:1]) each nquads(z*cp, cp, cp)],
            [tface(cp*2, cp)],
            []
        ));
}

module pipeholetpl(bof=10, zof=-2.3, thi=2.0, tol=0.2, cp=240)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;
    br2 = 126/2;

    ethi = 1.2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = 40;
    hei = 120;

    rimh = 35;

    sa = 0;
    ea = 359;

    ho = botholeoff;
    ihr = (rcx-5) * sqrt(3)/2;

    tly = 5;

    tcp = cp;

    translate([0,0,rcz-bothi-thi]) {
        difference() {
            polyhedron(convexity=6, points=concat(
                zbcirclearc(-poleholehi-10, br2+1.2, 360/cp, sa, ea),
                zbcirclearc(-poleholehi-10, br2, 360/cp, sa, ea),
                zbcirclearc(-rimh, br2, 360/cp, sa, ea),
                zbcirclearc(-rimh, br2-5, 360/cp, sa, ea),
                zbcirclearc(-rimh+1, br2-5, 360/cp, sa, ea),
                zbcirclearc(-rimh+1, br2+1.2, 360/cp, sa, ea),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*tcp, tcp, tcp)],
                nquads(tly*tcp, tcp, -tly*tcp),
                []
            ));

            // Holes for bolts and nuts
            for (an=[0:120:240]) rotate([0,0,an])
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-35]) {
                translate([0,br2-1,-poleholehi]) rotate([-90,0,0]) cylinder(15, 1.5, 1.5, $fn=32);
                *translate([0,br2+3,-poleholehi]) translate([-5.5/2-5,0,-5.5/2]) cube([5.5+5,2.4,5.5]);
                *translate([0,br2+3,-poleholehi]) translate([-5.5/2,0,-5.5/2]) cube([5.5,2.4,5.5+6]);
            }

        }
    }
}

module bottomblob(bof=10, zof=-2.3, thi=2.0, tol=0.2, cp=480)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;
    br2 = 126/2;

    ethi = 1.2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = 80;
    hei = 120;

    rimh = 35;

    sa = 30;
    ea = sa+120;

    ho = botholeoff;
    ihr = (rcx-5) * sqrt(3)/2;

    tly = nly+5;

    tcp = (cp/3)+1;

    translate([0,0,rcz-bothi-thi]) {
        difference() {
            polyhedron(convexity=6, points=concat(
                [for (z=[0:nly]) each zbcirclearc(-z*hei/nly, bra+brd*cos(z*180/nly), 360/cp, sa, ea) ],
                zbcirclearc(-hei, br2, 360/cp, sa, ea),
                zbcirclearc(-rimh, br2, 360/cp, sa, ea),
                zbcirclearc(-rimh, br2-5, 360/cp, sa, ea),
                zbcirclearc(-rimh+3, br2-5, 360/cp, sa, ea),
                zbcirclearc(0, br2-6+rimh, 360/cp, sa, ea),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*tcp, tcp, tcp, 1)],
                nquads(tly*tcp, tcp, -tly*tcp, 1),
                [[for (z=[0:tly]) z*tcp+tcp-1]],
                [[for (z=[tly:-1:0]) z*tcp]],
                []
            ));
            // Screw holes
            for (an=[240,300]) rotate([0,0,an]) {
                translate([0,ho,-hei/2-9]) cylinder(hei/2+9-2, 5, 5, $fn=32);
                translate([0,ho,-2.01]) cylinder(2.02, boltrad, boltrad, $fn=32);
                *translate([0,ho,-hei/2-3.5]) rotate([45,0,0]) {
                    rotate([0,0,45]) cylinder(20, 14, 7, $fn=4);
                    #translate([ 10, 0, 10]) rotate([0,-15, 0]) cube([6,5,5], true);
                    #translate([-10, 0, 10]) rotate([0, 15, 0]) cube([6,5,5], true);
                }
            }
            // Holes for feet
            for (an=[240,300]) rotate([0,0,an]) translate([0, ihr+3, 0]) bottomfoothole();

            // Holes for extra lights
            for (an=[240,300]) rotate([0,0,an]) {
                translate([0, ho, -hei/2-0]) rotate([45,0,0]) {
                    translate([0,0,3]) cylinder(17, 4, 4, $fn=32);
                    // translate([0,0,40/2+12.5+7]) cube([12,10,40], true);
                    translate([12/2,0,12.5+7]) rotate([0,-90,0]) linear_extrude(height=12) polygon([
                        [0,-5],[31,-5],[30,5],[28,5],[28,8],[22,5],[0,5]
                    ]);
                }
                /*
                *translate([-10/2, ho-16, -hei/2+25]) {
                    rotate([0,90,0]) linear_extrude(height=10) polygon([
                        [0,7],[9,7],[16,0],[16,-22],[0,-22]
                    ]);
                }
                */
            }

            // Holes for bolts and nuts
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-35]) {
                translate([0,br2-1,-poleholehi]) rotate([-90,0,0]) cylinder(15, 1.5, 1.5, $fn=32);
                translate([0,br2+3,-poleholehi]) translate([-5.5/2-5,0,-5.5/2]) cube([5.5+5,2.4,5.5]);
                *translate([0,br2+3,-poleholehi]) translate([-5.5/2,0,-5.5/2]) cube([5.5,2.4,5.5+6]);
            }

            // Small holes for connecting parts
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-30]) {
                phd = sqrt(2);
                translate([-0.01, br2+ 5, -32]) rotate([0,90,0]) cylinder(10.01, phd, phd, $fn=4);
                translate([-0.01, br2+35, -5]) rotate([0,90,0]) cylinder(10.01, phd, phd, $fn=4);
                translate([-0.01, br -10, -5]) rotate([0,90,0]) cylinder(10.01, phd, phd, $fn=4);
                translate([-0.01, br2+ 5, -90]) rotate([0,90,0]) cylinder(10.01, phd, phd, $fn=4);
            }
        }
    }
}

module bottomblobmid(bof=10, zof=-2.3, thi=2.0, tol=0.2, cp=120)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;
    br2 = 126/2;

    ethi = 1.2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = 40;
    mly = 28;
    hei = 120;

    cwid = bra+brd*cos(mly*180/nly);

    rimh = 35;

    ho = botholeoff;
    ihr = (rcx-5) * sqrt(3)/2;

    // tly = nly+5;
    tly = (nly-mly)+8;

    translate([0,0,rcz-bothi-thi]) {
        difference() {
            polyhedron(convexity=6, points=concat(
                [for (z=[mly:nly]) each zbcircle(0, 0, -z*hei/nly, bra+brd*cos(z*180/nly), 360/cp) ],
                zbcircle(0, 0, -hei, br2, 360/cp),
                zbcircle(0, 0, -rimh, br2, 360/cp),
                zbcircle(0, 0, -rimh, br2-5, 360/cp),
                zbcircle(0, 0, -rimh+3, br2-5, 360/cp),
                zbcircle(0, 0, -rimh+3, cwid, 360/cp),
                zbcircle(0, 0, -rimh+3, cwid+12, 360/cp),
                zbcircle(0, 0, -rimh, cwid+12, 360/cp),
                zbcircle(0, 0, -rimh-12, cwid, 360/cp),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
                nquads(tly*cp, cp, -tly*cp),
                []
            ));
            for (an=[30:120:270], an2=[-50,50]) rotate([0,0,an+an2]) {
                translate([0,br2-1,-poleholehi]) rotate([-90,0,0]) cylinder(20, 2, 2, $fn=32);
            }
            for (an=[90:120:359]) rotate([0,0,an]) {
                translate([0,cwid+12,-50]) linear_extrude(height=50) polygon([
                    [0,-10],[10,0],[-10,0]
                ]);
            }
        }
    }
}

function zbcircle(x,y,z,d,an) = [
    for (a = [0:an:360-an]) [x+d*sin(a),y+d*cos(a),z]
];

module bottomblobside(bof=10, zof=-2.3, thi=2.0, tol=0.2, cp=120)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;
    br2 = 126/2;

    ethi = 1.2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = 40;
    mly = 28;
    hei = 120;

    cwid = bra+brd*cos(mly*180/nly);

    rimh = 35;

    ho = botholeoff;
    ihr = (rcx-5) * sqrt(3)/2;

    // tly = nly+5;
    tly = (mly)+3;

    tcp = (cp/3)+1;

    translate([0,0,rcz-bothi-thi]) {
        difference() {
            union() {
                polyhedron(convexity=6, points=concat(
                    [for (z=[0:mly]) each zbcirclearc(-z*hei/nly, bra+brd*cos(z*180/nly), 360/cp, 30, 150) ],
                    zbcirclearc(-rimh-12, cwid, 360/cp, 30, 150),
                    zbcirclearc(-rimh, cwid+12, 360/cp, 30, 150),
                    zbcirclearc(0, cwid+12, 360/cp, 30, 150),
                    []
                ), faces = concat(
                    [for (z=[0:tly-1]) each nquads(z*tcp, tcp, tcp, 1)],
                    nquads(tly*tcp, tcp, -tly*tcp, 1),
                    [[for (z=[0:tly]) z*tcp+tcp-1]],
                    [[for (z=[tly:-1:0]) z*tcp]],
                    []
                ));
                for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-30]) {
                    translate([0,cwid+12,-50]) linear_extrude(height=50) polygon([
                        [0,-10],[10,0],[0,10]
                    ]);
                }
            }
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-40]) {
                translate([0,cwid-1,-poleholehi]) rotate([-90,0,0]) cylinder(15, 2, 2, $fn=32);
                *translate([0,cwid+3,-poleholehi]) translate([-5.5/2-5,0,-5.5/2]) cube([5.5+5,2.4,5.5]);
                translate([0,cwid+3,-poleholehi]) translate([-5.5/2,0,-5.5/2]) cube([5.5,2.4,5.5+6]);
            }
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-30]) {
                phd = sqrt(2);
                translate([-0.01, cwid+10, -5]) rotate([0,90,0]) cylinder(5.01, phd, phd, $fn=4);
                translate([-0.01, br-10, -5]) rotate([0,90,0]) cylinder(5.01, phd, phd, $fn=4);
                translate([-0.01, cwid+5, -70]) rotate([0,90,0]) cylinder(5.01, phd, phd, $fn=4);
            }
            for (an=[240,300]) rotate([0,0,an]) {
                translate([0,ho,-hei/2-9]) cylinder(hei/2+9-2, 5, 5, $fn=32);
                translate([0,ho,-2.01]) cylinder(2.02, boltrad, boltrad, $fn=32);
                *translate([0,ho,-hei/2-3.5]) rotate([45,0,0]) {
                    rotate([0,0,45]) cylinder(20, 14, 7, $fn=4);
                    #translate([ 10, 0, 10]) rotate([0,-15, 0]) cube([6,5,5], true);
                    #translate([-10, 0, 10]) rotate([0, 15, 0]) cube([6,5,5], true);
                }
            }
            for (an=[240,300]) rotate([0,0,an]) translate([0, ihr+3, 0]) bottomfoothole();
        }
    }
}

function zbcirclearc(z,d,an,s,e) = [
    for (a = [s:an:e]) [d*sin(a),d*cos(a),z]
];

module bottomring(bof=10, zof=-2.3, thi=2.0, tol=0.2, cp=120)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;
    br2 = 126/2;

    ethi = 1.2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = 40;
    mly = 28;
    hei = 120;

    cwid = bra+brd*cos(mly*180/nly);

    rimh = 35;

    ho = botholeoff;
    ihr = (rcx-5) * sqrt(3)/2;

    tly = 5;

    tcp = (cp/3)+1;

    translate([0,0,rcz-bothi-thi]) {
        difference() {
            polyhedron(convexity=6, points=concat(
                zbcirclearc(-rimh+3, cwid+12-tol, 360/cp, 30, 150),
                zbcirclearc(-rimh+3, br2-5, 360/cp, 30, 150),
                zbcirclearc(-rimh+5, br2-5, 360/cp, 30, 150),
                zbcirclearc(-10, cwid+2, 360/cp, 30, 150),
                zbcirclearc(0, cwid+ 2, 360/cp, 30, 150),
                zbcirclearc(0, cwid+12-tol, 360/cp, 30, 150),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*tcp, tcp, tcp, 1)],
                nquads(tly*tcp, tcp, -tly*tcp, 1),
                [[for (z=[0:tly]) z*tcp+tcp-1]],
                [[for (z=[tly:-1:0]) z*tcp]],
                []
            ));
            for (m=[0,1]) mirror([0,m,0]) rotate([0,0,-30]) {
                translate([0,cwid+12,-rimh+3-0.01]) linear_extrude(height=rimh-3+0.02) polygon([
                    [0,-10-tol],[10+tol,0],[-0.1,0]
                ]);
            }
        }
    }

}

module plugcase(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    w = 38; // width
    h = 17; // height
    l = 21; // length
    d = 11; // diagonal
    s = 8; // inset
    t = thi; // thickness
    s2 = 1/sqrt(2);

    d2 = d * (h/l);
    d3 = d2-t*s2;

    fw = 14;
    ft = 1.6;
    translate([-plugoffset-4.2, 0, rcz-bothi-2]) {
        difference() {
            union() {
                translate([-l/2, (w/2+fw/2-1),2+ft/2]) cube([l, fw, ft], true);
                translate([-l/2,-(w/2+fw/2-1),2+ft/2]) cube([l, fw, ft], true);
                translate([-l-2/2, 0, 2+6/2]) cube([2, w, 6], true);
                polyhedron(convexity=5, points=[
                    [-d,-w/2+d,-h], [-d, w/2-d,-h], [-l, w/2-d,-d2],    [-l,-w/2+d,-d2],
                    [ 0,-w/2,-h],   [ 0, w/2,-h],   [-l,   w/2,0],    [-l,  -w/2,0],
                    [ 0,-w/2,s],    [ 0, w/2,s],    [-l,   w/2,s],    [-l,  -w/2,s],
                    [-t,-w/2+t,s],  [-t, w/2-t,s],  [-l+t, w/2-t,s],  [-l+t,-w/2+t,s],
                    [-t,-w/2+t,-h+t], [-t, w/2-t,-h+t], [-l+t, w/2-t,0], [-l+t,-w/2+t,0],
                    [-d+t*s2,-w/2+d,-h+t], [-d+t*s2, w/2-d,-h+t], [-l+t, w/2-d,-d3],    [-l+t,-w/2+d,-d3],
                    []
                    ], faces=concat(
                    [bface(0,4)],
                    nquads(0,4,4),
                    nquads(4,4,4),
                    nquads(8,4,4),
                    nquads(12,4,4),
                    nquads(16,4,4),
                    [tface(20,4)],
                    []
                ));
                translate([-2-3.8/2,  14, -12.5/2-2-1.2/2]) cube([3.8, 8, 6+1.2], true);
                translate([-2-3.8/2, -14, -12.5/2-2-1.2/2]) cube([3.8, 8, 6+1.2], true);

                translate([-2-3.8,  14, -12.5/2-2]) rotate([0,-90,0]) cylinder(4, 3, 3, $fn=24);
                translate([-2-3.8, -14, -12.5/2-2]) rotate([0,-90,0]) cylinder(4, 3, 3, $fn=24);
            }
            translate([-l+2+0.01, 12, 4]) rotate([0,-90,0]) {
                minkowski() {
                    cylinder(t+2.02, 1.9, 1.9, $fn=24);
                    cube([0.001, 2, 0.001], true);
                }
            }
            translate([0.01, 0, -12.5/2-2]) rotate([0,-90,0]) {
                minkowski() {
                    cylinder(t+0.02+3.8, 12.9/2, 12.9/2, $fn=48);
                    cube([0.001, 8, 0.001], true);
                }
                translate([0, 14, 0]) cylinder(8.02, 1.5, 1.5, $fn=24);
                translate([0,-14, 0]) cylinder(8.02, 1.5, 1.5, $fn=24);

            }
            translate([-2-2.8/2, 14, -12.5/2-2]) cube([2.8, 6, 6.01], true);
            translate([-2-2.8/2,-14, -12.5/2-2]) cube([2.8, 6, 6.01], true);
        }
        // sacrificial layers
        #translate([-2-2.8-0.2/2,  14, -12.5/2-2]) cube([0.2, 5, 5], true);
        #translate([-2-2.8-0.2/2, -14, -12.5/2-2]) cube([0.2, 5, 5], true);
        #translate([-l+2-0.1, 12, 4]) cube([0.2, 6, 4], true);
    }
}

module bottomplate1(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    bz = 30;

    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 25;

    rx = rcx+2;

    t = 0.001;

    union() {
        difference() {
            intersection() {
                bottomplate();
                translate([0,0,rcz-bothi-0.01]) linear_extrude(convexity=4, height=bz) polygon([
                    [boxx-17, boxy+t], [-boxx, boxy+t], [-boxx,boxy+1.81+t], [-boxx-14.81-t,boxy+1.81+t],
                    [-boxx-14.81-t, boxy+t], [-rx, boxy+t], [-rx, -rx],
                    [boxx-t, -rx], [boxx-t, -boxy-t], [boxx-17, -boxy-t]
                ]);
            }
            translate([0, 0, rcz - bothi]) {
                xpyrrow(-boxx-55, -boxx-14, boxy, 0.1);
                xpyrrow(-boxx, boxx-17, boxy, 0.1);
                ypyrrow(-boxy, boxy, boxx-17, 0.1);
                ypyrrow(-boxy-65, -boxy, boxx, 0.1);
            }
        }
        translate([0, 0, rcz - bothi]) {
            xpyrrow(5-boxx-55, -boxx-14, boxy);
            xpyrrow(5-boxx, boxx-17, boxy);
            ypyrrow(5-boxy, boxy, boxx-17);
            ypyrrow(5-boxy-65, -boxy, boxx);
        }
    }
}

module bottomplate2(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    bz = 30;

    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 25;

    rx = rcx+2;

    t = 0.001;

    union() {
        difference() {
            intersection() {
                bottomplate();
                translate([0,0,rcz-bothi-0.01]) linear_extrude(convexity=4, height=bz) polygon([
                    [boxx-t, -rx], [boxx-t, -boxy-t], [boxx-17, -boxy-t],
                    [boxx-17, boxy+t], [boxx+2, boxy+t],
                    [boxx+2, rx], [rx, rx], [rx, -rx]
                ]);
            }
            translate([0, 0, rcz - bothi]) {
                ypyrrow(5-boxy, boxy, boxx-17, 0.1);
                ypyrrow(5-boxy-65, -boxy, boxx, 0.1);
                ypyrrow(5+boxy, boxy+65, boxx+2, 0.1);
            }
        }
        translate([0, 0, rcz - bothi]) {
            ypyrrow(-boxy, boxy, boxx-17);
            ypyrrow(-boxy-65, -boxy, boxx);
            ypyrrow(boxy, boxy+65, boxx+2);
        }
    }
}

module bottomplate3(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    bz = 30;

    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 25;

    rx = rcx+2;

    t = 0.001;

    union() {
        difference() {
            intersection() {
                bottomplate();
                translate([0,0,rcz-bothi-0.01]) linear_extrude(convexity=4, height=bz) polygon([
                    [boxx+2, boxy+t], [-boxx, boxy+t], [-boxx,boxy+1.81+t], [-boxx-14.81-t,boxy+1.81+t],
                    [-boxx-14.81-t, boxy+t], [-rx, boxy+t], [-rx, rx],
                    [boxx+2, rx]
                ]);
            }
            translate([0, 0, rcz - bothi]) {
                xpyrrow(5-boxx-55, -boxx-14, boxy, 0.1);
                xpyrrow(5-boxx, boxx-17, boxy, 0.1);
                ypyrrow(boxy, boxy+65, boxx+2, 0.1);
            }
        }
        translate([0, 0, rcz - bothi]) {
            xpyrrow(-boxx-55, -boxx-14, boxy);
            xpyrrow(-boxx, boxx-17, boxy);
            ypyrrow(5+boxy, boxy+65, boxx+2);
        }
    }
}

module xpyrrow(st, en, y, tol = 0)
{
    for (x=[st+5:10:en-5]) {
        translate([x, y, -tol]) cylinder(2+tol, 2+tol*2, tol, $fn=4);
    }
}

module ypyrrow(st, en, x, tol = 0)
{
    for (y=[st+5:10:en-5]) {
        translate([x, y, -tol]) cylinder(2+tol, 2+tol*2, tol, $fn=4);
    }
}

module bottomplate(xof=xsof*butsp, bof=10, zof=-2.3, thi=2.0, tol=0.2)
{
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);
    bothi = 23;

    br = rcx+1.3;

    ho = botholeoff;

    psul = 158;
    psuw = 98;
    psuh = 26;
    strt = 2;
    psuho = 16;
    ex = strt*2+tol*2;

    ihr = (rcx-5) * sqrt(3)/2;
    translate([0,0,rcz-bothi]) {
        difference() {
            union() {
                // Plate
                translate([0,0,-thi]) cylinder(thi, br, br, $fn=240);

                // Side struts
                for (an=[0:60:300]) rotate([0,0,an]) {
                    sth = 10;
                    stl = (an % 180) ? 46.8 : 66;
                    translate([0, ihr-1-tol, sth/2]) cube([82,2,sth], true);
                    translate([ 40, ihr-1-tol-stl/2, sth/2]) cube([2,stl,sth], true);
                    translate([-40, ihr-1-tol-stl/2, sth/2]) cube([2,stl,sth], true);
                }

                // Nut holders
                for (an=[0:60:300]) {
                    translate([ho*sin(an), ho*cos(an), 2.5]) cube([14.8,6,5], true);
                }

                // Struts for psu
                translate([ (psul/2+strt/2+tol), 0, psuh/2]) cube([strt,psuw+ex,psuh], true);
                translate([-(psul/2+strt/2+tol), 0, psuho/2]) cube([strt,psuw+ex,psuho], true);
                translate([0, (psuw/2+strt/2+tol), psuh/2]) cube([psul+ex,strt,psuh], true);
                translate([0,-(psuw/2+strt/2+tol), psuh/2]) cube([psul+ex,strt,psuh], true);

                // Feet for psu (and nuts)
                translate([ (psul/2-8),  (psuw/2-8), 6/2]) cube([17,17,6], true);
                translate([ (psul/2-8), -(psuw/2-8), 6/2]) cube([17,17,6], true);
                translate([-(psul/2-8),  (psuw/2-8), 6/2]) cube([17,17,6], true);
                translate([-(psul/2-8), -(psuw/2-8), 6/2]) cube([17,17,6], true);

                if (vertpc) {
                    // Case for power connector
                    translate([0, 52+15/2, pluginset]) {
                        translate([0,0,4/2-pluginset/2]) cube([40, 20, 4+pluginset], true);
                        translate([0,0,4+22/2]) cube([23.1, 16.6, 22], true);
                        *translate([0,0,4]) minkowski() {
                            cylinder(22, 15.1/2, 15.1/2, $fn=48);
                            cube([8, 0.001, 0.001], true);
                        }
                        *translate([0,-5,4+22/2]) cube([23, 10, 22], true);
                        translate([0,0,4+4/2]) cube([28+6, 10, 4], true);
                    }
                }

                // Extra walls for gluing
                translate([psul/2, -psuw/2, 0]) linear_extrude(height=psuh) polygon([
                    [0,-2.2],[0,-4.2],[-20,-4.2],[-22,-2.2]
                ]);
                translate([psul/2, psuw/2+2.2, 0]) rotate([90,0,180])
                    linear_extrude(height=2) polygon([
                        [0,14], [8,6], [8,0], [psul,0], [psul,psuh], [0,psuh]
                    ]);
                translate([psul/2+0.2, psuw/2, 0]) linear_extrude(height=10) polygon([
                    [0,-4], [0,42], [2,44], [4,41], [4,0]
                ]);
                translate([psul/2+0.2, -psuw/2, 0]) linear_extrude(height=10) polygon([
                    [-2,0], [-2,-42], [2,-44], [2,0]
                ]);
            }

            // PSU bolt holes
            translate([-(psul/2-4), -(psuw/2-5), 6]) {
                translate([0,0,-7]) cylinder(7.01, boltrad, boltrad, $fn=24);
                translate([0,2.5,-1.4-2.8/2]) cube([6,20,2.8], true);
            }
            translate([ (psul/2-2.8),  (psuw/2-7.5), 6]) {
                translate([0,0,-7]) cylinder(7.01, boltrad, boltrad, $fn=24);
                translate([0,0,-1.4-2.8/2]) cube([6,20,2.8], true);
            }

            // Bolt+nut holes to lower
            for (an=[0:60:300]) {
                translate([ho*sin(an), ho*cos(an), -thi-0.01]) cylinder(thi+8+0.02, boltrad, boltrad, $fn=32);
                translate([ho*sin(an), ho*cos(an), 2.8/2]) cube([6, 12.41, 2.8], true);
            }

            uo = ihr+3;
            // Bolt holes to upper
            for (an=[0:60:300]) {
                translate([uo*sin(an), uo*cos(an), -thi-0.01]) cylinder(thi+0.02, boltrad, boltrad, $fn=32);
            }

            hd = 1.9;
            // od = 50;
            // nd = floor(od/(3*hd));
            nd = 8;
            // Air holes
            for (d=[1:nd], an=[360/(d*6)+30:360/(d*6):360+30]) {
                translate([sin(an)*d*hd*3, cos(an)*d*hd*3, -thi-0.01])
                cylinder(thi+0.02, hd, hd, false, $fn=24);
            }

            if (vertpc) {
                // Hole for c5 connector
                translate([0,52+15/2,-thi+pluginset]) {
                    translate([0,0,4.2/2-pluginset/2]) cube([35.4, 15.6, 4.21+pluginset], true);
                    translate([0,0,26/2]) cube([20.8, 12.8, 26], true);
                    *minkowski() {
                        cylinder(26, 12.7/2, 12.7/2, $fn=48);
                        cube([8, 0.001, 0.001], true);
                    }
                    translate([ 14, 0, 4.1]) cylinder(6, 1.5, 1.5, $fn=24);
                    translate([-14, 0, 4.1]) cylinder(6, 1.5, 1.5, $fn=24);
                    translate([0,0,thi+4+2.8/2]) cube([28+6+0.01, 6, 2.8], true);
                    *translate([-4, -3.3, 20]) rotate([0,-90,0]) cylinder(8, 3, 3, $fn=24);
                    translate([-4, -4.6, 20]) rotate([0,-90,0]) {
                        minkowski() {
                            cylinder(8, 1.8, 1.8, $fn=24);
                            cube([2, 0.001, 0.001], true);
                        }
                    }
                }

                // Hole for ty-rapping 220v cable
                translate([-72, 50, 22]) cube([10, 2.5, 2], true);
            } else { // not vertpc
                translate([-plugoffset-4.2-21/2, 0, -thi/2]) {
                    cube([21.4, 38.4, thi+0.02], true);
                }
                translate([-plugoffset-4.2-23+0.01, 12, 2]) rotate([0,-90,0]) {
                    minkowski() {
                        cylinder(2.02, 1.8,1.8, $fn=24);
                        cube([0.001, 2, 0.001], true);
                    }
                }
            }
        }
        if (vertpc) {
            // Connector sacrificial layers
            #translate([0,52+15/2, pluginset]) {
                translate([ 14, 0, 6.8+0.1]) cube([4,4,0.2], true);
                translate([-14, 0, 6.8+0.1]) cube([4,4,0.2], true);
            }
        }

        // PSU bolt holes sacrificial layers
        #translate([-(psul/2-4), -(psuw/2-5), 6]) {
            translate([0,0,-1.4+0.2/2]) cube([4,4,0.2], true);
        }
        #translate([ (psul/2-2.8),  (psuw/2-7.5), 6]) {
            translate([0,0,-1.4+0.2/2]) cube([4,4,0.2], true);
        }

        // Bolt holes sacrificial layers
        #for (an=[0:60:300]) {
            translate([ho*sin(an), ho*cos(an), 2.8+0.2/2]) cube([4,4, 0.2], true);
        }

    }
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
    ihr = (rcx-5) * sqrt(3)/2;

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
        // Bolt holes for cube mount
        botboltoff = (numbut+0.5)*butsp-ewid/2-3;
        for (an=[0:120:240]) rotate([0,0,an])
        rotate([0,180+atan(sqrt(2)),0]) rotate([0,0,135]) {
            for (y=[1:2:numbut-1]) {
                translate([botboltoff, (y+0.5)*butsp, 2.3]) cylinder(2.2, boltrad, boltrad, $fn=32);
                translate([(y+0.5)*butsp, botboltoff, 2.3]) cylinder(2.2, boltrad, boltrad, $fn=32);
            }
        }
        // Bolt holes for bottom plate
        for (an=[0:60:300]) rotate([0,0,an]) {
            translate([0, ihr+3, rcz-bothi-0.01]) cylinder(8.01, boltrad, boltrad, $fn=24);
            translate([0, ihr+3, rcz-bothi+2+2.8/2]) cube([6,6.2,2.8], true);
        }

        nd1 = 2.8;
        nd2 = nd1 + 2.8;
        nd3 = 8;
        nw1 = boltrad;
        nw2 = 3.2;
        boltslot = [
            [-nw1, 0.01], [-nw1, -nd1], [-nw2, -nd1],
            [-nw2, -nd2], [-nw1, -nd2], [-nw1, -nd3],
            [ nw1, -nd3], [ nw1, -nd2], [ nw2, -nd2],
            [ nw2, -nd1], [ nw1, -nd1], [ nw1, 0.01] ];
        // Bolt slots for electronics
        translate([52, -ihr, rcz-bothi-0.01]) linear_extrude(height=60, convexity=4)
            polygon(boltslot);
        translate([2-(65.6/2-5.0), -ihr, rcz-bothi-0.01]) linear_extrude(height=23, convexity=4)
            polygon(boltslot);
        translate([2+(65.6/2-16.8), -ihr, rcz-bothi-0.01]) linear_extrude(height=23, convexity=4)
            polygon(boltslot);
    }
    // Bolt holes for bottom plate, sacrificial layer
    #for (an=[0:60:300]) rotate([0,0,an]) {
        translate([0, ihr+3, rcz-bothi+2+2.8+0.1]) cube([4,4,0.2], true);
    }
}

module bottomsideconnect(xof=xsof*butsp, bof=10, zof=-2.3, tol=0.1)
{
    bothi = 22;
    cxy = (numbut+0.5)*butsp-ewid/2;
    cz = bof+zof+2;
    rcx = (cxy+cz)*sqrt(2/3);
    rcz = (cz-2*cxy)/sqrt(3);

    connh = 10;
    cx = 10/2;
    cy = 6/2-tol;
    ct = 2/2-tol;

    translate([rcx-5, 0, rcz-bothi-1]) linear_extrude(height=connh-tol, convexity=6) polygon([
        [-cy,-cx-ct], [-cy,-cx+ct], [-ct,-cx+ct],
        [-ct, cx-ct], [-cy, cx-ct], [-cy, cx+ct],
        [ cy, cx+ct], [ cy, cx-ct], [ ct, cx-ct],
        [ ct,-cx+ct], [ cy,-cx+ct], [ cy,-cx-ct]
    ]);
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
            rotate([0,0,-120]) bottomside(xof,bof,zof,tol);
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

module cubeedgewhite(xof=xsof*butsp, bof=10, zof=-2.3, thi=1, tol=0.2, cp=32)
{
    sd = butsp-xof*2;
    rd = bof+zof+xof;
    an = 90/cp;
    an2 = 45/cp;

    br = butdia/2;

    esta = asin((ewid/2)/br);
    cnf = ceil((esta*2) / an);
    sta = an * cnf / 2;  // recalc so it's an integer number of steps

    ss = 2*(cp+1);
    ss2 = 2*(cnf+1)+1;
    ins1 = 2*ss;
    ins2 = 2*ss+2*ss2;
    ic1 = [0, ss-1, ss, 2*ss-1];
    ic2 = [ss+ss/2-1, ss+ss/2, ss/2-1, ss/2];

    polyhedron(convexity=5,
        points = concat(
            xarc(tol, 0, 0,  rd,     360, 270, -an),
            xarc(tol, 0, 0,  rd+thi, 270, 360,  an),
            xarc(sd-tol, 0, 0, rd,     360, 270, -an),
            xarc(sd-tol, 0, 0, rd+thi, 270, 360,  an),

            [[sd/2+br*cos(180+sta)+tol, sd/2+br*cos(180+sta), rd]],
            zarc(sd/2, sd/2, rd, br, 180+sta, 180-sta, -an2),
            [[sd/2-br*cos(180+sta)-tol, sd/2+br*cos(180+sta), rd]],

            [[sd/2+br*cos(180+sta)+tol, sd/2+br*cos(180+sta), rd+thi]],
            zarc(sd/2, sd/2, rd+thi, br, 180+sta, 180-sta, -an2),
            [[sd/2-br*cos(180+sta)-tol, sd/2+br*cos(180+sta), rd+thi]],

            [[sd/2+br*cos(360+sta)-tol, -rd, -sd/2+br*cos(360+sta)]],
            yarc(sd/2, -rd, -sd/2, br, 360+sta, 360-sta, -an2),
            [[sd/2-br*cos(360+sta)+tol, -rd, -sd/2+br*cos(360+sta)]],

            [[sd/2+br*cos(360+sta)-tol, -(rd+thi), -sd/2+br*cos(360+sta)]],
            yarc(sd/2, -(rd+thi), -sd/2, br, 360+sta, 360-sta, -an2),
            [[sd/2-br*cos(360+sta)+tol, -(rd+thi), -sd/2+br*cos(360+sta)]],
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

module cubeedgeblack(xof=xsof*butsp, bof=10, zof=-2.3, thi=1.2, tol=0.2)
{
    sd = xof*2-0.2;
    difference() {
        union() {
            // Outside
            cubeedge(sd = butsp-ewid, thi = 1.2, rd=bof+zof+xof+1);
            // Middle
            translate([butsp/2-ewid/2-sd/2, 0, 0]) cubeedge(sd = sd, thi = 1.0+tol, rd=bof+zof+xof-tol);
            // Inside
            cubeedgeinside(butsp-ewid, bof-2.8, rd=bof+zof+xof-tol);

            // Outer pieces
            for (m=[0,1]) mirror([0,m,m]) {
                translate([butsp/2-ewid/2,-xof,bof+zof+xof+1])
                    edgefacet(thi=1.2,xof=xsof*holesp*12-0.0101);
                translate([butsp/2-ewid/2,-xof,bof+zof-0.5])
                    edgefacet(thi=xof+0.5-tol,xof=xsof*holesp*12-0.0101);

                // Bits around buttons
                for (m2=[0,1]) translate([butsp/2-ewid/2,-xof,bof+zof+xof-0.3])
                    mirror([m2,0,0]) edgeinset(thi=1.4,xof=xsof*holesp*12);
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

module cubeedgeinside(sd, ins, rd=10, cp=32)
{
    an = 90/cp;
    rotate([0,90,0]) linear_extrude(height=sd, convexity=5) polygon(concat(
        arc(0, 0, rd, 180, 270, an),
        [[-ins,0],[-ins,-ins+2.5],[-ins+2.5,-ins+2.5],[-ins+2.5,-ins],[0,-ins]]
    ));
}

module cubecorner(xof=xsof*butsp, bof=10, zof=-2.3, cp=32, thi=1.2, tol=0.2)
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
    rd = xof+bof+zof+1+thi;
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
        xyzarcs(rd-thi, -sd, cp),
        xyzarcs(rd-thi,   0, cp),
        xyzarcs(rd-thi-1-tol,   0, cp),
        xyzarcs(rd-thi-1-tol, -sd, cp),
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

    br = rd-thi-1-tol;
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
        zarc(-xo, -xo, rd-thi, hrd, sta, 90-sta, an2),
        yarc(-xo, rd,   -xo, hrd, 90-sta, sta, -an2),
        yarc(-xo, rd-thi, -xo, hrd, 90-sta, sta, -an2),
        xarc(rd,   -xo, -xo, hrd, sta, 90-sta, an2),
        xarc(rd-thi, -xo, -xo, hrd, sta, 90-sta, an2),
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

module cubebackedges(xof = xsof*butsp, bof = 10, zof = -2.3, thi=1.2, tol=0.2)
{
    difference() {
        union() {
            cubebackedge(xof, bof, zof, thi);
            translate([0,-zof, -zof]) mirror([0,1,1]) cubebackedge(xof, bof, zof);

            sd = butsp-ewid;
            translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = thi, rd=bof+zof+xof+1);
            translate([numbut*butsp-xof+tol, xof, -(zof+xof)]) cubeedge(sd = butsp/2-ewid/2+xof-tol, thi = 1.2, rd=bof+zof+xof-.2);
            // translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedge(sd = sd, thi = 1.0, rd=bof+zof+xof-1.2);

            // Inside
            translate([(numbut-0.5)*butsp+ewid/2, xof, -(zof+xof)]) cubeedgeinside(butsp-ewid, bof-2.8, rd=bof+zof+xof-tol);
            translate([numbut*butsp+6, numbut*butsp+6, 6]) cube([6,6,2], true);
        }
        translate([0,-zof, -zof]) mirror([0,1,1])
            translate([numbut*butsp+6, numbut*butsp+6, 6]) cube([6,6,2], true);
    }
}

module cubebackedge(xof, bof, zof, thi=1.2, tol=0.2, cp=32)
{
    xo = butsp/2; // offset of hole centers
    backwid = butsp-ewid/2;
    endofs = (numbut-0.5)*butsp;
    whiteof = butsp/2-xof+tol;
    backof = butsp/2+tol;

    an = 90/cp;
    rd = butdia/2;
    esta = asin((ewid/2)/rd);
    cnf = ceil(((esta*2)) / an);
    sta = an * (cnf) / 2;  // recalc so it's an integer number of steps
    sta45 = 45+(an/2)*(1+((cnf+1) % 2)); // Was rounded to half, so compensate

    ctof = (butsp/2)-rd*cos(sta);

    // Edge with cutouts for buttons
    for (z=[1/*,-1.2*/]) translate([(numbut-0.5)*butsp, 0, bof+z]) linear_extrude(height=thi, convexity=4)
        polygon(concat(
            [[ewid/2,xof], [backwid,xof], [backwid,endofs+backwid]],
            [[sin(45)*rd, butsp*(numbut-0.5)+cos(45)*rd]],
            [for (x=[numbut-1:-1:0]) each arc( 0, butsp*(x+0.5), rd, (x==numbut-1?sta45:sta), 180-sta, an)]
        ));

    // Middle bit of edge
    translate([(numbut-0.5)*butsp, 0, bof-0.205])
        linear_extrude(height=1.21) polygon(concat(
            [[whiteof, ctof], [whiteof,xof], [backwid,xof], [backwid, endofs+backwid]],
            [[sin(45)*rd, butsp*(numbut-0.5)+cos(45)*rd]],
            arc( 0, butsp*(numbut-0.5), rd, sta45, 180-sta, an),
            [for (x=[numbut-2:-1:0]) each concat(
                [[whiteof, butsp*(x+1)+ctof],[whiteof, butsp*(x+1)-ctof]],
                arc( 0, butsp*(x+0.5), rd, sta, 180-sta, an)
                )],
            []
        ));

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

module whiteside(xof=xsof*butsp, bof=10, zof=-2.3, nh=numbut, thi=1, eof=0.5-xsof, cp=512)
{
    wid = butsp * (nh-1+2*eof);
    hr = holesp*4;
    an = 360/cp;

    tcs = cp*nh*nh;
    ns = 2*(nh-1);

    tcut = tcs+ns*4;
    tcr = tcut+ns*4;

    esta = 45-asin((ewid/2)/hr);
    cnf = ceil(esta / an);
    sta = an * cnf;  // recalc so it's an integer number of steps
    ctof = hr*cos(45-sta);
    etof = (butsp/2)-ctof;

    color("#eee") translate([0,0,bof])
    linear_extrude(height=thi, convexity=5)
    difference() {
        polygon(points=concat(
            [for (x=[0:nh-1], y=[0:nh-1]) each circle((x+0.5)*butsp, (y+0.5)*butsp, hr, an)],
            ssquare(xof, butsp*nh-xof, nh-1, butsp, butsp-xof, butsp+xof),
            ssquare(etof, butsp*nh-etof, nh-1, butsp, butsp-etof, butsp+etof),
            [for (x=[1:nh-1], y=[1:nh-1]) each rect(x*butsp, y*butsp, facetnutwid, facetnuthei)],
            []
        ), paths=[concat(
            ws_corner(cp, cp/2, 0, 3, cnf, 2*ns, 0, tcs, tcut),
            [for (x=[1:nh-2]) each ws_corner(cp, cp*3/4, nh*x, 2, cnf, 2*x-1, 2*x, tcs, tcut)],
            ws_corner(cp, cp/2, nh*(nh-1), 2, cnf, ns-1, 3*ns, tcs, tcut),
            [for (x=[1:nh-2]) each ws_corner(cp, cp*3/4, nh*(nh-1)+x, 1, cnf, 3*ns+2*x-1, 3*ns+2*x, tcs, tcut)],
            ws_corner(cp, cp/2, nh*nh-1, 1, cnf, 4*ns-1, 2*ns-1, tcs, tcut),
            [for (x=[nh-2:-1:1]) each ws_corner(cp, cp*3/4, nh*x+nh-1, 0, cnf, ns+2*x, ns+2*x-1, tcs, tcut)],
            ws_corner(cp, cp/2, nh-1, 0, cnf, ns, 3*ns-1, tcs, tcut),
            [for (x=[nh-2:-1:1]) each ws_corner(cp, cp*3/4, x, 3, cnf, 2*ns+2*x, 2*ns+2*x-1, tcs, tcut)],
            []
        ),
            for (x=[1:nh-2],y=[1:nh-2]) [for (i=[0:cp-1]) (x+y*nh)*cp+i],
            for (i=[0:(nh-1)*(nh-1)-1]) [for (s=[0:3]) tcr+i*4+s]
        ]);
        for (x=[0:nh-1],y=[0:nh-1]) {
            translate([(x+0.5)*butsp, (y+0.5)*butsp]) square([(ctof)*2,(ctof)*2], true);
        }
    }
}

// Circle part with edge parts
// offset, quadrant, number of points, points to cut
function ws_corner(cp, ns, o, q, c, s1, e1, o1, o2) = concat(
    [s1+o1, s1+o2],
    [for (i=[0+c:ns-c]) o*cp+(i+cp*(q*2+1)/8)%cp],
    [e1+o2, e1+o1]
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

module backendguide(nb = numbut, thi = 0.4)
{
    cwid = butsp-8;
    swid = 20;
    twid = 10;
    bwid = 3;
    hi = 2.6;

    wid = 1.4;
    wid2 = 4.0;
    ext = 0.2;
    translate([0,0.15,0]) union() {
        for (x=[0:nb-1]) {
            translate([x*butsp+9.5, 9.5, -thi]) cube([wid, nb*butsp-19.5, thi]);
        }
        for (y=[0:nb-1]) {
            translate([9.5, y*butsp+9.5, -thi]) cube([nb*butsp-19.5, wid, thi]);
        }
        for (x=[0:nb-1], y=[0:nb-1]) {
            translate([x*butsp+9.5, y*butsp+9.5, -hi]) difference() {
                union() {
                    linear_extrude(height=hi) polygon([
                        [-ext,0],[0,-ext],[wid,-ext],[wid+ext,0],
                        [wid+ext,wid],[wid,wid+ext],[0,wid+ext],[-ext,wid]
                    ]);
                    translate([0,0,1]) linear_extrude(height=hi-1) polygon([
                        [-ext,0],[0,-ext],[wid2,-ext],[wid2+ext,0],
                        [wid2+ext,wid],[wid2,wid+ext],[0,wid+ext],[-ext,wid]
                    ]);
                }
                translate([-ext-0.01, wid/2, 1.8]) rotate([0,90,0]) cylinder(wid2+ext*2+0.02, 0.4, 0.4, $fn=24);
                translate([wid/2, wid+ext+0.01, 0.8]) rotate([90,0,0]) cylinder(wid+ext*2+0.02, 0.4, 0.4, $fn=24);
            }
            translate([x*butsp+19.5, y*butsp+9.5, -hi]) difference() {
                translate([0,0,1]) linear_extrude(height=hi-1) polygon([
                    [0,0],[ext,-ext],[wid-ext,-ext],[wid,0],
                    [wid,wid],[wid-ext,wid+ext],[ext,wid+ext],[0,wid]
                ]);
                translate([-ext-0.01, wid/2, 1.8]) rotate([0,90,0]) cylinder(wid+ext*2+0.02, 0.4, 0.4, $fn=24);
            }
            translate([x*butsp+9.5, y*butsp+19.5, -hi]) difference() {
                linear_extrude(height=hi) polygon([
                    [-ext,ext],[0,0],[wid,0],[wid+ext,ext],
                    [wid+ext,wid-ext],[wid,wid],[0,wid],[-ext,wid-ext]
                ]);
                translate([wid/2, wid+ext+0.01, 0.8]) rotate([90,0,0]) cylinder(wid+ext*2+0.02, 0.4, 0.4, $fn=24);
            }
        }
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
                    rotate([0,0,45]) translate([0, 8.48, 0.6]) cube([7, 0.6, 0.801], true);
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
            rotate([0,0,an]) translate([0, dhoff+0.4, 0.6]) cube([7, 0.8, 0.8], true);
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
            rotate([0,0,an]) translate([0, dhoff+0.4, 0.6]) cube([7, 0.8, 0.8], true);
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
        rotate([0,0,-45]) translate([0, dhoff+0.4, 0.6]) cube([7, 0.8, 0.8], true);

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

module cubeedge(sd = holesp * 48, thi = 1, rd=10, cp=32)
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

module edgeinset(sd = holesp * 48, thi=1, rd=butdia/2, cp=32, xof=xsof*holesp*12)
{
    an = 90/cp;
    xo = butsp/2; // offset of hole centers
    esta = asin((ewid/2)/rd);
    cnf = floor((90-(esta*2)) / an);
    sta = an * (cp-cnf) / 2;  // recalc so it's an integer number of steps
    bkx = xo - rd * cos(sta)-butsp*0.2;
    bky = xo - rd * sin(sta)-butsp*0.2;
    bk = xo - rd * cos(sta);
    linear_extrude(height=thi, convexity=4) polygon(concat(
        // [[bkx,bky],[bky,bkx]],
        [[bk,bk]],
        arc(xo, xo, rd, 180+sta, 270-sta, an),
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

    linear_extrude(convexity=5, height=thi) polygon(concat(
        [[ xo-ewid/2, xof ]],
        arc( xo, xo, rd, 180+sta, 270-sta, an),
        arc(-xo, xo, rd,  90+sta, 180-sta, an),
        [[-xo+ewid/2, xof ]],
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

module sidefacet(sd = holesp * 48, thi=1.2, rd=butdia/2, cp=32)
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
            linear_extrude(convexity=5, height=thi) polygon(concat(
                arc(-xo, -xo, rd,   0+sta,  90-sta, an),
                arc( xo, -xo, rd, 270+sta, 360-sta, an),
                arc( xo,  xo, rd, 180+sta, 270-sta, an),
                arc(-xo,  xo, rd,  90+sta, 180-sta, an),
                []
            ));
            translate([0,0,-(facetnutthi-ngap)/2]) cube([facetnutwid-0.2,facetnuthei-0.2,facetnutthi-ngap], true);
            for (an=[0:90:270]) rotate([0,0,an])
                translate([0,0,-1]) edgeinset(thi=1.01);
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

module footmid(idia=90, pdia=126, dia=155, hei=111.8, ehei=10, ethi=6, bthi=15, bot=44, cp=60)
{
    tly = 9;
    br2 = pdia/2;
    difference() {
        polyhedron(convexity=5,
            points = concat(
                zbcircle(0, 0, bot,  dia/2, 360/cp),
                zbcircle(0, 0, bot, idia/2, 360/cp),
                zbcircle(0, 0, bot+bthi, idia/2, 360/cp),
                zbcircle(0, 0, bot+bthi, pdia/2, 360/cp),
                zbcircle(0, 0, hei+ehei-ethi, pdia/2, 360/cp),
                zbcircle(0, 0, hei+ehei-ethi+0.4, pdia/2+0.4, 360/cp),
                zbcircle(0, 0, hei+ehei-ethi+0.4, pdia/2+ethi-0.4, 360/cp),
                zbcircle(0, 0, hei+ehei-ethi, pdia/2+ethi, 360/cp),
                zbcircle(0, 0, hei-ethi, pdia/2+ethi, 360/cp),
                zbcircle(0, 0, hei-(dia-pdia)/2,  dia/2, 360/cp),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
                nquads(tly*cp, cp, -tly*cp),
                []
            ));
        // Screw holes
        for (an=[0:90:360-90]) {
            rotate([0,0,an+6]) {
                translate([br2+1.4+3/2, 0, fpshi+2/2]) cube([3, 7, 7+2], true);
                translate([br2-0.5, 0, fpshi]) rotate([0,90,0]) cylinder(ethi+1, 2, 2, $fn=48);
            }
            rotate([0,0,an+90-6]) {
                translate([br2+1.4+3/2, 0, fpshi+2/2]) cube([3, 7, 7+2], true);
                translate([br2-0.5, 0, fpshi]) rotate([0,90,0]) cylinder(ethi+1, 2, 2, $fn=48);
            }
        }
        // Cable throughholes
        for (an=[0:72:360-72]) rotate([0,0,an+36]) {
            translate([0, idia/2-1.5, bot+6]) rotate([-90,0,0]) cylinder((dia-idia)/2+2, 6, 6, $fn=48);
            translate([-12/2, idia/2-1.5, bot-0.01]) cube([12, (dia-idia)/2+2, 6.01]);
        }
        // Disc mounting holes
        for (an=[0:72:360-72]) rotate([0,0,an]) {
            translate([0, (68+155)/4, bot]) {
                translate([0,0,-0.01]) cylinder(bthi+0.02, 3.1, 3.1, $fn=48);
                *translate([0,0,3]) cylinder(bthi-3+0.02, 7, 7, $fn=48);
                // Hex nut M6
                m6rd = (10*2/sqrt(3))/2;
                translate([0,0,3]) cylinder(bthi-3+0.02, m6rd, m6rd, $fn=6);
            }
        }
    }
}

module footstickfoot(cdia=68, hei=42, pts=5, cp=60)
{
    cr = cdia/2;
    co = cr-9;
    cr2 = cdia/2 + 5;
    translate([0,0,2]) rotate([0,0,180/pts]) difference() {
        union() {
            linear_extrude(height=hei, convexity=5) polygon(concat(
                [for (an=[0:360/cp:360/pts]) [cr*sin(an), cr*cos(an)]],
                [[co*sin(360/pts), co*cos(360/pts)],[co*sin(0), co*cos(0)]]
            ));
            linear_extrude(height=5, convexity=5) polygon(concat(
                [[cr*sin(0), cr*cos(0)]],
                [for (an=[6:360/cp:360/pts-6]) [cr2*sin(an), cr2*cos(an)]],
                [[cr*sin(360/pts), cr*cos(360/pts)]],
                [[co*sin(360/pts), co*cos(360/pts)],[co*sin(0), co*cos(0)]]
            ));
        }
        m6rd = (10.1*2/sqrt(3))/2;
        rotate([0,0,-180/pts]) translate([0, cr-7, -0.01]) cylinder(hei+0.02, 3, 3, $fn=cp);
        rotate([0,0,-180/pts]) translate([0, cr-7, -0.01]) cylinder(hei-10+0.01, m6rd, m6rd, $fn=6);
    }
    /*
    #rotate([0,0,-180/pts]) translate([0, cr-7, 20]) cylinder(70, 3, 3, $fn=cp);
    #rotate([0,0,-180/pts]) translate([0, cr-7, -1]) cube([30, 20, 2], true);
    */
}

module footstickdisc(pdia=126, idia=40, cdia=68, pts=4, cp=60)
{
    inr = (pdia/2)-3.6;
    holr1 = inr-12;
    holr2 = idia/2;
    cr = cdia/2;
    translate([0,0,60]) difference() {
        union() {
            cylinder(50, inr, inr, $fn=cp);
            translate([0,0,50]) cylinder(6, inr, inr-4, $fn=cp);
        }
        translate([0,0,10]) cylinder(50.01, holr1, holr1, $fn=cp);
        translate([0,0,-0.01]) cylinder(10.02, holr2, holr2, $fn=cp);
        for (an=[180/pts:360/pts:360-180/pts]) rotate([0,0,an]) {
            translate([0, cr-7, -0.01]) cylinder(20.02, 3.1, 3.1, $fn=cp);
            *translate([0, cr-7, 14]) cylinder(10.02, 3.5, 3.5, $fn=cp);
        }
    }
}

module footmidtwo(idia=90, pdia=126, dia=155, hei=111.8, ehei=10, ethi=6, bthi=15, bot=44, cdia=68, idia2=40, cp=60)
{
    inr = (pdia/2)-3.7;
    holr1 = inr-8;
    holr2 = idia2/2;
    cr = cdia/2;
    pts = 5;

    idia3 = holr1*2;

    ibot = 44;
    ihei = 65;

    difference() {
        union() {
            footmid(idia, pdia, dia, hei, ehei, ethi, bthi, bot, cp);
            translate([0,0,ibot]) {
                intersection() {
                    difference() {
                        union() {
                            linear_extrude(height=ihei, convexity=5) difference() {
                                circle(inr, $fn=cp);
                                circle(holr1, $fn=cp);
                            }
                            for (an=[0:90:360-90]) rotate([0,0,an]) {
                                translate([0, pdia/2, bthi]) rotate([90,0,0]) cylinder(10, 10, 10, $fn=4);
                            }
                        }
                        for (an=[0:72:360-72]) rotate([0,0,an]) {
                            translate([0, holr1+9.4, bthi]) rotate([90,0,0])
                                linear_extrude(height=15) scale([15,25]) circle(1, $fn=6);
                        }
                    }
                    cylinder(ihei, (inr-4)+(ihei*4/6), inr-4, $fn=cp);
                }
                san=8;
                san2=18;
                linear_extrude(height=bthi, convexity=5) union() {
                    for (an=[0:72:360-72]) rotate([0,0,an+36]) {
                        polygon(concat(
                            [[holr2*sin(72-san2), holr2*cos(72-san2)],
                             [holr2*sin(san2), holr2*cos(san2)]],
                            [for (an=[san:(72-2*san)/10:72-san]) [(idia/2+1)*sin(an), (idia/2+1)*cos(an)]]
                        ));
                    }
                }
                hwid=30;
                hthi=10;
                hhei=72;
                hbot=50;
                //cylinder(ihei-6, inr, inr, $fn=cp);
                //translate([0,0,ihei-6]) cylinder(6, inr, inr-4, $fn=cp);
                //#translate([-15, inr-12, 50]) cube([30, 10, 200]);
                rotate([0,0,36]) translate([0, inr, 0]) midhandle(hwid, hthi, hhei, hbot);
                rotate([0,0,180+36]) translate([0, inr, 0]) midhandle(hwid, hthi, hhei, hbot);
            }
        }
        // Handle holes
        rotate([0,0,36]) {
            translate([-26/2, inr-10, ibot+52]) cube([26.2, 6.2, 22.02]);
            translate([0, inr-12-0.01, ibot+62]) rotate([-90,0,0]) cylinder(12.01, 2, 2, $fn=48);
        }
        rotate([0,0,180+36]) {
            translate([-26/2, inr-10, ibot+52]) cube([26.2, 6.2, 22.02]);
            translate([0, inr-12-0.01, ibot+62]) rotate([-90,0,0]) cylinder(12.01, 2, 2, $fn=48);
        }

        // Sticky feet holes
        translate([0,0,ibot]) {
            //translate([0,0,10]) cylinder(ihei-10+0.01, holr1, holr1, $fn=cp);
            //translate([0,0,-0.01]) cylinder(10.02, holr2, holr2, $fn=cp);
            for (an=[0/pts:360/pts:360-180/pts]) rotate([0,0,an]) {
                translate([0, cr-7, -0.01]) cylinder(bthi+0.02, 3.1, 3.1, $fn=cp);
            }
        }
        // Cable throughholes
        for (an=[0:72:360-72]) rotate([0,0,an+36]) {
            translate([0, idia3/2-1.5, bot+6]) rotate([-90,0,0]) cylinder((dia-idia3)/2+2, 6, 6, $fn=48);
            translate([-12/2, idia3/2-1.5, bot-0.01]) cube([12, (dia-idia2)/2+2, 6.01]);
            //translate([-12/2, idia2/2-1.5, bot-0.01]) cube([12, (idia3-idia2)/2+1.2, 10.02]);
        }
    }
}

module midhandle(hwid, hthi, hhei, hbot)
{
    x1 = -2;
    x2 = -hthi-2;
    x3 = -7;
    z1 = hbot-(x3-x2)*1;

    polyhedron(points=[
            [-hwid/2, x1, z1  ], [ hwid/2, x1, z1],
            [ hwid/2, x3, z1  ], [-hwid/2, x3, z1],
            [-hwid/2, x1, hbot], [ hwid/2, x1, hbot],
            [ hwid/2, x2, hbot], [-hwid/2, x2, hbot],
            [-hwid/2, x1, hhei], [ hwid/2, x1, hhei],
            [ hwid/2, x2, hhei], [-hwid/2, x2, hhei],
            [-hwid/2+1.2, x1-1.2, hhei+2], [ hwid/2-1.2, x1-1.2, hhei+2],
            [ hwid/2-1.2, x2+1.2, hhei+2], [-hwid/2+1.2, x2+1.2, hhei+2],
        ], faces = [
            [3,2,1,0],
            [0,1,5,4],[1,2,6,5],[2,3,7,6],[3,0,4,7],
            [4,5,9,8],[5,6,10,9],[6,7,11,10],[7,4,8,11],
            [8,9,13,12],[9,10,14,13],[10,11,15,14],[11,8,12,15],
            [12,13,14,15],
        ]);
}

module foothandle(cp=60, pdia=126, an=36)
{
    inr = (pdia/2)-3.7;
    hei = 150;
    translate([0,0,52+44]) rotate([0,0,an]) difference() {
        union() {
            translate([-26/2, inr-10, 0]) cube([26, 6, hei]);
            rotate([0,0,180]) translate([-26/2, inr-10, 0]) cube([26, 6, hei]);
            translate([0, -inr+4, hei]) rotate([-90,0,0]) cylinder(inr*2-8, 26/2, 26/2, $fn=cp);
        }
        translate([-7.2/2, inr-10.01, 10-7/2]) cube([7.2, 6.02, 7]);
        rotate([0,0,180]) translate([-7.2/2, inr-10.01, 10-7/2]) cube([7.2, 6.02, 7]);
    }
}

module footmiddisc(thi=10, thi2=36.8, dia=175, hdia=142, pdia=126, idia=90, cp=60)
{
    tly = 6;
    br2 = pdia/2;

    difference() {
        polyhedron(convexity=5,
            points = concat(
                zbcircle(0, 0,    0,  dia/2, 360/cp),
                zbcircle(0, 0,    0, idia/2, 360/cp),
                zbcircle(0, 0, thi2, idia/2, 360/cp),
                zbcircle(0, 0, thi2, hdia/2, 360/cp),
                zbcircle(0, 0,  thi+4, hdia/2, 360/cp),
                zbcircle(0, 0,  thi, hdia/2+4, 360/cp),
                zbcircle(0, 0,  thi,  dia/2, 360/cp),
                []
            ), faces = concat(
                [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
                nquads(tly*cp, cp, -tly*cp),
                []
            ));
        for (an=[0:90:360-90]) {
            hlexan = asin(10/(br2+10));
            rotate([0,0,an+0]) {
                translate([br2+10, 10, -0.01]) cylinder(2.31, 6.1, 4, $fn=48);
                translate([br2+10, 10, 2.3-0.01]) cylinder(thi-2+0.02, 2, 2, $fn=48);
                translate([br2+10, 10, thi-5]) rotate([0,0,45+hlexan]) {
                    cylinder(3.41, 7/sqrt(2), 7/sqrt(2), $fn=4);
                    translate([0,0,3.4]) cylinder(1.01, 6.8/sqrt(2), 6.8/sqrt(2), $fn=4);
                    translate([0,0,4.4]) cylinder(4.61, 7/sqrt(2), 7/sqrt(2), $fn=4);
                }
            }
            rotate([0,0,an+90]) {
                translate([br2+10,-10, -0.01]) cylinder(2.31, 6.1, 4, $fn=48);
                translate([br2+10,-10, 2.3-0.01]) cylinder(thi-2+0.02, 2, 2, $fn=48);
                translate([br2+10,-10, thi-5]) rotate([0,0,45-hlexan]) {
                    cylinder(3.41, 7/sqrt(2), 7/sqrt(2), $fn=4);
                    translate([0,0,3.4]) cylinder(1.01, 6.8/sqrt(2), 6.8/sqrt(2), $fn=4);
                    translate([0,0,4.4]) cylinder(4.61, 7/sqrt(2), 7/sqrt(2), $fn=4);
                }
            }
        }
        // Disc mounting holes
        for (an=[0:72:360-72]) rotate([0,0,an]) {
            translate([0, (68+155)/4, 0]) {
                translate([0,0,-0.01]) cylinder(thi2+0.02, 4.5, 4.5, $fn=48);
                translate([0,0,-0.01]) cylinder(3.2+0.01, 7.7, 7.7, $fn=48);
            }
        }
    }
    // Mid bottom connector holes sacrificial layer
    #for (an=[0:90:360-90]) {
        rotate([0,0,an+0]) {
            translate([br2+10, 10, 2.3]) cylinder(0.3, 2.5, 2.5, $fn=48);
        }
        rotate([0,0,an+90]) {
            translate([br2+10,-10, 2.3]) cylinder(0.3, 2.5, 2.5, $fn=48);
        }
    }
    // Disc mounting holes
    #for (an=[0:72:360-72]) rotate([0,0,an]) {
        translate([0, (68+155)/4, 0]) {
            translate([0,0,3.2]) cylinder(0.3, 4.6, 4.6, $fn=48);
        }
    }
}

module stalks(hei=208, dia=380, cp=120, pdia=126, ddia=295, dth=25.5, bth=2, tol=1, arc=90, seed=130, conn=0) {
            ns = 5;
            for (fs=[0:ns]) {
                rv = rands(0, 1, 6, seed+fs);
                s_sd = 8+rv[0]*12;
                s_ed = 2+rv[0]*1;
                s_sx = (dia/2-s_sd-100)*rv[1]+100;
                s_ex = 126/2+1.2-s_ed;
                s_san = 5+(fs/ns)*70+10*rv[2];
                s_ean = s_san+30*(rv[3]-0.5);
                s_shi = (dia/2)-s_sx*0.8-s_sd-37;
                s_hei = hei+0-30*rv[4]*rv[4]-s_shi;
                s_sof = -45*rv[5];

                footstalk(shi=s_shi, hei=s_hei, san=s_san, ean=s_ean, sx=s_sx, ex=s_ex, sd=s_sd, ed=s_ed, sof=s_sof, cp=cp/3);
            }
}

module footconnector(dia=380, xtol=0.2, ytol=0.4)
{
    br=dia/2;
    // Side to side connector holes
    translate([br-30, 0, 3]) difference() {
        translate([0,0,4/2]) cube([10-xtol, 40-xtol, 4-ytol], true);
        translate([0,10,-0.01]) cylinder(4.02, 1.7, 1.7, $fn=48);
        translate([0,-10,-0.01]) cylinder(4.02, 1.7, 1.7, $fn=48);
    }
}

module footblob(hei=208, dia=380, cp=120, pdia=126, ddia=295, dth=25.5, bth=2, tol=1, arc=90, seed=130, conn=0)
{
    sa = 0;
    ea = sa+arc;
    ethi = 1.2;

    br = dia/2;
    br1 = ddia/2+tol;
    br2 = pdia/2;

    bra = (br+(br2+ethi))/2;
    brd = (br-(br2+ethi))/2;

    nly = floor(cp/3);

    tly = nly+10;
    tcp = (cp/(360/arc))+1;

    midly = floor(nly*0.7);

    difference() {
        union() {
            polyhedron(convexity=8,
                points = concat(
                    //[for (z=[nly:-1:0]) each zbcirclearc(z*(hei+bth)/nly-bth, bra+brd*footblobarc(z/nly, 80), 360/cp, sa, ea) ],
                    //[for (z=[nly:-1:0]) each radliftmorph(zbcirclearc(z*(hei+bth)/nly-bth, bra+brd*footblobarc(z/nly, 80), 360/cp, sa, ea), conn, connhi, br/2, br) ],
                    [for (z=[nly:-1:0]) each zbcirclearcblob(z*((hei*0.75)+bth)/nly-bth, bra+brd*footblobarc(z/nly, 80, ex=1), 360/cp, sa, ea, bbr=br, ban=90-conn, bup=(conn?connhi-3:0)) ],
                    zbcirclearc(-bth   , br, 360/cp, sa, ea),
                    zbcirclearc(-bth   , br2, 360/cp, sa, ea),
                    zbcirclearc(0      , br2, 360/cp, sa, ea),
                    zbcirclearc(0      , br1, 360/cp, sa, ea),
                    zbcirclearc(dth+tol, br1, 360/cp, sa, ea),
                    zbcirclearc(dth+tol+(br1-br2)-6, br2+6, 360/cp, sa, ea),
                    zbcirclearc(122-6, br2+6, 360/cp, sa, ea),
                    zbcirclearc(122, br2, 360/cp, sa, ea),
                    zbcirclearc(hei, br2, 360/cp, sa, ea),
                    zbcirclearc(hei, br2+ethi, 360/cp, sa, ea),
                    []
                ), faces = concat(
                    [for (z=[0:tly-1]) each nquads(z*tcp, tcp, tcp, 1)],
                    nquads(tly*tcp, tcp, -tly*tcp, 1),
                    [[for (z=[0:tly]) z*tcp+tcp-1]],
                    [[for (z=[tly:-1:0]) z*tcp]],
                    []
                )
            );
            ns = 5;
            for (fs=[0:ns]) {
                rv = rands(0, 1, 6, seed+fs);
                s_sd = 8+rv[0]*12;
                s_ed = 2+rv[0]*1;
                s_sx = (dia/2-s_sd-100)*rv[1]+100;
                s_ex = 126/2+1.2-s_ed;
                s_san = 5+(fs/ns)*70+10*rv[2];
                s_ean = s_san+30*(rv[3]-0.5);
                s_shi = (dia/2)-s_sx*0.8-s_sd-37;
                s_hei = hei+0-30*rv[4]*rv[4]-s_shi;
                s_sof = -45*rv[5];

                footstalk(shi=s_shi, hei=s_hei, san=s_san, ean=s_ean, sx=s_sx, ex=s_ex, sd=s_sd, ed=s_ed, sof=s_sof, cp=cp/6);
            }

            // Mid bottom connector hole plugs
            rotate([0,0,sa]) {
                translate([br2+10, 10, 0]) cylinder(2, 6, 4, $fn=cp/10);
            }
            rotate([0,0,ea]) {
                translate([br2+10,-10, 0]) cylinder(2, 6, 4, $fn=cp/10);
            }
        }
        // Side to side connector holes
        rotate([0,0,sa]) {
            translate([br-30, 20/2-0.01, 3+4/2]) cube([10, 20.02, 4], true);
            *translate([br-30,-0.01,8]) rotate([-90,45,0]) cylinder(20.01, 10/sqrt(2), 10/sqrt(2), $fn=4);
            translate([br-30,10,-bth+3-0.01]) cylinder(10.01, 2, 2, $fn=cp/10);
            translate([br-30,10,-bth-0.01]) cylinder(3.01, 4.0, 4.0, $fn=cp/10);
        }
        rotate([0,0,ea]) {
            translate([br-30,-20/2+0.01, 3+4/2]) cube([10, 20.02, 4], true);
            *translate([br-30, 0.01,8]) rotate([90,45,0]) cylinder(20.01, 10/sqrt(2), 10/sqrt(2), $fn=4);
            translate([br-30,-10,-bth+3-0.01]) cylinder(10.01, 2, 2, $fn=cp/10);
            translate([br-30,-10,-bth-0.01]) cylinder(3.01, 4.0, 4.0, $fn=cp/10);
        }

        // Mid bottom connector holes
        rotate([0,0,sa]) {
            translate([br2+10, 10,-bth-0.01]) cylinder(6.01, 2, 2, $fn=cp/10);
            translate([br2+10, 10,-bth-0.01]) cylinder(3.01, 4.0, 4.0, $fn=cp/10);
        }
        rotate([0,0,ea]) {
            translate([br2+10,-10,-bth-0.01]) cylinder(6.01, 2, 2, $fn=cp/10);
            translate([br2+10,-10,-bth-0.01]) cylinder(3.01, 4.0, 4.0, $fn=cp/10);
        }

        // Top pole screw holes
        *rotate([0,0,sa]) {
            translate([br2+1.6+4/2, 5-2/2, fpshi+0.1]) cube([4, 7+2, 7.2], true);
            translate([br2-0.5, 5, fpshi]) rotate([0,90,0]) cylinder(12, 2, 2, $fn=cp/10);
            translate([br2+7.2, 5, fpshi]) rotate([0,90,0]) cylinder(10, 4.0, 4.0, $fn=cp/10);
        }
        rotate([0,0,sa+6]) {
            translate([br2-0.5, 0, fpshi]) rotate([0,90,0]) cylinder(12, 2, 2, $fn=cp/10);
            translate([br2+7.2, 0, fpshi]) rotate([0,90,0]) cylinder(11, 4.0, 4.0, $fn=cp/10);
        }
        *rotate([0,0,ea]) {
            translate([br2+1.6+4/2,-5+2/2, fpshi+0.1]) cube([4, 7+2, 7.2], true);
            translate([br2-0.5,-5, fpshi]) rotate([0,90,0]) cylinder(12, 2, 2, $fn=cp/10);
            translate([br2+7.2,-5, fpshi]) rotate([0,90,0]) cylinder(10, 4.0, 4.0, $fn=cp/10);
        }
        rotate([0,0,ea-6]) {
            translate([br2-0.5, 0, fpshi]) rotate([0,90,0]) cylinder(12, 2, 2, $fn=cp/10);
            translate([br2+7.2, 0, fpshi]) rotate([0,90,0]) cylinder(11, 4.0, 4.0, $fn=cp/10);
        }
        
        // Power connector hole
        if (conn) {
            topan = 4*360/cp;
            s1of = 38;
            s2of = 22;
            slex = 7;
            toparcan = topan*floor(asin(11/connrad)/topan);
            toparcbot = connhi-7-connrad+cos(asin(11/connrad))*connrad;
            rotate([0,0,conn]) {
                translate([br,0,connhi-7-connrad]) rotate([0,-90,0]) cylinder(27-2+0.01, connrad, connrad, $fn=360/topan);
                translate([br-27+2,0,0]) rotate([0,-90,0]) linear_extrude(height=11,convexity=5)
                    polygon(concat(
                        [[toparcbot,-22/2],[s2of,-22/2],[s2of-slex,-22/2-slex],[0,-22/2-slex],
                            [0,22/2+slex],[s2of-slex,22/2+slex],[s2of,22/2],[toparcbot,22/2]],
                        [for (an=[toparcan:-topan:-toparcan]) [connhi-7-connrad+cos(an)*connrad,sin(an)*connrad]]
                    ));
                translate([br-28-4.4,-36/2,0]) cube([4.2,36,38]);
                translate([br-27-8.4,0,0]) rotate([0,-90,0]) linear_extrude(height=25,convexity=5)
                    polygon(concat(
                        [[toparcbot,-22/2],[s1of-slex,-22/2-slex],[0,-22/2-slex],
                            [0,22/2+slex],[s1of-slex,22/2+slex],[toparcbot,22/2]],
                        [for (an=[toparcan:-topan:-toparcan]) [connhi-7-connrad+cos(an)*connrad,sin(an)*connrad]]
                    ));

                // screw holes for plugsocket
                translate([br-27+3,-14,fplughi]) rotate([0,-90,0]) cylinder(12, 1.2, 1.2, $fn=cp/10);
                translate([br-27+3, 14,fplughi]) rotate([0,-90,0]) cylinder(12, 1.2, 1.2, $fn=cp/10);
            }
        }
    }
    // Mid bottom connector holes sacrificial layer
    rotate([0,0,sa]) {
        #translate([br2+10, 10, 1]) cylinder(0.2, 2.5, 2.5, $fn=8);
        #translate([br-30, 10, 1]) cylinder(0.2, 2.5, 2.5, $fn=8);
        #translate([br-30, 10, 7]) cylinder(0.2, 2.5, 2.5, $fn=8);
    }
    rotate([0,0,ea]) {
        #translate([br2+10,-10, 1]) cylinder(0.2, 2.5, 2.5, $fn=8);
        #translate([br-30,-10, 1]) cylinder(0.2, 2.5, 2.5, $fn=8);
        #translate([br-30,-10, 7]) cylinder(0.2, 2.5, 2.5, $fn=8);
    }
}

// Circle arc but with a blob at angle 'ban'
function zbcirclearcblob(z,d,an,s,e,ban=70,banw=20,bup=40,bbo=120,bbr=190) = [
    for (a = [s:an:e])
        let (
            sca = abs(a-ban)>banw ? 0 : (banw-abs(a-ban))/banw,
            scr = (bbr-d)>bbo ? 0 : (bbo-(bbr-d))/bbo,
            scsa = cos(180-180*sca)/2+0.5,
            scsr = scr>1 ? (cos(180-90*scr)+1+(cos((scr-1)*270)-1)*1) : cos(180-90*scr)+1,
            upadd = bup*scsa*scsr
        )
        [d*sin(a),d*cos(a),z+upadd]
];

// Raise points in direction 'an' by distance scaled from 0 at radius 'rd1' to 'up' at radius 'rd2'
function radliftmorph(pnts, an, up, rd1, rd2) = (
    let (
        mdis = rd2 - rd1,
        tx = cos(an)*rd2,
        ty = sin(an)*rd2
    )
    [for (i=[0:len(pnts)-1])
        let (
            p = pnts[i],
            dx = tx-p.x,
            dy = ty-p.y,
            dis = sqrt(dx*dx + dy*dy),
            dscl = (dis < mdis) ? (dis/mdis) : 1,
            scl = cos(dscl*180+0)/2+0.5,
            upadd = up*scl
        ) [p.x, p.y, p.z+upadd]]
);

module footstalk(shi=40, hei=160, san=10, ean=25, sx=130, ex=126/2-0.8, sd=12, ed=2, sof=0, cp=30)
{
    tly = cp;
    bra = (sx+ex)/2;
    brd = (sx-ex)/2;
    ana = (san+ean)/2;
    and = (san-ean)/2;
    polyhedron(convexity=3,
        points = clampcone(179, 179, -2, clampcyl(127/2, concat(
            [for (z=[tly:-1:0]) each
                let (r = bra+brd*footblobarc(z/tly, sof, 1),
                     an = ana+and*footblobarc(z/tly, 0, 1))
                zbcircle(r*cos(an), r*sin(an), shi+z*hei/tly, sd+(ed-sd)*z/tly, 360/cp)],
            [[sx*cos(san), sx*sin(san), shi]] )) 
        ), faces = concat(
            [bface(0, cp)],
            [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
            tfacec(cp*tly, cp, cp*(tly+1)),
            []
        )
    );
}

// Make sure points do not fall inside a cylinder of diameter 'dia'
// Push points out when they do
// Factor 0.99 is to just keep it 3d
function clampcyl(dia, pts) = [
    for (i=[0:len(pts)-1])
        let (p = pts[i]
            ,d = sqrt(p.x*p.x + p.y*p.y)
            ,s = d>dia ? 1 : (((dia/d)-1)*0.99)+1
            )
        [p.x*s, p.y*s, p.z]
];

// Make sure points do not fall inside a cone of base 'dia' and height 'hi'
// Push points up when they do
function clampcone(hei, dia, ofs, pts) = [
    for (i=[0:len(pts)-1])
        let (p = pts[i]
            ,d = sqrt(p.x*p.x + p.y*p.y)
            ,coned = dia*(hei-p.z+ofs)/hei
            ,t = d>coned ? 0 : (coned-d)*0.7
            ,s = d>coned ? 1 : (((coned/d)-1)*0.25)+1
            )
        [p.x*s, p.y*s, p.z+t]
];

// Function that outputs an arc from -1 to 1 where z goes from 0 to 1
//function footblobarc(z, sa=45) = ((2/(cos(sa)+1))*(((1-cos(sa))/2)+cos(sa+z*(180-sa))));

function footblobarc(z, sa=45, ex=0.75) = (
    (z > ex) ? -1 : 
    (2/(cos(sa)+1))*(((1-cos(sa))/2)+cos(sa+(z/ex)*(180-sa)))
    );

module poleshell(dia=126, hei=190.4, cp=120)
{
    br = dia/2;
    th = 1.2;
    tly = 3;
    polyhedron(convexity=5,
        points = concat(
            zbcircle(0,0,0,br+th,360/cp),
            zbcircle(0,0,0,br,360/cp),
            zbcircle(0,0,hei,br,360/cp),
            zbcircle(0,0,hei,br+th,360/cp),
            []
        ),
        faces = concat(
            [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
            nquads(tly*cp, cp, -tly*cp),
            []
        )
    );
}

module standpole(dia=126, hei=558, cp=60)
{
    br = dia/2;
    th = 3.6;
    tly = 3;
    polyhedron(convexity=5,
        points = concat(
            zbcircle(0,0,0,br,360/cp),
            zbcircle(0,0,0,br-th,360/cp),
            zbcircle(0,0,hei,br-th,360/cp),
            zbcircle(0,0,hei,br,360/cp),
            []
        ),
        faces = concat(
            [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
            nquads(tly*cp, cp, -tly*cp),
            []
        )
    );
}

module brakediscsub(cp = 60)
{
    odia = 295;
    idia = 155;
    cdia = 68;
    hdia = 178;
    oth = 25.5;
    ith = 18.5;
    hth = 7;
    ndia = 12.8;

    translate([0, 0, hth]) {
        linear_extrude(height=2, convexity=4) difference() {
            circle(idia/2, $fn=cp);
            circle(cdia/2, $fn=cp);
            for (an=[0:360/5:360-360/5]) rotate([0,0,an]) {
                translate([0, (cdia+idia)/4, 0]) circle(ndia/2, $fn=30);
            }
        }
        linear_extrude(height=oth-hth+ith, convexity=4) union() {
            difference() {
                circle(cdia/2+2, $fn=cp);
                circle(cdia/2, $fn=cp);
            }
            difference() {
                circle(idia/2, $fn=cp);
                circle(idia/2-2, $fn=cp);
            }
            for (an=[0:360/5:360-360/5]) rotate([0,0,an]) {
                translate([0, (cdia+idia)/4, 0]) difference() {
                    circle(ndia/2+2, $fn=30);
                    circle(ndia/2, $fn=30);
                }
                *translate([-1, cdia/2+1, 0]) square([2,14]);
                *translate([-1, idia/2-14-1, 0]) square([2,14]);
                translate([0, (cdia+idia)/4, 0]) {
                    rotate([0,0,180]) translate([-1,ndia/2+1,0]) square([2,14]);
                    rotate([0,0, 45]) translate([-1,ndia/2+1,0]) square([2,18.2]);
                    rotate([0,0,-45]) translate([-1,ndia/2+1,0]) square([2,18.2]);
                }
            }
        }
    }
}

module brakedisc(cp = 60)
{
    odia = 295;
    idia = 155;
    cdia = 68;
    hdia = 178;
    oth = 25.5;
    ith = 18.5;
    hth = ith+oth-7.2;
    ndia = 12.8;

    tly = 7;

    color("#976")
    difference() {
        polyhedron(convexity=5,
            points = concat(
                zbcircle(0, 0, 0, hdia/2, 360/cp),
                zbcircle(0, 0, hth, hdia/2, 360/cp),
                zbcircle(0, 0, hth, cdia/2, 360/cp),
                zbcircle(0, 0, oth+ith, cdia/2, 360/cp),
                zbcircle(0, 0, oth+ith, idia/2, 360/cp),
                zbcircle(0, 0, oth, idia/2, 360/cp),
                zbcircle(0, 0, oth, odia/2, 360/cp),
                zbcircle(0, 0, 0, odia/2, 360/cp),
                []
            ),
            faces = concat(
                [for (z=[0:tly-1]) each nquads(z*cp, cp, cp)],
                nquads(tly*cp, cp, -tly*cp),
                []
            )
        );
        /*
        union() {
            cylinder(oth, odia/2, odia/2, $fn=60);
            cylinder(oth+ith, idia/2, idia/2, $fn=60);
        }
        translate([0,0,-0.01]) cylinder(oth+ith+0.02, cdia/2, cdia/2, $fn=60);
        translate([0,0,-0.01]) cylinder(hth+0.02, hdia/2, hdia/2, $fn=60);
        */
        for (an = [360/5:360/5:360]) {
            rotate([0,0,an]) translate([0,(cdia+idia)/4,-0.01])
                cylinder(oth+ith+0.02, ndia/2, ndia/2, $fn=30);
        }
    }
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
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
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

function tfacec(o, n, e) = concat([[o,o+n-1,e]],[for (p=[0:1:n-2]) [o+p+1,o+p,e]]);

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
