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
off = side*s3*(3+sqrt(5))/12;     // Distance of faces from center

eoff = side*(1+sqrt(5))/4;        // Distance of edges from center
voff = side*sqrt(10+2*sqrt(5))/4; // Distance of vertices from center

lipheight = lipwidth * 2 * (off/wid);

tran = atan(wid/off);  // Angle between point and center of triange as seen from d20 center
dihed = acos(-sqrt(5)/3);  // Dihedral angle
edgean = atan((wid/2)/off);  // Angle offset of edge
edgesan = atan((side/2)/eoff);  // Angle offset of other edge

vertan = atan(2);

lipins = lipin * 0.75;

txtfont = "Calibri:style=Bold";
txtsize = side/3;
txtt = 1.0;

edgewid=12.6;

cordhole=7;

digpins = [
    [], //0
    [],
    [],
    [],
    [],
    [], //5
    [],
    [],
    [],
    [],
    [ [28,33.5],[28,-45.8],[28,-28],[28,15.5],
      [1.5,-25],[2.5,14],[54.5,-25],[54.5,14],
      [-14,-27],[-14,0],[-16.5,31],[-0.5,-36],[-25,-44.5],
      [-50,-36],[-35,-27],[-35,10],[-50,12.5],[-38,27.5]], //10
    [],
    [],
    [],
    [],
    [], //15
    [],
    [],
    [],
    [],
    []  //20
];

digholes = [0,
    0,0,0,3,1,
    0,0,0,0,0,
    2,0,3,0,0,
    0,0,3,0,0
    ];

sdigit=0;
dodigit=0;
doedge=0;
dovertex=0;
doclamp=0;
doswitch=0;
if (sdigit) {
    dig = dodigit==6?" 6.":dodigit==9?" 9.":str(dodigit);
    translate([0,0,-off]) triangledigit(dig, digpins[dodigit]);
    
    *translate([0,0,-off]) triangleside(dig, digpins[dodigit]);

} else if (dodigit) {
    dig = dodigit==6?" 6.":dodigit==9?" 9.":str(dodigit);
    rotate([180,0,0]) translate([0,0,-off]) triangleside(dig, digpins[dodigit], hole=digholes[dodigit]);
} else if (doedge) {
    rotate([90,0,0]) edge(doedge==2, doedge==3);
} else if (dovertex) {
    rotate([0,0,0]) vertex(dovertex==2);
} else if (doclamp) {
    if (doclamp == 2) {
        rotate([0,90,0]) cordlip();
    } else {
        cordholder();
    }
} else if (doswitch) {
    if (doswitch == 3) {
        nub();
    } else if (doswitch == 2) {
        rotate([0,0,108]) switchcap();
    } else {
        rotate([-18,0,0]) rotate([0,-90,0]) switchhouse();
    }
} else {
    d20();
}

module d20()
{
    color("gray") for (a=[360/5:360/5:360]) {
        rotate([tran,0,a]) triangleside(hole=3);
        rotate([dihed-tran,180,a]) triangleside();
        rotate([180+tran,0,a]) triangleside();
        rotate([180+dihed-tran,180,a]) triangleside();
    }
    for (a=[360/5:360/5:360]) {
        rotate([tran+edgean,0,a]) edge(a==360);
        rotate([0,edgesan,a+90]) edge(a==360, a==288);
        
        rotate([90,90-edgesan,a-18]) edge(a==288, a==72||a==360);
        rotate([90,90+edgesan,a+18]) edge(a==72, a==144||a==216);
        
        rotate([0,edgesan+180,a+90]) edge(a==360, a==288);
        rotate([tran+edgean,180,a+180]) edge(a==360);
    }
    topvertex();
    for (a=[360/5:360/5:360]) {
        rotate([vertan,0,a+36]) vertex();
        rotate([180+vertan,0,a+36]) vertex();
    }
    rotate([180,0,0]) vertex();
    cord();
    switch();
    translate([0,0,268]) cord();
}

module switch(h=70, d=30, t=1.6, s=5)
{
    color("gray") switchhouse(h=h, d=d, t=t, s=s);
    *#switchcap(h=h, d=d, t=t, s=s);
    
    color("blue") translate([0,0,voff+200]) rotate([0,90,-18]) translate([0,0,8]) {
        wemosd1();
    }
    translate([0,0,225-h/2-1.9]) rotate([0,0,72]) cordholder();
    translate([0,0,225+h/2-9.1]) rotate([0,0,72]) cordholder();
    
    translate([0,0,voff+200]) rotate([0,90,162]) translate([0,0,d/2+1.8]) nub();
}

module nub(d=23, t=6, h=4, sh=3)
{
    hd = d/2;
    r = (t*t+hd*hd)/(2*t);
    difference() {
        intersection() {
            translate([0,0,t-r]) sphere(r, $fn=120);
            translate([0,0,t/2]) cube([d,d,t], true);
        }
        intersection() {
            cylinder(6, h/2, h/2, true, $fn=32);
            cube([sh, h+0.1, 6], true);
        }
    }
}

module switchhouse(h=70, d=30, t=1.6, s=5, l1=2.5, l2=1.5)
{
    side = tan(180/s)*(d+t*2);
    translate([0,0,voff+200]) {
        difference() {
            union() {
                for (a=[0:s-3]) {
                    rotate([0,0,a*360/s]) translate([0,d/2+t/2,0]) cube([side,t,h], true);
                }
                rotate([0,0,(s-2)*360/s]) translate([0,d/2+t/2,0]) {
                    translate([side/2-l1/2,t/4,0])
                     cube([l1,t/2,h], true);
                    translate([side/2-l2/2,-t/4,0])
                     cube([l2,t/2,h], true);
                }
                rotate([0,0,(s-1)*360/s]) translate([0,d/2+t/2,0]) {
                    translate([-(side/2-l1/2),t/4,0])
                     cube([l1,t/2,h], true);
                    translate([-(side/2-l2/2),-t/4,0])
                     cube([l2,t/2,h], true);
                }
                rotate([0,90,-18]) translate([0,0,-d/2+1.8]) {
                    cube([20,20,4], true);
                    // translate([0,0,2]) cube([20,21,1], true);
                }
            }
            rotate([0,90,-18]) translate([0,0,-d/2-t-0.1]) cylinder(t+0.2, 4, 4, $fn=60);
            wt = -0.1;
            rotate([0,90,-18]) translate([0,0,-d/2+1.2+wt]) {
                translate([0,0,0.3]) intersection() {
                    cube([17.7,17.7,4.9], true);
                    rotate([0,0,45]) cube([21.4,21.4,5.0],true);
                }
                cylinder(5.5,17.7/2,17.7/2,true,$fn=60);
                translate([0,0,2.2]) cube([21,7,1.2],true);
                translate([0,0,2.2]) cube([7,21,1.2],true);
            }
        }

        ed = d/2/cos(36);
        edt = (d/2+t)/cos(36);
        difference() {
            polyhedron(points = concat(
              [[0,0,h/2+d/2+t]],
              [for (a=[180/s:360/s:360]) [edt*sin(a),edt*cos(a),h/2]],
              [for (a=[180/s:360/s:360]) [ed*sin(a),ed*cos(a),h/2]]
            ), faces = concat(
              [[0,1,2],[0,2,3],[0,3,4],[0,4,5],[0,5,1]],
              [[2,1,6,7],[3,2,7,8],[4,3,8,9],[5,4,9,10],[1,5,10,6]],
              [[10,9,8,7,6]]
            ));
            translate([0,0,h/2-0.1]) cylinder(d/2+t+2,cordhole/2,cordhole/2,$fn=60);
        }
        mirror([0,0,1]) difference() {
            polyhedron(points = concat(
              [[0,0,h/2+d/2+t]],
              [for (a=[180/s:360/s:360]) [edt*sin(a),edt*cos(a),h/2]],
              [for (a=[180/s:360/s:360]) [ed*sin(a),ed*cos(a),h/2]]
            ), faces = concat(
              [[0,1,2],[0,2,3],[0,3,4],[0,4,5],[0,5,1]],
              [[2,1,6,7],[3,2,7,8],[4,3,8,9],[5,4,9,10],[1,5,10,6]],
              [[10,9,8,7,6]]
            ));
            translate([0,0,h/2-0.1]) cylinder(d/2+t+2,cordhole/2,cordhole/2,$fn=60);
        }

        sa = sin(36);
        ca = cos(36);
        b1 = side/2-l2;
        b3 = side/2-l2+1;
        wmo = 13;
        wd = (d/2-tol);
        // wd*sa+bx*ca = wmo
        // wd*ca-bx*sa = b2
        // bx*ca = wmo-wd*sa
        // bx = (wmo-wd*sa)/ca
        // bx*sa = (wmo-wd*sa)*sa/ca
        // b2 = wd*ca - bx*sa
        //    = wd*ca - ((wmo-wd*sa)*sa/ca)
        b2 = wd*ca - ((wmo-wd*sa)*sa/ca);
        rotate([0,0,72]) translate([0,0,-h/2]) linear_extrude(height=h) polygon([
            [-12.8,-3],
            [-9.8,-3],
            //[-12.8,0],
            [-15.8,3],
            //[-14.5,-4.5],
            [-d/2*sa-b3*ca,-d/2*ca+b3*sa],
            [-d/2*sa-b1*ca,-d/2*ca+b1*sa],
            [-(d/2-tol)*sa-b1*ca,-(d/2-tol)*ca+b1*sa],
            [-wmo,-b2],
            [-12.8,-5]
        ]);
        rotate([0,0,72]) translate([0,0,-h/2]) mirror([1,0,0]) linear_extrude(height=h) polygon([
            [-12.8,-3],
            [-9.8,-3],
            [-15.8,3],
            //[-14.5,-4.5],
            [-d/2*sa-b3*ca,-d/2*ca+b3*sa],
            [-d/2*sa-b1*ca,-d/2*ca+b1*sa],
            [-(d/2-tol)*sa-b1*ca,-(d/2-tol)*ca+b1*sa],
            [-wmo,-b2],
            [-12.8,-5]
        ]);
    }
}

module switchcap(h=70, d=30, t=1.6, s=5, l1=2.5, l2=1.5, tol=0.1)
{
    l1t = l1+tol;
    l2t = l2+tol;
    side = tan(180/s)*(d+t*2);
    translate([0,0,voff+200]) {
        union() {
            rotate([0,0,(s-2)*360/s]) translate([0,d/2+t/2,0]) {
                translate([-l1t/2,t/4-tol/2,0])
                 cube([side-l1t,t/2+tol,h-tol*2], true);
                translate([-l2t/2,-t/4-tol/2,0])
                 cube([side-l2t,t/2-tol,h-tol*2], true);
            }
            rotate([0,0,(s-1)*360/s]) translate([0,d/2+t/2,0]) {
                translate([l1t/2,t/4-tol/2,0])
                 cube([side-l1t,t/2+tol,h-tol*2], true);
                translate([l2t/2,-t/4-tol/2,0])
                 cube([side-l2t,t/2-tol,h-tol*2], true);
            }
        }
    }
}

module wemosd1() {
    translate([0,0,-2.4]) cube([34.6,25.4,4.8], true);
    // translate([-17.3,   0,0]) rotate([0,0,90]) mcutab(12);
    /*
    translate([ 17.3,-11.2,0]) rotate([0,0,-90]) mcutab(6);
    translate([ 17.3, 11.2,0]) rotate([0,0,-90]) mcutab(6);
    translate([-17.3,-11.2,0]) rotate([0,0, 90]) mcutab(6);
    translate([-17.3, 11.2,0]) rotate([0,0, 90]) mcutab(6);

    translate([ 10,-12.7-2/2,-7/2+0.1]) cube([7,2,7],true);
    translate([ 10, 12.7+2/2,-7/2+0.1]) cube([7,2,7],true);
    translate([-10,-12.7-2/2,-7/2+0.1]) cube([7,2,7],true);
    translate([-10, 12.7+2/2,-7/2+0.1]) cube([7,2,7],true);
    */
}


module mcutab(w) {
    translate([-w/2,0,0]) rotate([0,90,0]) linear_extrude(height=w) polygon([
        [0,0],[4.8,0],[5.4,-0.5],[7,0.5],[5.4,1.5],[0,1.5]
    ]);
}

module cord(h=230, d=6)
{
    color("black") translate([0,0,voff+h/2-50]) {
        cylinder(h, d/2, d/2, true, $fn=30);
    }
}

module topvertex(d=cordhole)
{
    vertex(true);
    cordholder(d=d);
    cordlip(d=d);
}

module cordholder(h=7, d=cordhole, t=1.2, nw=7, nt=2.2, lt=0.8, o=voff)
{
    x = 16;
    translate([0,0,o-h-x]) difference() {
        union() {
            cylinder(h, d/2+t, d/2+t, $fn=120);
            translate([0,-(d+1)/2,h/2]) cube([d+t*2,d+1,h], true);
        }
        translate([0,0,-0.1]) cylinder(h+0.2, d/2, d/2, $fn=120);
        translate([0,-d/4-nt/2-lt,h/2]) cube([nw-2,d/2+nt,h+0.2], true);
        translate([0,-d/2-nt/2-lt,h/2]) cube([nw,nt,h+0.2], true);
        translate([0,-d/2-0.1,h/2]) rotate([90,0,0]) cylinder(nt*3, 2, 2, $fn=120);
    }
}

module cordlip(h=7, d=cordhole, t=0.8, nw=7, o=voff)
{
    x = 16;
    w = 4;
    translate([0,0,o-h-x]) {
        difference() {
            union() {
                translate([0,-d/2-t/2+2,h/2-0.1]) cube([nw-2.2,t+4,h+0.2], true);
                translate([0,-d/2-w/2+2,-t/2-0.1]) cube([nw-2.2,w+4,t], true);
            }
            translate([0,0,-1.2]) cylinder(h+1.4, d/2, d/2, $fn=60);
        }
    }
}

module vertex(hole=false, w=edgewid, o=voff, t=2, bt=2.5)
{
    d1 = 14.802;
    d2 = 17.55;
    d3 = 20.3;
    d4 = 11.5;
    bo = 8.7;
    difference() {
        translate([0,0,o]) polyhedron(
            points = concat(
                [[0,0,-3.14]],
                stubpenta2(d1, bo),
                stubpenta(d2, bo),
                stubpenta3(d4, (25.8)/tan(90-edgesan))
            ),
            faces = concat(
                [for (i=[0:4]) [0,i+1,(i+1)%5+1]],
                [for (i=[0:4]) each [
                    [i+1,(i*2+9)%10+1+5,i*2+1+5],
                    [i+1,i*2+1+5,(i*2+1)%10+1+5],
                    [i+1,(i*2+1)%10+1+5,(i+1)%5+1]]],
                [for (i=[0:4]) each [
                    [i+16,i*2+1+5,(i*2+9)%10+1+5],
                    [i+16,(i*2+1)%10+1+5,i*2+1+5],
                    [i+16,(i+1)%5+16,(i*2+1)%10+1+5]]],
                nbotsd(5,16)
            )
        );
        l=side - 2*(off/wid)-30;
        // Edge lip holes
        for (a=[360/5:360/5:360]) {
            rotate([0,edgesan,a+90]) translate([-l/2,0,(eoff-2.7)-(t+tol/2)*2.175]) rotate([0,-edgesan,0]) rotate([0,0,180]) edgepin(w+tol*2,t+tol+0.2);
        }
        // Face pin holes
        for (a=[360/5:360/5:360]) {
            rotate([tran,0,a]) translate([0,wid-10,off-4.1]) {
                cylinder(5,2.1,2.1,$fn=32);
                translate([0,0,-2]) cylinder(2.01,1.1,2.1,$fn=32);
            }
        }
        if (hole) {
            translate([0,0,voff-30]) cylinder(30, cordhole/2, cordhole/2, $fn=120);
        }
    }
}

function stubpenta2(w, bo, of=0) = concat(
    [for (a = [360/5:360/5:360]) each
        [[w*sin(a)+bo*sin(a-126), w*cos(a)+bo*cos(a-126), (-w-of)/tan(90-edgesan)]]    ]);

function stubpenta3(w, of) = concat(
    [for (a = [360/10:360/5:360]) each
        [[w*sin(a), w*cos(a), -of]]    ]);

function stubpenta(w, bo, of=0) = concat(
    [for (a = [360/5:360/5:360]) each
        [[w*sin(a)+bo*sin(a-126), w*cos(a)+bo*cos(a-126), -w/tan(90-edgesan)],
         [w*sin(a)+bo*sin(a+126), w*cos(a)+bo*cos(a+126), -w/tan(90-edgesan)]]
    ]);

module edge(top=false, wire=false, l=side - 2*(off/wid)-30, w=edgewid, o=eoff-2.7, t=2)
{
  col = top?"green":wire?"blue":"orange";
  color(col) {
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
    translate([l/2,0,o-t*2.175]) rotate([0,edgesan,0]) edgepin(w,t);

    translate([-l/2,0,o-t*2.175]) rotate([0,-edgesan,0]) rotate([0,0,180]) edgepin(w,t);


    translate([0,0,o-t/2-13]) cube([l-10.79,w,2], true);
    for (n=[-3:2:3]) {
        translate([n*((l-2)/10),0,o-t/2-6]) cube([2,w,13], true);
    }
    translate([-5*((l-2)/10),0,o]) rotate([0,-20,0])
        translate([0,0,-t/2-7.598]) cube([2,w,14], true);
    translate([ 5*((l-2)/10),0,o]) rotate([0, 20,0])
        translate([0,0,-t/2-7.598]) cube([2,w,14], true);
    translate([-5*((l-2)/10),0,o-t/2-2]) cube([2,w,5], true);
    *translate([ 5*((l-2)/10),0,o-t/2-6]) cube([2,w,13], true);

    if (top) {
        for (n=[-4:4]) {
            translate([n*(33/2),0,o-t/2-14]) stripholder(w);
        }
        translate([(-5)*(33/2),0,o-t/2-14]) stripholder(w, h=1.5);
        translate([( 5)*(33/2),0,o-t/2-14]) stripholder(w, h=1.5);
        translate([(-5.8)*(33/2),0,o-t/2-14]) stripholder(w, h=3, g=1);
        translate([( 5.8)*(33/2),0,o-t/2-14]) stripholder(w, h=3, g=1);

    }
    if (wire) {
        for (n=[-4:2:4]) {
            translate([n*side/11,0,o-t/2-14]) wireholder(w);
        }
    }
  }
}

module stripholder(w=edgewid, l=5, t=1.2, iw=11, h=0.8, g=0.2)
{
    x = w/2;
    x2 = iw/2;
    rotate([0,90,0]) translate([0,0,-l/2]) linear_extrude(height=l) polygon([
        [-1,x],[h+t,x],[h+t,-x],[g+0.5,-x],[g,0.5-x],[g,-x2],[h,-x2],[h,x2],[-1,x2]
    ]);
}

module wireholder(w=edgewid, l=10, t=1.2, b=2, h=5, g=0.2)
{
    x  = w/2;
    dt = t/2;
    rotate([0,90,0]) translate([0,0,-l/2]) linear_extrude(height=l) polygon([
        [-1,x],[h-b,x],[h,x-b],[h,b-x],[h-b,-x],[g+0.6,-x],[g,0.6-x],
        [g,t-x],[h-b-dt,t-x],[h-t,dt+b-x],[h-t,x-dt-b],[h-b-dt,x-t],[-1,x-t]
    ]);
}

module edgepin(w,t)
{
     linear_extrude(height=t) polygon([
        [-5,-w/2],[7-w/2,-w/2],[7,0],[7-w/2,w/2],[-5,w/2]]);
}

module pinlip(t=14, w=1.2, pw=5.2, h=(pinhi*0.915)-4, no=1)
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

module triangledigit(txt="", dpins = [], w=wid, t=thick, o=off+tol, bt = 2.5)
{
    sds = 3;
    difference() {
        union() {
            translate([0,-w/20,o]) linear_extrude(height=t-0.4)
             offset(r=5.9) offset(r=-4)
             text(text=txt, size=txtsize, font=txtfont,
              halign="center",valign="center");
            translate([0,-w/20,o-1]) linear_extrude(height=1)
             offset(r=9) offset(r=-4)
             text(text=txt, size=txtsize, font=txtfont,
              halign="center",valign="center");
        }
        for (dp = dpins) {
            translate([dp[0],dp[1],o-1.1])
             cylinder(1.2, 1.1, 1.1, $fn=32);
        }
    }
}


module triangleside(txt="", dpins = [], hole=0, w=wid, t=thick, o=off+tol, bt = 2.5)
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
        translate([0,-w/20,o+t-txtt]) linear_extrude(height=t+0.2)
         offset(r=6) offset(r=-4) text(text=txt, size=txtsize, font=txtfont,
            halign="center",valign="center");
        if (hole) {
            rotate([-tran,0,120*hole]) translate([0,0,voff-10]) cylinder(15,cordhole/2,cordhole/2,$fn=120);
        }
    }
    *for (dp = dpins) {
         translate([dp[0],dp[1],o-1.5])
         cylinder(1.6, 1, 1, $fn=32);
         translate([dp[0],dp[1],o-2.5])
         cylinder(1.4, 0.8, 1.1, $fn=32);
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
    
    // Vertex pins
    for (a=[360/3:360/3:360]) {
        rotate([0,0,a]) translate([0,wid-10,off-4]) {
            cylinder(5,2,2,$fn=64);
            translate([0,0,-2]) cylinder(2,1,2,$fn=32);
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

function nquads(n,o) = [for (i=[0:n-1]) each [[(i+1)%n+o,i+o,i+o+n],[(i+1)%n+o,i+o+n,(i+1)%n+o+n]]];

function ntopsd(n,o) = [[for (i=[0:n-1]) (i+o)]];
function nbotsd(n,o) = [[for (i=[n-1:-1:0]) (i+o)]];
