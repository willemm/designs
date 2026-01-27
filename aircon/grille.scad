
width = 583;
height = 300;
topwid = 26;
tritop = 200;
tribot = 25;
beamwidth = 40;
beamoffset = 360;
beamthick = 15;

topcut = [89, 105, 0];
toprot = atan(height*2/width);

if(1) {
    rotate([0, 0, -toprot]) intersection() {
        grille();
        topcut();
        *hollow_cutout();
    }
} else {
    grille();
    hole();
}

if(0) {
color("#9554") translate([-100,105,0.01]) cube([210,250,2],true);
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

module topcut()
{
    //trislopeang = atan((tritop-tribot) / height);
    slopeang = atan(height/(width/2));
    boff = -36;
    toff = 69;
    polyhedron(convexity=8,
        points = [
            [boff*cos(slopeang), boff*sin(slopeang), -0.01],
            [width/2, height, -0.01], [-width/2-toff, height, -0.01],
            [0, 0, tribot+0.01], [width/2, height, tritop+0.01], [-width/2, height, tritop+0.01],

            [-72*cos(slopeang), 0, -0.01],
            [-width/4, height/2, (tritop+tribot)/2+0.01],
        ],
        faces = concat([ [0, 1, 2, 6], [5, 4, 3, 7] ],
            [[0, 3, 4], [0, 4, 1], [1, 4, 5], [1, 5, 2]],
            //[[0, 5, 3], [0, 2, 5]]
            [[0, 6, 3], [6, 7, 3], [6, 2, 7], [2, 5, 7]]
        ));
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
    backlip = 10;
    backlip2 = 5;

    trirad = 2;
    triinr = 2;
    triinrcut = 5;
    inof = 20;
    stri = 5;

    topnotch = topwid+1;

    trislopeang = atan((tritop-tribot) / height);

    holeoff = [-37, dia/2+11, 0];

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

    /*
    translate([holeoff.x,holeoff.y,-60]) linear_extrude(height=60, convexity=6) difference() {
        circle(dia/2, $fn=sidecnt);
        circle(dia/2-thick, $fn=sidecnt);
    }
    */

    innerbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, triinr, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*triinr, -cos(an)*triinr, 0]
            ],
            interline_ca(angs_in, cornersof, triinr, sd+1, ssteps*2, 0, ssteps-1)
        )];

    /*
    outerbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs, corners, trirad, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[sd])
                corners[sd]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline_ca(angs, corners, trirad, sd+1, ssteps*2, 0, ssteps-1)
        )];
    */
    a1len = len(angs[1]);
    a1off1 = [-topnotch*cos(angs[1][0]),-topnotch*sin(angs[1][0]),0];
    a1off2 = [topnotch*cos(angs[2][0]),topnotch*sin(angs[2][0]),0];
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
            [corners[1]+a1off1+a1off2+[0,trirad,0]],
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
    spoints = concat(outerbotarr, 
        slopey(tribot, tritop, height, outerbotarr),
        slopey(tribot, tritop, height, rotarr(innerbotarr)),
        [for (dz = [
            [dia/2-thick-backlip,          backlip2],
            [dia/2-thick-backlip+backlip2, 0],
            [dia/2-thick,                  0],
            [dia/2-thick,                  -backoff],
            [dia/2-thick/2,                -backoff+thick/2],
            [dia/2,                        -backoff],
            [dia/2,                        0],
            ]) each circlepoints(holeoff.x, holeoff.y, dz[0], dz[1], sidecnt)]
    );

    difference() {
        union() {
            polyhedron(convexity=8,
                points=spoints,
                faces=concat(
                    nquads(0, sidecnt, sidecnt, 0),
                    nquads(sidecnt, sidecnt, sidecnt, 0),
                    nquads(sidecnt*2, sidecnt, sidecnt, 0),
                    nquads(sidecnt*3, sidecnt, sidecnt, 0),
                    nquads(sidecnt*4, sidecnt, sidecnt, 0),
                    nquads(sidecnt*5, sidecnt, sidecnt, 0),
                    nquads(sidecnt*6, sidecnt, sidecnt, 0),
                    nquads(sidecnt*7, sidecnt, sidecnt, 0),
                    nquads(sidecnt*8, sidecnt, sidecnt, 0),
                    nquads(sidecnt*9, sidecnt, -sidecnt*9, 0),
                    []
            ));

            *difference() {
                slats(corners, 10, 0.3, 11.0, tribot, tritop, height);
                if (backoff < 0) {
                    translate([holeoff.x,holeoff.y,-0.1])
                        linear_extrude(height=-backoff+0.2+thick/2, convexity=6) difference() {
                            circle(dia/2+0.2, $fn = cp*3);
                            circle(dia/2-thick-0.2, $fn = cp*3);
                        }
                }
            }
        }
        if (1) {
            hollow_cutout(trirad, inof, 3, triinrcut, backlip, thick, dia, backlip2, backoff, cp);
        }
        *if (1) {
            top_cutout(0, -(height-inof/4), stri, inof, trirad);
            top_cutout(-width/4+inof/4, -(height/2), stri, inof, trirad);
            top_cutout(width/4+inof/4, -(height/2), stri, inof, trirad);
        }
        if (1) {
            cof = 1.6;
            // Small cutout on backside of top
            beamwid = beamwidth+2*4;
            beamoff = beamoffset - 4 - width/2;
            // width scaled to angle
            translate([beamoff, -(width/2-beamoff)*tan(slopeang), -0.03]) rotate([0,0,180+slopeang])
                translate([0,-cof-0.01,0]) cube([-beamwid/cos(slopeang)-cof*tan(slopeang),
                                                cof+0.02, beamthick+0.03]);

            cof2 = 2;
            sang2 = 180-slopeang;
            // Small cutout on bit between top and right
            translate([beamoff, (beamoff)*tan(sang2), -0.05]) rotate([0,0,sang2])
                translate([0,-0.01,0]) cube([beamwid/cos(sang2)+cof2*tan(sang2),
                                                cof2+0.02, beamthick+0.03]);
        }
        *if (1) {
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
                        nquads(0, 4, 4, 0)
                    ));

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
                nquads(0, 4, 4, 0)
        ));
    }
}

module top_cutout(offx=0, offy=0, stri=5, inof=20, trirad=2, thick=2, cp=60)
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

    angs_in = [
        concat([for (an=[180:sa:180+flang]) an],[180+slopeang]),
        concat([180+slopeang], [for (an=[180+clang:sa:540-clang]) an], [540-slopeang]),
        concat([180-slopeang], [for (an=[180-flang:sa:180]) an]),
        ];

    translate([0, 0, tribot]) rotate([trislopeang, 0, 0])
    translate([offx, offy*sfac, -2])
    linear_extrude(height=2.1, convexity=8) polygon(concat(
        [for (sd=[0:2]) each [for (an=angs_in[sd])
            [cornersof[sd].x + sin(an)*stri, (cornersof[sd].y - cos(an)*stri)*sfac] ] ]
    ));
}

module hollow_cutout(trirad=2, inof=20, cof=3, triinrcut=5, backlip=10, thick=5, dia=200, backlip2=5, backoff=-10, cp=60)
{
    topnotch = topwid+1;
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

    a1off1 = [-topnotch*cos(angs[1][0]),-topnotch*sin(angs[1][0]),0];
    a1off2 = [topnotch*cos(angs[2][0]),topnotch*sin(angs[2][0]),0];

    holeoff = [-37, dia/2+11, 0];

    radof = (trirad*2-1 > cof ? trirad*2-cof : 1);
    tof = 20;
    tofy1 = 5;
    tofy2 = 15;
    cornersmid = [
        [width/4+cof*cos(angs[2][0]), height/2, -0.02],
        [-topnotch*cos(angs[2][0]), height-cof*0.75+topnotch*sin(angs[2][0]), -0.02] +
            [-radof*cos(angs[2][0]), radof*sin(angs[2][0]), 0],
        [-topnotch*cos(angs[2][0]), height-cof*0.75+topnotch*sin(angs[2][0]), -0.02] +
            [radof*cos(angs[1][0]), -radof*sin(angs[1][0]), 0],
        [0, height-cof*0.75-trirad/2, -0.02]+a1off1+a1off2,
        [topnotch*cos(angs[1][0]), height-cof*0.75-topnotch*sin(angs[1][0]), -0.02] +
            [-radof*cos(angs[2][0]), radof*sin(angs[2][0]), 0],
        [topnotch*cos(angs[1][0]), height-cof*0.75-topnotch*sin(angs[1][0]), -0.02] +
            [radof*cos(angs[1][0]), -radof*sin(angs[1][0]), 0],
        //[-(width/4+cof*cos(angs[1][0])), height/2, -0.02],
        [-(width/2+cof*cos(angs[1][0])), 0, -0.02],
        [0, cof, -0.02],
    ];
    cuttop = [
        [width/4+3, height/2-3, 0],
        [width/4, height/2, 0]+
            [cos(angs[2][0]), -sin(angs[2][0]), 0]*(tof/2),
        [-(width/4), height/2, 0]+
            [-cos(angs[1][0]), sin(angs[1][0]), 0]*(tof/2),
        [-(width/4+3), height/2-3, 0],
        [0, -5, 0],
    ];
    mcnt = len(cornersmid);
    ccnt = len(cuttop);
    ssteps = ceil(cp/2);

    cutbotarr = [for (sd=[0:2]) each concat(
            interline_ca(angs_in, cornersof, triinrcut, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*triinrcut, -cos(an)*triinrcut, 0]
            ],
            interline_ca(angs_in, cornersof, triinrcut, sd+1, ssteps*2, 0, ssteps-1)
        )];

    render(convexity=10) difference() {
        polyhedron(convexity = 8,
            points = concat(cornersmid,
                slopey(tribot+0.04, tritop+0.04, height, cornersmid)),
            faces = nbtquads(mcnt, 2));
        polyhedron(convexity = 8,
            points = concat(
                slopey(tribot-5, tritop-5, height, cuttop),
                slopey(tribot+0.05, tritop+0.05, height, cuttop)),
            faces = nbtquads(ccnt, 2));

        hollow_sweep(cof);

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
        cfcs = len(cutbotarr);
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof, -0.05, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-backlip+cof, backlip2, cfcs),
                slopey(tribot+0.08, tritop+0.08, height, rotarr(cutbotarr))),
            faces = nbtquads(cfcs, 3));
        //translate([holeoff.x, holeoff.y, -0.01]) cylinder(16, dia/2+cof, dia/2+cof, $fn=cp*3);
        polyhedron(convexity=8,
            points = concat(
                circlepoints(holeoff.x, holeoff.y, dia/2-thick+0.01, -0.01, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2-thick+0.01, -backoff-0.01, cfcs),
                circlepoints(holeoff.x, holeoff.y, dia/2-thick-18, -backoff+10, cfcs)),
            faces = nbtquads(cfcs, 3));
    }
}

module hollow_sweep(cof=3)
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

// Faces of side of layers
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

// Top and bottom layer
// number, offset
function nqbottop(n, o) = [[for (i=[0:n-1]) i],[for (i=[o+n-1:-1:o]) i]];

// Top and bottom layer plus sides, simple
// number of sides, number of layers
function nbtquads(n, nl) = concat(nqbottop(n, (nl-1)*n),
    [for (l=[0:nl-2]) each nquads(l*n, n, n, 0)]);

// Rotate an array
function rotarr(arr) = concat([for (i=[ceil(len(arr)/2):len(arr)-1]) arr[i]], [for (i=[0:ceil(len(arr)/2)-1]) arr[i]]);

function circlepoints(x, y, r, z, cnt) =
    [for (an=[0:(360/cnt):360-(360/cnt)]) [x+sin(an)*r, y-cos(an)*r, z]];
