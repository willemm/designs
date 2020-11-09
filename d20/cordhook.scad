ohole = 10;
hole = ohole / cos(180/8);
thick = 2.4;
owid = hole + thick*2;
wid = owid / cos(180/8);
offs = 14;

difference() {
    union() {
        translate([-offs,0,0]) rotate([0,0,180/8]) cylinder(thick, wid/2, wid/2, true, $fn=8);
        translate([ offs,0,0]) rotate([0,0,180/8]) cylinder(thick, wid/2, wid/2, true, $fn=8);
        cube([offs*2, owid, thick], true);
    }
    translate([    0,0,0]) rotate([0,0,180/8]) cylinder(thick+0.1, hole/2, hole/2, true, $fn=8);
    translate([-offs,0,0]) rotate([0,0,180/8]) cylinder(thick+0.1, hole/2, hole/2, true, $fn=8);
    translate([ offs,0,0]) rotate([0,0,180/8]) cylinder(thick+0.1, hole/2, hole/2, true, $fn=8);
}