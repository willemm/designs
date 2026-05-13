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
light_thick = 7.5;

if (doitem == "post_sleeve") { post_sleeve(); } 
if (doitem == "side_wall") { rotate([0,0,90]) side_wall(); } 
if (doitem == "") {

    for (m1 = [0:1]) mirror([m1,0,0]) {
        translate([post_pos.x+wall_offset,slot_front_off,0]) color("#7a4") side_wall();
        translate([post_pos.x+wall_offset,slot_front_off,wall_height+0.1]) color("#7a4") side_wall();
        for (m2 = [0:1]) mirror([0,m2,0]) {
            translate(post_pos) {
                post();
                color("#985") post_sleeve(m2);
                color("#985") translate([0,0,wall_height+0.1]) post_sleeve(m2, m2);
            }
        }
    }
    translate([0,0,0.1]) color("#875") front_top();

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

module front_top()
{
    sleeve_rad = (post_hole/2) + post_thick;
    sr = sleeve_rad;
    fo = 1.5 + 0.5;

    front_thick = 3;
    front_off = 10;
    wl = posts_x/2 - sr-fo;
    wh = wall_height*2 + cap_height;

    difference() {
        union() {
            translate([0, -posts_y/2+front_thick-front_off, 0]) rotate([90,0,0]) {
                linear_extrude(height=front_thick, convexity=8) polygon(concat(
                    [[wl-2, wh-86], [wl, wh-86], [wl, wh], [-wl, wh], [-wl, wh-86], [-wl+2, wh-86]],
                    [for (an=[-60:1:60]) [0, wh-110] + [sin(an)*wl, cos(an) * 80]]
                ));
            }
            translate([0, -posts_y/2-front_off, wh-50]) linear_extrude(height=50, convexity=8) {
                polygon([
                    [-wl, 0], [-wl+2, 0], [-wl+2, front_off-0.6], [-wl+7, front_off-0.6], [-wl+7, front_off+7], [-wl+2, front_off+7], [-wl+2, 22], [-wl, 22] 
                ]);
                polygon([
                    [wl, 0], [wl-2, 0], [wl-2, front_off-0.6], [wl-7, front_off-0.6], [wl-7, front_off+7], [wl-2, front_off+7], [wl-2, 22], [wl, 22] 
                ]);
            }
            translate([0, -posts_y/2-front_off, wh-86]) linear_extrude(height=86, convexity=8) {
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
            translate([0, -posts_y/2-front_off, wh-2]) linear_extrude(height=2, convexity=8) {
                polygon([
                    [-wl, 0], [-wl, 22], [wl, 22], [wl, 0]
                ]);
            }
        }
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
module post_sleeve(front=0, cap=0)
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
            wir = wire_hole/2;
            wio = (post_hole + wire_hole)/2;
            translate([0,0,-0.01]) linear_extrude(height=hh+0.01, convexity=4) {
                oan = 135;
                polygon(concat(
                    [wir*[sin(oan+90), cos(oan+90)], wir*[sin(oan-90), cos(oan-90)]],
                    [for (an=[oan-90:12:oan+90]) wio*[sin(oan),cos(oan)]+wir*[sin(an),cos(an)]]
                ));
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
            translate([0,0,wall_height-cap_lip]) linear_extrude(height=cap_height+cap_lip-2, convexity=6) {
                polygon(slot_points);
            }
        }
    }

    *linear_extrude(height=wall_height, convexity=6) {
        difference() {
            polygon(sleeve_points());
            circle(post_hole/2, $fn=30);
        }
    }
    *#circle((post_hole/2+1.5), $fn=30);
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

function set_z(pts, z) = [for (p=pts) [p.x, p.y, z]];

// Faces of side of layers
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
    [s+(i+1)%n, s+(i+1)%n+o, s+i],
    [s+(i+1)%n+o, s+i+o, s+i]
]];

function slice_list(l, s, e) = [for (i=[s:e]) l[i]];
