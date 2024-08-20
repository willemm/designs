
grille();

module grille()
{
    lcp = 60;
    cp = 60;
    width = 580;
    height = 300;
    dia = 200;
    thick = 3.0;

    backoff = 60;

    trirad = 10;
    triinr = 5;
    inof = 32;

    tritop = 250;
    tribot = 100;

    trislopeang = atan((tritop-tribot) / height);

    holeoff = [-30, dia/2+10, 0];


    ssteps = ceil(cp/2);

    sa = 360/cp;
    slopeang = 180-atan((height-2*trirad)/((width-2*trirad)/2));
    flang1 = floor(slopeang/sa)*sa;
    clang = flang1 + sa;

    sidecnt = cp+5 - ((flang1 == slopeang) ? 2 : 0)+3*(ssteps*2);
    flang = flang1 - ((flang1 == slopeang) ? sa : 0);
    angs = [
        concat([for (an=[0:sa:flang]) an],[slopeang]),
        concat([slopeang], [for (an=[clang:sa:360-clang]) an], [360-slopeang]),
        concat([360-slopeang], [for (an=[360-flang:sa:360]) an]),
        ];

    cangs = [slopeang/2, 180, 360-slopeang/2];
    corners = [[width/2-trirad, trirad, 0], [0, (height-trirad), 0], [-(width/2-trirad), trirad, 0]];
    cornersof = [for (sd=[0:2]) corners[sd]-[inof*sin(cangs[sd]), -inof*cos(cangs[sd]), 0]];
    //cornerssl = [for (sd=[0:2]) corners[sd]-[(inof-triinr-0.1)*sin(cangs[sd]), -(inof-triinr-0.1)*cos(cangs[sd]), 0]];
    //*#polyhedron(points=slopey(tribot, tritop, height, cornerssl), faces=[[0,1,2]]);

    /*
    translate([holeoff.x,holeoff.y,-60]) linear_extrude(height=60, convexity=6) difference() {
        circle(dia/2, $fn=sidecnt);
        circle(dia/2-thick, $fn=sidecnt);
    }
    */

    spoints = concat(
        [for (sd=[0:2]) each concat(
            interline(angs, corners, trirad, sd, ssteps*2, ssteps, ssteps*2-1),
            [for (an=angs[sd])
                corners[sd]+[sin(an)*trirad, -cos(an)*trirad, 0]
            ],
            interline(angs, corners, trirad, sd+1, ssteps*2, 0, ssteps-1)
        )],
        slopey(tribot, tritop, height, concat(
            [for (sd=[0:2]) each concat(
                interline(angs, corners, trirad, sd, ssteps*2, ssteps, ssteps*2-1),
                [for (an=angs[sd])
                    corners[sd]+[sin(an)*trirad, -cos(an)*trirad, 0]
                ],
                interline(angs, corners, trirad, sd+1, ssteps*2, 0, ssteps-1)
            )],
            [for (sd=[0:2]) each concat(
                interline(angs, cornersof, triinr, sd, ssteps*2, ssteps, ssteps*2-1),
                [for (an=angs[sd])
                    cornersof[sd]+[sin(an)*triinr, -cos(an)*triinr, 0]
                ],
                interline(angs, cornersof, triinr, sd+1, ssteps*2, 0, ssteps-1)
            )]
        )),
        /*
        [for (sd=[0:2]) each [for (an=angs[sd])
            cornersof[sd]+[sin(an)*triinr, -cos(an)*triinr, 0]
        ]],
        */
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick), holeoff.y-cos(an)*(dia/2-thick), 0]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2-thick), holeoff.y-cos(an)*(dia/2-thick), -backoff]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2), holeoff.y-cos(an)*(dia/2), -backoff]],
        [for (an=[0:(360/sidecnt):360-(360/sidecnt)]) [holeoff.x+sin(an)*(dia/2), holeoff.y-cos(an)*(dia/2), 0]],

        []
    );
    rotate([180-trislopeang, 0, 0]) {
        polyhedron(convexity=8,
            points=spoints,
            faces=concat(
                nquads(0, sidecnt, sidecnt, 0),
                nquads(sidecnt, sidecnt, sidecnt, 0),
                nquads(sidecnt*2, sidecnt, sidecnt, 0),
                nquads(sidecnt*3, sidecnt, sidecnt, 0),
                nquads(sidecnt*4, sidecnt, sidecnt, 0),
                nquads(sidecnt*5, sidecnt, sidecnt, 0),
                nquads(sidecnt*6, sidecnt, -sidecnt*6, 0),
                []
        ));

        slats(corners, 20, 0.4, 2.0, tribot, tritop, height);
    }
}

module slats(corners, num, so, eo, tribot, tritop, height, thick=3, ang=20)
{
    // Calculate factor for desired y thickness
    toff = thick/(corners[1].y-corners[0].y)/2;
    for (sl=[1:num-1]) {
        fact = (sl+so)/(num+so+eo);
        fact2 = fact+((1.5-(sl*2.0/num))/num);
        pts = concat(
            slopey(tribot-50, tritop-100, height, [
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
function interline(angs, corners, rd, sd, ssteps, from, to) = 
    let( an = angs[sd%3][0],
        pt1 = corners[(sd+2)%3]+[sin(an)*rd, -cos(an)*rd, 0],
        pt2 = corners[ sd   %3]+[sin(an)*rd, -cos(an)*rd, 0]) [
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

color("#5954") translate([200,-90,-90]) cube([210,250,2],true);
color("#9554") translate([0,-90,-90]) cube([210,250,2],true);
color("#5594") translate([-200,-90,-90]) cube([210,250,2],true);
color("#5954") translate([-100,-300,-90]) cube([250,210,2],true);
color("#5594") translate([100,-300,-90]) cube([250,210,2],true);
