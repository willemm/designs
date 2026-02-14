side = 0;

width = 583;
height = 300;
topwid = 26;
tritop = 200;
tribot = 25;
beamwidth = 40;
beamoffset = 360;
beamthick = 15;

holeoff = [-37, 111];

lipwid = 5;
lipthick = 2;

sweep = false; // Sweeping cutout for side with offset inlet
tophole = false; // Cut a panel from the front for access

supportstep = 27.3; // Supports for top face every 2.75cm
supportwid = 1.2;

topcut = [89, 105, 0];
toprot = atan(height*2/width);

//echo(atan((tritop-tribot) / height));

if(side == 1) {
    rotate([0, 0, -toprot]) intersection() {
        grille();
        topsegment_cut();
    }
} else if (side == 2) {
    rotate([0, 0, -toprot]) intersection() {
        grille();
        leftsegment_cut();
    }
} else if (side == 3) {
    rotate([0, 0, -toprot]) intersection() {
        grille();
        rightsegment_cut();
    }
} else if (side == 4) {
    rotate([0, 90,0]) mount_rt();
} else if (side == 5) {
    rotate([0,-90,0]) mount_rb();
} else if (side == 6) {
    rotate([0,-90,0]) mount_lt();
} else if (side == 7) {
    rotate([0, 90,0]) mount_lb();
} else if (side == 8) {
    rotate([0,0,0]) hole_repair();
} else {

if(0) {
    *pipe();
    *pin();
} else if(1) {
    rotate([0,0,-toprot]) {
        *color("#333") screws();
        *color("#666") pipe();
        slopeang = atan(height/(width/2));
        translate([0,height,0]) rotate([0,0,180-slopeang]) {
            translate([-60,0,0]) mount_rt();
            translate([-320,0,0]) mount_rb();
        }
        translate([0,height,0]) rotate([0,0,180+slopeang]) {
            translate([80,0,0]) mount_lt();
            translate([360,0,0]) mount_lb();
        }
        *hole_repair();
    }

    color("#c555") import("grille-top.stl", convexity=10);
    color("#5c55") import("grille-left.stl", convexity=10);
    color("#55c5") import("grille-right.stl", convexity=10);

} else if(1) {
    rotate([0, 0, -toprot]) {
        intersection() {
            render(convexity=10) grille();

            *topsegment_cut();
            *leftsegment_cut();
            *rightsegment_cut();
        }
        *cutout_supports();
        *hollow_cutout_top();
        *hollow_cutout_right();
        *hollow_cutout_left();
        *difference() {
            #hollow_channel_out(ocof=0);
            hollow_channel();
        }
        *hollow_channel();
    }
    *rotate([0, 0, -toprot]) {
        //sidewid = 3*sin(toprot)*sin(toprot);
        sidewid = 1.6;
        #translate([-width/4, height/2, -0.1]) rotate([0, 0, -toprot]) 
            translate([0,0,0]) cube([200, sidewid, 10]);
    }
} else {
    grille();
    hole();
}

if(0) {
color("#9554") translate([-98,105,0.01]) cube([210,250,2],true);
color("#5954") translate([100,-103,0.01]) cube([250,210,2],true);
color("#5594") translate(topcut-[0,0,0.01]) cube([250,210,2],true);
}

if(0) {
    trislopeang = atan((tritop-tribot) / height);
    color("#5594")
        rotate([0, 0, -toprot])
        rotate([trislopeang, 0, 0])
        translate([-12,222,22])
        rotate([0, 0, 30])
        cube([250,210,2],true);
    color("#5954")
        rotate([0, 0, -toprot])
        rotate([trislopeang, 0, 0])
        translate([-125,59,22])
        rotate([0, 0, -26])
        cube([250,210,2],true);
}

if(0) {
color("#5954") translate([200,-110,-25]) cube([210,250,2],true);
//color("#9554") translate([0,-90,-25]) cube([210,250,2],true);
color("#5594") translate([-200,-110,-25]) cube([210,250,2],true);
color("#5954") translate([0,-200,-25]) cube([250,210,2],true);

color("#9554") translate([0,-90,-25]) cube([250,210,2],true);
// color("#5591") translate([100,-300,-90]) cube([250,210,2],true);

/*
ang = atan((250-100)/300);
color("#5594") translate([-20,-82,80]) rotate([-ang,0,0]) cube([250,210,2],true);
*/
}
}

module mount_rt()
{
    difference() {
        mounting_block(sizey=25, botlip=25, depth=30, lbl="RT", mir=1);
        mounting_screw(30, 30, 11);
        mounting_screw(30, 6, -15, 3.9);
        translate([-10.3,4.9,10.2]) cube([0.3,8,10]);
    }
}

module mount_rb()
{
    difference() {
        mounting_block(sizey=25, botlip=25, depth=12, lbl="RB");
        mounting_screw(12, 10, 11);
        mounting_screw(12, 34, -15, 3.9);
        translate([-30,4.9,10.2]) cube([0.3,8,10]);
    }
}

module mount_lt()
{
    // TODO
    difference() {
        mounting_block(sizey=50, depth=16, lbl="LT");
        mounting_screw(16, 10, 40);
        mounting_screw(16, 26, 15, 5, 3);
        translate([-30,4.9,10.2]) cube([0.3,8,10]);
    }
}

module mount_lb()
{
    difference() {
        mounting_block(sizey=50, depth=13, lbl="LB", mir=1);
        mounting_screw(13, 30, 40);
        mounting_screw(13, 14, 20, 5, 3);
        translate([-10.3,4.9,10.2]) cube([0.3,8,10]);
    }
}

module mounting_block(depth=30, sizey=30, botlip=0, lbl="NA", mir=0)
{
    tol = 0.1;
    vtol = 0.3;
    sizex = 40;
    out = 20;
    lip = 10;
    thick = 3;
    inset = lipwid+tol;

    bev = 1;
    dlip = [7,5];

    clipwid = 10;
    clipin = lipthick+vtol;
    clipthick = 2;
    clipcon = (sizey-20 < 5 ? 5 : sizey-20);
    clipedge = 3;
    botlipbev = (botlip-bev > 0 ? botlip-bev : botlip);

    translate([-mir*sizex,0,0]) mirror([mir,0,0]) rotate([0,-90,0]) {
        difference() {
            linear_extrude(height=sizex-tol, convexity=8) polygon([
                [-2, inset+thick], [-2-thick-vtol+tol, inset-vtol+tol],
                [-sizey+bev, inset-vtol+tol], [-sizey, inset-vtol+tol-bev],
                [-sizey, -depth+bev], [-sizey+bev, -depth],
                [botlip-bev, -depth], [botlip, -depth+bev],
                [botlip, -bev-tol], [botlipbev, -tol],
                [0, -tol], [0, inset], [lip+vtol+bev, inset],
                [lip+vtol+bev, inset-vtol]+dlip, [lip+vtol+bev, inset+thick-bev*2]+dlip,
                [lip+vtol, inset+thick-bev]+dlip, [lip+vtol-bev, inset+thick-bev]+dlip,
                [lip+vtol, inset+thick],
            ]);
            rotate([0,90,0]) translate([0,0,-sizey-tol])
                linear_extrude(height=sizey+lip+vtol+tol, convexity=8) polygon([
                    [-sizex-tol, clipwid+tol*2+dlip.y], [-sizex-tol, inset-vtol+tol],
                    [-sizex+clipwid+vtol, inset-vtol+tol],
                    [-sizex+clipwid+vtol, clipwid+tol*2+dlip.y],
            ]);
            translate([-sizey+3,-depth+8,-0.3]) mirror([0,1-mir,0]) translate([0, -5, 0])
                linear_extrude(height=0.3+tol, convexity=8) { text(lbl, 10); }
        }
        translate([0,0,sizex-clipwid]) linear_extrude(height=clipwid, convexity=8) polygon([
            [-sizey+bev, inset+clipthick], [-sizey, inset+clipthick-bev],
            [-sizey, -depth+bev], [-sizey+bev, -depth],
            [botlip-bev, -depth], [botlip, -depth+bev],
            [botlip, -bev-vtol], [botlipbev, -vtol],
            [0, -vtol], [0, inset-vtol], [-sizey+clipcon, inset-vtol], [-sizey+clipcon, inset],
            [clipin, inset], [clipin+bev, inset-clipedge],
            [clipin+clipthick, inset-clipedge], [lip, inset+vtol],
            [lip, inset+thick-bev], [lip-bev, inset+thick],
            [-2, inset+thick], [-2+((inset+clipthick)-(inset+thick)), inset+clipthick],
        ]);
        /*
        *translate([0,0,sizex-clipwid-vtol-tol]) linear_extrude(height=clipwid+vtol+tol, convexity=8) polygon([
            [lip+vtol, inset], [lip+vtol+bev, inset],
            [lip+vtol+bev, inset-vtol]+dlip, [lip+vtol+bev, inset+thick-bev*2]+dlip,
            [lip+vtol, inset+thick-bev]+dlip, [lip+vtol-bev, inset+thick-bev]+dlip,
            [lip+vtol, inset+thick],
        ]);
        */

    }
}

module mounting_screw(depth=30, x=0, y=0, z=10, sink=8)
{
    screwrad = 4/2;
    headrad = 11/2; // 16/2
    clipwid = 10;
    tol = 0.1;

    rotate([-90,0,0]) translate([-x, y, 0])
        rotate_extrude(convexity=5, $fn=120) polygon([
            [0, -depth-tol],
            [screwrad, -depth-tol], [screwrad, z-sink],
            [headrad, z-sink], [headrad, z+tol],
            [0, z+tol],
    ]);
}

module hole_repair(cof=1.6) {
    tol=0.2;
    beamwid = beamwidth+2*4-tol*2;
    beamoff = beamoffset - 4 - width/2+tol;
    lipth = 1.2;
    lipin = 5;
    liptop = 0.6;

    linear_extrude(height=beamthick-tol, convexity=8) polygon([
        [beamoff, 0], [beamoff, cof], [beamoff+beamwid, cof], [beamoff+beamwid, 0]
    ]);
    linear_extrude(height=lipthick, convexity=8) polygon([
        [beamoff, 0], [beamoff, lipwid], [beamoff+beamwid, lipwid], [beamoff+beamwid, 0]
    ]);
    rotate([90,0,0]) translate([0,0,-lipth-cof]) linear_extrude(height=lipth, convexity=8) polygon([
        [beamoff, lipthick],
        [beamoff-lipin, lipthick+lipin],
        [beamoff-lipin, beamthick+liptop],
        [beamoff+beamwid+lipin, beamthick+liptop],
        [beamoff+beamwid+lipin, lipthick+lipin],
        [beamoff+beamwid, lipthick],
    ]);
}

module pin()
{
    cylinder(5, 2, 2, $fn=60);
    translate([0,0,5]) cylinder(1, 2, 1, $fn=60);
    cylinder(0.8, 4, 4, $fn=120);
}

module pipe(dia=200, len=100, off=10, lip=10, blip=-2, thick=5, pth=1.6, tol=0.3)
{
    inoff = thick-pth-tol;
    in = thick-tol;
    translate([holeoff.x, holeoff.y, 0]) {
        rotate_extrude(convexity=5, $fn=240) polygon([
            [dia/2-inoff, -len+pth],
            [dia/2-blip, -len+pth], [dia/2-blip, -len],
            [dia/2-in, -len], [dia/2-in, -lip*2],
            [dia/2-lip, 0], [dia/2-in, 0], [dia/2-in, off],
            [dia/2-inoff, off]
        ]);
    }
}

module topsegment_cut()
{
    //trislopeang = atan((tritop-tribot) / height);
    slopeang = atan(height/(width/2));
    toff = sweep ? 69 : 0;

    sface = sweep ? 
        [[0, 1, 2, 6], [5, 4, 3, 7],
         [0, 3, 4], [0, 4, 1], [1, 4, 5], [1, 5, 2],
         [0, 6, 3], [6, 7, 3], [6, 2, 7], [2, 5, 7]] :
        [[0, 1, 2], [5, 4, 3],
         [0, 3, 4], [0, 4, 1], [1, 4, 5], [1, 5, 2],
         [0, 5, 3], [0, 2, 5]];

    render(convexity=10) union() {
        polyhedron(convexity=8,
            points = [
                [0, 0, -0.01],
                [width/2, height, -0.01], [-width/2-toff, height, -0.01],
                [0, 0, tribot+0.01], [width/2, height, tritop+0.01], [-width/2, height, tritop+0.01],

                [-72*cos(slopeang), 0, -0.01],
                [-width/4, height/2, (tritop+tribot)/2+0.01],
            ],
            faces = sface);
        if (!sweep) {
            intersection() {
                hollow_channel();
                rotate([0, 0, toprot]) translate(topcut-[0,0,0.1]) cube([249,210,height+1],true);
            }
        }
    }
}

module rightsegment_cut()
{
    corners = [
        [width/2, 0, 0]-[-3*cos(toprot),sin(toprot),0]*0.1,
        [width/4, height/2, 0]+[cos(toprot),sin(toprot),0]*0.1,
        [0, 0, 0]-[cos(toprot),sin(toprot),0]*0.1,
    ];
    difference() {
        polyhedron(convexity=8,
            points = concat(
                slopey(-0.01, -0.01, height, corners),
                slopey(tribot+0.01, tritop+0.01, height, corners)),
            faces = nbtquads(len(corners), 2));
    }
}

module leftsegment_cut()
{
    corners = [
        [-width/4, height/2, 0]+[-cos(toprot),sin(toprot),0]*0.1,
        [-width/2, 0, 0]-[3*cos(toprot),sin(toprot),0]*0.1,
        [0, 0, 0]-[-cos(toprot),sin(toprot),0]*0.1,
    ];
    render(convexity=10)
    difference() {
        polyhedron(convexity=8,
            points = concat(
                slopey(-0.01, -0.01, height, corners),
                slopey(tribot+0.01, tritop+0.01, height, corners)),
            faces = nbtquads(len(corners), 2));
        if (!sweep) {
            intersection() {
                hollow_channel_out(ocof=0.2);
                rotate([0, 0, toprot]) translate(topcut-[0,0,0.1]) cube([249,210,height+1],true);
            }
        }
    }
}

module hollow_channel_out(triinr=2, inof=20, trirad=2, backoff=-10, backlip=5, backlip2=5, thick=5, dia=200, cof=1.6, ocof=1.8, cp=60)
{
    sa = 360/cp;
    ssteps = ceil(cp/2);
    slopeang = 180-atan(height/(width/2));
    flang1 = floor(slopeang/sa)*sa;
    clang = flang1 + sa;

    holeinrcut = triinr + cof + ocof;

    flang = flang1 - ((flang1 == slopeang) ? sa : 0);
    cornersof = [
        [-(width/4-trirad/2)+inof, height/2-inof/2, 0],
        [0, trirad+inof/2, 0],
        [width/4-trirad/2-inof, height/2-inof/2, 0],
    ];
    angs_in = [
        concat([for (an=[180:sa:180+flang]) an],[180+slopeang]),
        concat([180+slopeang], [for (an=[180+clang:sa:540-clang]) an], [540-slopeang]),
        concat([180-slopeang], [for (an=[180-flang:sa:180]) an]),
        ];
    cutbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, holeinrcut, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*holeinrcut, -cos(an)*holeinrcut, 0]
            ],
            interline_ca(angs_in, cornersof, holeinrcut, sd+1, ssteps*2, 0, ssteps-1)
        )];

    cfcs = len(cutbotarr);
    ibot = circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof+ocof, backlip2, cfcs);
    itop = slopey(tribot+0.08, tritop+0.08, height, rotarr(cutbotarr));
    //render(convexity=10) union() {
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof+ocof, -0.05, cfcs),
                interpolate_steps(ibot, itop, 10)),
            faces = nbtquads(cfcs, 12));
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2+ocof, -0.02, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2+ocof, -backoff+0.3, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2+ocof-thick-35, -backoff+thick+31, cfcs)),
            faces = nbtquads(cfcs, 3));
    //}
}

module hole()
{
    side = 394;
    outerwid = 50;

    beamwid = beamwidth;
    beamoff = beamoffset - width/2;
    beamh1 = height * (width/2-beamoff)/(width/2)+outerwid;
    beamh2 = height * (width/2-beamoff-beamwid)/(width/2)+outerwid;

    tritop = 200;
    tribot = 25;
    //trislopeang = atan((tritop-tribot) / height);
    trislopeang = 180;

    toprad = topwid / sqrt(2);

    if(0) {
    echo([[width/2,0], [0,height], [-width/2,0]]);
    echo([beamoff, 0], [beamoff+beamwid, 0], [beamoff+beamwid, beamh2-outerwid], [beamoff, beamh1-outerwid]);
    echo([0, height], [toprad, height-toprad], [0, height-2*toprad], [-toprad, height-toprad]);
    }

    color("#5885") rotate([180-trislopeang, 0, 0]) translate([0, 0, 15]) {
        linear_extrude(height=10, convexity=10) difference() {
            polygon([
                [-width/2-outerwid, 0],
                [-width/2-outerwid, -outerwid],
                [width/2+outerwid, -outerwid],
                [width/2+outerwid, 0],
                [0, height+outerwid],
            ]);
            polygon([
                [-width/2, 0], [width/2, 0], [0, height],
            ]);
        }
        translate([0,0,-20]) linear_extrude(height=200, convexity=10) polygon([
            [0, height], [toprad, height-toprad], [0, height-2*toprad], [-toprad, height-toprad],
        ]);
        translate([0,0,-20]) linear_extrude(height=20, convexity=10) polygon([
            [beamoff, -outerwid], [beamoff+beamwid, -outerwid], [beamoff+beamwid, beamh2], [beamoff, beamh1],
        ]);
    }

    sideang = atan(height*2/width)+90;
    *#translate([0, height, 0]) rotate([0, 0, sideang]) translate([0, 25, 0]) cube([5, side, 10]);
}

module grille(cp=60)
{
    lcp = 60;
    dia = 200;
    thick = 5.0;

    backoff = -10;
    backlip = 5;
    backlip2 = 5;

    trirad = 2;
    triinr = 2;
    inof = 20;
    stri = 5;
    cof = 1.6;

    bev = 1;

    topnotch = topwid+1;

    trislopeang = atan((tritop-tribot) / height);

    ssteps = ceil(cp/2);

    sa = 360/cp;
    slopeang = 180-atan(height/(width/2));
    flang1 = floor(slopeang/sa)*sa;
    clang = flang1 + sa;

    sidecnt = cp+5 - ((flang1 == slopeang) ? 2 : 0)+3*(ssteps*2);
    flang = flang1 - ((flang1 == slopeang) ? sa : 0);
    angs = [
        concat([for (an=[0:sa:flang]) an],[slopeang]),
        concat([slopeang], [for (an=[clang:sa:360-clang]) an], [360-slopeang]),
        concat([360-slopeang], [for (an=[360-flang:sa:360]) an]),
        ];
    angs_in = [
        concat([for (an=[180:sa:180+flang]) an],[180+slopeang]),
        concat([180+slopeang], [for (an=[180+clang:sa:540-clang]) an], [540-slopeang]),
        concat([180-slopeang], [for (an=[180-flang:sa:180]) an]),
        ];

    croff = 1/tan((180-slopeang)/2);
    topoff = 1/sin(slopeang-90);

    cangs = [slopeang/2, 180, 360-slopeang/2];
    corners = [[width/2-trirad*croff, trirad, 0], [0, (height-trirad*topoff), 0], [-(width/2-trirad*croff), trirad, 0]];
    //cornersof = [for (sd=[0:2]) corners[sd]-[inof*sin(cangs[sd]), -inof*cos(cangs[sd]), 0]];
    cornersof = [
        [-(width/4-trirad/2)+inof, height/2-inof/2, 0],
        [0, trirad+inof/2, 0],
        [width/4-trirad/2-inof, height/2-inof/2, 0],
    ];
    //cornerssl = [for (sd=[0:2]) corners[sd]-[(inof-triinr-0.1)*sin(cangs[sd]), -(inof-triinr-0.1)*cos(cangs[sd]), 0]];
    //*#polyhedron(points=slopey(tribot, tritop, height, cornerssl), faces=[[0,1,2]]);

    innerbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, triinr, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*triinr, -cos(an)*triinr, 0]
            ],
            interline_ca(angs_in, cornersof, triinr, sd+1, ssteps*2, 0, ssteps-1)
        )];

    bevirad = triinr+bev;
    innerbotarr_bev = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, bevirad, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*bevirad, -cos(an)*bevirad, 0]
            ],
            interline_ca(angs_in, cornersof, bevirad, sd+1, ssteps*2, 0, ssteps-1)
        )];


    a1len = len(angs[1]);
    a1off1 = [-topnotch*cos(angs[1][0]),-topnotch*sin(angs[1][0]),0];
    a1off2 = [ topnotch*cos(angs[2][0]), topnotch*sin(angs[2][0]),0];
    //a1off3 = a1off1+a1off2;
    outerbotarr = concat(
            interline_ca(angs, corners, trirad, 0, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[0])
                corners[0]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            //interline_ca(angs, corners, trirad, 1, ssteps*2, 0, ssteps-1),
            interline_ca(angs,
                [corners[0],corners[1]+a1off1,corners[2]],
                trirad, 1, ssteps*2, 0, ssteps*2-1),
            /*
            [for (an=angs[1])
                corners[1]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            */
            [for (ani=[1:2:a1len-1])
                corners[1]+a1off1+[sin(angs[1][ani])*trirad, -cos(angs[1][ani])*trirad, 0]
            ],
            //[corners[1]+a1off3+[0,trirad,0]],
            [[0, height+topnotch/cos(angs[1][0]), 0]],
            [for (ani=[1:2:a1len-1])
                corners[1]+a1off2+[sin(angs[1][ani])*trirad, -cos(angs[1][ani])*trirad, 0]
            ],
            interline_ca(angs,
                [corners[0],corners[1]+a1off2,corners[2]],
                trirad, 2, ssteps*2, 0, ssteps*2-1),
            //interline_ca(angs, corners, trirad, 2, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[2])
                corners[2]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline_ca(angs, corners, trirad, 3, ssteps*2, 0, ssteps-1)
        );

    bevrad = trirad-bev;
    outerbotarr_bev = concat(
            interline_ca(angs, corners, bevrad, 0, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[0])
                corners[0]+[sin(an)*bevrad, -cos(an)*bevrad, 0]
            ],
            interline_ca(angs,
                [corners[0],corners[1]+a1off1,corners[2]],
                bevrad, 1, ssteps*2, 0, ssteps*2-1),
            [for (ani=[1:2:a1len-1])
                corners[1]+a1off1+[sin(angs[1][ani])*bevrad, -cos(angs[1][ani])*bevrad, 0]
            ],
            [[0, height+(topnotch+bev)/cos(angs[1][0]), 0]],
            [for (ani=[1:2:a1len-1])
                corners[1]+a1off2+[sin(angs[1][ani])*bevrad, -cos(angs[1][ani])*bevrad, 0]
            ],
            interline_ca(angs,
                [corners[0],corners[1]+a1off2,corners[2]],
                bevrad, 2, ssteps*2, 0, ssteps*2-1),
            [for (an=angs[2])
                corners[2]+[sin(an)*bevrad, -cos(an)*bevrad, 0]
            ],
            interline_ca(angs, corners, bevrad, 3, ssteps*2, 0, ssteps-1)
        );

    itop = slopey(tribot-bev, tritop-bev, height, rotarr(innerbotarr));
    ibot = circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip, backlip2, sidecnt);

    difference() {
        union() {
            polyhedron(convexity=8,
                points = concat(outerbotarr, 
                    slopey(tribot-bev, tritop-bev, height, outerbotarr),
                    slopey(tribot, tritop, height, outerbotarr_bev),
                    slopey(tribot, tritop, height, rotarr(innerbotarr_bev)),
                    interpolate_steps(itop, ibot, 10),
                    circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip, 0, sidecnt)),
                faces=dquads(sidecnt, 16));

            slats(corners, 10, 0.3, 11.0, tribot, tritop, height);

            // Small ridge because the cut just doesn't quite reach
            translate([holeoff.x, holeoff.y, 0]) rotate([0, 0, 270-slopeang])
                translate([-25, dia/2-backlip-7.2, 0]) cube([50, 2.5, 9]);
        }
        polyhedron(convexity=5,
            points= [for (dz = [
                [dia/2,                        -0.07],
                [dia/2,                        -backoff],
                [dia/2-thick/2,                -backoff+thick/2],
                [dia/2-thick,                  -backoff],
                [dia/2-thick,                  -0.07],
            ]) each circlepoints(holeoff.x, holeoff.y, dz[0], dz[1], sidecnt)],
            faces=dquads(sidecnt, 5));

        hollow_cutout_top(trirad, inof, cof, triinr, backlip, thick, dia, backlip2, backoff, cp);
        hollow_cutout_right(cof, cp);
        hollow_cutout_left(trirad, inof, cof, triinr, backlip, thick, dia, backlip2, backoff, cp);

        holes();

        if (tophole) {
            top_cutout(0, -(height-inof/4), stri, inof, trirad, istop=true);
            top_cutout(-width/4+inof/4, -(height/2), stri, inof, trirad);
            top_cutout(width/4-inof/4, -(height/2), stri, inof, trirad);
        }
        *cutout_supports();
        if (0) {
            // Small cutout on backside of top
            beamwid = beamwidth+2*4;
            beamoff = beamoffset - 4 - width/2;
            // width scaled to angle
            translate([beamoff, -(width/2-beamoff)*tan(slopeang), -0.1]) rotate([0,0,180+slopeang])
                translate([0,-lipwid-0.1,0]) cube([-beamwid/cos(slopeang)-lipwid*tan(slopeang),
                                                lipwid+0.2, beamthick+0.1]);

            sang2 = 180-slopeang;
            // Small cutout on bit between top and right
            // Double width
            translate([beamoff, (beamoff)*tan(sang2), -0.1]) rotate([0,0,sang2])
                translate([-lipwid*tan(sang2),-lipwid-0.1,0]) cube([beamwid/cos(sang2)+lipwid*2*tan(sang2),
                                                lipwid*2+0.2, beamthick+0.1]);
            // Small cutout on bottom
            translate([beamoff, -0.1, -0.1]) cube([beamwid, lipwid+0.2, beamthick+0.1]);
        }
        *#if (0) {
            beamwid = beamwidth+2*4;
            beamoff = beamoffset - 4 - width/2;
            beamtol = 0.04;
            beamh1 = height * (width/2-beamoff)/(width/2) + beamtol;
            beamh2 = height * (width/2-beamoff-beamwid)/(width/2) + beamtol;

            translate([0, 0, -beamtol]) {
                /*
                linear_extrude(height=beamthick + beamtol, convexity=10) polygon([
                    [beamoff, -beamtol], [beamoff+beamwid, -beamtol],
                    [beamoff+beamwid, beamh2], [beamoff, beamh1],
                ]);
                */
                bh = beamthick + beamtol;
                bh2 = bh;// + beamwid;
                polyhedron(convexity=8,
                    points = [
                        [beamoff, -beamtol, 0], [beamoff+beamwid, -beamtol, 0],
                        [beamoff+beamwid, beamh2, 0], [beamoff, beamh1, 0],

                        [beamoff, -beamtol, bh], [beamoff+beamwid, -beamtol, bh2],
                        [beamoff+beamwid, beamh2, bh2], [beamoff, beamh1, bh],
                    ],
                    faces = concat([ [0, 1, 2, 3], [7, 6, 5, 4] ],
                        nquads(0, 4, 4)
                    ));

            }
        }
    }
}

module cutout_supports(cof=1.6)
{
    slopeang = 180-atan(height/(width/2));
    beamwid = beamwidth+2*4;
    beamoff = beamoffset - 4 - width/2;
    // Small cutout on bottom
    cutout_support(beamoff, beamwid, lipwid+0.02, beamthick+0.01, 1.6+0.02, slt=true);

    // width scaled to angle
    tbeamwid = -beamwid/cos(slopeang)-lipwid*tan(slopeang);

    // Small cutout on backside of top
    translate([beamoff, -(width/2-beamoff)*tan(slopeang), 0])
        rotate([0,0,slopeang]) cutout_support(-tbeamwid, tbeamwid, lipwid, beamthick, cof);

    sang2 = 180-slopeang;
    mbeamwid = beamwid/cos(sang2)+lipwid*2*tan(sang2);
    // Small cutout on bit between top and right, double width
    translate([beamoff, (beamoff)*tan(sang2), 0]) rotate([0,0,sang2])
        cutout_support(-lipwid*tan(sang2), mbeamwid, lipwid, beamthick, cof, dbl=true);
}

module cutout_support(off, len, wid, hei, cof, slt=false, dbl=false, cut=1, tol=0.01, voff=0.5)
{
    cwid = dbl ? wid*2 : wid;
    ccof = dbl ? -wid-tol : -tol;
    translate([off, 0, 0]) {
        translate([0,ccof,-tol]) cube([cut, cwid+tol*2, hei+tol]);
        translate([len-cut,ccof,-tol]) cube([cut, cwid+tol*2, hei+tol]);
        rotate([0,90,0]) translate([0,0,tol]) linear_extrude(convexity=8, height=len-tol*2) {
            if (dbl) {
                polygon([
                    [-hei, cof+tol], [voff-hei, cof+tol], [tol-hei, cof/2],
                    [voff-hei, 0], [tol-hei, -cof/2],
                    [voff-hei, -cof-tol], [-hei, -cof-tol]
                ]);
            } else {
                polygon([
                    [-hei, cof+tol], [voff-hei, cof+tol], [tol-hei, cof/2],
                    [voff-hei, -tol], [-hei,-tol]
                ]);
            }
            if (slt) {
                polygon([
                    [wid+voff-hei, wid-tol], [voff-hei, cof+tol],
                    [voff-hei-cut, cof+tol], [voff+wid-hei, wid+cut],
                ]);
            }
        }
    }
}

module slats(corners, num, so, eo, tribot, tritop, height, thick=1.2)
{
    // Calculate factor for desired y thickness
    toff = thick/(corners[1].y-corners[0].y)/2;
    botbot = 0; // tribot-30;
    bottop = 0; // tribot-40;
    for (sl=[1:num-1]) {
        fact = (sl+so)/(num+so+eo);
        fact2 = fact+((0.4-(sl*-1.5/num))/num);
        pts = concat(
            slopey(botbot, bottop, height, [
                [ corners[0].x + (corners[1].x - corners[0].x)*(fact2-toff)
                , corners[0].y + (corners[1].y - corners[0].y)*(fact2-toff)
                , corners[0].z + (corners[1].z - corners[0].z)*(fact2-toff) ],
                [ corners[0].x + (corners[1].x - corners[0].x)*(fact2+toff)
                , corners[0].y + (corners[1].y - corners[0].y)*(fact2+toff)
                , corners[0].z + (corners[1].z - corners[0].z)*(fact2+toff) ],
                [ corners[2].x + (corners[1].x - corners[2].x)*(fact2+toff)
                , corners[2].y + (corners[1].y - corners[2].y)*(fact2+toff)
                , corners[2].z + (corners[1].z - corners[2].z)*(fact2+toff) ],
                [ corners[2].x + (corners[1].x - corners[2].x)*(fact2-toff)
                , corners[2].y + (corners[1].y - corners[2].y)*(fact2-toff)
                , corners[2].z + (corners[1].z - corners[2].z)*(fact2-toff) ]
            ]),
            slopey(tribot, tritop, height, [
                [ corners[0].x + (corners[1].x - corners[0].x)*(fact-toff)
                , corners[0].y + (corners[1].y - corners[0].y)*(fact-toff)
                , corners[0].z + (corners[1].z - corners[0].z)*(fact-toff) ],
                [ corners[0].x + (corners[1].x - corners[0].x)*(fact+toff)
                , corners[0].y + (corners[1].y - corners[0].y)*(fact+toff)
                , corners[0].z + (corners[1].z - corners[0].z)*(fact+toff) ],
                [ corners[2].x + (corners[1].x - corners[2].x)*(fact+toff)
                , corners[2].y + (corners[1].y - corners[2].y)*(fact+toff)
                , corners[2].z + (corners[1].z - corners[2].z)*(fact+toff) ],
                [ corners[2].x + (corners[1].x - corners[2].x)*(fact-toff)
                , corners[2].y + (corners[1].y - corners[2].y)*(fact-toff)
                , corners[2].z + (corners[1].z - corners[2].z)*(fact-toff) ]
            ]));
        polyhedron(convexity=6,
            points = pts,
            faces = concat(
                [[0,1,2,3],
                [7,6,5,4]],
                nquads(0, 4, 4)
        ));
    }
}

module top_cutout(offx=0, offy=0, stri=5, inof=20, trirad=2, lipof=10, istop=false, thick=2, cp=60)
{
    trislopeang = atan((tritop-tribot) / height);
    sfac = -1/cos(trislopeang);
    sa = 360/cp;
    slopeang = 180-atan(height/(width/2));
    flang1 = floor(slopeang/sa)*sa;
    clang = flang1 + sa;

    flang = flang1 - ((flang1 == slopeang) ? sa : 0);

    cornersof = [
        [-(width/4-trirad/2)+inof, height/2-inof/2, 0],
        [0, trirad+inof/2, 0],
        [width/4-trirad/2-inof, height/2-inof/2, 0],
    ];
    cornerslip = [
        [-(width/4-trirad/2)+inof+lipof*tan(slopeang/2), height/2-inof/2-lipof, 0],
        [0, trirad+inof/2-lipof*2*cos(slopeang), 0],
        [width/4-trirad/2-inof-lipof*tan(slopeang/2), height/2-inof/2-lipof, 0],
    ];

    angs_in = [
        concat([for (an=[180:sa:180+flang]) an],[180+slopeang]),
        concat([180+slopeang], [for (an=[180+clang:sa:540-clang]) an], [540-slopeang]),
        concat([180-slopeang], [for (an=[180-flang:sa:180]) an]),
        ];

    intof = 10.6;

    incut0 = [for (an=angs_in[0])
        [cornerslip[0].x + sin(an)*stri, (cornerslip[0].y - cos(an)*stri)*sfac] ];
    incut1 = istop ? [
            [-intof, sfac*(inof/2-(lipof+intof)*2*cos(slopeang))],
            [ intof, sfac*(inof/2-(lipof+intof)*2*cos(slopeang))],
        ] :
        [for (an=angs_in[1])
            [cornerslip[1].x + sin(an)*stri, (cornerslip[1].y - cos(an)*stri)*sfac] ];
    incut2 = [for (an=angs_in[2])
        [cornerslip[2].x + sin(an)*stri, (cornerslip[2].y - cos(an)*stri)*sfac] ];

    translate([0, 0, tribot]) rotate([trislopeang, 0, 0])
    translate([offx, offy*sfac, 0]) {
        translate([0, 0, -thick])
        linear_extrude(height=thick+0.01, convexity=8) polygon(concat(
            [for (sd=[0:2]) each [for (an=angs_in[sd])
                [cornersof[sd].x + sin(an)*stri, (cornersof[sd].y - cos(an)*stri)*sfac] ] ]
        ));
        translate([0, 0, -thick-thick*0.74])
        linear_extrude(height=thick+0.02, convexity=8) polygon(concat(incut0, incut1, incut2));
    }
}

module hollow_cutout_top(trirad=2, inof=20, cof=1.6, triinr=2, backlip=5, thick=5, dia=200, backlip2=5, backoff=-10, cp=60)
{
    topnotch = topwid+1;
    sa = 360/cp;
    slopeang = atan(height/(width/2));
    cos_sl = cos(slopeang);
    sin_sl = sin(slopeang);

    radof = 1;
    tof = 20;
    tofy1 = tophole ? 4 : 2;
    tofy2 = 15;

    sweepcorner = sweep ? 
        [-(width/2-cof/sin_sl), 0, 0] :
        [-(width/4-cof/sin_sl), height/2, 0];

    corners = [
        [width/4-cof/sin_sl, height/2, 0],
        [topnotch*cos_sl, height-(topnotch)*sin_sl-cof/cos_sl, 0] +
            [ radof*cos_sl, -radof*sin_sl, 0],
        [topnotch*cos_sl, height-(topnotch)*sin_sl-cof/cos_sl, 0] +
            [-radof*cos_sl, -radof*sin_sl, 0],
        [0, height-(topnotch+cof)/cos_sl, 0],
        [-topnotch*cos_sl, height-topnotch*sin_sl-cof/cos_sl, 0] +
            [ radof*cos_sl, -radof*sin_sl, 0],
        [-topnotch*cos_sl, height-topnotch*sin_sl-cof/cos_sl, 0] +
            [-radof*cos_sl, -radof*sin_sl, 0],
        sweepcorner,
        [0, cof/cos_sl, 0],
    ];

    render(convexity=10)
    difference() {
        polyhedron(convexity = 8,
            points = concat(
                slopey(-0.02, -0.02, height, corners),
                slopey(tribot-tofy1, tritop-tofy1, height, corners)),
            faces = nbtquads(len(corners), 2));

        // Side outie with straight faces
        if (sweep) hollow_sweep(cof);

        if (tophole) {
            // Support slants for top hole
            translate([-topnotch*2, height-10, tritop-60])
                rotate([45,0,0]) cube([topnotch*4, 30, 60]);
            polyhedron(convexity=8,
                points = [
                    [-width/2, 0, (tribot)+0.03],
                    [-width/2+tof, 0, (tribot)+0.03],
                    [-width/2+tof, 0, (tribot)+0.03-tofy1],
                    [-width/2, 0, (tribot)+0.03-tofy2],

                    [0, height, tritop+0.03],
                    [0+tof, height, tritop+0.03],
                    [0+tof, height, tritop+0.03-tofy1],
                    [0, height, tritop+0.03-tofy2],
                ],
                faces = nbtquads(4, 2));
            polyhedron(convexity=8,
                points = [
                    [width/2, 0, (tribot)+0.03],
                    [width/2, 0, (tribot)+0.03-tofy2],
                    [width/2-tof, 0, (tribot)+0.03-tofy1],
                    [width/2-tof, 0, (tribot)+0.03],

                    [0, height, tritop+0.03],
                    [0, height, tritop+0.03-tofy2],
                    [0-tof, height, tritop+0.03-tofy1],
                    [0-tof, height, tritop+0.03],
                ],
                faces = nbtquads(4, 2));
        }

        hollow_channel(triinr, inof, trirad, backoff, backlip, backlip2, thick, dia, cof);

        rthick = 1.6;
        // Ridge to connect air channel to top
        translate([-rthick/2, height/2-10, -0.2]) cube([rthick, height/2, tritop]);

        liplen = (height/2)/sin_sl;
        liptop = topnotch+lipwid+cof*sin(toprot)-0.8; // Fudge
        // Bottom lips for bed adhesion and stiffness
        translate([0, 0, -0.09]) rotate([0, 0, 180-toprot]) 
            translate([0,-lipwid,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, 0, -0.09]) rotate([0, 0, toprot]) 
            translate([0,0,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, height, -0.09]) rotate([0, 0, -toprot]) 
            translate([0,-lipwid,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, height, -0.09]) rotate([0, 0, 180+toprot]) 
            translate([0,0,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, height, -0.09]) rotate([0, 0, -toprot]) 
            translate([0,-topnotch-lipwid,0]) cube([liptop, lipwid, lipthick+0.09]);
        translate([0, height, -0.09]) rotate([0, 0, 180+toprot]) 
            translate([0,topnotch,0]) cube([liptop, lipwid, lipthick+0.09]);
        translate([-lipwid/2, height/2-10, -0.09]) cube([lipwid, height/2, lipthick+0.09]);

        top_support();
    }
}

module hollow_cutout_left(trirad=2, inof=20, cof=1.6, triinr=2, backlip=5, thick=5, dia=200, backlip2=5, backoff=-10, cp=60)
{
    sa = 360/cp;
    slopeang = atan(height*2/width);
    cos_sl = cos(slopeang);
    sin_sl = sin(slopeang);

    tofy1 = tophole ? 4 : 2;

    corners = [
        [-width/4, height/2-cof/sin_sl, 0],
        [-width/2+cof/tan(slopeang/2), cof, 0],
        [-cof/tan(slopeang/2), cof, 0],
    ];

    render(convexity=10)
    difference() {
        polyhedron(convexity = 8,
            points = concat(
                slopey(-0.02, -0.02, height, corners),
                slopey(tribot-tofy1, tritop-tofy1, height, corners)),
            faces = nbtquads(len(corners), 2));
        hollow_channel_out(triinr, inof, trirad, backoff, backlip, backlip2, thick, dia, cof);

        liplen = (height/2)/sin_sl;
        // Bottom lips for bed adhesion and stiffness
        translate([0, 0, -0.09]) rotate([0, 0, 180-toprot]) 
            translate([0,0,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([-width/2, 0, -0.09]) rotate([0, 0, toprot]) 
            translate([0,-lipwid,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, 0, -0.09]) rotate([0, 0, 0]) 
            translate([-width/2,0,0]) cube([width/2, lipwid, lipthick+0.09]);

        translate([holeoff.x, holeoff.y, -0.09])
            cylinder(lipthick+0.09, dia/2+lipwid, dia/2+lipwid, $fn=cp*3);

        lr_support(-width/4);
    }
}

module hollow_cutout_right(cof=1.6, cp=60)
{
    sa = 360/cp;
    slopeang = atan(height*2/width);
    cos_sl = cos(slopeang);
    sin_sl = sin(slopeang);

    tofy1 = tophole ? 4 : 2;

    corners = [
        [width/2-cof/tan(slopeang/2), cof, 0],
        [width/4, height/2-cof/sin_sl, 0],
        [cof/tan(slopeang/2), cof, 0],
    ];

    liplen = (height/2)/sin_sl;
    render(convexity=10)
    difference() {
        polyhedron(convexity = 8,
            points = concat(
                slopey(-0.02, -0.02, height, corners),
                slopey(tribot-tofy1, tritop-tofy1, height, corners)),
            faces = nbtquads(len(corners), 2));

        liplen = (height/2)/sin_sl;
        // Bottom lips for bed adhesion and stiffness
        translate([0, 0, -0.09]) rotate([0, 0, toprot]) 
            translate([0,-lipwid,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([width/2, 0, -0.09]) rotate([0, 0, 180-toprot]) 
            translate([0,0,0]) cube([liplen, lipwid, lipthick+0.09]);
        translate([0, 0, -0.09]) rotate([0, 0, 0]) 
            translate([0,0,0]) cube([width/2, lipwid, lipthick+0.09]);
        lr_support(width/4);
    }
}

module top_support()
{
    ch = height/2;
    ct = tritop;
    fx = height*2/width;
    tx = fx*(tritop-tribot)/height;
    for (x=[supportstep:supportstep:width/4-10]) {
        chs = ch-x*fx+10;
        translate([x+supportwid/2, height-x*fx, ct-x*tx-3]) rotate([0,-90,0])
        linear_extrude(height=supportwid) polygon([
            [0.01, 0.01], [-chs-0.01, -chs-0.01], [0.01, -chs-0.01]
        ]);
        translate([-x+supportwid/2, height-x*fx, ct-x*tx-3]) rotate([0,-90,0])
        linear_extrude(height=supportwid) polygon([
            [0.01, 0.01], [-chs-0.01, -chs-0.01], [0.01, -chs-0.01]
        ]);
    }
}

module lr_support(cx)
{
    ch = height/2;
    ct = (tritop+tribot)/2;
    fx = height*2/width;
    tx = fx*(tritop-tribot)/height;
    for (x=[supportstep/2:supportstep:width/4-10]) {
        chs = ch-x*fx;
        translate([cx+x+supportwid/2, ch-x*fx, ct-x*tx-3]) rotate([0,-90,0])
        linear_extrude(height=supportwid) polygon([
            [0.01, 0.01], [-chs-0.01, -chs-0.01], [0.01, -chs-0.01]
        ]);
        translate([cx-x+supportwid/2, ch-x*fx, ct-x*tx-3]) rotate([0,-90,0])
        linear_extrude(height=supportwid) polygon([
            [0.01, 0.01], [-chs-0.01, -chs-0.01], [0.01, -chs-0.01]
        ]);
    }
}

module hollow_sweep(cof=1.6)
{
    csang = atan(height/(width/2));
    boff = -36;
    toff = 69;
    cioff = cof*[sin(csang), cos(csang), 0];
    polyhedron(convexity = 8,
        points = [
            [-width/2-toff, height, -0.05]+cioff,
            [-72*cos(csang), 0, -0.05]+cioff,
            [0, 0, tribot+0.05]+cioff,

            [-width/4, height/2, (tritop+tribot)/2+0.05]+cioff,

            //[-72*cos(slopeang), 0, -0.01],
            [-width/2, -height*2, -0.05]+cioff,
            ],
        faces = [[0, 1, 3], [1, 2, 3],
            [1, 0, 4], [2, 1, 4], [3, 2, 4], [0, 3, 4] ]);
}

module hollow_channel(triinr=2, inof=20, trirad=2, backoff=-10, backlip=5, backlip2=5, thick=5, dia=200, cof=1.6, cp=60)
{
    sa = 360/cp;
    ssteps = ceil(cp/2);
    slopeang = 180-atan(height/(width/2));
    flang1 = floor(slopeang/sa)*sa;
    clang = flang1 + sa;

    holeinrcut = triinr + cof;

    flang = flang1 - ((flang1 == slopeang) ? sa : 0);
    cornersof = [
        [-(width/4-trirad/2)+inof, height/2-inof/2, 0],
        [0, trirad+inof/2, 0],
        [width/4-trirad/2-inof, height/2-inof/2, 0],
    ];
    angs_in = [
        concat([for (an=[180:sa:180+flang]) an],[180+slopeang]),
        concat([180+slopeang], [for (an=[180+clang:sa:540-clang]) an], [540-slopeang]),
        concat([180-slopeang], [for (an=[180-flang:sa:180]) an]),
        ];
    cutbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, holeinrcut, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*holeinrcut, -cos(an)*holeinrcut, 0]
            ],
            interline_ca(angs_in, cornersof, holeinrcut, sd+1, ssteps*2, 0, ssteps-1)
        )];

    cfcs = len(cutbotarr);
    ibot = circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof, backlip2, cfcs);
    itop = slopey(tribot+0.08, tritop+0.08, height, rotarr(cutbotarr));
    //render(convexity=10) union() {
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof, -0.05, cfcs),
                interpolate_steps(ibot, itop, 10)),
            faces = nbtquads(cfcs, 12));
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2-thick+0.01, -0.02, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2-thick+0.01, -backoff, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-18, -backoff+10, cfcs)),
            faces = nbtquads(cfcs, 3));
    //}
}

module holes(cof=1.6)
{
    connecting_hole(toprot, 25, 15, cof*2);
    connecting_hole(toprot, 195, 15, cof*2);
    connecting_hole(toprot, 195, 80, cof*2);

    connecting_hole(180-toprot, 12, 12, cof*2);
    connecting_hole(180-toprot, 195, 25, cof*2);
    connecting_hole(180-toprot, 195, 80, cof*2);

    *mounting_hole(toprot, 40, 12, cof);
    *mounting_hole(toprot, 330, 12, cof);

    *mounting_hole(180-toprot, 40, 12, cof);
    *mounting_hole(180-toprot, 330, 12, cof);

    translate([0, height-57, -0.01]) rotate([45, 0, 0]) cube([lipwid+0.5, 15, 15], true);
}

module screws(cl=15, sl=30)
{
    connecting_hole(toprot, 25, 15, cl);
    connecting_hole(toprot, 195, 15, cl);
    connecting_hole(toprot, 195, 80, cl);

    connecting_hole(180-toprot, 12, 12, cl);
    connecting_hole(180-toprot, 195, 25, cl);
    connecting_hole(180-toprot, 195, 80, cl);

    mounting_hole(toprot, 40, 12, sl);
    mounting_hole(toprot, 330, 12, sl);

    mounting_hole(180-toprot, 40, 12, sl);
    mounting_hole(180-toprot, 330, 12, sl);
}

module mounting_hole(rot, x, z, l, d=4)
{
    fx = rot>90 ? x : -x;
    rr = rot<90 ? rot : rot+180;

    translate([0, height, 0]) rotate([0, 0, rr])
    translate([fx, 0.05, z]) rotate([90,0,0]) cylinder(l+0.1, d/2, d/2, $fn=30);
}

module connecting_hole(rot, x, z, l, d=4)
{
    rotate([0, 0, rot])
    translate([x, (l+0.1)/2, z]) rotate([90,0,0]) cylinder(l+0.1, d/2, d/2, $fn=30);
}

// Array of points that form a line between two points with angle offsets from an array
function interline_ca(angs, corners, rd, sd, ssteps, from, to, mangs=3) = 
    let(an = angs[sd%mangs][0]) interline(
        corners[(sd+2)%mangs]+[sin(an)*rd, -cos(an)*rd, 0],
        corners[ sd   %mangs]+[sin(an)*rd, -cos(an)*rd, 0],
        ssteps, from, to);

// Array of points that form a line between two points
function interline(pt1, pt2, ssteps, from, to) =
    [for (st = [from:to]) [
        pt1.x + (pt2.x-pt1.x)*(st/ssteps),
        pt1.y + (pt2.y-pt1.y)*(st/ssteps),
        pt1.z + (pt2.z-pt1.z)*(st/ssteps) ]];

// change z coordinate as function of y coordinate
function slopey(from, to, my, pts) = [for (pt=pts) [pt.x, pt.y, pt.z + from + (to-from)*(pt.y/my)]];

// Multiple interpolationsteps
// Top array, bottom array, steps
function interpolate_steps(bot, top, st) =
    [for (pos=[0:1/st:1]) each interpolate(bot, top, pos)];

// Interpolate between two arrays of points
// Top array, bottom array, position (0-1)
function interpolate(bot, top, pos) =
    [for (i=[0:len(top)-1]) inter(top[i], bot[i], pos)];

// Interpolate between p1 and p2
function inter(p1, p2, pos) =
    [ p1.x * pos + p2.x * (1-pos)
    , p1.y * pos + p2.y * (1-pos)
    , p1.z * pos + p2.z * (1-pos)
    ];

// Faces of side of layers
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o) = [for (i=[0:n-1]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

// Top and bottom layer
// number, offset
function nqbottop(n, o) = [[for (i=[0:n-1]) i],[for (i=[o+n-1:-1:o]) i]];

// Top and bottom layer plus sides, simple
// number of sides, number of layers
function nbtquads(n, nl) = concat(nqbottop(n, (nl-1)*n),
    [for (l=[0:nl-2]) each nquads(l*n, n, n)]);

// Faces of n sides of layers which form a donut pattern
// number, number of layers
function dquads(n, nl) = concat(
    [for (s=[0:nl-2]) each nquads(s*n, n, n)],
    nquads((nl-1)*n, n, (1-nl)*n));

// Rotate an array
function rotarr(arr) = concat([for (i=[ceil(len(arr)/2):len(arr)-1]) arr[i]], [for (i=[0:ceil(len(arr)/2)-1]) arr[i]]);

function circlepoints(x, y, r, z, cnt) =
    [for (an=[0:(360/cnt):360-(360/cnt)]) [x+sin(an)*r, y-cos(an)*r, z]];
