doitem = "";


flmd = 2;
flml = 4;
flmw = 2;
flmt = 0.2;
offset = -10;
offset2 = -8;

slideth = 3;

if (doitem == "house") { house(); }
if (doitem == "slider") { slider(); }
if (doitem == "") {

    filament_end();
    nut();
    translate([2,0,0]) bolt();

    house();
    translate([2,0,0]) slider();
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
            translate([offset2+1.2+3.4/2,9.6/2-2/2,0]) cube([3.4, 2.01, slideth+0.2], true);
            translate([offset+11+1.2+2/2,0,0]) cube([2, 5.6, 6.01], true);
            translate([offset+11+1.2/2,0,2+1.02/2]) cube([1.21, 4, 1.02], true);
            translate([offset+11+1.2/2,0,-2-1.02/2]) cube([1.21, 4, 1.02], true);
            translate([0,-9.6/2+2.001,0]) rotate([90,0,0]) cylinder(2.82, 1.6, 1.6, $fn=30);
            translate([0,-9.6/2+3.2,0]) rotate([90,0,0]) cylinder(1.2, 0.8, 1.6, $fn=30);

            // To enable bridging
            translate([offset2+1.2+2.6+1/2-0.01,0,1.7-0.01]) cube([1.02, 5.6, 0.21], true);
        }
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
