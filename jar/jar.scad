doitem = "";

outer_dia = 188;
def_cp = 60;

choff = 1.5;

baseholes = [43,45,87,106];
capholes = [36,49,93,94];
cappins = [10,21,84,103];

if (doitem == "inner_base") { inner_base(cp=240); } 
if (doitem == "inner_cap") { rotate([180,0,45]) inner_cap(cp=240); } 
if (doitem == "") {
    //translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
    *translate([0,0,150]) rotate([0,90,0]) brainL();
    *translate([0,0,150]) rotate([0,-90,0]) brainR();

    *color("#68c") outer_base();

    color("#68c") inner_base(cp=60);
    color("#86c") inner_cap(cp=60);

    *color("#ccc8") render(convexity=5) glassjar();
}

module inner_base(cp=def_cp)
{
    jthi = 6;
    irad = outer_dia/2 - jthi;
    crad = 40;
    hei = 50;
    wad = 47.5;
    hmof = 10.4;

    hst = 5.8;

    drhei = 2;

    holes = [for (d=[crad+hst-2.1: hst: irad-hst/2])
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
                polygon(concat(
                    [for (an=[0:360/cp:90]) [sin(an)*irad, cos(an)*irad]],
                    [for (an=[90:-360/cp:0]) [sin(an)*crad, cos(an)*crad]]
                ));
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
            rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                // #translate([0,0,-14]) cylinder(3, 11, 11, $fn=cp);
                translate([-10.6,-11,-14]) cube([23.3,22,3]);
                // #translate([0,0,-14-wad]) cylinder(4, 5, 5, $fn=cp);
                intersection() {
                    translate([-12,-5,-14-wad]) cube([19, 10, 4]);
                    translate([-5,-5,-14-wad]) rotate([-45,0,0]) rotate([0,0,-64])
                        translate([-8.5,-2.0,0]) cube([20,12.0,20]);
                }
            }
            for (h=baseholes) {
                cwid = 5.8;
                chei = 6.5;
                d = holes[h][0];
                an = holes[h][1];
                rotate([0,0,an]) translate([d,0,hei-12]) difference() {
                    translate([-cwid/2,-chei/2,0]) cube([cwid,chei,12]);
                    translate([0,0,-0.01]) cylinder(12.02, 1.2, 1.2, $fn=cp/6);
                    translate([0,0,-0.01]) rotate([0,0,45]) cylinder(4, chei/sqrt(2)+0.1, 1.2, $fn=4);
                }
            }
        }
        rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
            translate([0,0,-12]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-11]) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 1, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-12-wad]) cylinder(wad + 0.1, 4, 4, $fn=cp);
        }
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

        rotate([0,0,29]) translate([crad-1,0,hei]) rotate([0,90,0]) {
            rotate([0,0,30]) cylinder(irad-crad-22, 3, 3, $fn=6);
        }
        *rotate([0,0,45]) translate([irad-2.2,0,hei/2]) rotate([0,90,0]) {
            rotate([0,0,0]) cylinder(5, 10*sqrt(2), 10*sqrt(2), $fn=4);
        }
    }
}

module inner_cap(cp=def_cp)
{
    bhei = 50;
    jthi = 6;
    irad = outer_dia/2 - jthi;
    crad = 40;
    hei = 2;
    wad = 50;
    hmof = 9.0; 

    hst = 5.8;

    caphi = 22-3;

    holes = [for (d=[crad+hst-2.1: hst: irad-hst/2])
        let(nstp = floor(d/(hst/1.5)),
            stp = (90-choff)/nstp,
            vst = d*3.141/nstp/2,
            fstp = floor(nstp/2),
            by = hst*0.5-0.25,
            bx1 = vst*0.5-0.5,
            bx2 = vst*0.5-0.1)
        for (an=[stp/2+choff/2-fstp*stp:stp:45-stp/2])
            [d, an, by, bx1, bx2]
    ];

    translate([0,0,50.1]) difference() {
        union() {
            difference() {
                union() {
                    linear_extrude(height=hei, convexity=20) {
                        polygon(concat(
                            [for (an=[45:360/cp:135]) [sin(an)*irad, cos(an)*irad]],
                            [for (an=[135:-360/cp:45]) [sin(an)*crad, cos(an)*crad]]
                        ));
                    }
                }
                for (h=[0:len(holes)-1]) {
                    if (len(search(h, capholes)) == 0) {
                        d = holes[h][0];
                        an = holes[h][1];
                        rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1, 3, $fn=cp/6);
                    }
                }
            }
            translate([0,0,-hei]) intersection() {
                rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([0,0,-caphi+10]) cylinder(caphi+10, 10, 10, $fn=cp);
                }
                translate([50,1,2*hei-30]) cube([50, 50, 30]);
            }
            for (h=cappins) {
                d = holes[h][0];
                an = holes[h][1];
                by = holes[h][2];
                bx1 = holes[h][3];
                bx2 = holes[h][4];
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
        for (h=capholes) {
            d = holes[h][0];
            an = holes[h][1];
            rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1.5, 1.5, $fn=cp/6);
        }
        rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, 0]) rotate([45,0,4]) {
            translate([0,0,-caphi+9.9]) cylinder(caphi+0.1, 7, 7, $fn=cp);
            translate([0,0,-22+10]) cylinder(4, 10.01, 10.01, $fn=cp);
            translate([0,-5,-8]) rotate([90,0,0]) cylinder(5, 4, 4, $fn=cp);
        }
    }
}

module outer_base()
{
    thick = 30;
    irad = outer_dia/2;
    orad = irad+thick;
    stp = 12;
    thei = 35;
    bot = 15;
    bthi = 3;

    difference() {
        polyhedron(points = concat(
                circX(-bot, orad+1.5, 0, stp),
                circX(thei-bot, orad, 0.5, stp),
                circX(thei*2-bot, irad+20, 1, stp),
                circX(thei*3.15-bot, irad, 1.5, stp)
            ), faces = concat(
                nbot(0,stp),
                [for (l=[0:2]) each nquad(l, stp)],
                ntop(3,stp)
            )
        );
        translate([0,0,-bthi]) cylinder(thei*3.15-bot+0.01+bthi, irad, irad, $fn=def_cp);
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

function circX(z, d, of=0, cp=def_cp) = [for (an=[of*(360/cp):360/cp:(cp+of-1)*(360/cp)])
    [sin(an)*d, cos(an)*d, z]
];

function nquad(l, cp=def_cp) = [for (an=[0:cp-1]) each [
    [l*cp + an, l*cp + (an+1)%cp, (l+1)*cp + an],
    [(l+1)*cp + an, l*cp + (an+1)%cp, (l+1)*cp + (an+1)%cp]
]];

function ntop(l,cp=def_cp) = [[for (an=[0:cp-1]) l*cp+an]];
    
function nbot(l,cp=def_cp) = [[for (an=[cp-1:-1:0]) l*cp+an]];
