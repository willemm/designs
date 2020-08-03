s3=sqrt(3);
tol=0.1;

lips = false;

lipthick = 1;
lipball = 1;
lipballoff = 0.2;
lipwidth = 5;
numlip = 3;
lipstr = -0.3;
lipoff = 4.5;
lipin = 1;

pinhi=16;

thick = 1.6;
side = 240;  // Edge length

wid = side/s3;  // Radius of face triangles
off = side*s3*(3+sqrt(5))/12;  // Distance of faces from center

eoff = side*(1+sqrt(5))/4;

lipheight = lipwidth * 2 * (off/wid);

tran = atan(wid/off);  // Angle between point and center of triange as seen from d20 center
dihed = acos(-sqrt(5)/3);  // Dihedral angle
edgean = atan((wid/2)/off);  // Angle offset of edge
edgesan = atan((side/2)/eoff);  // Angle offset of other edge

lipins = lipin * 0.75;

txtfont = "Calibri:style=Bold";
txtsize = side/3;
txtt = 1;

dodigit=0;
doedge=0;
if (dodigit) {
    dig = dodigit==6?" 6.":dodigit==9?" 9.":str(dodigit);
    rotate([180,0,0]) translate([0,0,-off]) triangleside(dig);
} else if (doedge) {
    rotate([90,0,0]) edge(doedge==2);
} else {
    d20();
    *rotate([180,0,0]) translate([0,0,-off]) triangleside("16");
    *rotate([90,0,0]) edge();
}

module d20()
{
    color("gray") for (a=[360/5:360/5:360]) {
        rotate([tran,0,a]) triangleside();
        rotate([dihed-tran,180,a]) triangleside();
        *rotate([180+tran,0,a]) triangleside();
        *rotate([180+dihed-tran,180,a]) triangleside();
    }
    color("orange") for (a=[360/5:360/5:360]) {
        rotate([tran+edgean,0,a]) edge(a==360);
        rotate([0,edgesan,a+90]) edge(a==360);
    }
}

module edge(top=false, l=side - 2*(off/wid)-25, w=8, o=eoff-2.7, t=2)
{
    translate([0,0,o-t/2]) difference() {
        cube([l,w,2], true);
        for (n=[0:numlip-1]) {
            no = (n-(numlip/2-0.5));
            translate([no*side/(numlip+lipstr)-lipoff,-lipins,0])
             rotate([edgean,0,0]) cube([5.2,2.4,5],true);
            translate([no*side/(numlip+lipstr)+lipoff,lipins,0])
             rotate([-edgean,0,0]) cube([5.2,2.4,5],true);
        }
    }
    for (n=[0:numlip-1]) {
        no = (n-(numlip/2-0.5));
        translate([no*side/(numlip+lipstr)+lipoff,0,o])
         pinlip(t=w);
        translate([no*side/(numlip+lipstr)-lipoff,0,o])
         pinlip(t=w);
    }
    if (top) {
        translate([0,0,o-t/2-13]) cube([l,w,2], true);
        for (n=[-5:2:5]) {
            translate([n*((l-2)/10),0,o-t/2-6]) cube([2,w,13], true);
        }
    }
}

module pinlip(t=14, w=1, pw=5.2, h=(pinhi*0.915)-4, no=1)
{
    n = no*0.97;
    rotate([-90,0,0]) translate([-pw/2,0,-t/2]) 
    linear_extrude(height=t) polygon([
        [-w,0],[-w,h],[0,h+n],[no,h],[0,h-n],[0,0]
    ]);
    rotate([-90,0,180]) translate([-pw/2,0,-t/2]) 
    linear_extrude(height=t) polygon([
        [-w,0],[-w,h],[0,h+n],[no,h],[0,h-n],[0,0]
    ]);
}

module triangleside(txt="", w=wid, t=thick, o=off+tol, bt = 2.5)
{
    sds = 3;
    difference() {
        polyhedron(
            points = concat(
                triangle(w-(wid/off+off*4/wid)*bt,o),
                //triangle(w-6,o-t),
                triangle(w-(wid/off)*bt, o-bt),
                // triangle(w, o),
                triangle(w+(wid/off)*t, o+t)
            ),
            faces=concat(
                ntopsd(3,0),
                nquads(3,0),
                nquads(3,3),
                nbotsd(3,6)
            ), convexity=6
        );
        translate([0,-w/20,o+t-txtt]) linear_extrude(height=t)
         offset(r=6) offset(r=-4) text(text=txt, size=txtsize, font=txtfont,
            halign="center",valign="center");
    }

    if (lips) {
        // Connectors
        for (a=[120:120:360]) {
            rotate([0,0,a])
            for (n=[0:numlip-1]) {
                no = (n-(numlip/2-0.5));
                flip = ((n+(no > 0 ? 1 : 0))%2);
                translate([no*side/(numlip+lipstr),-w/2,o])
                 lip(flip, no);
            }
        }
    } else {
        // Connectors
        for (a=[120:120:360]) {
            rotate([0,0,a])
            for (n=[0:numlip-1]) {
                no = (n-(numlip/2-0.5));
                translate([no*side/(numlip+lipstr)+lipoff,-w/2,o])
                 pin();
            }
        }
    }
}

module pin(t=2, w=5, h=pinhi, n=1, sk = off/wid)
{
    polyhedron(
        points=concat(
            pinpoints(w/2,h,n,0,lipin),
            pinpoints(w/2,h,n,t*(wid/off)/2,lipin+t)
        ),
        faces = concat(
            ntopsd(10,0),
            nquads(10,0),
            nbotsd(10,10)
        ), convexity=6);
}

function pinpoints(w,h,n,o,t) = [
    [w,t,0],[w,t,o-h+n*3],[w-n,t,o-h+n*2],
    [w,t,o-h+n],[w-n,t,o-h],
    [-w+n,t,o-h],[-w,t,o-h+n],
    [-w+n,t,o-h+n*2],[-w,t,o-h+n*3],[-w,t,0]
];


module lip(flip=0,n=0,w=lipwidth,t=lipthick,h=lipheight,bt=lipball,bo=lipballoff,o=tol)
{
    bo2 = t + (t-bo);
    translate([(t+o)/2-(t+o)*flip,w/2,-h/2]) difference() {
        union() {
            rotate([0,90,0]) translate([0,0,-t/2])
            linear_extrude(height=t)
            polygon([[0,-w/2],[-h/2,-w/2],[-h/2,w*1.6],[w/2.7,w/3]]);
            //translate([0,0,h/4]) cube([t,w,h/2], true);
            rotate([0,90,0]) cylinder(t, w/2, w/2, true, $fn=30);
            if (n>0) {
                difference() {
                    translate([flip*bo-bo/2,0,0])
                    rotate([0,90,0]) sphere(bt, $fn=30);
                    translate([(t-o)-(t-o)*flip*2,0,0])
                    cube([t,bt*2,bt*2], true);
                }
            }
        }
        if (n<0) {
            translate([flip*bo2-bo2/2,0,0])
            rotate([0,90,0]) sphere(bt+o, $fn=30);
        }
    }
}

function triangle(w,h) = concat(
    [for (a = [360:-120:120])
        [w*sin(a), w*cos(a), h]]
);

function nquads(n,o) = [for (i=[0:n-1]) [(i+1)%n+o,i+o,i+o+n,(i+1)%n+o+n]];

function ntopsd(n,o) = [[for (i=[0:n-1]) (i+o)]];
function nbotsd(n,o) = [[for (i=[n-1:-1:0]) (i+o)]];
