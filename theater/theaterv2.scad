doitem = "";

post_dia = 15;
post_hole = post_dia+1;
wire_hole = 4;
post_thick = 3;

posts_x = 400;
posts_y = 248;
post_pos = [posts_x/2,posts_y/2];
post_depth = 100;
post_height = 270;
slot_front_off = 0;
wall_height = 130;
cap_height = 20;
cap_lip = 30;

wall_thick = 8;
wall_length = 223;
wall_offset = 11.0;

light_len = 201;
light_width = 13;
light_thick = 8;

cover_width = 85.6;
cover_height = 50;
cover_thick = 2;
cover_depth = 16.8;

if (doitem == "switch_shim") { rotate([-90,0,0]) switch_shim(); }
if (doitem == "front_cover") { rotate([-90,0,0]) front_cover(); }
if (doitem == "front_top_l") { rotate([0,180,0]) front_top_l(); } 
if (doitem == "front_top_r") { rotate([0,180,0]) front_top_r(); } 
if (doitem == "post_sleeve") { post_sleeve(); } 
if (doitem == "post_sleeve_bl") { post_sleeve(0,0,1); } 
if (doitem == "post_sleeve_tl") { mirror([0,0,1]) post_sleeve(0,1,1); } 
if (doitem == "post_sleeve_tr") { rotate([0,180,0]) post_sleeve(0,1); } 
if (doitem == "side_wall") { rotate([0,0,90]) side_wall(); } 
if (doitem == "rod_holder") { rotate([0,90,0]) rod_holder(); } 
if (doitem == "") {

    light_bar();
    light_switch();
    curtain_rod();
    translate([0,0,0.2]) color("#999") switch_shim();
    for (m1 = [0:1]) mirror([m1,0,0]) {
        translate([post_pos.x+wall_offset,slot_front_off,0]) color("#7a4") side_wall();
        translate([post_pos.x+wall_offset,slot_front_off,wall_height+0.1]) color("#7a4") side_wall();
        for (m2 = [0:1]) mirror([0,m2,0]) {
            translate(post_pos) {
                post();
                color("#985") post_sleeve(m2);
                color("#985") translate([0,0,wall_height+0.1]) post_sleeve(m2, m2, (!m1 && m2));
                color("#973") translate([6,-24,post_height+10.2]) rod_holder();
            }
        }
    }
    *translate([0,0,0.2]) color("#875") front_top();
    translate([0,0,0.2]) color("#875") render(convexity=10) front_top_l();
    translate([0,0,0.2]) color("#7856") render(convexity=10) front_top_r();
    translate([0,0,0.2]) color("#9756") front_cover();


    if(0) {
    translate([-50, 0, 0]) color("#985") post_sleeve();
    translate([-53, -24.5, 0]) color("#958") rotate([0,0,180]) post_sleeve();

    translate([ 14.0,-2.5,0]) color("#5c5") side_wall();
    translate([-14.0,2.5,0]) rotate([0,0,180]) color("#55c") side_wall();

    *translate([-post_pos.x-wall_offset+23.0,slot_front_off-5.0,0]) color("#57e") side_wall();

    *translate([post_pos.x,0,225]) rotate([0,0,-90]) color("#aaa9") import("toneel_decor_zijkant.stl", convexity=8);
    *translate([post_pos.x,0,75]) rotate([0,0,-90]) color("#8889") import("toneel_decor_zijkant.stl", convexity=8);
    }
}

module rod_holder()
{
    l = 18;
    d = 6.7;
    h = 40;
    g = 20;
    vg = 9;
    vw = 6.4;
    rotate([0,-90,0]) difference() {
        linear_extrude(height=l, convexity=8) difference() {
            polygon(concat(
                [for (an=[0:5:180]) [ sin(an)*d, cos(an)*d ]],
                [[-h, -d], [-h, -2], [-g, -2], [-g, 2], [-h, 2], [-h, d]]
            ));
            circle(5.2, $fn=72);
        }
        translate([-40.1, -vw/2, vg]) cube([20.1, vw, l-vg+0.1]);
    }
}

module front_top_l()
{
    front_thick = 3;
    front_off = 10;
    fp = -posts_y/2-front_off;
    wh = wall_height*2 + cap_height;

    intersection() {
        front_top();
        union() {
            translate([0, fp, 0]) rotate([90,0,0]) difference() {
                ch = 15;
                translate([0,0,-25]) linear_extrude(height=26, convexity=8) polygon(
                    [[0, wh+0.1], [0, wh-90], [200, wh-90], [200, wh+0.1]]
                );
                translate([0,0,-2]) linear_extrude(height=3, convexity=8) polygon(
                    [[0, wh-ch*2], [-ch, wh-ch], [0, wh], [ch, wh-ch]]
                );
            }
            translate([0, fp, wh-1.1]) linear_extrude(height=1.1+0.1, convexity=8) polygon(
                [[1, 4], [1, 18], [-8, 18], [-15, 11], [-8, 4]]
            );
        }
    }
}

module front_top_r()
{
    front_thick = 3;
    front_off = 10;
    fp = -posts_y/2-front_off;
    wh = wall_height*2 + cap_height;

    intersection() {
        front_top();
        difference() {
            translate([0, fp, 0]) rotate([90,0,0]) union() {
                ch = 15;
                translate([0,0,-25]) linear_extrude(height=26, convexity=8) polygon(
                    [[0, wh+0.1], [0, wh-90], [-200, wh-90], [-200, wh+0.1]]
                );
                translate([0,0,-1.6]) linear_extrude(height=3, convexity=8) polygon(
                    [[0, wh-ch*2], [-ch, wh-ch], [0, wh], [ch, wh-ch]]
                );
            }
            translate([0, fp, wh-1.4]) linear_extrude(height=1.4+0.1, convexity=8) polygon(
                [[1, 4], [1, 18], [-8, 18], [-15, 11], [-8, 4]]
            );
        }
    }
}

module switch_shim()
{
    translate([120, -posts_y/2-4.1-2.6, wall_height*2+cap_height-22]) {
        cube([45, 2.5, 16]);
    }
}

module front_cover()
{
    sleeve_rad = (post_hole/2) + post_thick;
    sr = sleeve_rad;
    fo = 1.5 + 0.5;

    front_thick = 3;
    front_off = 10;
    fp = -posts_y/2+front_off;
    wl = posts_x/2 - sr-fo;
    wh = wall_height*2 + cap_height;

    cw = cover_width;
    ch = cover_height;
    ct = cover_thick;
    cd = cover_depth;
    fst = 2.2;

    render(convexity=8) translate([wl, fp, wh]) rotate([90,180,0]) difference() {
        union() {
            linear_extrude(height=ct, convexity=8) polygon([
                [fst, fst], [cw, fst],
                [cw, ch-11], [cw-33, ch], [fst, ch]
            ]);
            linear_extrude(height=cd, convexity=8) polygon([
                [cw, fst],
                [cw, ch-11], [cw-33, ch], [fst+5, ch], [fst+5, ch-2],
                [cw-33, ch-2], [cw-2, ch-12], [cw-2, fst]
            ]);
            translate([0,0,cd-1.7]) linear_extrude(height=1.7) polygon([
                [cw, 20], [cw+4, 20], [cw+4, ch-12], [cw, ch-11]
            ]);
            lof = 4.5;
            lth = 2;
            lbt = lof + lth;
            lwd = 11.5;
            translate([cw+6,0,0]) rotate([0,-90,0]) linear_extrude(height=6.1) polygon([
                [0, fst+lof], [0, fst+lbt], [lwd, fst+lbt+lwd], [lwd+lth/2, fst+lof+lwd+lth/2]
            ]);
            linear_extrude(height=15) polygon(
                [[22,6], [67, 6], [67, 9], [68.6, 9], [68.6, 4.4], [20.4, 4.4], [20.4, 9], [22,9]]
            );
            linear_extrude(height=15) polygon(
                [[22,22.4], [67, 22.4], [67, 19.4], [68.6, 19.4], [68.6, 24], [20.4, 24], [20.4, 19.4], [22,19.4]]
            );
        }
        translate([cw+0.1,0,0]) rotate([0,-90,0]) linear_extrude(height=2.2) polygon(concat(
            [ [cd-2, fst+7], [cd+0.1, fst+7], [cd+0.1, fst-0.1], [cd-11, fst-0.1], [cd-11, fst+3] ],
            [ for (an=[-90:5:20]) [cd-9, fst+9]+2*[sin(an),cos(an)]]
        ));
        translate([44.5,14.2,-0.1]) linear_extrude(height=2.2) polygon(concat(
            [for (an=[0:6:180]) [5,0]+8*[sin(an),cos(an)]],
            [for (an=[180:6:360]) [-5,0]+8*[sin(an),cos(an)]]
        ));
        h1 = 13;
        h2 = 11;
        ho = 10;
        han = 2*acos((h2-ho)/(h1-ho));
        translate([44.5,6,14]) rotate([-90,0,0]) linear_extrude(height=16.4) polygon(concat(
            [[45/2,0], [-45/2,0]],
            [for (x=[-45/2:1:45/2]) [x, ho+(h1-ho)*cos(han*x/45)]]
        ));
    }
}

module front_top()
{
    sleeve_rad = (post_hole/2) + post_thick;
    sr = sleeve_rad;
    fo = 1.5 + 0.5;

    front_thick = 3;
    front_off = 10;
    fp = -posts_y/2-front_off;
    wl = posts_x/2 - sr-fo;
    wh = wall_height*2 + cap_height;

    render(convexity=10) difference() {
        union() {
            // Front arch
            translate([0, fp+front_thick, 0]) rotate([90,0,0]) {
                linear_extrude(height=front_thick, convexity=8) polygon(concat(
                    [[wl-2, wh-86], [wl, wh-86], [wl, wh], [-wl, wh], [-wl, wh-86], [-wl+2, wh-86]],
                    [for (an=[-60:1:60]) [0, wh-110] + [sin(an)*wl, cos(an) * 80]]
                ));
            }
            // Side slot outer
            translate([0, fp, wh-50]) linear_extrude(height=50, convexity=8) {
                polygon([
                    [-wl, 0], [-wl+2, 0], [-wl+2, front_off-0.6], [-wl+7, front_off-0.6],
                    [-wl+7, front_off+7.5], [-wl+2, front_off+7.5], [-wl+2, 22], [-wl, 22] 
                ]);
                polygon([
                    [wl, 0], [wl-2, 0], [wl-2, front_off-0.6], [wl-7, front_off-0.6],
                    [wl-7, front_off+7.5], [wl-2, front_off+7.5], [wl-2, 22], [wl, 22] 
                ]);
            }
            // Side wall
            translate([0, fp, wh-86]) linear_extrude(height=86, convexity=8) {
                polygon(concat(
                    [for (an=[90:1:136]) [-wl-sr, front_off]+sr*[sin(an),cos(an)]],
                    [for (an=[235:-5:180]) [-wl, 3.6]+3.6*[sin(an),cos(an)]],
                    [ [-wl, 0], [-wl+2, 0], [-wl+2, 14], [-wl, 14] ]
                    ));
                polygon(concat(
                    [for (an=[90:1:136]) [wl+sr, front_off]+sr*[-sin(an),cos(an)]],
                    [for (an=[235:-5:180]) [wl, 3.6]+3.6*[-sin(an),cos(an)]],
                    [ [wl, 0], [wl-2, 0], [wl-2, 14], [wl, 14] ]
                    ));
            }
            // Top
            translate([0, fp, wh-2]) linear_extrude(height=2, convexity=8) {
                polygon([
                    [-wl, 0], [-wl, 22], [wl, 22], [wl, 0]
                ]);
            }
            // Slot for light bar
            translate([0, fp, wh]) rotate([0,-90,0]) {
                lw = light_width+0.5;
                lt = light_thick+1;
                lp = [-6,10.2]; // Eyeballed
                ll = 202;
                translate([0,0,-ll/2]) linear_extrude(height=ll, convexity=8) {
                    difference() {
                        polygon([ [-25,1.5], [-4.5, 22], [-1, 22], [-1, 1.5] ]);
                        rotate([0,0,45]) polygon([ lp+[0,0], lp+[lw, 0], lp+[lw, lt], lp+[0, lt] ]);
                    }
                }
                translate([0, 0, ll/2]) linear_extrude(height=2, convexity=8) {
                    polygon([ [-25,1.5], [-4.5, 22], [-1, 22], [-1, 1.5] ]);
                }
                translate([0, 0, ll/2-6]) linear_extrude(height=8, convexity=8) {
                    polygon([ [-25,1.5], [-4.5, 22], [-6.5, 22], [-27, 1.5] ]);
                }
            }
            // Slot for cable cover, inside edge
            translate([0, fp, wh-41]) linear_extrude(height=24, convexity=8) {
                cw = cover_width+0.4;
                polygon([
                    [wl-cw-6, 1], [wl-cw-6, 7], [wl-cw, 7],
                    //[wl-cw, 5.3], [wl-cw-4, 5.3], [wl-cw-4, 1]
                    [wl-cw, 1]
                ]);
            }
            // Slot for cable cover, outside
            translate([0, fp+22, 0]) rotate([90,0,0]) {
                cb = wh-cover_height;
                cw = wl-cover_width-1;
                co = 4.5;
                linear_extrude(height=1.6, convexity=8) polygon([
                    [wl-co, cb], [wl, cb], [wl, wh], [cw, wh],
                    [cw, wh-co], [wl-co, wh-co]
                ]);
            }
            // Nub to hold cover in place
            translate([wl-48, fp, wh-cover_height]) rotate([0,90,0]) {
                linear_extrude(height=20) polygon([
                    [-0.5,3], [1.5, 5], [5.5, 3]
                ]);
            }
        }
        // Slot for side post ridge
        translate([0, -posts_y/2, wh-100-0.01]) {
            slot_neck = 2.2;
            slot_thick = 4.4;
            sln = slot_neck/2;
            slo = (sln+2.2);
            slt = slot_thick/2;
            sls = wl;
            sls0 = sls + 0.01;
            sls1 = sls - 2;
            sls2 = sls - 5;
            linear_extrude(height=98.01, convexity=8) {
                polygon([
                    [sls0, slo-sln], [sls1, slo-sln], [sls1, slo-slt], [sls2, slo-slt],
                    [sls2, slo+slt], [sls1, slo+slt], [sls1, slo+sln], [sls0, slo+sln]
                ]);
                polygon([
                    [-sls0, slo-sln], [-sls1, slo-sln], [-sls1, slo-slt], [-sls2, slo-slt],
                    [-sls2, slo+slt], [-sls1, slo+slt], [-sls1, slo+sln], [-sls0, slo+sln]
                ]);
            }
        }
        // Slot for cable cover, inside edge
        translate([0, fp, wh-41.1]) linear_extrude(height=24, convexity=8) {
            cw = cover_width;
            polygon([
                [wl-cw-4.5, 3], [wl-cw-4.5, 5.5], [wl-cw, 5.5], [wl-cw, 3]
            ]);
        }
        /*
        // Nub to hold cover in place
        translate([wl-48, fp, wh-cover_height]) rotate([0,90,0]) {
            linear_extrude(height=20) polygon([
                [-2.5,3.1], [-2.5, 1.5], [0.5, 1.5], [0.5, 3.1]
            ]);
        }
        */
    }
}

module side_wall()
{
    //wall_length = posts_y - post_hole - 2*2 - 1;
    wl = wall_length/2;
    wh = wall_height;
    wt = wall_thick/2;

    slot_width = 6;
    slot_neck = 3;
    slot_length = 19.5;
    slot_neck_length = 4.75;
    slot_tol = 0.5;
    slot_step = slot_width + slot_neck + slot_tol*2;
    slot_startoff = 15;
    slot_groove = 4.5;
    end_slot_neck = 2;
    end_slot_thick = 5;
    end_slot_depth = 20;

    wall_bevel_x = 0.5;
    wall_bevel_z = 4;

    sw = slot_width/2;
    sn = slot_neck/2;
    sl = slot_length;
    snl = slot_neck_length;
    sg = slot_groove;
    //swn = slot_width-slot_neck;
    ss = slot_step;
    s0 = floor((wall_length - slot_startoff) / ss) * ss / 2;

    esn = end_slot_neck/2;
    est = end_slot_thick/2;
    esd = wl-end_slot_depth;

    function wall_slot(o=0) = [
        [-wt, -sn+o], [-wt-sl+snl+sg-o, -sn+o], [-wt-sl+snl+sg-o, -sw+o],
        [-wt-sl+sg+o, -sw+o], [-wt-sl+sg+o, -sn+o], [-wt-sl, -sn+o],
        [-wt-sl, sn-o], [-wt-sl+sg+o, sn-o], [-wt-sl+sg+o, sw-o],
        [-wt-sl+snl+sg-o, sw-o], [-wt-sl+snl+sg-o, sn-o], [-wt, sn-o]
    ];

    /*
    wall_ends = [
            [-wt, wl-3], [-wt-3, wl-3], [-wt-3, wl], [wt, wl],
            [wt, -wl], [-wt-3, -wl], [-wt-3, -wl+3], [-wt, -wl+3]
        ];
    */
    function wall_ends(o=0) = [
            [-wt-sl, wl-o], [-esn-o, wl-o], [-esn-o, esd+4+o], [-est-o, esd+4+o], [-est-o, esd-o],
            [est+o, esd-o], [est+o, esd+4+o], [esn+o, esd+4+o], [esn+o, wl], [wt, wl],

            //[wt, esd-2], [wt-5, esd-2],
            //[wt-5, -esd+2], [wt, -esd+2],

            [wt, -wl], [esn+o, -wl], [esn+o, -esd-4-o], [est+o, -esd-4-o], [est+o, -esd+o],
            [-est-o, -esd+o], [-est-o, -esd-4-o], [-esn-o, -esd-4-o], [-esn-o, -wl+o], [-wt-sl, -wl+o]
        ];
    wall_points = concat(
        [for (p=slice_list(wall_slot(), 0, 5)) p+[0, s0+ss]],
        wall_ends(),
        [for (p=slice_list(wall_slot(), 6, 11)) p+[0,-s0-ss]],
        [for (y=[-s0:ss:s0], p=wall_slot()) p+[0,y]]
    );
    wall_points_off = concat(
        [for (p=slice_list(wall_slot(wall_bevel_x), 0, 5)) p+[0, s0+ss]],
        wall_ends(wall_bevel_x),
        [for (p=slice_list(wall_slot(wall_bevel_x), 6, 11)) p+[0,-s0-ss]],
        [for (y=[-s0:ss:s0], p=wall_slot(wall_bevel_x)) p+[0,y]]
    );
    wpc = len(wall_points);
    polyhedron(convexity=10,
        points = concat(
            set_z(wall_points_off, 0),
            set_z(wall_points, wall_bevel_z),
            set_z(wall_points, wh-wall_bevel_z),
            set_z(wall_points_off, wh)
        ), faces = concat(
            [[for (a=[wpc-1:-1:0]) a]],
            nquads(0, wpc, wpc),
            nquads(wpc, wpc, wpc),
            nquads(wpc*2, wpc, wpc),
            [[for (a=[wpc*3:wpc*4-1]) a]]
        )
    );
}

// Front = 0 or 1, front/back offset
module post_sleeve(front=0, cap=0, cable=0)
{
    sleeve_rad = (post_hole/2) + post_thick;
    slot_depth = 8;
    slot_in = (posts_y - wall_length)/2-0.5 + (front*2-1) * slot_front_off;
    slot_width = 4;
    back_length = 30;
    slot_out = 17;

    slot_neck = 1.6;
    slot_thick = 3.6;

    end_slot_neck = 1.5;
    end_slot_thick = 4.5;
    end_slot_depth = 20;

    sleeve_bevel_x = 0.5;
    sleeve_bevel_z = 4;

    sr = sleeve_rad;
    bl = (posts_y - wall_length)/2 + end_slot_depth;
    so = slot_out;
    sd = slot_in;
    sw = slot_width/2;
    wo = wall_offset;
    bo = (wo > 6.5) ? (wo-6.5) : 0;
    fo = 1.5;
    sso = 10;

    esn = end_slot_neck/2;
    est = end_slot_thick/2;
    esd = wall_length-end_slot_depth;

    center = [((wo+esn)+(-sr-fo))/2, 0];
    radius = [((wo+esn)-(-sr-fo))/2, sr];
    function sleeve_points() = concat(
        [for (an=[-90:5:90]) center+[sin(an)*radius.x, cos(an)*radius.y]],
        [
            //[wo+esn, sr],
            [wo+esn, -bl+3.5],
            [wo+est, -bl+3.5],
            [wo+est, -bl+0.5],
            [wo-est, -bl+0.5],
            [wo-est, -bl+3.5],
            [wo-esn, -bl+3.5],
            [wo-esn, -sd],
            [-sr-fo, -sd],
            //[-sr-fo, sr],
        ]);

    spc = len(sleeve_points());

    hh = wall_height + (cap ? cap_height-2 : 0.01);
    th = wall_height + (cap ? cap_height : 0);
    render(convexity=8) {
        difference() {
            linear_extrude(height=th, convexity=8) polygon(sleeve_points());
            /*
            polyhedron(convexity=8,
                points = concat(
                    set_z(sleeve_points(), 0),
                    set_z(sleeve_points(), wall_height)
                ), faces=concat(
                    [[for (a=[spc-1:-1:0]) a]],
                    nquads(0, spc, spc),
                    [[for (a=[spc*1:spc*2-1]) a]]
                ));
            */
            translate([0,0,-0.01]) cylinder(hh+0.01, post_hole/2, post_hole/2, $fn=30);
            if(cable) {
                wir = wire_hole/2;
                wio = (post_hole + wire_hole)/2;
                hh2 = cap ? hh-cap_height : hh;
                translate([0,0,-0.01]) linear_extrude(height=hh2+0.01, convexity=4) {
                    oan = 135;
                    polygon(concat(
                        [wir*[sin(oan+90), cos(oan+90)], wir*[sin(oan-90), cos(oan-90)]],
                        [for (an=[oan-90:12:oan+90]) wio*[sin(oan),cos(oan)]+wir*[sin(an),cos(an)]]
                    ));
                }
            }
            if(cap && cable) {
                translate([0,0,wall_height+cap_height-cover_height]) {
                    rt = 90;
                    ro = 1;
                    //rx = ro/cos(rt);
                    //ry = ro/sin(rt);
                    rotate([0,0,rt]) rotate([0,90,0]) translate([0,0,-12.5]) {
                        linear_extrude(height=6) polygon(concat(
                            [[-28, 12.5], [-28, -8], [-8, -8], [12.5, 12.5]]
                        ));
                        *linear_extrude(height=12) polygon(concat(
                            [[-28, 8], [-28, -5], [-5, -5], [8, 8]]
                        ));
                    }
                    /*
                    rotate([0,90,0]) translate([0,0,-12.6]) linear_extrude(height=1.53) polygon(
                        [[-28, -4.1], [-28, -4.1-rx], [2.3+ro, -4.1-rx], [2.3, -4.1]]
                    );
                    rotate([0,90,0]) translate([0,0,-12.6]) linear_extrude(height=1.53) polygon(
                        [[-30, -4], [-30, -4-rx-2], [3+ro, -4-rx-2], [3+ro, -4-rx],  [3, -4]]
                    );
                    rotate([0,0,90]) rotate([0,90,0]) translate([0,0,-12.6]) linear_extrude(height=1.53) polygon(
                        [[-30, 4], [-30, 4+ry+2], [3+ro, 4+ry+2], [3+ro, 4+ry], [3, 4]]
                    );
                    */
                }
            }
        }
        if (cap) {
            sln = slot_neck/2;
            slo = -(sln+2.5);
            slt = slot_thick/2;
            sls = -sr-fo;
            sls0 = sls + 0.1;
            sls1 = sls - 3;
            sls2 = sls - 5;
            slot_points = [
                    [sls0, slo-sln], [sls1, slo-sln], [sls1, slo-slt], [sls2, slo-slt],
                    [sls2, slo+slt], [sls1, slo+slt], [sls1, slo+sln], [sls0, slo+sln]
            ];
            translate([0,0,wall_height-cap_lip]) linear_extrude(height=cap_height+cap_lip-2.3, convexity=6) {
                polygon(slot_points);
            }
        }
    }
}

// Front = 0 or 1, front/back offset
module post_sleeve_old(front=0)
{
    sleeve_rad = (post_hole/2) + post_thick;
    slot_depth = 8;
    slot_in = (posts_y - wall_length)/2-0.5 + (front*2-1) * slot_front_off;
    slot_width = 4;
    back_length = 30;
    slot_out = 17;

    end_slot_neck = 2;
    end_slot_thick = 5;
    end_slot_depth = 20;

    sleeve_bevel_x = 0.5;
    sleeve_bevel_z = 4;

    sr = sleeve_rad;
    bl = back_length;
    so = slot_out;
    sd = slot_in;
    sw = slot_width/2;
    wo = wall_offset;
    bo = (wo > 6.5) ? (wo-6.5) : 0;
    fo = 1.5;
    sso = 10;

    esn = end_slot_neck/2;
    est = end_slot_thick/2;
    esd = wall_length-end_slot_depth;

    function sleeve_points(off=0) = [
        [sr+bo, -bl],
        [sw+wo+off, -bl],
        [sw+wo+off, -sd+off],
        [-sw+wo-3-off, -sd+off],
        [-sw+wo-3-off, -sd-4-off],
        [-sw+wo-off, -sd-4-off],
        [-sw+wo-off, -so+off],
        [-sr+8.25+off, -so+off],
        [-sr+8.25+off, -so+1.5+off], 
        [-sr+2.5-off, -so+1.5+off],
        [-sr+2.5-off, -so+off],
        [-sr-fo, -so+off],
        [-sr-fo, sr],
        [sr+bo, sr],
    ];

    spc = len(sleeve_points());

    difference() {
        polyhedron(convexity=8,
            points = concat(
                set_z(sleeve_points(sleeve_bevel_x), 0),
                set_z(sleeve_points(), sleeve_bevel_z),
                set_z(sleeve_points(), wall_height-sleeve_bevel_z),
                set_z(sleeve_points(sleeve_bevel_x), wall_height)
            ), faces=concat(
                [[for (a=[spc-1:-1:0]) a]],
                nquads(0, spc, spc),
                nquads(spc, spc, spc),
                nquads(spc*2, spc, spc),
                [[for (a=[spc*3:spc*4-1]) a]]
            ));
        translate([0,0,-0.01]) cylinder(wall_height+0.02, post_hole/2, post_hole/2, $fn=30);
    }

    *linear_extrude(height=wall_height, convexity=6) {
        difference() {
            polygon(sleeve_points());
            circle(post_hole/2, $fn=30);
        }
    }
    *#circle((post_hole/2+1.5), $fn=30);
}

module post()
{
    color("#ca8") translate([0,0,-post_depth])
        cylinder(post_depth+post_height, post_dia/2, post_dia/2, $fn=30);
}

module light_bar()
{
    color("#ccc") translate([-light_len/2, -posts_y/2-1, wall_height*2+3])
        rotate([45,0,0]) cube([light_len, light_width, light_thick]);
}

module light_switch()
{
    h1 = 13;
    h2 = 11;
    ho = 10;
    han = 2*acos((h2-ho)/(h1-ho));
    color("#666") translate([120, -posts_y/2-4.1, wall_height*2+cap_height-22]) {
        linear_extrude(height=16, convexity=8) polygon(concat(
            [[45,0], [0,0]],
            [for (x=[0:1:45]) [x, ho+(h1-ho)*cos(han*(x-(45/2))/45)]]
        ));
        translate([45/2,12,16/2]) rotate([-90,0,0]) cylinder(3, 2.8, 2.8, $fn=30);
    }
}

module curtain_rod()
{
    l = posts_x+15;
    d = 10/2;
    color("#ccc")
    translate([-l/2, -posts_y/2+24, post_height+10])
    rotate([0,90,0]) cylinder(l, d, d, $fn=48);
}

function set_z(pts, z) = [for (p=pts) [p.x, p.y, z]];

// Faces of side of layers
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
    [s+(i+1)%n, s+(i+1)%n+o, s+i],
    [s+(i+1)%n+o, s+i+o, s+i]
]];

function slice_list(l, s, e) = [for (i=[s:e]) l[i]];
