
//translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
*translate([0,0,150]) rotate([0,90,0]) brainL();
*translate([0,0,150]) rotate([0,-90,0]) brainR();

*color("#68c") outer_base();

color("#68c") inner_base(cp=240);

*color("#ccc8") render(convexity=5) glassjar();

outer_dia = 190;

def_cp = 60;

module inner_base(cp=def_cp)
{
    jthi = 5;
    irad = outer_dia/2 - jthi;
    crad = 40;
    hei = 50;
    wad = 50;
    hmof = 10.4;

    hst = 6;

    difference() {
        union() {
            linear_extrude(height=hei, convexity=20) difference() {
                polygon(concat(
                    [for (an=[0:360/cp:90]) [sin(an)*irad, cos(an)*irad]],
                    [for (an=[90:-360/cp:0]) [sin(an)*crad, cos(an)*crad]]
                ));
                for (d=[crad+hst-2.2: hst: irad-hst/2]) {
                    nstp = floor(d/(hst/1.5));
                    stp = 89.5/nstp;
                    for (an=[stp/2+0.25:stp:90-stp/2]) {
                        rotate([0,0,an]) translate([d,0,0]) rotate([0,0,45]) circle((hst*0.6), $fn=4);
                    }
                }
            }
            rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,2]) {
                translate([0,0,-14]) cylinder(3, 11, 11, $fn=cp);
                translate([0,0,-14-wad]) cylinder(4, 5, 5, $fn=cp);
            }
        }
        rotate([0,0,20]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,2]) {
            translate([0,0,-12]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-11]) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 1, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-12-wad]) cylinder(wad + 0.1, 4, 4, $fn=cp);
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