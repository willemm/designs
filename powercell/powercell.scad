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

if (doitem == "house") { house(); }
if (doitem == "slider") { slider(); }
if (doitem == "hexbase_top") { hexbase_top(); }
if (doitem == "hexbase_bot") { hexbase_bot(); }
if (doitem == "") {

    hexbase_top();
    batteries();

    ws2811();
    digispark();

    *filament_end();
    *nut();
    *translate([2,0,0]) bolt();

    *house();
    *translate([2,0,0]) slider();
}

module hexbase_bot()
{
    dia = 109.6;
    can = 0.6;
    hi = 1;
    bhi = 5;
    s3 = sqrt(3);
    shox = 8;
    shoy = 25;

    cx = dia*s3/4;
    cy = dia/4;

    h1 = 18;
    h2 = 19;
    h3 = 19.7;
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
                    [cx-2,  -cy+2/s3], [cx-18, -cy-14/s3],
                    [cx-18,  cy-shoy], [cx-2,   cy-shoy]
                ]);
                polygon([
                    [cx-18, cy-shoy+2], [cx-2,  cy-shoy+2],
                    [cx-2,  cy-2/s3], [cx-18, cy+14/s3]
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
        }
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
    s3 = sqrt(3);
    shox = 8;
    shoy = 10;

    cx = dia*s3/4;
    cy = dia/4;

    h1 = 0;
    h2 = 2;
    h3 = 6;

    hx = cx-6;

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
                    [cx-2,  -cy+2/s3], [cx-18, -cy-14/s3],
                    [cx-18,  cy-shoy], [cx-2,   cy-shoy]
                ]);
                polygon([
                    [cx-18, cy-shoy+2], [cx-2,  cy-shoy+2],
                    [cx-2,  cy-2/s3], [cx-18, cy+14/s3]
                ]);
                polygon([
                    [cx-20, cy-shoy+2], [cx-20, cy+16/s3],
                    [cx-30,  cy+26/s3], [cx-44,  cy+12/s3]
                ]);
                polygon([
                    [cx-20, cy-shoy], [cx-46, cy+10/s3],
                    [cx-46, 4/s3]
                ]);
                polygon([
                    [cx-20, cy-shoy-2], [cx-20, -cy+shoy+2],
                    [cx-46, 0]
                ]);
            }
            polygon([
                [-32,-16], [-32, 16],
                [ 29, 16], [ 29,-16]
            ]);
        }
    }

    for (an=[0:120:240]) rotate([0,0,an]) {
        translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
    }
    batterybox();
}

module batterybox(num = numbatteries, bo = batteryoffset, thi = 1.2, bof=0.9)
{
    x1 = -32;
    x2 =  28;
    yo = num/2*bo;
    xo = 15/2+2;

    bhdi = (14.5+0.5)/2;

    color("#333") union() {
        translate([x1, -num/2*bo-thi, bof]) cube([x2-x1, thi, 17]);
        translate([x1,  num/2*bo    , bof]) cube([x2-x1, thi, 17]);

        translate([x1-thi, -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, 17]);
        translate([x2    , -num/2*bo-thi, bof]) cube([thi, num*bo+thi*2, 17]);

        translate([x2+thi/2, 0, 0]) rotate([0,-90,0]) linear_extrude(height=x2-x1+thi, convexity=6) {
            polygon(concat(
                [[xo-sin(15)*bhdi,yo+1], [bof, yo+1], [bof,-yo-1], [xo-sin(165)*bhdi,-yo-1]],
                [for (y=[-(num-1)/2:(num-1)/2], an=[15:5:165]) [xo-sin(an)*bhdi, y*bo-cos(an)*bhdi]],
                []
            ));
        }
    }
}

module ws2811()
{
    s3 = sqrt(3);
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    color("#5c5") rotate([0,0,240]) translate([cx-4 -12.5/2, cy-3.5, 5+1.5/2]) cube([12.5, 9, 1.5], true);
}

module digispark()
{
    s3 = sqrt(3);
    dia = 109.6;
    cx = dia*s3/4;
    cy = dia/4;

    // color("#55c") rotate([0,0,240]) translate([cx-18 -18/2, cy-3.5, 5+1.5/2]) cube([18, 23, 1.5], true);
    color("#55c") rotate([0,0,0]) translate([cx-19 -23/2, -26, 5+1.5/2])
        cube([23, 18, 1.5], true);
}

module batteries(num = numbatteries, bo = batteryoffset)
{
    bdia = 14.5;
    color("#585") rotate([0,0,0]) for (y=[-(num-1)/2:(num-1)/2]) {
        dr = ((y+(num-1)/2) % 2) ? 1 : -1;
        translate([0, y*bo, 15/2+2]) rotate([0,90,0]) {
            translate([0,0,-50/2+dr*2]) cylinder(49, bdia/2, bdia/2, $fn=48);
            translate([0,0, dr*(50/2+2)-1]) cylinder(1, 3, 3, $fn=48);
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
