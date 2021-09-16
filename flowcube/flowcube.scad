
// Holes in perfboard
// holesp = 2.54;
holesp = 2.54;
holedia = 1;
boardth = 1.2;

perfboard(47,47);

module perfboard(w,h)
{
    wid = holesp * (w+1);
    hei = holesp * (h+1);
    hr = holedia/2;

    cp = 16;
    an = 360/cp;
    lo = 2*(w+h+2);
    lo2 = lo + cp*w*h;
    points = concat(
        ssquare(wid,hei,w+1,h+1,0),
        [for (x=[1:w], y=[1:h]) each circle(x*holesp, y*holesp, 0, hr, an)],
        ssquare(wid,hei,w+1,h+1,boardth),
        [for (x=[1:w], y=[1:h]) each circle(x*holesp, y*holesp, boardth, hr, an)]
    );
    polyhedron(points = points, faces = concat(
        // [[0,1,2,3],[lo2+3,lo2+2,lo2+1,lo2+0]],
        nquads(0, lo, lo2), // Outside
        [for (p=[lo:cp:lo2-1]) each nquads(p, cp, lo2)], // Hole insides

        // Front face between holes
        [for (x=[0:w-2], y=[0:h-1]) each 
            fquads(cp, lo+cp*(y+h*x), lo+cp*(y+h*(x+1)), 0, 0, cp*0.5)],

        // Front face between hole sides
        [for (x=[0:w-2], y=[0:h-2]) each [
            [lo+cp*(y+h*(x+1)), lo+cp*(y+1+h*(x+1)+0.5), lo+cp*(y+1+h*x+0.5), lo+cp*(y+h*x)]
        ]],

        // Front face between holes, vertical
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*0), lo+cp*(y+1+h*0), cp*0.75, cp*0.75, cp*0.25)],
        [for (y=[0:h-2]) each
            fquads(cp, lo+cp*(y+h*(w-1)), lo+cp*(y+1+h*(w-1)), 0, cp*0.5, cp*0.25)],

        // Front face between hole sides and sides
        [for (x=[0:w-2]) each [
            [lo+cp*(h*x+0.5), x+1, x+2, lo+cp*(h*(x+1)+0.5)],
            [lo+cp*(h*(x+2)-1), lo-h-1-x-2, lo-h-1-x-1, lo+cp*(h*(x+1)-1)]
        ]],
        [for (y=[0:h-2]) each [
            [lo+cp*(h*(w-1)+y+0.25), w+y+2, w+y+3, lo+cp*(h*(w-1)+y+1+0.25)],
            [lo+cp*(y+1+0.75), lo-y-2, lo-y-1, lo+cp*(y+0.75)]
        ]],
        // Side triangles in corners
        [
            [lo+cp*(0.75), lo-1, 0],
            [lo+cp*(0.5), 0, 1],
            [lo+cp*(h*(w-1)+0.5), w, w+1],
            [lo+cp*(h*(w-1)+0.25), w+1, w+2],
            [lo+cp*(h*w-1+0.25), h+w+1, h+w+2],
            [lo+cp*(h*w-1+0), h+w+2, h+w+3],
            [lo+cp*(w), w+h+w+2, w+h+w+3],
            [lo+cp*(w+0.75), w+h+w+3, w+h+w+4]
        ],
        // Corner darts
        [for (a=[0:cp*0.25-1]) each [
            [0,lo+a+cp*0.5,lo+a+1+cp*0.5],
            [w+1,lo+a+cp*(h*(w-1)+0.25),lo+a+1+cp*(h*(w-1)+0.25)],
            [h+w+2,lo+a+cp*(h*w-1+0),lo+a+1+cp*(h*w-1+0)],
            [w+h+w+3,lo+cp*(h-1)+(a+cp*0.75)%cp,lo+cp*(h-1)+(a+1+cp*0.75)%cp],
        ]],
/*

        [for (x=[0:w-1], y=[0:h-2]) each 
            bquads(cp, lo2+lo+cp*(x+w*y), lo2+lo+cp*(x+w*(y+1)), 0, 0, cp*0.5)],

        // Back face between hole sides
        [for (x=[0:w-2], y=[0:h-2]) each [
            [lo2+lo+cp*(x+w*y), lo2+lo+cp*(x+1+w*y+0.5), lo2+lo+cp*(x+1+w*(y+1)+0.5), lo2+lo+cp*(x+w*(y+1))]
        ]],
        */

        // Back face between hole sides and sides
        [for (x=[0:w-2]) each [
            [lo2+lo+cp*(h*(x+1)+0.5), lo2+x+2, lo2+x+1, lo2+lo+cp*(h*(x+0)+0.5)],
            [lo2+lo+cp*(h*(x+1)-1), lo2+lo-h-1-x-1, lo2+lo-h-1-x-2, lo2+lo+cp*(h*(x+2)-1)]
        ]]

    ));
    *translate([0,0,-boardth/2]) difference() {
        cube([wid, hei, boardth], true);
        for (x=[-w/2+0.5:w/2], y=[-h/2+0.5:h/2]) {
            translate([x*holesp, y*holesp, 0]) cylinder(boardth+0.02, hr, hr, true, $fn=48);
        }
    }
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

// Front face, between holes (sets)
// set size, set 1 offset, set 2 offset, start 1, start 2, size
function fquads(ss, o1, o2, s1, s2, sz) = [for (i=[0:sz-1]) each [
    [o1+(s1+i)%ss, o1+(s1+i+1)%ss, o2+(s2+ss-i-1)%ss],
    [o1+(s1+i)%ss, o2+(s2+ss-i-1)%ss, o2+(s2+ss-i)%ss]
]];
// Back face, between holes (sets)
// set size, set 1 offset, set 2 offset, start 1, start 2, size
function bquads(ss, o1, o2, s1, s2, sz) = [for (i=[0:sz-1]) each [
    [o1+(s1+i+1)%ss, o1+(s1+i)%ss, o2+(s2+ss-i-1)%ss],
    [o2+(s2+ss-i-1)%ss, o1+(s1+i)%ss, o2+(s2+ss-i)%ss]
]];
