doitem = "";

post_dia = 15;
post_hole = post_dia+1;

posts_x = 400;
posts_y = 248;
post_pos = [posts_x/2,posts_y/2];
post_depth = 100;
post_height = 250;
slot_front_off = 0;
wall_height = 130;

wall_thick = 8;
wall_length = 223;
wall_offset = 11.0;

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
                color("#985") translate([0,0,wall_height+0.1]) post_sleeve(m2);
            }
        }
    }

    translate([-50, 0, 0]) color("#985") post_sleeve();
    translate([-53, -24.5, 0]) color("#958") rotate([0,0,180]) post_sleeve();

    translate([ 14.0,-2.5,0]) color("#5c5") side_wall();
    translate([-14.0,2.5,0]) rotate([0,0,180]) color("#55c") side_wall();

    *translate([-post_pos.x-wall_offset+23.0,slot_front_off-5.0,0]) color("#57e") side_wall();

    translate([post_pos.x,0,225]) rotate([0,0,-90]) color("#aaa9") import("toneel_decor_zijkant.stl", convexity=8);
    translate([post_pos.x,0,75]) rotate([0,0,-90]) color("#8889") import("toneel_decor_zijkant.stl", convexity=8);
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
module post_sleeve(front=0)
{
    thick = 3;
    sleeve_rad = (post_hole/2) + thick;
    slot_depth = 8;
    slot_in = (posts_y - wall_length)/2-0.5 + (front*2-1) * slot_front_off;
    slot_width = 4;
    back_length = 30;
    slot_out = 17;

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
    function sleeve_points(off=0) = concat(
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

    difference() {
        polyhedron(convexity=8,
            points = concat(
                set_z(sleeve_points(), 0),
                set_z(sleeve_points(), wall_height)
            ), faces=concat(
                [[for (a=[spc-1:-1:0]) a]],
                nquads(0, spc, spc),
                [[for (a=[spc*1:spc*2-1]) a]]
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

// Front = 0 or 1, front/back offset
module post_sleeve_old(front=0)
{
    thick = 3;
    sleeve_rad = (post_hole/2) + thick;
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
