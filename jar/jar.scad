
//translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
translate([0,0,110]) rotate([0,90,0]) brainL();
translate([0,0,110]) rotate([0,-90,0]) brainR();

color("#ccc8") render(convexity=5) glassjar();

cp = 60;

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
    odia = 190/2;
    thi = 4;
    tdia = 125/2+thi;
    top = 290;
    neck = 220;
    
    nbev = (odia-tdia);
    
    points = concat(
            circX(0, odia),
            circX(neck, odia),
            circX(neck+nbev, tdia),
            circX(top, tdia),
            circX(top, tdia-thi),
            circX(neck+nbev, tdia-thi),
            circX(neck, odia-thi),
            circX(thi, odia-thi)
        );
    //echo(points);
    faces = concat(
        //nbot(0),
        [for (l=[0:6]) each nquad(l)],
        //ntop(7),
        []
    );
    //echo(faces);
    polyhedron(convexity=5,
        points = points,
        faces = faces
    );
}

function circX(z, d) = [for (an=[360/cp:360/cp:360])
    [sin(an)*d, cos(an)*d, z]
];

function nquad(l) = [for (an=[0:cp-1]) each [
    [l*cp + an, l*cp + (an+1)%cp, (l+1)*cp + an],
    [(l+1)*cp + an, l*cp + (an+1)%cp, (l+1)*cp + (an+1)%cp]
]];

function ntop(l) = [[for (an=[0:cp-1]) l*cp+an]];
    
function nbot(l) = [[for (an=[cp-1:-1:0]) l*cp+an]];