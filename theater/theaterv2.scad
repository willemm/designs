doitem = "side_wall";

post_dia = 15;
post_hole = post_dia+1;

posts_x = 400;
posts_y = 248;
post_pos = [posts_x/2,posts_y/2];
post_depth = 100;
post_height = 250;
slot_front_off = 0;
wall_height = 130;

wall_thick = 3;
wall_length = 229;
wall_offset = 8.5;

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

    translate([ 11.5,-2.5,0]) color("#5c5") side_wall();
    translate([-11.5,2.5,0]) rotate([0,0,180]) color("#55c") side_wall();

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
    slot_startoff = 25;
    slot_groove = 4.5;

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

    function wall_slot(o=0) = [
        [-wt, -sn+o], [-wt-sl+snl+sg-o, -sn+o], [-wt-sl+snl+sg-o, -sw+o],
        [-wt-sl+sg+o, -sw+o], [-wt-sl+sg+o, -sn+o], [-wt-sl, -sn+o],
        [-wt-sl, sn-o], [-wt-sl+sg+o, sn-o], [-wt-sl+sg+o, sw-o],
        [-wt-sl+snl+sg-o, sw-o], [-wt-sl+snl+sg-o, sn-o], [-wt, sn-o]
    ];

    /*
    linear_extrude(height=wh, convexity=10) {
        polygon(concat(
            [[-wt, wl], [wt, wl], [wt, -wl], [-wt, -wl]],
            [for (y=[-s0:ss:s0], p=wall_slot()) p+[0,y]]
        ));
    }
    */
    wall_ends = [
            [-wt, wl-3], [-wt-3, wl-3], [-wt-3, wl], [wt, wl],
            [wt, -wl], [-wt-3, -wl], [-wt-3, -wl+3], [-wt, -wl+3]
        ];
    wall_points = concat(
        wall_ends,
        [for (y=[-s0:ss:s0], p=wall_slot()) p+[0,y]]
    );
    wall_points_off = concat(
        wall_ends,
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
    slot_out = slot_depth + (posts_y - wall_length)/2-0.5 + (front*2-1) * slot_front_off;
    slot_width = 4;

    sleeve_bevel_x = 0.5;
    sleeve_bevel_z = 4;

    sr = sleeve_rad;
    so = slot_out;
    sd = slot_out - slot_depth;
    sw = slot_width/2;
    wo = wall_offset;
    bo = (wo > 6.5) ? (wo-6.5) : 0;
    fo = 1.5;
    sso = 10;

    function sleeve_points(off=0) = [
        [sr+bo, -so],
        [sw+wo+off, -so],
        [sw+wo+off, -sd+off],
        [-sw+wo-3-off, -sd+off],
        [-sw+wo-3-off, -sd-4-off],
        [-sw+wo-off, -sd-4-off],
        [-sw+wo-off, -so+1.5+off],
        [-sr+7.75-off, -so+1.5+off],
        [-sr+7.75-off, -so+off], 
        [-sr+3+off, -so+off],
        [-sr+3+off, -so+1.5+off],
        [-sr-fo, -so+1.5+off],
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
