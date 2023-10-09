doitem = "";
board_thick = 5;
hole_offset = 17;
post_dia = 15;
post_hole = post_dia+1;

front_hi = 80;

if (doitem == "outside_corner") { outside_corner(); } 
if (doitem == "inside_corner")  { inside_corner(); } 
if (doitem == "top_corner")     { top_corner(); } 
if (doitem == "top_back")       { rotate([-90,0,0]) top_front(cutout=false); } 
if (doitem == "top_front")      { rotate([-90,0,0]) top_front(); } 
if (doitem == "top_front_m")    { rotate([-90,0,0]) mirror([1,0,0]) top_front(); } 
if (doitem == "topfront_pin")   { cube([36, 9.8, 4.5]); }
if (doitem == "tc_jig")         { tc_jig(); }
if (doitem == "") {
    outside_corner();
    translate([0,0,board_thick+2]) inside_corner();
    translate([0,0,80]) inside_corner();

    translate([hole_offset,hole_offset,350+7]) rotate([0,180,270]) top_corner();

    *#translate([hole_offset, hole_offset, 350+7]) rotate([0,180,270]) tc_jig();

    color("#8c4") translate([hole_offset,hole_offset,350+7-56]) top_front();

    translate([hole_offset, hole_offset, 7]) color("#ca8") cylinder(350, post_dia/2, post_dia/2, $fn=30);

    #translate([hole_offset+200,hole_offset+2,350+7-0+14]) cube([38, 4.5, 9.8], true);
}

module tc_jig()
{
    twid = 24;
    th = twid;
    ttab = 5;
    ins = front_hi-th+ttab;
    hcut = 2;
    //tlen = 30;
    tbev = 15;
    sdep = 15;
    swid = 7;
    stab = 15;
    tdep = 10;
    htol = 0.3;
    vtol = 0.2;
    pin = 3;

    difference() {
        translate([-23,-15,-25]) cube([50, 30, 50]);
        translate([tbev,0,-25-0.01]) cylinder(50.02, pin/2, pin/2, $fn=30);
        rotate([0,90,0]) translate([th/2,0,-23-0.01]) cylinder(50.02, post_dia/2+htol, post_dia/2+htol, $fn=30);
    }
}

module top_front(cutout=true)
{
    tol = 0.5;
    swid = 7-tol*2;
    stab = 15-tol*2;
    sdep = 15;
    tdep = 10-tol*2;
    shi = front_hi;
    hi = 100;
    off = 12+tol;
    wid = 400-2*off;

    arhi = 60;
    arof = 5;
    arwd = 20;

    difference() {
        translate([off,0,0]) linear_extrude(height=shi, convexity=5) {
            polygon([
                //[sdep+2, -swid/2],
                //[sdep+2, -swid/2-0.6],
                [sdep, -swid/2-5],

                [sdep, -swid/2],
                [tdep, -swid/2],
                [tdep, -stab/2+1],
                [tdep-1, -stab/2],
                [1,    -stab/2],
                [0,    -stab/2+1],

                [0,     stab/2-1],
                [1,     stab/2],
                [tdep-1,  stab/2],
                [tdep,  stab/2-1],
                [tdep,  swid/2],
                [sdep,  swid/2],
                [sdep,  stab/2-1],
                [sdep+1,  stab/2],

                [wid/2, stab/2],
                [wid/2, -swid/2-5],

                /*
                [wid-sdep, stab/2],
                [wid-sdep, swid/2],
                [wid-tdep, swid/2],
                [wid-tdep, stab/2],
                [wid,      stab/2],

                [wid,      -stab/2],
                [wid-tdep, -stab/2],
                [wid-tdep, -swid/2],
                [wid-sdep, -swid/2],
                [wid-sdep, -swid/2-0.6],
                [wid-sdep-1, -swid/2-0.6],
                [wid-sdep-1, -swid/2],
                */
            ]);
        }
        if (cutout) {
            cdep = 20;
            cthi = 5;
            cwid = 10;
            translate([off+wid/2-cdep/2, (stab-swid)/4, 0]) {
                translate([0,0,10]) cube([cdep+0.6,cthi,cwid], true);
                translate([0,0,shi/2]) cube([cdep+0.6,cthi,cwid], true);
                translate([0,0,shi-10]) cube([cdep+0.6,cthi,cwid], true);
            }
            fstep = 0.3;
            soff = 5;
            anarr = [for (san=[0:0.3:sqrt(90)-soff+1]) 90+(soff*soff)-((san+soff)*(san+soff))];
            translate([off,tdep-1.99,0]) rotate([90,0,0]) {
                linear_extrude(height=tdep+6.02, convexity=6) polygon(concat(
                    [ [arwd,-0.01],[wid/2+0.1,-0.01],[wid/2+0.1,arhi] ],
                    [for (an=anarr) [wid/2-cos(an)*(wid/2-arwd), arof+sin(an)*(arhi-arof)]]
                ));
            }
            ddep1 = swid/2-11.01;
            ddep2 = ddep1+4.01;
            for (an=[0:2:len(anarr)-3]) {
                polyhedron(convexity=6, points = [
                    [off+wid/2-cos(anarr[an])*(wid/2-arwd), ddep1, arof+sin(anarr[an])*(arhi-arof)],
                    [off+wid/2-cos(anarr[an+2])*(wid/2-arwd), ddep1, arof+sin(anarr[an+2])*(arhi-arof)],
                    [off+wid/2-cos(anarr[an+1])*(wid/2-arwd), ddep2, arof+sin(anarr[an+1])*(arhi-arof)],
                    [off+wid/2-cos(anarr[an+1])*(wid/2-arwd+6), ddep1, arof+5+sin(anarr[an+1])*(arhi-arof+10)]
                ], faces = [
                    [0,2,1],[0,1,3],[1,2,3],[2,0,3]
                ]
                );
            }
            *#translate([off,-2,0]) rotate([90,0,0]) {
                linear_extrude(height=6) polygon(concat(
                    [ [arwd, 0], [15, 0], [15, 80], [wid/2, 80] ],
                    [for (an=[90:-2:0]) [wid/2-cos(an)*(wid/2-arwd), arof+sin(an)*(arhi-arof)]]
                ));
            }
        }
    }

    
}

module top_corner()
{
    twid = 24;
    th = twid;
    ttab = 5;
    ins = front_hi-th+ttab;
    hcut = 2;
    //tlen = 30;
    tbev = 15;
    sdep = 15;
    swid = 7;
    stab = 15;
    tdep = 10;
    htol = 0.3;
    vtol = 0.2;
    pin = 3;
    difference() {
        translate([0, twid/2+sdep, 0]) rotate([90,0,0]) linear_extrude(height=twid+sdep, convexity=5)
            polygon([
                [twid/2+tbev, -th], [twid/2+tbev, 0],
                [twid/2, tbev], [twid/2, ins], [-twid/2, ins],
                [-twid/2, 0], [-twid/2, -th]
            ]);
        translate([0,0,-th-0.01]) linear_extrude(height=ins+th+0.01-ttab, convexity=5) {
            polygon([
                [ stab/2, twid/2],
                [ stab/2, twid/2+tdep],
                [ swid/2, twid/2+tdep],
                [ swid/2, twid/2+sdep+0.01],
                [-swid/2, twid/2+sdep+0.01],
                [-swid/2, twid/2+tdep],
                [-stab/2, twid/2+tdep],
                [-stab/2, twid/2]
            ]);
        }
        translate([0,0,-th-0.01]) linear_extrude(height=ins+th+0.02, convexity=5) {
            polygon([
                [ twid/2+tbev+0.01, twid/2],
                [ twid/2+tbev+0.01, twid/2+sdep+0.01],
                [ twid/2, twid/2+sdep+0.01],
                [ twid/2, twid/2+tbev]
            ]);
        }
        translate([0,0,-hcut]) cylinder(ins+hcut+0.01, post_dia/2+vtol, post_dia/2+vtol, $fn=30);
        translate([tbev,0,-twid-0.01]) cylinder(twid-8.01, pin/2, pin/2, $fn=30);
        translate([tbev,0,-twid-0.01]) cylinder(twid+8.01, pin/2-0.5, pin/2-0.5, $fn=30);
        *translate([tbev,0,-twid-0.01]) cylinder(2, pin/2+2, pin/2, $fn=30);
        rotate([0,90,0]) translate([th/2,0,-twid/2-0.01]) cylinder(twid+tbev+0.02, post_dia/2+htol, post_dia/2+htol, $fn=30);
    }
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
