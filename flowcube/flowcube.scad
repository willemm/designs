
// Holes in perfboard
// holesp = 2.54;
holesp = 2.54;
holedia = 1;
boardth = 1.2;

ledsp = holesp * 4;
ledz = boardth+0.5;

butsp = holesp * 12;

for (x=[0:3], y=[0:3]) {
    translate([(x+0.5)*butsp, (y+0.5)*butsp, 0]) buttonset();
}

color("#a85") perfboard(47, 47);

color("#eee") translate([0,0,10]) perfboard(4, 4, 1, holesp * 12, holesp * 8, 0.5, 64);

color("#333") translate([0,0,11]) {
    difference() {
        perfboard(4, 4, 0.6, holesp * 12, holesp * 8, 0.5, 64);
        for (x=[0:3]) {
            translate([(x+0.5)*holesp*12, 24*holesp, 0.5]) cube([10,48*holesp+0.01,1.01], true);
        }
        for (y=[0:3]) {
            translate([24*holesp, (y+0.5)*holesp*12, 0.5]) cube([48*holesp+0.01,10,1.01], true);
        }
    }
}

module buttonset()
{
    color("#acf") translate([0, 0, ledz]) switch();
    color("#767") translate([-ledsp, 0, ledz]) wsled();
    color("#767") translate([ ledsp, 0, ledz]) wsled();
    color("#767") translate([0, -ledsp, ledz]) wsled();
    color("#767") translate([0,  ledsp, ledz]) wsled();
}

module switch()
{
    swsz = 8;
    swhi = 5;
    stemw = 3;
    stemh = 3.6;
    stemhi = 10;
    translate([0,0,swhi/2])   cube([swsz, swsz, swhi], true);
    translate([0,0,stemhi/2]) cube([stemw, stemh, stemhi], true);
}

module wsled()
{
    wsdia = 9/2;
    wssz = 4.9;
    wsbt = 1.6;
    wsthi = 3.2;
    translate([0,0,wsthi/2]) cube([wssz, wssz, wsthi], true);
    cylinder(wsbt, wsdia, wsdia, $fn=64);
}


module perfboard(w,h, thi=boardth, hsp = holesp, hdi = holedia, eof=1, cp=16)
{
    wid = hsp * (w-1+eof*2);
    hei = hsp * (h-1+eof*2);
    hr = hdi/2;

    an = 360/cp;
    lo = 2*(w+h+2);
    l2 = lo + cp*w*h;
    lo2 = l2+lo;
    points = concat(
        ssquare(wid,hei,w+1,h+1,0),
        [for (x=[0:w-1], y=[0:h-1]) each circle((x+eof)*hsp, (y+eof)*hsp, 0, hr, an)],
        ssquare(wid,hei,w+1,h+1,thi),
        [for (x=[0:w-1], y=[0:h-1]) each circle((x+eof)*hsp, (y+eof)*hsp, thi, hr, an)]
    );
    polyhedron(points = points, faces = concat(
        // [[0,1,2,3],[l2+3,l2+2,l2+1,l2+0]],
        nquads(0, lo, l2), // Outside
        [for (p=[lo:cp:l2-1]) each nquads(p, cp, l2)], // Hole insides

        // Front face between holes
        [for (x=[0:w-2], y=[0:h-1]) each 
            fquads(cp, lo+cp*(y+h*x), lo+cp*(y+h*(x+1)), 0, 0, cp*0.5)],
        // Back face between holes
        [for (x=[0:w-2], y=[0:h-1]) each 
            bquads(cp, lo2+cp*(y+h*x), lo2+cp*(y+h*(x+1)), 0, 0, cp*0.5)],

        // Front face between hole sides
        fhquads(lo,  cp, w, h),
        bhquads(lo2, cp, w, h),

        // Front face between holes, vertical
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*0), lo+cp*(y+1+h*0), cp*0.75, cp*0.75, cp*0.25)],
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*(w-1)), lo+cp*(y+1+h*(w-1)), 0, cp*0.5, cp*0.25)],

        // Back face between holes, vertical
        [for (y=[0:h-2]) each
            bquads(cp, lo2+cp*(y+h*0), lo2+cp*(y+1+h*0), cp*0.75, cp*0.75, cp*0.25)],
        [for (y=[0:h-2]) each
            bquads(cp, lo2+cp*(y+h*(w-1)), lo2+cp*(y+1+h*(w-1)), 0, cp*0.5, cp*0.25)],

        fsquads(0 , cp, w, h),
        bsquads(l2, cp, w, h),

        fcornerdart(0,  cp, w, h),
        bcornerdart(l2, cp, w, h),
        []
    ));
}

// Square with multiple points on sides
// width, height, side steps, z coord
function ssquare(w,h,ws,hs,z) = concat(
    [for (i=[0:ws-1])  [i*(w/ws),0,z]],
    [for (i=[0:hs-1])  [w,i*(h/hs),z]],
    [for (i=[ws:-1:1]) [i*(w/ws),h,z]],
    [for (i=[hs:-1:1]) [0,i*(h/hs),z]]
);

function circle(x,y,z,d,an) = [
    for (a = [0:an:360-an]) [x+d*sin(a),y+d*cos(a),z]
];

// Faces of side of layers
// start offset, number, layer offset
function nquads(s, n, o) = [for (i=[0:n-1]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

// Faces, between holes (sets)
// set size, set 1 offset, set 2 offset, start 1, start 2, size, direction
function fquads(ss, o1, o2, s1, s2, sz, di=0) = [for (i=[0:sz-1]) each [
    [o1+(s1+i+di)%ss, o1+(s1+i+1-di)%ss, o2+(s2+ss-i-1+di)%ss],
    [o1+(s1+i+di)%ss, o2+(s2+ss-i-1+di)%ss, o2+(s2+ss-i-di)%ss]
]];
function bquads(ss, o1, o2, s1, s2, sz, di=1) = fquads(ss, o1, o2, s1, s2, sz, di);

// Square set faces
// base offset, set size, wid, hei, offset left, offset right, direction
function fhquads(lo, ss, w, h, o1 = 0, o2 = 0.5, di=0) = [for (x=[0:w-2], y=[0:h-2]) each [
    [lo + ss*(y+h*(x+1-di)+o1), lo + ss*(y+1+h*(x+1-di)+o2), lo + ss*(y+1+h*(x+di)+o2)],
    [lo + ss*(y+h*(x+1-di)+o1), lo + ss*(y+1+h*(x+  di)+o2), lo + ss*(y+  h*(x+di)+o1)]
]];
function bhquads(lo, ss, w, h, o1 = 0, o2 = 0.5, di=1) = fhquads(lo, ss, w, h, o1, o2, di);

// Square set, one side
// base offset, set size, side size, side offset, edge offset, side jump, direction
function fvquads(lo, ss, sd, so, eo, sj=1, di=0) = [for (i=[0:sd-2]) each [
    [lo + ss*(so + (i+di)*sj), i+eo + di  , i+eo + 1-di],
    [lo + ss*(so + (i+di)*sj), i+eo + 1-di, lo + ss*(so + (i+1-di)*sj)]
]];

// Corner triangle
// base offset, set size, set offset, edge offset, edge set size, set offset, inside set offset, direction
function fvcorner(lo, ss, eo, es, so, io, di=0) = [
    [lo+es + ss*so+(ss*(io+0.25))%ss, lo+(eo+es+di-1)%es, lo+(eo+es-di)%es],
    [lo+es + ss*so+(ss*(io     ))%ss, lo+eo+di, lo+eo+1-di]
];

// Square set, sides 
// base offset, set size, wid, hei, direction
function fsquads(lo, ss, w, h, di=0) = concat(
    // Side faces
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=w, so=0.5,          eo=lo+1,       sj= h, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=w, so=h*w-1,        eo=lo+w+h+3,   sj=-h, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=h, so=(w-1)*h+0.25, eo=lo+w+2,     sj= 1, di=di),
    fvquads(lo=lo+2*(w+h+2), ss=ss, sd=h, so=h-1+0.75,     eo=lo+w+h+w+4, sj=-1, di=di),
    // Corner triangles
    fvcorner(lo=lo, ss=ss, eo=0,       es=2*(w+h+2), so=0,       io=0.5,  di=di),
    fvcorner(lo=lo, ss=ss, eo=w+1,     es=2*(w+h+2), so=h*(w-1), io=0.25, di=di),
    fvcorner(lo=lo, ss=ss, eo=h+w+2,   es=2*(w+h+2), so=h*w-1,   io=0,    di=di),
    fvcorner(lo=lo, ss=ss, eo=w+h+w+3, es=2*(w+h+2), so=h-1,     io=0.75, di=di)
);
function bsquads(lo, ss, w, h, di=1) = fsquads(lo, ss, w, h, di);

// Corner dart triangle
// base offset, set offset, steps, edge offset, direction
function fcornertri(lo, so, ss, eo, di=0) = [for (a=[0:ss*0.25-1]) each [
    [eo, lo+(so*ss+a+di)%ss, lo+(so*ss+a+1-di)%ss]
]];

// Corner dart triangle set
// base offset, set size, wid, hei, direction
function fcornerdart(lo, ss, w, h, di=0) = concat(
    fcornertri(lo=lo+2*(w+h+2),              so=0.5,  ss=ss, eo=lo + 0,       di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h*(w-1)), so=0.25, ss=ss, eo=lo + w+1,     di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h*w-1),   so=0,    ss=ss, eo=lo + h+w+2,   di=di),
    fcornertri(lo=lo+2*(w+h+2)+ss*(h-1),     so=0.75, ss=ss, eo=lo + w+h+w+3, di=di)
);
function bcornerdart(lo, ss, w, h, di=1) = fcornerdart(lo, ss, w, h, di);
