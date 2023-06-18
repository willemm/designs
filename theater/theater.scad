
outside_corner();
inside_corner();

module outside_corner()
{
    top = 150;
    wid = 40;
    bev = 10;
    thi = 5;
    linear_extrude(convexity=5, height=top) polygon([
        [wid, -thi], [bev, -thi], [-thi, bev], [-thi, wid],
        [0, wid], [0, bev+thi/2], [bev+thi/2, 0], [wid, 0]
    ]);
}

module inside_corner()
{
    bth = 5;
    top = 30;
    wid = 40;
    bev = 10;
    holer = 15;
    srad = 4/2;
    hrad = 7/2;
    
    difference() {
        linear_extrude(convexity=5, height=top) difference() { polygon([
                [wid+bth, bth], [bev, bth], [bth, bev], [bth, wid+bth],
                [bth+wid-12, wid+bth], [wid+bth, bth+wid-12]
            ]);
            translate([bth+wid/2, bth+wid/2]) circle(holer, $fn=30);
        }
        translate([bth+wid/2, 0, top/2]) rotate([-90,0,0]) {
            translate([0, 0, bth-0.01]) cylinder(wid/2-holer, srad, srad, $fn=30);
            translate([0, 0, bth+wid/2-holer-2]) cylinder(3, hrad, hrad, $fn=30);

            translate([0, 0, bth+wid/2+holer-1]) cylinder(wid/2-holer+1.01, hrad, hrad, $fn=30);
        }
        translate([0, bth+wid/2, top/2]) rotate([0,90,0]) {
            translate([0, 0, bth-0.01]) cylinder(wid/2-holer, srad, srad, $fn=30);
            translate([0, 0, bth+wid/2-holer-2]) cylinder(3, hrad, hrad, $fn=30);

            translate([0, 0, bth+wid/2+holer-1]) cylinder(wid/2-holer+1.01, hrad, hrad, $fn=30);
        }
    }
}
