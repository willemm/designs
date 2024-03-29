doitem = "battery_retainer";


flmd = 2;
flml = 4;
flmw = 2;
flmt = 0.2;
offset = -10;
offset2 = -8;

slideth = 3;

numbatteries = 3;
batteryoffset = 15;
batteryan = 30;
battof = [+0, +7.75, 0];

batth = 1.2;
batty = 57;
battx = batteryoffset * numbatteries;

digipos = [27.5, 25.4, 240, 15];
tinypos = [7, 109.6*sqrt(3)/4-2.1, 5, 210];
wspos = [42, 23.9, 240];

s3 = sqrt(3);

if (doitem == "house") { house(); }
if (doitem == "slider") { slider(); }
if (doitem == "hexbase_top") { hexbase_top(); }
if (doitem == "hexbase_bot") { hexbase_bot(); }
if (doitem == "cover_top") { cover_top(); }
if (doitem == "cover_bot") { cover_bot(); }
if (doitem == "cover_pin") { cover_pin(); }
if (doitem == "wire_guide") { wire_guide(); }
if (doitem == "try") { cover_holder(159.6, 19); }
if (doitem == "batterybox") { batterybox(); *batteries(); }
if (doitem == "receiver_jig") { receiver_jig(); }
if (doitem == "outerlid") { rotate([180,0,0]) outer_lid(); }
if (doitem == "connector_holder") { rotate([180,0,0]) mc_holder(); }
if (doitem == "helix_top") { rotate([180,0,0]) helix_top(); }
if (doitem == "battery_retainer") { rotate([180,0,30]) battery_retainer(); }
if (doitem == "") {


    if (1) {
        color("#acc") translate([0,0,12.5]) rotate([180,0,0]) import("behuizing met staanders.stl", convexity=6);

        hexbase_top();

        color("#8ad") battery_retainer();
        *receiver_jig();
        *translate([0,0,13.5]) cover_top();
        *translate([0, -109.6/2+3.7, 1.1]) rotate([90,0,0]) wire_guide();
        *translate([0, -159.6/2, 14+19-2.5-2.1]) cover_pin();

        rotate([0,0,batteryan]) batteries();
        *ws2811();
        *digispark();
        *attiny_board();
        *receiver();
    } else {
        *color("#abd") translate([0,0,33.0]) rotate([0,0,0]) import("deksel.stl", convexity=6);
        *color("#bda") translate([0,0,33.0]) outer_lid();
        *color("#ac8") translate([0,0,33.0]) mc_holder();
        *color("#a926") translate([0,0,33.0]) magnetic_connector();

        color("#abd") translate([0,0,38.0]) helix_top();
        *color("#abd8") translate([0,0,38.0]) rotate([0,0,0]) import("triple helix_top.stl", convexity=6);

        color("#acc") translate([0,0,-125.4]) rotate([0,0,0]) import("behuizing met staanders.stl", convexity=6);

        *hexbase_bot();
        *translate([0,0,14]) cover_bot();
        *translate([0, -109.6/2+3.7, 1.1]) rotate([90,0,0]) wire_guide();
        *translate([0, -159.6/2, 14+19-2.5-2.1]) cover_pin();
    }


    *filament_end();
    *nut();
    *translate([2,0,0]) bolt();

    *house();
    *translate([2,0,0]) slider();
}

module helix_top()
{
    // hdia = 123;
    hwid = 107;
    hr = hwid/sqrt(3);

    ph = 3;
    pb = 4;
    pa = 3;
    po = 6;
    union() {
        import("triple helix_top.stl", convexity=6);
        for (an=[30:60:360-30]) rotate([0,0,an]) {
            polyhedron(convexity=4,
                points = [
                    [hr, 0, 0], [hr-8/s3, -8, 0], [hr-14/s3, -6, 0], [hr-14/s3, 6, 0], [hr-8/s3, 8, 0],
                    [hr, 0,-ph], [hr-8/s3, -8,-ph], [hr-14/s3, -6,-ph], [hr-14/s3, 6,-ph], [hr-8/s3, 8,-ph],
                    [hr-pa, 0,-ph-pb], [hr-pa-po/s3, -po, -ph-pb], [hr-pa-po/s3, po, -ph-pb],
                ], faces = [
                    [0,1,2,3,4],
                    [1,0,5,6],[2,1,6,7],[3,2,7,8],[4,3,8,9],[0,4,9,5],
                    //[9,8,7,6,5],
                    [6,5,10,11],[7,6,11],[8,7,11,12],[9,8,12],[5,9,12,10],
                    [12,11,10],
                ]);
        }
    }
}

module mc_holder(cp=24)
{
    bthi = 0.6;
    bwid = 9;
    blen = 19;
    bof = 4;
    bd = (blen-bof*2)/2;

    exthi = 0.4;
    exhei = 8;
    exwid = 3;
    tol = 0.1;
    exex = 1;

    hthi = 2+exthi;

    bev = hthi;

    union() {
        translate([0,0,-hthi]) linear_extrude(height=hthi-exthi, convexity=5) polygon([
            [-bd-2, -bof-bd+tol], [-bd-2, bof+bd-tol], [ bd+2, bof+bd-tol], [ bd+2, -bof-bd+tol],
            [-2.5, -bof-bd+exwid], [-2.5, bof+bd-exwid], [ 2.5, bof+bd-exwid], [ 2.5, -bof-bd+exwid],
        ], [[0,1,2,3],[4,5,6,7]]);

        translate([0, -bof-bd-exex+tol, 0]) rotate([-90,0,0])
            linear_extrude(height=exex+exwid-tol, convexity=5) difference() {
                polygon([
                    [-bd-2, exthi],[-bd-2, bev], [-bd-2+exhei-bev, exhei],
                    [ bd+2-exhei+bev, exhei], [bd+2, bev], [bd+2, exthi]
                ]);
                translate([0, 4]) circle(1.2, $fn=48);
        }
        translate([0, bof+bd+exex-tol, 0]) rotate([-90,0,180])
            linear_extrude(height=exex+exwid-tol, convexity=5) difference() {
                polygon([
                    [-bd-2, exthi],[-bd-2, bev], [-bd-2+exhei-bev, exhei],
                    [ bd+2-exhei+bev, exhei], [bd+2, bev], [bd+2, exthi]
                ]);
                translate([0, 4]) circle(1.2, $fn=48);
        }
    }
}

module outer_lid(cp=24)
{
    thi = 4.0;
    dia = 150;
    exdia = 10*sqrt(3);
    rd = dia/sqrt(3);
    erd = exdia/sqrt(3);

    hdia = 4;
    hhdia = 7.8;
    hhthi = 1.2;
    hhins = 1.6;

    bthi = 0.6;
    bwid = 9;
    blen = 19;
    bof = 4;
    bd = (blen-bof*2)/2;

    exthi = 0.4;
    exhei = 8;
    exwid = 4;
    exex = 1;
    bev = 2.4;

    mcdia = 7.2;

    difference() {
        union() {
            linear_extrude(height=thi, convexity=5) polygon(
                [for (a1=[0:60:360-60], a2=[-120:60:120])
                    [sin(a1)*rd+sin(a1+a2)*erd, cos(a1)*rd+cos(a1+a2)*erd]
                ]
            );
            translate([0,0,-exthi]) linear_extrude(height=exthi+0.01) polygon([
                [-bd-2, -bof-bd-2], [-bd-2, bof+bd+2], [ bd+2, bof+bd+2], [ bd+2, -bof-bd-2],
            ]);

            translate([0, -bof-bd-exex, 0]) rotate([-90,0,180])
                linear_extrude(height=exwid, convexity=5) difference() {
                    polygon([
                        [-bd-2, 0],[-bd-2, bev], [-bd-2+exhei-bev, exhei],
                        [ bd+2-exhei+bev, exhei], [bd+2, bev], [bd+2, 0]
                    ]);
                    translate([0, 4]) circle(1.5, $fn=48);
            }
            translate([0, bof+bd+exex, 0]) rotate([-90,0,0])
                linear_extrude(height=exwid, convexity=5) difference() {
                    polygon([
                        [-bd-2, 0],[-bd-2, bev], [-bd-2+exhei-bev, exhei],
                        [ bd+2-exhei+bev, exhei], [bd+2, bev], [bd+2, 0]
                    ]);
                    translate([0, 4]) circle(1.5, $fn=48);
            }
        }
        for (an=[0:60:360-60]) rotate([0,0,an]) {
            translate([0,rd,-0.01]) cylinder(thi+0.02, hdia/2, hdia/2, $fn=cp);
            translate([0,rd, hhthi]) cylinder(thi-hhthi+0.01, hhdia/2, hhdia/2, $fn=cp);
        }
        translate([0,0,-exthi-0.01]) cylinder(exthi+thi+0.02, mcdia/2, mcdia/2, $fn=cp);
        san = asin(bwid/(blen-bof*2));
        translate([0,0,-exthi-0.01]) linear_extrude(height=exthi+hhins+0.01) polygon(concat(
            [for (an=[-san:san/cp:san]) [sin(an)*bd, bof+cos(an)*bd]],
            [for (an=[180-san:san/cp:180+san]) [sin(an)*bd, -bof+cos(an)*bd]]
        ));
    }
    // Sacrificial hole layers
    #for (an=[0:60:360-60]) rotate([0,0,an]) {
        translate([0, rd, hhthi-0.2]) cylinder(0.2, hhdia/2, hhdia/2, $fn=cp);
    }
}

module cover_bot()
{
    dia = 109.6;
    di2 = 159.6;

    basehi = 14;
    sidehi = 19;

    thi = 1;
    rti = 3;

    cx = di2*s3/4;
    cy = di2/4;

    cya = dia/4;

    bx = battx/2+batth+0.2;
    by = batty/2+batth+0.2;

    // Ridgy bit
    color("#7a2") translate([0,0,0]) linear_extrude(height = rti, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [di2/2 * sin(an), di2/2 * cos(an)]] );
            for (an=[0:60:300]) rotate([0, 0, an]) {
                polygon([
                    [ 4, cy*2-5], [ 7, cy*2-15],
                    [7, cya*2-4], [0, cya*2-10], [-7, cya*2-4],
                    [-7, cy*2-15], [-4, cy*2-5], [0, cy*2-3],
                ]);
                polygon([
                    [cx-3, cy-21/s3], [cx-20, cy-38/s3],
                    [cx-20, 1.5], [cx-3, 1.5],
                ]);
                polygon([
                    [cx-3, -1.5], [cx-20, -1.5],
                    [cx-20, -cy+38/s3], [cx-3, -cy+21/s3],
                ]);
                polygon([
                    [cx-24, cy-39/s3], [cx-32, cy-35/s3],
                    [cx-38, cy-41/s3], [cx-38, -cy+41/s3],
                    [cx-32, -cy+35/s3], [cx-24, -cy+39/s3],
                ]);
                polygon([
                    [cx-40, cy-43/s3], [3, 0], [cx-40, -cy+43/s3],
                ]);
            }
        }
    }
    // Flat bit
    color("#8c3") translate([0,0,rti]) linear_extrude(height = thi, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [di2/2 * sin(an), di2/2 * cos(an)]] );
            for (an=[0:60:300]) rotate([0, 0, an]) {
                polygon([
                    [0, cy*2-3],
                    [ 4, cy*2-5], [ 7, cy*2-15],
                    [7, cy*2-22], [-7, cy*2-22],
                    [-7, cy*2-15], [-4, cy*2-5],
                ]);
            }
        }
    }
    for (an=[0:60:300]) rotate([0, 0, an]) {
        translate([0,0,rti]) cover_holder(di2, sidehi-rti);
    }
}

module cover_top()
{
    dia = 109.6;
    di2 = 159.6;

    basehi = 14;
    sidehi = 19;

    thi = 1;
    rti = 3;

    cx = di2*s3/4;
    cy = di2/4;

    cya = dia/4;

    bx = battx/2+batth+0.2;
    by = batty/2+batth+0.2;

    // Ridgy bit
    color("#7a2") translate([0,0,0]) linear_extrude(height = rti, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [di2/2 * sin(an), di2/2 * cos(an)]] );
            rotate([0,0,batteryan]) translate(battof) polygon([
                [-by+2.3,-bx], [-by+2.3, bx],
                [ by-2.3, bx], [ by-2.3,-bx]
            ]);
            for (an=[0:60:300]) rotate([0, 0, an]) {
                polygon([
                    [ 4, cy*2-5], [ 7, cy*2-15],
                    [7, cya*2-4], [0, cya*2-10], [-7, cya*2-4],
                    [-7, cy*2-15], [-4, cy*2-5], [0, cy*2-3],
                ]);
                polygon([
                    [cx-3, cy-21/s3], [cx-20, cy-38/s3],
                    [cx-20, 1.5], [cx-3, 1.5],
                ]);
                polygon([
                    [cx-3, -1.5], [cx-20, -1.5],
                    [cx-20, -cy+38/s3], [cx-3, -cy+21/s3],
                ]);
                polygon([
                    [cx-24, cy-39/s3], [cx-32, cy-35/s3],
                    [cx-38, cy-41/s3], [cx-38, -cy+41/s3],
                    [cx-32, -cy+35/s3], [cx-24, -cy+39/s3],
                ]);
                polygon([
                    [cx-40, cy-43/s3], [3, 0], [cx-40, -cy+43/s3],
                ]);
            }
        }
        rotate([0,0,0]) polygon([
            [-cx+24, -1.5], [-cx+37, -1.5], [-cx+35, +1.5], [-cx+24, +1.5]
        ]);
        rotate([0,0,batteryan]) translate(battof) polygon([
            [-by+0.3,-bx-2], [-by+0.3, bx+2],
            [ by-0.3, bx+2], [ by-0.3,-bx-2],
            [-by+2.3,-bx], [-by+2.3, bx],
            [ by-2.3, bx], [ by-2.3,-bx],
        ], [[0,1,2,3], [4,5,6,7]]);
    }
    // Flat bit
    color("#8c3") translate([0,0,rti]) linear_extrude(height = thi, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [di2/2 * sin(an), di2/2 * cos(an)]] );
            rotate([0,0,batteryan]) translate(battof) polygon([
                [-by+2.3,-bx], [-by+2.3, bx],
                [ by-2.3, bx], [ by-2.3,-bx]
            ]);
            for (an=[0:60:300]) rotate([0, 0, an]) {
                polygon([
                    [0, cy*2-3],
                    [ 4, cy*2-5], [ 7, cy*2-15],
                    [7, cy*2-22], [-7, cy*2-22],
                    [-7, cy*2-15], [-4, cy*2-5],
                ]);
            }
        }
    }
    for (an=[0:60:300]) rotate([0, 0, an]) {
        translate([0,0,rti]) cover_holder(di2, sidehi-rti);
    }
    // Battery cover hinges
    *rotate([0,0,batteryan]) for (m=[0,1]) mirror([m,0,0])
        translate([(batty/2-0.9), -battx/2+battof.y-1.4, thi+rti]) {
        polyhedron(points = [
            [ 0, 0, 0], [ 0, -8, 0], [ 0, -5, 3], [ 0, -3, 3],
            [-5, 0, 0], [-5, -8, 0], [-5, -5, 3], [-5, -3, 3],
            [-8,-4, 0]
        ], faces = [
            [0,1,2,3],
            [4,5,1,0], [5,6,2,1], [6,7,3,2], [7,4,0,3],
            [7,6,8], [6,5,8], [5,4,8], [4,7,8],
        ]);
    }
}

module cover_holder(di, hi)
{
    wid = 20;
    swi = 7;
    ln = 15;
    ho = 2.5;
    ht = 2.2;

    cx = di*s3/4;
    cy = di/2;

    sx = swi/2;

    who = 10;
    co = sx/s3;

    color("#6a2") translate([0, -cy, 0]) difference() {
        union() {
            linear_extrude(height=hi, convexity=6) polygon([
                    [ 0, 0], [ -wid/2, wid/2/s3], [ -wid/2, ln],
                    [ wid/2, ln], [ wid/2, wid/2/s3]
                ]);
            rotate([0,-90,0]) translate([0,0,-wid/2]) linear_extrude(height=wid) polygon([
                [0,ln+who], [who,ln], [0,ln]
            ]);
        }

        translate([0, 0, hi-ho-ht]) linear_extrude(height=ht+0.2, convexity=6) polygon(
            mirrorx([
            [sx+0.1, -0.01],
            [sx+0.1, 6],
            [sx+0.1+1.8, 13],
            [sx+0.1, 14],
            [sx+0.1, ln+0.01]
            ])
        );
        polyhedron(convexity=4, points=[
            [0, 3, -0.001], [4, 5, -0.001], [7, 15, -0.001], [7, 22, -0.001],
            [-7, 22, -0.001], [-7, 15, -0.001], [-4, 5, -0.001],

            [0, 7, 4], [0, 15, 7],
        ], faces = [
            [0,1,2,3,4,5,6],
            [1,0,7], [2,1,7], [2,7,8], [3,2,8], [4,3,8],
            [5,4,8], [5,8,7], [6,5,7], [0,6,7],
        ]);
        *rotate([0,-90,0]) translate([0,0,-4]) linear_extrude(height=8) polygon([
            [-0.01,ln-10+0.01], [who,ln], [-0.01,ln+0.01]
        ]);
        *rotate([0,-90,0]) translate([0,0,-swi/2]) linear_extrude(height=swi) polygon([
            [hi-ho+0.2-0.01,-0.01], [hi-ho+0.2-0.01,co+0.01], [hi-ho+0.2+co+0.01,-0.01],
        ]);
        rotate([0,-90,0]) translate([0,0,-swi/2]) linear_extrude(height=swi) polygon([
            [hi-ho+0.2-0.01,-0.01], [hi-ho+0.2-0.01,co],
            [hi+0.01,co], [hi+0.01,-0.01],
        ]);
    }
}

module wire_guide()
{
    hw = 2.4;
    ln = 15.5;
    color("#4a8") linear_extrude(height=1.4, convexity=6) polygon([
        [hw, 0.8], [hw-0.8, 0], [-hw+0.8, 0], [-hw,0.8],
        [-hw, ln-1], [-hw+1, ln], [hw-1, ln], [hw, ln-1],
        [hw, ln-3.6], [hw-0.4, ln-4], [hw-0.8, ln-4], [hw-1.2, ln-3.6],
        [hw-1.2, ln-1.2], [hw-1.6, ln-0.8], [-hw+1.6, ln-0.8],
        [-hw+1.2, ln-1.2], [-hw+1.2, ln-5.0], [-hw+2, ln-5.8], [hw-0.8, ln-5.8], [hw, ln-6.6],
    ]);
}

module cover_pin()
{
    wid = 20;
    swi = 7;
    ln = 15;
    ho = 2.5;
    ht = 2.2;

    th = 1.2;

    sx = swi/2;

    color("#bc4") linear_extrude(height=2, convexity=6) polygon(mirrorx([
        [sx-0.4, -2.4], [sx, -2.0], [sx, 6], [sx+1.8, 13], [sx, 14], [sx, 15.2],
        [sx+3, 15.2], [sx+3, 17.2], [sx, 17.2], [sx-th, 17.2-th], [sx-th, 1.5]
    ]));
}

function mirrorx(ar) = concat(ar, [for (i=[len(ar)-1:-1:0]) [-ar[i][0], ar[i][1]]]);

module hexbase_bot(battery = false)
{
    dia = 109.6;
    can = 0.6;
    hi = 1;
    bhi = 5;
    shox = 8;
    shoy = 25;

    cx = dia*s3/4;
    cy = dia/4;

    h1 = 16;
    h2 = 17;
    h3 = 17.7;
    hx = cx-16;

    // Channel bit
    color("#aa3") linear_extrude(height = can, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
            for (an=[0:120:240]) rotate([0,0,an]) {
                polygon([
                    [cx-4,  -cy+4/s3], [cx-22, -cy-14/s3],
                    [cx-28, -cy+4/s3], [cx-18, -cy+14/s3],
                    [cx-18,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                ]);
                polygon([
                    [cx-2, cy-shoy-2.8],
                    [cx-2, cy-shoy-6.8],
                    [cx-16, cy-shoy-6.8],
                    [cx-16, cy-shoy-2.8]
                ]);
            }
            rotate([0,0,240]) polygon([
                [ hx, cy-shoy-3],  [ hx+1, cy-shoy-3],
                [ hx+1, cy-h3], [ hx, cy-h3]
            ]);
            rotate([0,0,120]) polygon([
                [ cx-15.9, cy-shoy-2.8], [ cx-15.9, cy-shoy-4.2],
                [ cos(120)*(hx) - sin(120)*(cy-h2),
                  sin(120)*(hx) + cos(120)*(cy-h2) ],
                [ cos(120)*(hx+1) - sin(120)*(cy-h2-1),
                  sin(120)*(hx+1) + cos(120)*(cy-h2-1) ],
            ]);
            polygon([
                [ cx-15.99, cy-shoy-5.4], [ cx-15.99, cy-shoy-6.8],
                [ cos(240)*(hx+1) - sin(240)*(cy-h1),
                  sin(240)*(hx+1) + cos(240)*(cy-h1) ],
                [ cos(240)*(hx) - sin(240)*(cy-h1-1),
                  sin(240)*(hx) + cos(240)*(cy-h1-1) ],
            ]);
            rotate([0,0,240]) {
                polygon([ [hx, cy-h3], [hx, cy-h3-1], [hx+1,cy-h3-1], [hx+1, cy-h3]]);
                polygon([ [hx, cy-h2], [hx, cy-h2-1], [hx+1,cy-h2-1], [hx+1, cy-h2]]);
                polygon([ [hx, cy-h1], [hx, cy-h1-1], [hx+1,cy-h1-1], [hx+1, cy-h1]]);
            }
        }
    }
    // Middle bit
    translate([0,0,can]) linear_extrude(height = hi-can, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
            for (an=[0:120:240]) rotate([0,0,an]) {
                polygon([
                    [cx-4,  -cy+4/s3], [cx-22, -cy-14/s3],
                    [cx-28, -cy+4/s3], [cx-18, -cy+14/s3],
                    [cx-18,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                ]);
                polygon([
                    [cx-2, cy-shoy-2.8],
                    [cx-2, cy-shoy-6.8],
                    [cx-16, cy-shoy-6.8],
                    [cx-16, cy-shoy-2.8]
                ]);
            }
            rotate([0,0,240]) {
                polygon([ [hx, cy-h3], [hx, cy-h3-1], [hx+1,cy-h3-1], [hx+1, cy-h3]]);
                polygon([ [hx, cy-h2], [hx, cy-h2-1], [hx+1,cy-h2-1], [hx+1, cy-h2]]);
                polygon([ [hx, cy-h1], [hx, cy-h1-1], [hx+1,cy-h1-1], [hx+1, cy-h1]]);
            }
        }
    }
    // Ridgy bit
    color("#ba3") translate([0,0,hi]) linear_extrude(height = bhi-hi, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
            for (an=[0:120:240]) rotate([0,0,an]) {
                polygon([
                    [cx-2, -cy+10/s3],
                    [cx-6,  -cy-2/s3], [cx-18, -cy-14/s3],
                    [cx-18,  cy-shoy], [cx-2,   cy-shoy]
                ]);
                polygon([
                    [cx-18, cy-shoy+2], [cx-2,  cy-shoy+2],
                    [cx-2, cy-10/s3], [cx-6,  cy+2/s3],
                    [cx-18, cy+14/s3]
                ]);
                polygon([
                    [cx-20, cy-8], [cx-20, cy+16/s3],
                    [cx-32,  cy+28/s3], [cx-46,  cy+14/s3]
                ]);
                polygon([
                    [cx-20, cy-10], [cx-46, cy+10/s3],
                    [cx-46, 4/s3]
                ]);
                polygon([
                    [cx-20, cy-12], [cx-20, -cy+12],
                    [cx-46, 0]
                ]);
            }
            for (an=[0:60:300]) rotate([0,0,an]) {
                polygon([
                    [-2.5, cy*2-2.2], [+2.5, cy*2-2.2],
                    [+2.5, cy*2-3.8], [-2.5, cy*2-3.8],
                ]);
            }
            if (battery) {
                rotate([0,0,batteryan]) translate(battof) polygon([
                        [-batty/2-0.1,-battx/2-0.1], [-batty/2-1.1,-battx/2+0.9],
                        [-batty/2-1.1, battx/2-0.9], [-batty/2-0.1, battx/2+0.1],
                        [ batty/2+2.1, battx/2+0.1], [ batty/2+2.1,-battx/2-0.1],
                ]);
            }
        }
    }

    for (an=[0:60:300]) rotate([0,0,an]) {
        translate([cx, 0, 1]) rotate([0,-90,0]) linear_extrude(height=2) polygon([
            [0, -cy+7], [12, -cy+19], [12, cy-19], [0, cy-7],
        ]);
    }

    for (an=[0:120:240]) rotate([0,0,an]) {
        translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
    }
    if (battery) {
        rotate([0,0,batteryan]) batterybox();
    }
}

module hexbase_top(battery = true)
{
    dia = 109.6;
    can = 0.6;
    hi = 1;
    bhi = 5;
    shox = 8;
    shoy = 10;

    cx = dia*s3/4;
    cy = dia/4;

    h1 = 0;
    h2 = 2;
    h3 = 6;

    hx = cx-7;

    hx2 = cx-18;
    h22 = 10;

    h4 = 4;

    difference() {
        union() {
            // Channel bit
            color("#ba3") linear_extrude(height = can, convexity=6) {
                difference() {
                    polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
                    for (an=[0:120:240]) rotate([0,0,an]) {
                        polygon([
                                [cx-4,  -cy+9], [cx-6, -cy+7], [cx-16, -cy+7],
                                [cx-18, -cy+9], [cx-18,  5],
                                [cx-16,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                        ]);
                        polygon([
                                [cx-2, cy-shoy-2.8],
                                [cx-2, cy-shoy-6.8],
                                [cx-16, cy-shoy-6.8],
                                [cx-16, cy-shoy-2.8]
                        ]);
                    }
                    rotate([0,0,240]) polygon([
                            [ hx, cy-shoy-3],  [ hx+1, cy-shoy-3],
                            [ hx+1, cy-h3], [ hx, cy-h3]
                    ]);
                    rotate([0,0,120]) polygon([
                            [ cx-15.9, cy-shoy-2.8], [ cx-15.9, cy-shoy-3.8],
                            [ cos(120)*(hx2) - sin(120)*(cy-h22),
                            sin(120)*(hx2) + cos(120)*(cy-h22) ],
                            [ cos(120)*(hx) - sin(120)*(cy-h2),
                            sin(120)*(hx) + cos(120)*(cy-h2) ],
                            [ cos(120)*(hx) - sin(120)*(cy-h2-1),
                            sin(120)*(hx) + cos(120)*(cy-h2-1) ],
                            [ cos(120)*(hx2+1) - sin(120)*(cy-h22-1),
                            sin(120)*(hx2+1) + cos(120)*(cy-h22-1) ],
                    ]);
                    polygon([
                            [ cx-15.9, cy-shoy-4.6], [ cx-15.9, cy-shoy-6.6],
                            [ cos(240)*(hx) - sin(240)*(cy-h1),
                            sin(240)*(hx) + cos(240)*(cy-h1) ],
                            [ cos(240)*(hx+1) - sin(240)*(cy-h1-1),
                            sin(240)*(hx+1) + cos(240)*(cy-h1-1) ],
                    ]);
                    rotate([0,0,240]) {
                        polygon([ [hx, cy-h3], [hx, cy-h3-1], [hx+1,cy-h3-1], [hx+1, cy-h3]]);
                        polygon([ [hx, cy-h2], [hx, cy-h2-1], [hx+1,cy-h2-1], [hx+1, cy-h2]]);
                        polygon([ [hx, cy-h1], [hx, cy-h1-1], [hx+1,cy-h1-1], [hx+1, cy-h1]]);
                        polygon([ [hx, cy-h4], [hx, cy-h4-1], [hx+4,cy-h4-1], [hx+4, cy-h4]]);
                    }
                }
            }
            // Middle bit
            translate([0,0,can]) linear_extrude(height = hi-can, convexity=6) {
                difference() {
                    polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
                    for (an=[0:120:240]) rotate([0,0,an]) {
                        polygon([
                                [cx-4,  -cy+9], [cx-6, -cy+7], [cx-16, -cy+7],
                                [cx-18, -cy+9], [cx-18,  5],
                                [cx-16,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                        ]);
                        polygon([
                                [cx-2, cy-shoy-2.8],
                                [cx-2, cy-shoy-6.8],
                                [cx-16, cy-shoy-6.8],
                                [cx-16, cy-shoy-2.8]
                        ]);
                    }
                    rotate([0,0,240]) {
                        polygon([ [hx, cy-h3], [hx, cy-h3-1], [hx+1,cy-h3-1], [hx+1, cy-h3]]);
                        polygon([ [hx, cy-h2], [hx, cy-h2-1], [hx+1,cy-h2-1], [hx+1, cy-h2]]);
                        polygon([ [hx, cy-h1], [hx, cy-h1-1], [hx+1,cy-h1-1], [hx+1, cy-h1]]);
                        polygon([ [hx, cy-h4], [hx, cy-h4-1], [hx+1,cy-h4-1], [hx+1, cy-h4]]);
                        polygon([ [hx+3, cy-h4], [hx+3, cy-h4-1], [hx+4,cy-h4-1], [hx+4, cy-h4]]);
                    }
                }
            }
            // Ridgy bit
            color("#ba3") translate([0,0,hi]) linear_extrude(height = bhi-hi, convexity=6) {
                difference() {
                    polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
                    for (an=[0:120:240]) rotate([0,0,an]) {
                        polygon([
                                [cx-2, -cy+10/s3],
                                [cx-6,  -cy-2/s3], [cx-18, -cy-14/s3],
                                [cx-18,  cy-shoy], [cx-2,   cy-shoy]
                        ]);
                        polygon([
                                [cx-18, cy-shoy+2], [cx-2,  cy-shoy+2],
                                [cx-2,  cy-10/s3], [cx-6,  cy+2/s3],
                                [cx-18, cy+14/s3]
                        ]);
                        polygon([
                                [cx-20, cy-shoy+2], [cx-20, cy+16/s3],
                                [cx-30,  cy+26/s3], [cx-45,  cy+11/s3]
                        ]);
                        polygon([
                                [cx-20, cy-shoy], [cx-46, cy+9/s3],
                                [cx-46, 4/s3]
                        ]);
                        polygon([
                                [cx-20, cy-shoy-2], [cx-20, -cy+shoy+2],
                                [cx-46, 0]
                        ]);
                    }
                    for (an=[0:60:300]) rotate([0,0,an]) {
                        polygon([
                                [-2.5, cy*2-2.2], [+2.5, cy*2-2.2],
                                [+2.5, cy*2-3.8], [-2.5, cy*2-3.8],
                        ]);
                    }
                    if (battery) {
                        rotate([0,0,batteryan]) translate(battof) polygon([

                                [-batty/2-2.2,-battx/2-0.1],
                                [-batty/2-5.4,-battx/2+14.4],
                                [-batty/2-1.1,-battx/2+14.4],
                                [-batty/2-1.1,-battx/2+16.1],
                                [-batty/2-4.2,-battx/2+16.1],
                                [-batty/2-5.3,-battx/2+17.3],
                                [-batty/2-5.0, battx/2-4],
                                [-batty/2-1.1, battx/2-3],
                                [-batty/2-1.1, battx/2+0.1],

                                [ batty/2+1.1, battx/2+0.1],
                                [ batty/2+1.1, battx/2-3],
                                [ batty/2+5.0, battx/2-4],
                                [ batty/2+5.0,-battx/2+17.9],
                                [ batty/2+4.0,-battx/2+16.1],
                                [ batty/2+1.1,-battx/2+16.1],
                                [ batty/2+1.1,-battx/2+14.4],
                                [ batty/2+5.4,-battx/2+14.4],

                                [ batty/2+2.2,-battx/2-0.1],
                        ]);
                    }

                    // digispark
                    *rotate([0,0,digipos[2]]) polygon([
                            [digipos.x+0.2, digipos.y-9.2], [digipos.x-23.2, digipos.y-9.2],
                            [digipos.x-23.2, digipos.y+9.2], [digipos.x+0.2, digipos.y+9.2],
                    ]);

                    // attiny board
                    sz = [24, 15];
                    rotate([0,0,tinypos[3]]) translate([tinypos.x - (sz.x/2), tinypos.y - (sz.y/2), 0])
                        square(sz+[0,0.2], true);


                    // Receiver
                    rotate([0,0,0]) polygon([
                            [-cx + 2.5,-15], [-cx + 2.5, 00],
                            [-cx + 7.0, 00], [-cx + 7.0,-15],
                    ]);
                }
                *rotate([0,0,digipos[2]]) polygon(points=[
                        [digipos.x+1.4, digipos.y-10.4], [digipos.x-25.0, digipos.y-10.4],
                        [digipos.x-25.0, digipos.y+10],
                        [digipos.x-24.0, digipos.y+10.6], [digipos.x+1.4, digipos.y+10.6],
                        [digipos.x+0.2, digipos.y-9.2], [digipos.x-23.0, digipos.y-9.2],
                        [digipos.x-23.0, digipos.y+9.4], [digipos.x+0.2, digipos.y+9.4],
                ], paths=[
                [0,1,2,3,4],[5,6,7,8],
                ]);

                t = [2,2];
                *rotate([0,0,tinypos[3]]) translate([tinypos.x,tinypos.y]) polygon([
                    [-sz.x,-sz.y-t.y],[t.x,-sz.y-t.y],
                    [t.x,t.y],[-sz.x-t.x,t.y],
                    [-sz.x-t.x,-10],[-sz.x,-10],
                    [-sz.x,0.1],[0,0.1],[0,-sz.y],[-sz.x,-sz.y]
                ]);
            }

            // Digipark plateau
            *color("#b83") rotate([0,0,digipos[2]]) {
                translate([digipos.x-23.2, digipos.y+10.2, 1])
                    rotate([90,0,0]) linear_extrude(height=15) polygon([
                            [-1,0], [19,0], [19, 3], [0,3+19*tan(digipos[3])]
                    ]);
                translate([digipos.x-23.2, digipos.y+10.6, 3])
                    rotate([90,0,0]) linear_extrude(height=1.2) polygon([
                            [-0.75,0], [25,0], [25, 2], [0.3,2+24.7*tan(digipos[3])]
                    ]);
            }

            // attiny module plateau
            color("#b83") rotate([0,0,tinypos[3]]) translate([tinypos.x,tinypos.y, 0]) {
                translate([-2,-16, 0.9]) cube([2.2, 16.5, 2.5]);
                translate([-23.2,-16, 0.9]) cube([2.2, 16.5, 2.5]);
                rotate([0,90,0]) linear_extrude(height=2) polygon([
                    [-5,-16], [-0.5,-16],[-0.5, 1],[-5, 1],
                    [-5,-2],[-10,-2],[-10,-4],[-5,-9]
                ]);
                translate([-25.2,0,0]) rotate([0,90,0]) linear_extrude(height=2, convexity=4) polygon([
                    [-0.5,-10],[-0.5, 1],[-5, 1],
                    [-5,0],[-8,-3],[-8,-5.4],[-3.4,-10]
                ]);
                translate([0,-15.1,0]) rotate([90,0,0]) linear_extrude(height=2, convexity=4) polygon([
                    [2,0],[2,5],[-3,5],[-7,9],[-10,9],[-14,5],[-23,5],[-23,0]
                ]);
            }

            // 5V module
            *color("#b83") rotate([0,0,60]) translate([cx-2, 0, 1]) {
                translate([-8/2, 0, 1.2/2]) cube([8,10.8,1.2], true);
                translate([-9.2/2, -5.4-1.2/2, 8/2]) cube([9.2, 1.2, 8], true);
                translate([-9.2/2, +5.4+1.2/2, 8/2]) cube([9.2, 1.2, 8], true);
                translate([-8-1.2/2, 0, 8/2]) cube([1.2, 11, 8], true);
            }

            // ws2811 plateau
            color("#b83") rotate([0,0,240]) translate([wspos.x, wspos.y, 0]) {
                translate([-2,0,0]) rotate([0,-90,0]) linear_extrude(height=10.5, convexity=5)
                    polygon([
                        [0.9,-4.5],[0.9,4.5],[4,4.5],
                        [4,4.1],[2.4,2.5],[2.4,-2.5], [4,-4.1],
                        [4,-4.5]
                    ]);
                translate([-12.8+2.3/2,0,0.9+3.1/2]) cube([2.3,9,3.1], true);
                translate([0, 4.5, 0.9]) linear_extrude(height=4.1) polygon([
                    [0, 0], [0.8, 0], [0.8, -1], [2.2, -4], [0, -3]
                ]);
                translate([-12.8/2, 4.5+1.2/2, 0.9+4.1/2]) cube([12.8, 1.2, 4.1], true);

            }
            // WS2811 wire holders
            color("#b83") rotate([0,0,240]) translate([cx-18, wspos.y, 5]) rotate([0,-90,0]) linear_extrude(height=2, convexity=4)
            difference() {
                polygon([ [0, -7.2], [0, 9.14], [3.2, 9.14], [3.2, -4] ] );
                translate([1.6,-3]) rotate([0,0,180/8]) circle(1.2, $fn=8);
                translate([1.6, 0]) rotate([0,0,180/8]) circle(1.2, $fn=8);
                translate([1.6, 3]) rotate([0,0,180/8]) circle(1.2, $fn=8);
            }

            // Receiver
            color("#b83") translate([0,0,0.9]) difference() {
                union() {
                    linear_extrude(height=3.8) polygon([
                        [-cx + 1.9,-10.5], [-cx + 1.9,-0.3],
                        [-cx + 7.7,-0.3], [-cx + 7.7,-10.5],
                    ]);
                    linear_extrude(height=12.5) polygon([
                        [-cx + 6.5,-10.5], [-cx + 6.5,-0.3],
                        [-cx + 7.7,-0.3], [-cx + 7.7,-10.5],
                    ]);
                    linear_extrude(height=10.1) polygon([
                        [-cx + 1.9,-10.5], [-cx + 1.9,-0.3],
                        [-cx + 4.0,-0.3], [-cx + 4.0,-10.5],
                    ]);
                    linear_extrude(height=6.1) polygon([
                        [-cx + 1.9, 5.6], [-cx + 1.9, 7.6],
                        [-cx + 5.7, 7.6], [-cx + 5.7, 5.6],
                    ]);

                    linear_extrude(height=3.8) polygon([
                        [-cx + 4.3,-27], [-cx + 1.9, -22], [-cx + 1.9,-20],
                        [-cx + 9.6,-20], [-cx + 9.6, -24.65], [-cx + 8.3,-27],
                    ]);
                    linear_extrude(height=5.6) polygon([
                        [-cx + 3.1,-25.0], [-cx + 2.8,-23.5],
                        [-cx + 4.0,-23.5], [-cx + 4.0,-25.0],
                        [-cx + 4.9,-25.0], [-cx + 4.9,-26.2],
                        [-cx + 3.8,-26.2]
                    ]);
                    linear_extrude(height=5.6) polygon([
                        [-cx + 8.4,-24.65], [-cx + 8.4, -20],
                        [-cx + 9.6,-20], [-cx + 9.6, -24.65],
                    ]);
                    linear_extrude(height=12.5, convexity=4) polygon([
                        [-cx + 7.7, -0.3], [-cx + 9.5, -2+2/s3], [-cx + 12.7, -2+5.2/s3],
                        [-cx + 14.7, -2-0.8/s3], [-cx + 7.5, -2-8.0/s3],
                    ]);
                    translate([-cx + 22.7, -2-25/s3, 12.5]) rotate([0,-90,-60]) 
                        linear_extrude(height=4, convexity=4) polygon(concat([
                            [-2.5,0], [-11.5,0], [-5.0,-6.5], [0,-6.5], [0,-5.1]],
                            [for (an=[0:6:180]) [-2.5-sin(an)*2.55,-2.55-cos(an)*2.55]])
                        );
                }
                translate([-cx+8.5, 3, 10.0]) rotate([0,0,-60]) {
                    rotate([0,90,0]) cylinder(10, 5.077/2, 5.077/2, $fn=60);
                    translate([10/2,0,2.5/2]) cube([10,5.077,2.5 + 0.1], true);
                }
                translate([-cx+11, 1.5, 2]) rotate([0,90,-60]) {
                    cylinder(6, 1, 1, $fn=4);
                }
            }

            // Tilt module
            color("#b83") rotate([0,0,210]) translate([0, battx/2+3.8-battof.y, 0.6]) {
                translate([0, 0.4+2/2, 0.4+12/2]) cube([24.6, 2, 12], true);
                translate([10.3-4+6/2, 2.4+1.8+2/2, 0.4+4/2]) cube([6, 2, 4], true);
                translate([-10.3+4-6/2, 2.4+1.8+2/2, 0.4+4/2]) cube([6, 2, 4], true);
                translate([10.3+2/2, -2.7+8.9/2, 0.4+12/2]) cube([2, 8.9, 12], true);
                translate([-10.3-2/2, -2.7+8.9/2, 0.4+12/2]) cube([2, 8.9, 12], true);

                translate([10.3-2+4/2, 2.4+1.8+2/2, 0.4+12/2]) cube([4, 2, 12], true);
            }

            // Side tabs
            for (an=[0:60:300]) rotate([0,0,an]) {
                translate([cx, 0, 1]) rotate([0,-90,0]) linear_extrude(height=2) polygon([
                        [0, -cy+7], [12.4, -cy+19], [12.4, cy-19], [0, cy-7],
                ]);
            }

            // filament screwdowns
            for (an=[0:120:240]) rotate([0,0,an]) {
                translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
            }


            // Battery holder
            if (battery) {
                rotate([0,0,batteryan]) batterybox();
            }
        }
        /*
        // Hole for digispark screw
        rotate([0,0,digipos[2]]) translate([digipos.x-23.2, digipos.y+10.2, 1])
            rotate([0,digipos[3],0]) translate([21.6-23+2.4,-0.8-2.3,-1.2]) cylinder(9.2, 1.2, 1.2, $fn=24);
            */

        // Hole for Tilt module
        color("#b83") rotate([0,0,210]) translate([0, battx/2+3.8-battof.y, 0.6]) {
            translate([0, 2.4+1.8/2, 15.6/2]) cube([20.6,1.8,15.6], true);
        }
        // Bit of cutout for ws2811
        color("#b83") rotate([0,0,240]) translate([wspos.x, wspos.y, 0]) {
            translate([-1/2, 4.5-2/2, 4+1/2]) cube([1, 2, 1.1], true);
        }
    }
}

module battery_retainer(num = numbatteries, bo = batteryoffset, thi = 1.2, bof=1.6-14.6)
{
    x1 = -batty/2-2.6;
    x2 =  batty/2-2.6;
    yo = num/2*bo;
    xo = 15/2+2;

    tol = -0.2;

    bhdi = (14.5+0.5)/2;

    hw1 = 10;
    hw2 = 7;
    ht = 1.2;

    hi = 17.4;

    rotate([0,0,batteryan])
    translate(battof+[-x2-0.1, 0, 1.6+hi]) rotate([0,90,0]) linear_extrude(height=x2-x1+0.2, convexity=6) {
        polygon(concat(
            [[xo-sin(30)*bhdi,yo+tol], [bof, yo+tol], [bof,-yo-tol], [xo-sin(150)*bhdi,-yo-tol]],
            [for (y=[-(num-1)/2:(num-1)/2], an=[30:5:150]) [xo-sin(an)*bhdi, y*bo-cos(an)*bhdi]],
            []
        ));
    }
}

module receiver_jig()
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;
    // Receiver
    color("#b83") translate([0,0,0.9]) difference() {
        union() {
            linear_extrude(height=3.8) polygon([
                    [-cx + 1.9,-10.5], [-cx + 1.9,-0.3],
                    [-cx + 7.7,-0.3], [-cx + 7.7,-10.5],
            ]);
            linear_extrude(height=12.5) polygon([
                    [-cx + 6.5,-10.5], [-cx + 6.5,-0.3],
                    [-cx + 7.7,-0.3], [-cx + 7.7,-10.5],
            ]);
            linear_extrude(height=10.1) polygon([
                    [-cx + 1.9,-10.5], [-cx + 1.9,-0.3],
                    [-cx + 4.0,-0.3], [-cx + 4.0,-10.5],
            ]);
            linear_extrude(height=6.1) polygon([
                    [-cx + 1.9, 5.6], [-cx + 1.9, 7.6],
                    [-cx + 5.7, 7.6], [-cx + 5.7, 5.6],
            ]);

            linear_extrude(height=3.8) polygon([
                    [-cx + 4.3,-27], [-cx + 1.9, -22], [-cx + 1.9,-20],
                    [-cx + 9.6,-20], [-cx + 9.6, -24.65], [-cx + 8.3,-27],
            ]);
            linear_extrude(height=5.6) polygon([
                    [-cx + 3.1,-25.0], [-cx + 2.8,-23.5],
                    [-cx + 4.0,-23.5], [-cx + 4.0,-25.0],
                    [-cx + 4.9,-25.0], [-cx + 4.9,-26.2],
                    [-cx + 3.8,-26.2]
            ]);
            linear_extrude(height=5.6) polygon([
                    [-cx + 8.4,-24.65], [-cx + 8.4, -20],
                    [-cx + 9.6,-20], [-cx + 9.6, -24.65],
            ]);
            linear_extrude(height=12.5, convexity=4) polygon([
                    [-cx + 7.7, -0.3], [-cx + 9.5, -2+2/s3], [-cx + 12.7, -2+5.2/s3],
                    [-cx + 14.7, -2-0.8/s3], [-cx + 7.5, -2-8.0/s3],
            ]);
            translate([-cx + 22.7, -2-25/s3, 12.5]) rotate([0,-90,-60]) 
                linear_extrude(height=4, convexity=4) polygon(concat([
                            [-0.5, 0], [-0.5,1.6], [-11.5,1.6], [-11.5,-7.0], [0,-7.0], [0,-5.1]],
                            [for (an=[0:6:180]) [-2.5-sin(an)*2.55,-2.55-cos(an)*2.55]])
                        );
            linear_extrude(height=3.0, convexity=4) polygon([
                [-cx+8, -28], [-cx+5, -28], [-cx + 1, -23],[ -cx + 1, 8], [-cx+6, 8],
                [-cx + 12.5, 4], [-cx + 16.4, -2.5], [-cx + 24.12, -15.63], [-cx + 16, -20.31],
            ]);
            linear_extrude(height=12.5) polygon([
                [-cx + 12.5, 4], [-cx + 16.4, -2.5],
                [-cx + 15, -3.18], [-cx + 11.3, 3.3],
            ]);
        }
        translate([-cx+8.5, 3, 10.0]) rotate([0,0,-60]) {
            rotate([0,90,0]) cylinder(10, 5.077/2, 5.077/2, $fn=60);
            translate([10/2,0,2.5/2]) cube([10,5.077,2.5 + 0.1], true);
        }
    }

}

module batterybox(num = numbatteries, bo = batteryoffset, thi = 1.2, bof=0.6)
{
    x1 = -batty/2;
    x2 =  batty/2;
    yo = num/2*bo;
    xo = 15/2+2;

    bhdi = (14.5+0.5)/2;

    hw1 = 10;
    hw2 = 7;
    ht = 1.2;

    hi = 17.4;

    // color("#333")
    translate(battof) difference() {
        union() {
            translate([x1+ht, -num/2*bo-thi, bof]) cube([x2-x1-ht*2, thi, hi-bof]);
            translate([x1+ht,  num/2*bo    , bof]) cube([x2-x1-ht*2, thi, hi-bof]);

            translate([x1-thi, -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, hi-4-bof]);
            translate([x2    , -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, hi-4-bof]);

            translate([x2+0.1, 0, 0]) rotate([0,-90,0]) linear_extrude(height=x2-x1+0.2, convexity=6) {
                polygon(concat(
                    [[xo-sin(15)*bhdi,yo+1], [bof, yo+1], [bof,-yo-1], [xo-sin(165)*bhdi,-yo-1]],
                    [for (y=[-(num-1)/2:(num-1)/2], an=[15:5:165]) [xo-sin(an)*bhdi, y*bo-cos(an)*bhdi]],
                    []
                ));
            }

            for (x=[0,1]) {
                mirror([x,0,0]) {
                    for (y=[(-num+1)/2:(num-1)/2]) {
                        translate([x1, (y-0.5)*bo-thi, bof]) cube([ht,(bo-hw1)/2+thi,hi-4-bof]);
                        translate([x1, y*bo+hw1/2, bof]) cube([ht,(bo-hw1)/2+thi,hi-4-bof]);

                        translate([x1+ht, (y-0.5)*bo, bof]) cube([1.2,(bo-hw2)/2,hi-bof]);
                        translate([x1+ht, y*bo+hw2/2, bof]) cube([1.2,(bo-hw2)/2,hi-bof]);
                    }
                    translate([x1, -num/2*bo-thi, bof]) cube([1.8, num*bo+thi*2, 3.4]);
                }
            }
        }
        for (x=[0,1]) {
            mirror([x,0,0]) {
                for (y=[(-num+1)/2:(num-1)/2]) {
                    translate([x1-1, y*bo, bof+2.0]) rotate([0,45,0]) cube([0.57,3,5], true);
                }
                *#translate([x1-0.15, 0, 13+5.1/2]) cube([2.3, num*bo+2*thi+0.1, 5.1], true);
            }
        }
        // Cut off bits of corners
        translate([x1, -num/2*bo, 0]) rotate([0,0,30]) rotate([0,45,0]) cube([10,15,4.5], true);
        translate([x1-1.5, -num/2*bo, 10]) rotate([0,0,30]) cube([3,7,20], true);

        translate([x2, -num/2*bo, 0]) rotate([0,0,-30]) rotate([0,-45,0]) cube([10,8.2,4.5], true);
        translate([x2+1, -num/2*bo+5, 0.00]) rotate([0,0,-65]) rotate([0,-51,0]) rotate([0,0,23.8]) cube([5,2.27,1.3], true);
        translate([x2+1.5, -num/2*bo, 10]) rotate([0,0,-30]) cube([3,7,20], true);
        translate([0, num/2*bo+1.2, 0.6]) polyhedron(points = [
                [-7.8, 0.01, -0.01], [-5, 0.01, 3], [-5,-2, -0.01],
                [20.4, 0.01, -0.01], [18.4, 0.01, 3], [18.4,-2, -0.01],
            ], faces = [
                [0,1,2], [3,5,4],
                [0,3,1], [1,3,4],
                [1,4,2], [2,4,5],
                [2,5,0], [0,5,3],
            ]);
    }
    *#translate([x1+battof.x + 1/2, bo/2+battof.y, bof+8]) cube([1,10,9], true);
}

module ws2811()
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    color("#5c5") rotate([0,0,240]) translate([wspos.x, wspos.y, 4])
    difference() {
        union() {
            translate([-12.5/2, 0, 1.4/2]) cube([12.5, 9, 1.4], true);
            translate([-2.2 - 4.0/2, 0, -1.6/2]) cube([5.0, 4.0, 1.6], true);
            translate([-7.1 - 2.5/2, 0, -1.0/2]) cube([2.5, 7.5, 1.0], true);
        }
        for (y=[-3,-1,1,3]) {
            translate([-1, y, -0.01]) cylinder(1.42, 0.5, 0.5, $fn=12);
        }
    }
}

module digispark()
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    // color("#55c") rotate([0,0,240]) translate([cx-18 -18/2, cy-3.5, 5+1.5/2]) cube([18, 23, 1.5], true);
    color("#55c") rotate([0,0,240]) translate([digipos.x -23/2, digipos.y, 3.5+1.5/2])
        cube([23, 18, 1.5], true);
}

module attiny_board()
{
    sz = [23, 15, 1.6];

    color("#55c") rotate([0,0,tinypos[3]]) translate([tinypos.x - (sz.x/2), tinypos.y - (sz.y/2), tinypos.z + (sz.z/2)])
        cube(sz, true);
}

module receiver(small=0)
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    color("#59a")
    rotate([0,0,0]) translate([-cx+4, -25, 4.7])
    if (small) {
        h = 17;
        w = 11.6;
        th = 1.5;

        color("#59a") cube([w, h, th], true);
    } else {
        h = 30.5;
        w = 8.7;
        th = 0.95;

        translate([th/2, h/2, w/2]) cube([th, h, w], true);
        translate([th + 1.55/2, 14.6 + 10/2, w/2]) cube([1.55,10,3.9], true);
        translate([th + 3.4/2, 10/2, 3.6/2]) cube([3.4,10,3.6], true);

        // Antenna coil
        translate([4.5,28,w-2.5]) rotate([0, 90, -60]) cylinder(25, 2.5, 2.5, $fn=32);
    }
}

module batteries(num = numbatteries, bo = batteryoffset)
{
    bdia = 14.5;
    color("#585") rotate([0,0,0]) for (y=[-(num-1)/2:(num-1)/2]) {
        dr = ((y+(num-1)/2) % 2) ? 1 : -1;
        translate([battof.x, battof.y+y*bo, 15/2+2]) rotate([0,90,0]) {
            translate([0,0,-50/2+dr*1]) cylinder(49, bdia/2, bdia/2, $fn=48);
            translate([0,0, dr*(50/2+1)-1]) cylinder(1.5, 3, 3, $fn=48);
        }
    }
}

module house()
{
    color("#55a") union() {
        difference() {
            translate([offset2+11.2/2,0,0]) cube([11.2,9.6,6], true);
            translate([offset2-0.01,0,0]) rotate([0,90,0]) cylinder(8.21, 1.6, 1.6, $fn=30);
            translate([offset2+1.2+2.6/2,0,0]) cube([2.6, 5.6, 6.01], true);
            translate([offset+1.2+2.6+4.2+4/2,0,0]) cube([2, 4, 6.01], true);
            translate([offset+9.5-5/2,0,0]) cube([6.81, 5.6, slideth+0.2], true);
            // 0.2 offset for bridging
            translate([offset2+1.2+3.4/2+0.2,9.6/2-2/2,0]) cube([3.4, 2.01, slideth+0.2], true);
            translate([offset+11+1.2+2/2,0,0]) cube([2, 4.0, 6.01], true);
            translate([offset+11+1.2/2,0,2+1.02/2]) cube([1.21, 4, 1.02], true);
            translate([offset+11+1.2/2,0,-2-1.02/2]) cube([1.21, 4, 1.02], true);
            translate([0,-9.6/2+2.001,0]) rotate([90,0,0]) cylinder(2.82, 1.6, 1.6, $fn=30);
            translate([0,-9.6/2+3.2,0]) rotate([90,0,0]) cylinder(1.2, 0.8, 1.6, $fn=30);

            // To enable bridging
            // translate([offset2+1.2+2.6+1/2-0.01,0,1.7-0.01]) cube([1.02, 5.6, 0.21], true);
        }
        // Sacrificial layer
        #translate([offset2+1.2-0.1, 0, 0]) cube([0.2, 4, 4], true);
    }
}

module slider()
{
    color("#99f") union() {
        translate([offset+1.2+2.6, 0, -slideth/2]) linear_extrude(height=slideth, convexity=5) polygon([
            [1,-2.6], [2.8,-2.6],[4,-1.4],[4,2.6],[1,2.6],
            [1,1.6], [2.4,1.6], [2.4,-1.6], [1,-1.6]
        ]);
        *difference() {
            translate([offset+1.2+2.6+4/2, 0, 0]) cube([4, 5.4, 3], true);
            translate([offset+1.2+2.6+2.8/2-0.01, 0, 0]) cube([2.8+0.02, 3.2, 3.01], true);
        }
    }
}

module filament_end()
{
    translate([0,-3,0]) rotate([0,90,0]) union() {
        color("#7c7") rotate([90,0,0]) {
            cylinder(10,1,1,$fn=30);
            sphere(1,$fn=30);
        }
        color("#999") scale([1,1.5,1]) cylinder(0.2, 1, 1, true, $fn=30);
        color("#999") translate([0,3,0]) cube([1,4,0.2], true);
    }
}

module bolt()
{
    color("#444") translate([offset2-5.2,0,0]) rotate([0,90,0]) union() {
        cylinder(9.3, 1.5, 1.5, $fn=30);
        cylinder(1.6, 5.8/2, 5.8/2, $fn=30);
    }
}

module nut()
{
    color("#777") translate([offset2+1.2+2.6/2,0,0]) cube([2.3, 5.5, 5.5], true);
}

module magnetic_connector(cp=48)
{
    //bthi = 1.2;
    bthi = 0.6;
    bwid = 8.25;
    blen = 18;
    bof = 4;
    bd = (blen-bof*2)/2;

    translate([0,0,0.2]) {
        cylinder(3.5, 6.8/2, 6.8/2, $fn=48);
        san = asin(bwid/(blen-bof*2));
        translate([0,0,-bthi]) linear_extrude(height=bthi) polygon(concat(
            [for (an=[-san:san/cp:san]) [sin(an)*bd, bof+cos(an)*bd]],
            [for (an=[180-san:san/cp:180+san]) [sin(an)*bd, -bof+cos(an)*bd]]
        ));
        *#translate([0,0,-bthi]) cube([bwid,blen,bthi], true);
    }
}

