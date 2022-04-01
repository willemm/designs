doitem = "";


flmd = 2;
flml = 4;
flmw = 2;
flmt = 0.2;
offset = -10;
offset2 = -8;

slideth = 3;

numbatteries = 2;
batteryoffset = 15;
batteryan = 240;

batth = 1.2;
batty = 57;
battx = batteryoffset * numbatteries;
battof = -1;

digipos = [27.5, 25.4, 240];
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
if (doitem == "") {
    if (1) {
        hexbase_top();
        *translate([0,0,14]) cover_top();
        translate([0, -109.6/2+3.7, 1.1]) rotate([90,0,0]) wire_guide();
        *translate([0, -159.6/2, 14+19-2.5-2.1]) cover_pin();

        *rotate([0,0,batteryan]) batteries();
        ws2811();
        #digispark();
        receiver();
    } else {
        hexbase_bot();
        translate([0,0,14]) cover_bot();
        translate([0, -109.6/2+3.7, 1.1]) rotate([90,0,0]) wire_guide();
        translate([0, -159.6/2, 14+19-2.5-2.1]) cover_pin();
    }


    *filament_end();
    *nut();
    *translate([2,0,0]) bolt();

    *house();
    *translate([2,0,0]) slider();
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
            rotate([0,0,batteryan]) polygon([
                [-by+battof,-bx], [-by+battof, bx],
                [ by+battof, bx], [ by+battof,-bx]
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
            }
        }
    }
    // Flat bit
    color("#8c3") translate([0,0,rti]) linear_extrude(height = thi, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [di2/2 * sin(an), di2/2 * cos(an)]] );
            rotate([0,0,batteryan]) polygon([
                [-by+battof,-bx], [-by+battof, bx],
                [ by+battof, bx], [ by+battof,-bx]
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

module hexbase_bot()
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
        }
    }

    for (an=[0:60:240]) rotate([0,0,an]) {
        translate([cx, 0, 1]) rotate([0,-90,0]) linear_extrude(height=2) polygon([
            [0, -cy+7], [12, -cy+19], [12, cy-19], [0, cy-7],
        ]);
    }

    for (an=[0:120:240]) rotate([0,0,an]) {
        translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
    }
}

module hexbase_top()
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
            rotate([0,0,batteryan]) polygon([
                [-batty/2+battof-0.1,-battx/2-0.1], [-batty/2+battof-0.1, battx/2+0.1],
                [-batty/2+battof+1.9, battx/2+0.1], [-batty/2+battof+1.9,-battx/2-0.1]
            ]);
            *rotate([0,0,batteryan]) polygon([
                [-batty/2+battof-0.1,-battx/2-0.1], [-batty/2+battof-0.1, battx/2+0.1],
                [ batty/2+battof+0.1, battx/2+0.1], [ batty/2+battof+0.1,-battx/2-0.1]
            ]);
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
            rotate([0,0,batteryan]) translate([battof,0,0]) polygon([
                [-batty/2-0.1,-battx/2-0.1], [-batty/2-1.1,-battx/2+0.9],
                [-batty/2-1.1, battx/2-0.9], [-batty/2-0.1, battx/2+0.1],
                [ batty/2+2.1, battx/2+0.1], [ batty/2+2.1,-battx/2-0.1],
            ]);
            
            // digispark
            rotate([0,0,digipos[2]]) polygon([
                [digipos.x+0.2, digipos.y-9.2], [digipos.x-23.2, digipos.y-9.2],
                [digipos.x-23.2, digipos.y+9.2], [digipos.x+0.2, digipos.y+9.2],
            ]);
        }
        rotate([0,0,digipos[2]]) polygon(points=[
            [digipos.x+1.4, digipos.y-10.4], [digipos.x-24.4, digipos.y-10.4],
            [digipos.x-24.4, digipos.y+10.4], [digipos.x+1.4, digipos.y+10.4],
            [digipos.x+0.2, digipos.y-9.2], [digipos.x-23.2, digipos.y-9.2],
            [digipos.x-23.2, digipos.y+9.2], [digipos.x+0.2, digipos.y+9.2],
        ], paths=[
            [0,1,2,3],[4,5,6,7],
        ]);
    }
    color("#b83") rotate([0,0,digipos[2]]) translate([digipos.x-23/2-2.5, digipos.y+2.5, 1+3/2])
        cube([19, 14, 3], true);

    for (an=[0:60:240]) rotate([0,0,an]) {
        translate([cx, 0, 1]) rotate([0,-90,0]) linear_extrude(height=2) polygon([
            [0, -cy+7], [12, -cy+19], [12, cy-19], [0, cy-7],
        ]);
    }

    for (an=[0:120:240]) rotate([0,0,an]) {
        translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
    }
    rotate([0,0,batteryan]) batterybox();
}

module batterybox(num = numbatteries, bo = batteryoffset, thi = 1.2, bof=0.9)
{
    x1 = -batty/2;
    x2 =  batty/2;
    yo = num/2*bo;
    xo = 15/2+2;

    bhdi = (14.5+0.5)/2;

    hw1 = 10;
    hw2 = 7;
    ht = 1;

    // color("#333")
    translate([battof,0,0]) difference() {
        union() {
            translate([x1, -num/2*bo-thi, bof]) cube([x2-x1, thi, 17]);
            translate([x1,  num/2*bo    , bof]) cube([x2-x1, thi, 17]);

            translate([x1-thi, -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, 17]);
            translate([x2    , -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, 17]);

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
                        translate([x1, (y-0.5)*bo, bof]) cube([1,(bo-hw1)/2,17]);
                        translate([x1, y*bo+hw1/2, bof]) cube([1,(bo-hw1)/2,17]);

                        translate([x1+ht, (y-0.5)*bo, bof]) cube([0.8,(bo-hw2)/2,17]);
                        translate([x1+ht, y*bo+hw2/2, bof]) cube([0.8,(bo-hw2)/2,17]);
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
            }
        }
    }
    *#translate([x1+battof + 1/2, bo/2, bof+8]) cube([1,10,9], true);
}

module ws2811()
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    color("#5c5") rotate([0,0,240]) translate([wspos.x -12.5/2, wspos.y, 5+1.5/2]) cube([12.5, 9, 1.5], true);
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

module receiver(small=0)
{
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    if (small) {
        h = 17;
        w = 11.6;
        th = 1.5;

        color("#59a") rotate([0,0,240]) translate([-cx+2.2 + w/2, 16 - h/2, 5+th/2])
            cube([w, h, th], true);
    } else {
        h = 30;
        w = 13.5;
        th = 1.5;

        color("#59a") rotate([0,0,0]) translate([-cx+2.2 + w/2, 16 - h/2, 5+th/2])
            cube([w, h, th], true);
    }
}

module batteries(num = numbatteries, bo = batteryoffset)
{
    bdia = 14.5;
    color("#585") rotate([0,0,0]) for (y=[-(num-1)/2:(num-1)/2]) {
        dr = ((y+(num-1)/2) % 2) ? 1 : -1;
        translate([battof, y*bo, 15/2+2]) rotate([0,90,0]) {
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
