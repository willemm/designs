doitem = "";
board_thick = 5;
hole_offset = 17;
post_hole = 16;

if (doitem == "outside_corner") { outside_corner(); } 
if (doitem == "inside_corner")  { inside_corner(); } 
if (doitem == "") {
    outside_corner();
    translate([0,0,board_thick+2]) inside_corner();
    translate([0,0,80]) inside_corner();
}

module outside_corner()
{
    top = 100;
    wid = 30;
    bev = 6;
    thi = 5;
    srad = 3/2;
    bth = board_thick;
    hoff = hole_offset;

    difference() {
        union() {
            linear_extrude(convexity=5, height=top) polygon([
                [wid, -thi], [bev, -thi], [-thi, bev], [-thi, wid],
                [0, wid], [0, bev+thi/2],
                [bth-0.2, bev+thi/2], [bth-0.2, bth-0.2], [bev+thi/2, bth-0.2],
                [bev+thi/2, 0], [wid, 0]
            ]);
            linear_extrude(convexity=5, height=2) polygon([
                [wid, -thi], [bev, -thi], [-thi, bev], [-thi, wid],
                [wid/2, wid], [wid, wid/2]
            ]);
        }
        translate([hoff, 0, 17]) rotate([-90,0,0]) {
            translate([0, 0, -thi-0.01]) cylinder(thi+0.02, srad, srad, $fn=30);
        }
        translate([0, hoff, 17]) rotate([0,90,0]) {
            translate([0, 0, -thi-0.01]) cylinder(thi+0.02, srad, srad, $fn=30);
        }
        translate([hoff, 0, top-10]) rotate([-90,0,0]) {
            translate([0, 0, -thi-0.01]) cylinder(thi+0.02, srad, srad, $fn=30);
        }
        translate([0, hoff, top-10]) rotate([0,90,0]) {
            translate([0, 0, -thi-0.01]) cylinder(thi+0.02, srad, srad, $fn=30);
        }
        translate([0,0,0]) rotate([45,90,0]) translate([0,0,-bev*2.5])
            linear_extrude(height=bev*5) polygon([ [0.01,bev], [0.01-bev,0], [0.01,0] ]);
    }
}

module inside_corner()
{
    bth = board_thick;
    top = 20;
    wid = 25;
    holer = post_hole/2+0.1;
    srad = 4/2;
    hrad = 9/2;
    hoff = hole_offset;
    
    difference() {
        linear_extrude(convexity=5, height=top) difference() {
            polygon(concat(
                [ [wid+bth, bth], [bth, bth], [bth, wid+bth] ],
                [ for (an=[0:3:90]) [hoff+sin(an)*(wid+bth-hoff), hoff+cos(an)*(wid+bth-hoff)] ]
            ));
            translate([hoff, hoff]) circle(holer, $fn=60);
        }
        translate([hoff, 0, top/2]) rotate([-90,0,0]) {
            translate([0, 0, bth-0.01]) cylinder(wid/2-holer, srad, srad, $fn=30);
            translate([0, 0, bth+2]) cylinder(wid/2-holer-1, hrad, hrad, $fn=30);

            translate([0, 0, bth+wid/2+holer-3]) cylinder(wid/2-holer+3.01, hrad, hrad, $fn=30);
        }
        translate([0, hoff, top/2]) rotate([0,90,0]) {
            translate([0, 0, bth-0.01]) cylinder(wid/2-holer, srad, srad, $fn=30);
            translate([0, 0, bth+2]) cylinder(wid/2-holer-1, hrad, hrad, $fn=30);

            translate([0, 0, bth+wid/2+holer-3]) cylinder(wid/2-holer+3.01, hrad, hrad, $fn=30);
        }
    }
}
