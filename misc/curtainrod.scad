
dia = 21;

scrd = 3.5;
scrl = 25;

scran = 45;

fn = 120;
stp = 360/fn;

clanex = 30;
slanex = -15;
sdanex = -0;

clan = (stp*floor(clanex/stp));
slan = (stp*floor(slanex/stp));
sdan = (stp*floor(sdanex/stp));
holder();

*translate([0,0,2]) color("#4443") rod();
*rotate([0,0, scran]) color("#6663") screw();
*rotate([0,0,-scran]) color("#6663") screw();

module rod(dia = dia, len=100)
{
    cylinder(len, dia/2, dia/2, $fn = fn);
}

module screw(dia = dia, scrd=scrd, len=scrl)
{
    render(convexity=10) {
        translate([0,dia/2+5,-len+10.2+2]) cylinder(len, scrd/2, scrd/2, $fn = fn);
        translate([0,dia/2+5,10.2]) cylinder(2, scrd/2, 2*(scrd/2), $fn = fn);
    }
}

module holder(dia = dia, base=2, thi=10, wid=10, off=0.2, scrd=scrd)
{
    ird = dia/2+off;
    ord = dia/2+wid;

    scroff = dia/2+wid/2;

    clrd = 10;
    crd = 1;
    clrdi = clrd-2*crd;

    clanc2 = [ sin(90+clan)*(ird+clrd), cos(90+clan)*(ird+clrd) ];
    clanp2 = clanc2 + [ sin(270)*(clrd-crd), cos(270)*(clrd-crd) ];

    scrp2 = [ sin(90-scran)*scroff, cos(90-scran)*scroff ];

    scrofd = wid/2;

    difference() {
        union() {
            linear_extrude(height = base, convexity=6) polygon(concat(
                [for (an = [-90-slan:stp: 90+slan]) ird*sc(an)],
                [for (an = [ 90+slan:stp:270-slan]) (ird-off)*sc(an)],
                []
            ));
            linear_extrude(height = thi+base, convexity=6) polygon(dupl_mirror(concat(
                [for (an = [0:stp:90+clan]) ird*sc(an) ],
                [for (an = [270+clan:-stp:270]) clanc2+clrd*sc(an) ],
                [for (an = [270:-stp:90]) clanp2+crd*sc(an) ],
                [for (an = [270:stp:270+clan]) clanc2+clrdi*sc(an) ],
                bezier([
                    clanc2+clrdi*sc(270+clan),
                    clanc2+clrdi*sc(270+clan)+5*sc(270+clan+90),
                    scrp2+scrofd*sc(90-sdan)+5*sc(90-sdan+90),
                    scrp2+scrofd*sc(90-sdan)
                    ], fn/6),
                [for (an = [90-sdan:-stp: 90-scran]) scrp2+scrofd*sc(an) ],
                [for (an = [90-scran:-stp: 0]) ord*sc(an) ],
                []
            )));
        }
        *translate([0,0,-base]) cylinder(thi+base, dia/2+wid, dia/2+wid, $fn = fn);
        *cylinder(thi+0.01, dia/2+off, dia/2+off, $fn = fn);
        rotate([0,0,scran]) {
            translate([0,scroff,-0.01]) cylinder(base+thi+0.02, scrd/2+off, scrd/2+off, $fn = fn);
            translate([0,scroff,thi+base-2]) cylinder(2+0.02, scrd/2+off, 2*(scrd/2)+off, $fn = fn);
        }
        rotate([0,0,-scran]) {
            translate([0,scroff,-0.01]) cylinder(base+thi+0.02, scrd/2+off, scrd/2+off, $fn = fn);
            translate([0,scroff,thi+base-2]) cylinder(2+0.02, scrd/2+off, 2*(scrd/2)+off, $fn = fn);
        }

    }
}

function dupl_mirror(pts) = concat(pts, [for (i=[len(pts)-2:-1:1]) [-pts[i].x, pts[i].y]]);

function sc(an) = [sin(an),cos(an)];

// Interpolate each point of a list with the next
function interpts(pts, t) = [for (i = [0:len(pts)-2]) pts[i]*(1-t)+pts[i+1]*t];

// Calculate one bezier point recursively
function bezierpt(pts, t) = len(pts) == 1 ? pts : bezierpt(interpts(pts, t), t);

// Assumes an1 and an2 are divisible by stp
function bezier(pts, fn=fn) = [for (t = [0:1/fn:1]) each bezierpt(pts, t)];
