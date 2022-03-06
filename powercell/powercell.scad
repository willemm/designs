doitem = "hexbase_bot";


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
if (doitem == "hexbase_top") { hexbase(); }
if (doitem == "hexbase_bot") { hexbase(0); }
if (doitem == "") {

    hexbase();
    batteries();

    *filament_end();
    *nut();
    *translate([2,0,0]) bolt();

    *house();
    *translate([2,0,0]) slider();
}

module hexbase(top=1)
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

    // Channel bit
    color("#aa3") linear_extrude(height = can, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
            for (an=[0:120:240]) rotate([0,0,an]) {
                polygon([
                    [cx-4,  -cy+4/s3], [cx-16, -cy-8/s3],
                    [cx-16,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                ]);
                polygon([
                    [cx-4, cy-shoy-2.8],
                    [cx-4, cy-shoy-6.8],
                    [cx-16, cy-shoy-6.8],
                    [cx-16, cy-shoy-2.8]
                ]);
            }
            rotate([0,0,240]) polygon([
                [ cx-16, cy-shoy-3],  [ cx-15, cy-shoy-3],
                [ cx-15, cy-6], [ cx-16, cy-6]
            ]);
            rotate([0,0,120]) polygon([
                [ cx-15.9, cy-shoy-2.8], [ cx-15.9, cy-shoy-3.8],
                [ cos(120)*(cx-16) - sin(120)*(cy-2),
                  sin(120)*(cx-16) + cos(120)*(cy-2) ],
                [ cos(120)*(cx-15) - sin(120)*(cy-3),
                  sin(120)*(cx-15) + cos(120)*(cy-3) ],
            ]);
            polygon([
                [ cx-15.9, cy-shoy-4.6], [ cx-15.9, cy-shoy-6.6],
                [ cos(240)*(cx-16) - sin(240)*(cy-0),
                  sin(240)*(cx-16) + cos(240)*(cy-0) ],
                [ cos(240)*(cx-15) - sin(240)*(cy-1),
                  sin(240)*(cx-15) + cos(240)*(cy-1) ],
            ]);
            rotate([0,0,240]) {
                polygon([ [cx-16, cy-6], [cx-16, cy-5], [cx-15,cy-5], [cx-15, cy-6]]);
                polygon([ [cx-16, cy-2], [cx-16, cy-3], [cx-15,cy-3], [cx-15, cy-2]]);
                polygon([ [cx-16, cy-0], [cx-16, cy-1], [cx-15,cy-1], [cx-15, cy-0]]);
            }
        }
    }
    // Middle bit
    translate([0,0,can]) linear_extrude(height = hi-can, convexity=6) {
        difference() {
            polygon( [for (an=[0:60:300]) [dia/2 * sin(an), dia/2 * cos(an)]] );
            for (an=[0:120:240]) rotate([0,0,an]) {
                polygon([
                    [cx-4,  -cy+4/s3], [cx-16, -cy-8/s3],
                    [cx-16,  cy-shoy-9.6], [cx-4,   cy-shoy-9.6]
                ]);
                polygon([
                    [cx-4, cy-shoy-2.8],
                    [cx-4, cy-shoy-6.8],
                    [cx-16, cy-shoy-6.8],
                    [cx-16, cy-shoy-2.8]
                ]);
            }
            rotate([0,0,240]) {
                polygon([ [cx-16, cy-6], [cx-16, cy-5], [cx-15,cy-5], [cx-15, cy-6]]);
                polygon([ [cx-16, cy-2], [cx-16, cy-3], [cx-15,cy-3], [cx-15, cy-2]]);
                polygon([ [cx-16, cy-0], [cx-16, cy-1], [cx-15,cy-1], [cx-15, cy-0]]);
            }
        }
    }
    // Ridgy bit
    translate([0,0,hi]) linear_extrude(height = bhi-hi, convexity=6) {
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
            if (top) {
                polygon([
                    [-31,-16], [-31, 16],
                    [ 31, 16], [ 31,-16]
                ]);
            }
        }
    }

    for (an=[0:120:240]) rotate([0,0,an]) {
        translate([cx-6/2 -shox, cy-9.6/2 -shoy, 4]) rotate([0,90,0]) house();
    }
    if (top) {
        batterybox();
    }
}

module batterybox(num = numbatteries, bo = batteryoffset, thi = 1.2, bof=0.9)
{
    x1 = -30.5;
    x2 =  29.5;
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
            translate([offset2+12/2,0,0]) cube([12,9.6,6], true);
            translate([offset2-0.01,0,0]) rotate([0,90,0]) cylinder(8.21, 1.6, 1.6, $fn=30);
            translate([offset2+1.2+2.6/2,0,0]) cube([2.6, 5.6, 6.01], true);
            translate([offset+1.2+2.6+4.2+4/2,0,0]) cube([2, 4, 6.01], true);
            translate([offset+9.5-5/2,0,0]) cube([6.81, 5.6, slideth+0.2], true);
            // 0.2 offset for bridging
            translate([offset2+1.2+3.4/2+0.2,9.6/2-2/2,0]) cube([3.4, 2.01, slideth+0.2], true);
            translate([offset+11+1.2+2/2,0,0]) cube([2, 5.6, 6.01], true);
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
