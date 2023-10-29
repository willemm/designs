doitem = "";

outer_dia = 188;
def_cp = 60;

choff = 1.5;
hmof = 10.4;
holeof = 2.2;

baseholes = [39,42,81,99];
capholes = [33,44,86,87];
cappins = [10,19,78,95];

humidang = 20;

if (doitem == "inner_base") { inner_base(cp=240); } 
if (doitem == "inner_cap") { rotate([180,0,45]) inner_cap(cp=240); } 
if (doitem == "") {
    //translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
    *translate([0,0,160]) rotate([0,90,0]) brainL();
    *translate([0,0,160]) rotate([0,-90,0]) brainR();

    color("#6c8") outer_base();

    color("#68c") inner_base(cp=60, solid=true);
    *color("#86c") inner_cap(cp=60);
    *#rotate([0,0,90]) {
        color("#68c") inner_base(cp=60);
        color("#86c") inner_cap(cp=60);
    }
    *rotate([0,0,180]) {
        color("#68c") inner_base(cp=60);
        color("#86c") inner_cap(cp=60);
    }

    *color("#ccc8") render(convexity=5) glassjar();

    *color("#5954") translate([20,50,-26.2]) cube([250,200,2],true);
}

module outer_base(cp=def_cp)
{
    thick = 20;
    irad = outer_dia/2;
    orad = irad+thick;
    numedg = 12;
    stp = 32;
    bot = 25;
    bthi = 3;

    difference() {
        circles = generate_facet_circles(numedg, stp, orad, -bot, 30, 6);

        polyhedron(convexity=10
            , points = concat([for (circ=circles) each circX(circ[0], circ[1], circ[3], numedg) ],
                [[0, 0, bot+10]])
            , faces = concat(
                nbot(0,numedg),
                [for (l=[0:len(circles)-3]) each nquad(l, numedg)],
                [let (ci=numedg*(len(circles)-2), cc=numedg*len(circles))
                 for (l=[0:numedg-1]) each [
                     [ci+l, ci+(l+1)%numedg, ci+l+numedg],
                     [ci+l, ci+l+numedg, cc],
                     [ci+(l+1)%numedg, cc, ci+l+numedg]
                     ]]
            )
        );
        translate([0,0,-bthi]) cylinder(circles[len(circles)-1][0]+0.01+bthi, irad, irad, $fn=cp);
        #for (c=[1,2,3]) {
            circ = circles[c];
            for (an=[circ[3]*(360/numedg):360/numedg:(numedg+circ[3]-1)*(360/numedg)]) {
                rotate ([0,0,an+(360/numedg/2)]) {
                    translate([circ[1]*cos(360/numedg/2), 0, circ[0]]) rotate([0,270+circ[2],0])
                        translate([0,0,-0.01]) cylinder(33,3,3,$fn=cp/3);
                }
            }
        }
    }
}

module inner_base(cp=def_cp, solid=false)
{
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 50;
    wad = 47.5;

    hst = 5.8;

    drhei = 2;

    holes = [for (d=[crad+hst-holeof: hst: irad-hst/2])
        let(nstp = floor(d/(hst/1.5)),
            stp = (90-choff)/nstp,
            vst = d*3.141/nstp/2,
            by = hst*0.5-0.25,
            bx1 = vst*0.5-0.5,
            bx2 = vst*0.5-0.1)
        for (an=[stp/2+choff/2:stp:90-stp/2])
            [d, an, by, bx1, bx2]
    ];
    difference() {
        union() {
            linear_extrude(height=hei, convexity=20) difference() {
                // Quarter circle block
                polygon(concat(
                    [for (an=[0:360/cp:90]) [sin(an)*irad, cos(an)*irad]],
                    [for (an=[90:-360/cp:0]) [sin(an)*crad, cos(an)*crad]]
                ));
                if (!solid) {
                    // Square holes in block
                    for (hole=holes) {
                        d = hole[0];
                        an = hole[1];
                        by = hole[2];
                        bx1 = hole[3];
                        bx2 = hole[4];
                        rotate([0,0,an]) translate([d,0,0]) polygon([
                            [-by, -bx1], [ by, -bx2],
                            [ by,  bx2], [-by,  bx1]
                        ]);
                    }
                }
            }
            if (!solid) {
            // Upper block for humidifier element
            intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([-12,-11,-14]) cube([26,22,3]);
                }
                linear_extrude(height=hei, convexity=20)
                    polygon(concat(
                        [for (an=[0:360/cp:90]) [sin(an)*(irad-0.1), cos(an)*(irad-0.1)]],
                        [for (an=[90:-360/cp:0]) [sin(an)*(crad+hst*4.5-holeof), cos(an)*(crad+hst*4.5-holeof)]]
                    ));
            }
            // Lower block for cotton wad
            intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([-13,-5,-14-wad]) cube([21, 10, 4]);
                }
                linear_extrude(height=hei, convexity=20)
                    polygon(concat(
                        [for (an=[0:360/cp:90]) [sin(an)*(irad-0.1), cos(an)*(irad-0.1)]],
                        [for (an=[90:-360/cp:0]) [sin(an)*(crad+hst*6.5-holeof), cos(an)*(crad+hst*6.5-holeof)]]
                    ));

            }
            // Screw hole inserts
            for (h=baseholes) {
                cwid = 5.8;
                chei = 6.5;
                d = holes[h][0];
                an = holes[h][1];
                rotate([0,0,an]) translate([d,0,hei-12]) difference() {
                    translate([-cwid/2,-chei/2,0]) cube([cwid,chei,12]);
                    translate([0,0,-0.01]) cylinder(12.02, 1.3, 1.3, $fn=cp/6);
                    translate([0,0,-0.01]) rotate([0,0,45]) cylinder(4, chei/sqrt(2)+0.1, 1.2, $fn=4);
                }
            }
            }
        }
        // Cutouts for humidifier element
        rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
            translate([0,0,-12]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-11]) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 1, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-12-wad]) cylinder(wad + 0.1, 4, 4, $fn=cp);
        }
        if (!solid) {
        // Holes at bottom for water flow
        for (d=[crad+hst-2.2: hst: irad-hst/2]) {
            nstp = floor(d/(hst/1.5));
            stp = (90-choff)/nstp;
            for (an=[stp/2+(choff/2)-stp/2:stp:90]) {
                rotate([0,0,an]) translate([d,0,drhei]) rotate([90,0,0])
                    translate([0, 0, -hst*0.2]) cylinder(hst*0.4, 1, 1, $fn=4);
            }
        }
        rotate([0,0,0]) translate([crad-1,hst/2+0.5,drhei]) rotate([0,90,0])
            cylinder(irad-crad-2, 1, 1, $fn=4);
        rotate([0,0,90]) translate([crad-1,-hst/2-0.5,drhei]) rotate([0,90,0])
            cylinder(irad-crad-2, 1, 1, $fn=4);

        }
        // Cutout for humidifier cable
        rotate([0,0,29]) translate([crad-1,0,hei]) rotate([0,90,0]) {
            rotate([0,0,30]) cylinder(irad-crad-22, 3, 3, $fn=6);
        }
    }
}

module inner_cap(cp=def_cp)
{
    bhei = 50;
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 2;
    wad = 50;

    hst = 5.8;

    caphi = 22-3;

    holes = [for (d=[crad+hst-holeof: hst: irad-hst/2])
        let(nstp = floor(d/(hst/1.5)),
            stp = (90-choff)/nstp,
            vst = d*3.141/nstp/2,
            fstp = floor(nstp/2),
            by = hst*0.5-0.25,
            bx1 = vst*0.5-0.5,
            bx2 = vst*0.5-0.1)
        for (an=[stp/2-choff/2-fstp*stp:stp:45-stp/2])
            [d, an+(an > 0 ? choff : 0), by, bx1, bx2]
    ];

    translate([0,0,50.1]) difference() {
        union() {
            difference() {
                // Quarter circle plate
                union() {
                    linear_extrude(height=hei, convexity=20) {
                        polygon(concat(
                            [for (an=[45:360/cp:135]) [sin(an)*irad, cos(an)*irad]],
                            [for (an=[135:-360/cp:45]) [sin(an)*crad, cos(an)*crad]]
                        ));
                    }
                }
                // Water holes
                for (h=[0:len(holes)-1]) {
                    if (len(search(h, capholes)) == 0) {
                        d = holes[h][0];
                        an = holes[h][1];
                        rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1, 2.9, $fn=cp/6);
                    }
                }
            }
            // Extrusion to hold humidifier
            translate([0,0,-hei]) intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([0,0,-caphi+10]) cylinder(caphi+10, 10, 10, $fn=cp);
                }
                translate([50,1,2*hei-30]) cube([50, 50, 30]);
            }
            // Extrusions that fit in base holes
            for (h=cappins) {
                d = holes[h][0];
                an = holes[h][1];
                by = holes[h][2]-0.2;
                bx1 = holes[h][3]-0.2;
                bx2 = holes[h][4]-0.2;
                iy = by-0.5;
                ix1 = bx1-0.5;
                ix2 = bx2-0.5;
                rotate([0,0,an]) translate([d,0,-5])
                    linear_extrude(height=5, convexity=10) polygon(
                    points=[ 
                        [-by, -bx1], [ by, -bx2],
                        [ by,  bx2], [-by,  bx1],
                        [-iy, -ix1], [ iy, -ix2],
                        [ iy,  ix2], [-iy,  ix1],
                    ],
                    paths=[[0,1,2,3],[4,5,6,7]]
                );
            }
        }
        // Screw holes
        for (h=capholes) {
            d = holes[h][0];
            an = holes[h][1];
            rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1.6, 1.6, $fn=cp/6);
        }
        // Hole for humidifier
        rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, 0]) rotate([45,0,4]) {
            translate([0,0,-caphi+9.9]) cylinder(caphi+0.1, 7, 7, $fn=cp);
            translate([0,0,-22+10]) cylinder(4, 10.01, 10.01, $fn=cp);
            translate([0,-5,-8]) rotate([90,0,0]) cylinder(5, 4, 4, $fn=cp);
        }
    }
}

module humid_disc(cp=def_cp)
{
    cylinder(3, 20, 20, $fn=cp);

}

module brain()
{
    render(convexity=5) scale(4.95) import("brain.stl");
}

module brainL()
{
    translate([-110, -150, 0]) import("brain A.stl", convexity=5);
}

module brainR()
{
    rotate([0,0,180]) translate([-224, -200, 0]) import("brain B.stl", convexity=5);
}

module glassjar()
{
    orad = outer_dia/2-1;
    thi = 2;
    trad = 136/2+thi;
    top = 290;
    neck = 220;
    
    nbev = (orad-trad);
    
    points = concat(
            circX(0, orad),
            circX(neck, orad),
            circX(neck+nbev, trad),
            circX(top, trad),
            circX(top, trad-thi),
            circX(neck+nbev, trad-thi),
            circX(neck, orad-thi),
            circX(thi, orad-thi)
        );
    //echo(points);
    faces = concat(
        nbot(0),
        [for (l=[0:6]) each nquad(l)],
        ntop(7),
        []
    );
    //echo(faces);
    polyhedron(convexity=5,
        points = points,
        faces = faces
    );
}

// Generate diamond facets going up and inward from a cerrain radius
function generate_facet_circles(numedg, stp, rad, hei, an, num) = (num <= 0) ? [] : let(
    rad1 = cos(360/numedg/2)*rad+stp*sin(an),
    hei1 = hei + stp*cos(an),
    an1 = atan((cos(360/numedg/2)*rad1-rad) / (hei1-hei))
) concat(
    [[hei, rad, an, -num/2]],
    generate_facet_circles(numedg, stp, rad1, hei1, an1, num-1)
);

function circX(z, d, of=0, cp=def_cp) = [for (an=[of*(360/cp):360/cp:(cp+of-1)*(360/cp)])
    [sin(an)*d, cos(an)*d, z]
];

function nquad(l, cp=def_cp) = [for (an=[0:cp-1]) each [
    [l*cp + an, l*cp + (an+1)%cp, (l+1)*cp + an],
    [(l+1)*cp + an, l*cp + (an+1)%cp, (l+1)*cp + (an+1)%cp]
]];

function ntop(l,cp=def_cp) = [[for (an=[0:cp-1]) l*cp+an]];
    
function nbot(l,cp=def_cp) = [[for (an=[cp-1:-1:0]) l*cp+an]];
