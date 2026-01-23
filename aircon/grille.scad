
topcut = [87.3, 107.3, 0];

if(1) {
    intersection() {
        grille();
        rotate([0,0,45]) translate(topcut+[0,0,110]) cube([250,210,220],true);
    }
} else {
    grille();
    *hole();
}

if(0) {
*color("#5954") rotate([0,0,45]) translate([98,-92,-101.01]) cube([250,210,2],true);
color("#5594") rotate([0,0,45]) translate(topcut-[0,0,0.01]) cube([250,210,2],true);
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

module hole()
{
    height = 300;
    width = 585;
    topwid = 25;
    side = 394;
    outerwid = 50;

    beamwid = 40;
    beamoff = 360 - width/2;
    beamh1 = height * (width/2-beamoff)/(width/2)+outerwid;
    beamh2 = height * (width/2-beamoff-beamwid)/(width/2)+outerwid;

    tritop = 200;
    tribot = 25;
    //trislopeang = atan((tritop-tribot) / height);
    trislopeang = 180;

    toprad = topwid / sqrt(2);

    color("#5885") rotate([180-trislopeang, 0, 0]) translate([0, 0, -2]) {
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
        linear_extrude(height=20, convexity=10) polygon([
            [0, height], [toprad, height-toprad], [0, height-2*toprad], [-toprad, height-toprad],
        ]);
        linear_extrude(height=20, convexity=10) polygon([
            [beamoff, -outerwid], [beamoff+beamwid, -outerwid], [beamoff+beamwid, beamh2], [beamoff, beamh1],
        ]);
    }

    sideang = atan(height*2/width)+90;
    *#translate([0, height, 0]) rotate([0, 0, sideang]) translate([0, 25, 0]) cube([5, side, 10]);
}

module grille()
{
    lcp = 60;
    cp = 60;
    width = 585;
    height = 300;
    dia = 200;
    thick = 5.0;

    backoff = -10;
    backlip = 5;

    trirad = 2;
    triinr = 2;
    inof = 20;

    tritop = 200;
    tribot = 25;

    //trislopeang = atan((tritop-tribot) / height);
    trislopeang = 180;

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
            interline(angs_in, cornersof, triinr, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs_in[sd])
                cornersof[sd]+[sin(an)*triinr, -cos(an)*triinr, 0]
            ],
            interline(angs_in, cornersof, triinr, sd+1, ssteps*2, 0, ssteps-1)
        )];

    /*
    outerbotarr = [for (sd=[0:2]) each concat(
            interline(angs, corners, trirad, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[sd])
                corners[sd]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline(angs, corners, trirad, sd+1, ssteps*2, 0, ssteps-1)
        )];
    */
    outerbotarr = concat(
            interline(angs, corners, trirad, 0, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[0])
                corners[0]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline(angs, corners, trirad, 1, ssteps*2, 0, ssteps-1),
            interline(angs, corners, trirad, 1, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[1])
                corners[1]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline(angs, corners, trirad, 2, ssteps*2, 0, ssteps-1),
            interline(angs, corners, trirad, 2, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[2])
                corners[2]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline(angs, corners, trirad, 3, ssteps*2, 0, ssteps-1)
        );
    spoints = concat(outerbotarr, 
        slopey(tribot, tritop, height, outerbotarr),
        slopey(tribot, tritop, height, rotarr(innerbotarr)),
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick-backlip), holeoff.y-cos(an)*(dia/2-thick-backlip), 0]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick), holeoff.y-cos(an)*(dia/2-thick), 0]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick), holeoff.y-cos(an)*(dia/2-thick), -backoff]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2), holeoff.y-cos(an)*(dia/2), -backoff]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2), holeoff.y-cos(an)*(dia/2), 0]],

        []
    );

    difference() {
        rotate([180-trislopeang, 0, 0]) union() {
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
                    nquads(sidecnt*7, sidecnt, -sidecnt*7, 0),
                    []
            ));

            difference() {
                slats(corners, 10, 0.3, 11.0, tribot, tritop, height);
                if (backoff < 0) {
                    translate([0,0,-0.1]) linear_extrude(height=-backoff+0.2, convexity=6) polygon(concat(
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick-1), holeoff.y-cos(an)*(dia/2-thick-1)]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2+1), holeoff.y-cos(an)*(dia/2+1)]]
                    ));
                }
            }
        }
        if (1) {
            beamwid = 40+2*1;
            beamoff = 360 - 1 - width/2;
            beamtol = 0.01;
            beamh1 = height * (width/2-beamoff)/(width/2) + beamtol;
            beamh2 = height * (width/2-beamoff-beamwid)/(width/2) + beamtol;
            beamthick = 15;

            rotate([180-trislopeang,0,0]) translate([0, 0, -beamtol]) linear_extrude(height=beamthick + beamtol, convexity=10) polygon([
                [beamoff, -beamtol], [beamoff+beamwid, -beamtol], [beamoff+beamwid, beamh2], [beamoff, beamh1],
            ]);
        }
    }
}

module slats(corners, num, so, eo, tribot, tritop, height, thick=3)
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

// Array of points that form half of a line between two points
function interline(angs, corners, rd, sd, ssteps, from, to, mangs=3) = 
    let( an = angs[sd%mangs][0],
        pt1 = corners[(sd+2)%mangs]+[sin(an)*rd, -cos(an)*rd, 0],
        pt2 = corners[ sd   %mangs]+[sin(an)*rd, -cos(an)*rd, 0]) [
    for (st = [from:to]) [
        pt1.x + (pt2.x-pt1.x)*(st/ssteps),
        pt1.y + (pt2.y-pt1.y)*(st/ssteps),
        pt1.z + (pt2.z-pt1.z)*(st/ssteps)
]];

// change z coordinate as function of y coordinate
function slopey(from, to, my, pts) = [for (pt=pts) [pt.x, pt.y, pt.z + from + (to-from)*(pt.y/my)]];

// Faces of side of layers
// start offset, number, layer offset, startskip, endskip
function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

// Rotate an array
function rotarr(arr) = concat([for (i=[ceil(len(arr)/2):len(arr)-1]) arr[i]], [for (i=[0:ceil(len(arr)/2)-1]) arr[i]]);

//function rotarr(arr) = [for (i=[0:len(arr)-1]) arr[i]];
