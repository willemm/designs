post_dia = 15;
post_hole = post_dia+1;

posts_x = 400;
posts_y = 248;
post_pos = [posts_x/2,posts_y/2];
post_depth = 100;
post_height = 250;
slot_front_off = 0;
wall_height = 270;

wall_thick = 3;
wall_length = 233;
wall_offset = 8.5;

for (m1 = [0:1]) mirror([m1,0,0]) {
    translate([post_pos.x+wall_offset,slot_front_off,0]) color("#7a4") side_wall();
    for (m2 = [0:1]) mirror([0,m2,0]) {
        translate(post_pos) {
            post();
            color("#985") post_sleeve(m2);
        }
    }
}

translate([ 10.75,-3,0]) color("#5c5") side_wall();
translate([-10.75,3,0]) rotate([0,0,180]) color("#55c") side_wall();

translate([-post_pos.x-wall_offset+21.5,slot_front_off-6.0,0]) color("#57e") side_wall();

module side_wall()
{
    //wall_length = posts_y - post_hole - 2*2 - 1;
    wl = wall_length/2;
    wh = wall_height;
    wt = wall_thick/2;

    slot_width = 8;
    slot_neck = 3;
    slot_length = 18;
    slot_neck_length = 3.5;
    slot_tol = 0.5;
    slot_step = slot_width + slot_neck + slot_tol*2;
    slot_startoff = 25;
    slot_groove = 5;

    sw = slot_width/2;
    sn = slot_neck/2;
    sl = slot_length;
    snl = slot_neck_length;
    sg = slot_groove;
    //swn = slot_width-slot_neck;
    ss = slot_step;
    s0 = floor((wall_length - slot_startoff) / ss) * ss / 2;

    /*
    wall_slot = [[-wt, -sn/2], [-wt-sl+snl+swn/2, -sn/2], [-wt-sl+snl, -sw], [-wt-sl, -sw],
        [-wt-sl, sw], [-wt-sl+snl, sw], [-wt-sl+snl+swn/2, sn/2], [-wt, sn/2]];
    */
    wall_slot = [[-wt, -sn], [-wt-sl+snl+sg, -sn], [-wt-sl+snl+sg, -sw],
        [-wt-sl+sg, -sw], [-wt-sl+sg, -sn], [-wt-sl, -sn],
        [-wt-sl, sn], [-wt-sl+sg, sn], [-wt-sl+sg, sw],
        [-wt-sl+snl+sg, sw], [-wt-sl+snl+sg, sn], [-wt, sn]];

    linear_extrude(height=wh, convexity=10) {
        polygon(concat(
            [[-wt, wl], [wt, wl], [wt, -wl], [-wt, -wl]],
            [for (y=[-s0:ss:s0], p=wall_slot) p+[0,y]]
        ));
    }
}

// Front = 0 or 1, front/back offset
module post_sleeve(front=0)
{
    thick = 3;
    sleeve_rad = (post_hole/2) + thick;
    slot_depth = 7;
    slot_out = slot_depth + (posts_y - wall_length)/2-0.5 + (front*2-1) * slot_front_off;
    slot_width = 4;

    sr = sleeve_rad;
    so = slot_out;
    sd = slot_out - slot_depth;
    sw = slot_width/2;
    wo = wall_offset;
    bo = (wo > 6.5) ? (wo-6.5) : 0;
    sso = 10;

    linear_extrude(height=wall_height, convexity=6) {
        difference() {
            polygon(
                //[for (a=[0:360/30:180]) sleeve_rad*[cos(a), sin(a)]],
                [
                    [sr+bo, sr], [-sr, sr],
                    [-sr, -so+2.5], [-sr+5, -so+2.5], [-sr+5, -so],
                    [-sr+8.5, -so], 
                    [-sr+8.5, -so+2.5], [-sw+wo, -so+2.5],
                    //[-sw+wo, -so],
                    [-sw+wo, -sd],
                    [sw+wo, -sd], [sw+wo, -so], [sr+bo, -so],
                ]
            );
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

