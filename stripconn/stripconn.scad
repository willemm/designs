
*color("#777") conn12v();
*color("#999") translate([0,0,5]) connnut();

*rotate([180,0,0]) connbox();

*color("#bbb") psu();
*color("#bbe") translate([-82,-10,0]) cube([20,20,20]);

rotate([180,0,0]) psubox();

module psubox()
{
    len = 190;
    cw = 5.5;
    ch = 3.5;
    hof = 6;
    difference() {
        union() {
            translate([-len/2, -50/2, 25]) cube([len, 50, 2]);
            translate([-len/2, -50/2, 0]) cube([len, 2, 25]);
            translate([-len/2, 50/2-2, 0]) cube([len, 2, 25]);
            translate([-len/2, -50/2, 0]) cube([3, 50, 25]);
            translate([len/2-3, -50/2, 0]) cube([3, 50, 25]);
            for (x=[0,1]) mirror([x,0,0])
            translate([-len/2, 0, 0]) linear_extrude(height=26, convexity=5) polygon(concat(
                [[0, hof], [0, -hof]],
                [for (an=[-90:5:90]) [ hof+hof*cos(an), hof*sin(an)]]
            ));
        }
        *#translate([-len/2-0.01, -10, ch/2]) rotate([0,90,0]) cylinder(3.02, 3.5/2, 3.5/2, $fn=48);
        for (x=[0,1], y=[0,1]) mirror([x,0,0]) mirror([0,y,0])
        translate([-len/2-0.01, -10, 0]) rotate([0,90,0])
            linear_extrude(height=3.02, convexity=4) polygon(concat(
                //[[-ch/2, -cw/2], [0.01, -cw/2], [0.01, cw/2], [-ch/2, cw/2]],
                [[0.01, -cw/2], [0.01, cw/2]],
                [for (an=[-90:5:0]) [ -ch/2-cos(an)*ch/2,  (cw-ch)/2-sin(an)*ch/2]],
                [for (an=[ 0:5: 90]) [ -ch/2-cos(an)*ch/2, -(cw-ch)/2-sin(an)*ch/2]]
            ));

        for (x=[0,1]) mirror([x,0,0]) {
            translate([-len/2+hof, 0, -0.01]) cylinder(4.02, 1.6, 1.6, $fn=48);
            translate([-len/2+hof, 0, 4]) cylinder(23.01, 3.2, 3.2, $fn=48);
        }
        hlen = 130;
        xst = 7;
        zst = xst/sqrt(3);
        for (y=[0,1]) mirror([0,y,0]) {
            for (x=[0:hlen*2/xst+1], z=[(x%2!=0?zst:zst*1.5):zst:22]) {
                translate([x*(xst/2)-hlen/2-1.5, -50/2+2.01, z]) rotate([90,0,0]) cylinder(2.02, 1, 1, $fn=12);
            }
        }
    }
    for (x=[0,1], y=[0,1]) mirror([x,0,0]) mirror([0,y,0]) {
        translate([-len/2+2, -11-cw/2, ch-0.6]) cube([1, cw+2, 1]);
        translate([-48, -50/2, 0]) cube([1.5, 4, 25]);
    }
    for (x=[0,1]) mirror([x,0,0]) {
        #translate([-len/2+hof, 0, 3.7]) cylinder(0.3, 1.8, 1.8, $fn=48);
    }
}

module psu()
{
    translate([-123/2, -41/2, 0]) cube([123, 41, 20]);
}

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
