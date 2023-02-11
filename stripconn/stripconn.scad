
*color("#777") conn12v();
*color("#999") translate([0,0,5]) connnut();

rotate([180,0,0]) connbox();

module conn12v()
{
    difference() {
        union() {
            translate([0,0,-2]) cylinder(2, 12.5/2, 12.5/2, $fn=32);
            translate([0,0,0]) cylinder(15, 10.6/2, 10.6/2, $fn=48);
            translate([0,0,15]) cylinder(5, 2.5/2, 2.5/2, $fn=48);
            translate([4,-3.1/2,15]) cube([0.3, 3.1, 11]);
        }
        translate([0,0,-2.01]) cylinder(8.01, 5.5/2, 5.5/2, $fn=48);
    }
}

module connnut()
{
    linear_extrude(height=2.4, convexity=5) difference() {
        circle(14/sqrt(3), $fn=6);
        circle((11/2), $fn=48);
    }
}

module connbox()
{
    bw = 18;
    bl = 21;
    bx = 10.5;
    bh = 3;
    difference() {
        union() {
            translate([-bx, -bw/2, 0]) cube([bl, bw, bh]);
            translate([-bx, -bw/2, 0]) cube([bl, 2, 22]);
            translate([-bx, bw/2-2, 0]) cube([bl, 2, 22]);
            *translate([-bx, -bw/2, 0]) cube([2, bw, 22]);
            *translate([bl-bx-2, -bw/2, 0]) cube([2, bw, 20]);
            translate([-bx, -bw/2, 0]) cube([7, bw, 22]);
            translate([-bx, -bw/2, 0]) cube([bx*2, bw, 22]);
            translate([-bx,0,0]) rotate([0,90,0]) linear_extrude(height=2, convexity=4) {
                polygon([
                    [0,-bw/2],[2,-bw/2],[4+bw/4,-2],
                    [4+bw/4,2],[2,bw/2],[0,bw/2]
                ]);
            }
            translate([bl-bx-2, -bw/2, 22-4.6]) cube([18, bw, 4.6]);
        }
        translate([0,0,-0.01]) cylinder(bh+0.02, 11/2, 11/2, $fn=48);
        translate([0,0,bh-0.01]) cylinder(22-bh+0.02, 14/sqrt(3), 14/sqrt(3), $fn=6);
        translate([-bx-0.01,0,-5]) rotate([0,90,0]) cylinder(2.02, 1.5, 1.5, $fn=48);
        translate([bl-bx-5.5, -3-2, 22-2.4]) cube([17, 2, 2.41]);
        translate([bl-bx-5.5, +3, 22-2.4]) cube([17, 2, 2.41]);
        *translate([bl-bx+11, -5, 22-2.4]) cube([5.01, 10, 2.41]);
        translate([bl-bx+7, 0, 22-4.61]) cylinder(4.62, 1.5, 1.5, $fn=48);
        #translate([bl-bx+11, 0, 22-2.4]) linear_extrude(height=2.41, convexity=5) polygon([
            [5.01,-5], [5.01,5], [-4.5,5], [-0.5,1], [-0.5,-1], [-4.5,-5]
        ]);
    }
    #translate([0, 0, 3-0.3]) cylinder(0.3, 6, 6, $fn=48);
}
