doitem = "plugclipb";

s3 = sqrt(3);

if (doitem == "tubeend") { rotate([180,0,0]) tubeend(cp=240); }
if (doitem == "socketclip") { rotate([-90,0,0]) socketclip(cp=240); }
if (doitem == "plugclipt") { rotate([0,90,0]) plugclipt(cp=240); }
if (doitem == "plugclipb") { rotate([0,-90,0]) plugclipb(cp=240); }
if (doitem == "bottomplate") { rotate([180,0,0]) bottomplate(); }
if (doitem == "topplatebot") { topplatebot(cp=240); }
if (doitem == "topplatetop") { rotate([180,0,0]) topplatetop(cp=240); }
if (doitem == "receptacle") {
        rotate([0,90-asin(1/s3),45]) { receptacle(cp=240); }
}
if (doitem == "") {
    *color("#abd") translate([0,0,-9]) rotate([0,0,90]) import("behuizing met staanders.stl", convexity=6);
    
    *color("#653") translate([0,0,0]) render(convexity=8) socket();
    *color("#653") translate([0,0,0]) render(convexity=8) powerplug_f();
    color("#ea86") plugclipplace();

    *color("#646") tubeendplace();

    *color("#ea86") render(convexity=8) socketclipplace();
    *color("#686") bottomplate();
    *color("#686") topplatetop();
    *color("#797") topplatebot();
    *color("#a926") magnetic_connector();

    gap = 0.0;
    *color("#ade") receptacle();
    *color("#454") translate([gap,0,0]) render(convexity=8) receptacle();
    *color("#454") rotate([0,0,120]) translate([gap,0,0]) render(convexity=8) receptacle();
    *color("#454") rotate([0,0,240]) translate([gap,0,0]) render(convexity=8) receptacle();
    *color("#ade7") render(convexity=8) receptacle();
    // test print socket bit
    *intersection() {
        // Rotate for printing ?
        color("#aae") rotate([0,90-asin(1/s3),45]) {
            receptacle(cp=120);
        }
        translate([17,17,-143]) cylinder( 75, 36*sqrt(2), 36*sqrt(2), $fn=4);
    }
    *color("#8cc8") translate([-30,-00,-143]) rotate([0,0,0]) cube([210,250,2], true);

    if (0) {
        // Check thicknesses
        *color("#aac6") translate([0,0,(58.5-100)*s3]) rotate([-45,asin(1/s3),0]) translate([0,0,100-3/2]) cube([200,200,3], true);
        *color("#aac6") translate([0,0,(58.5-100)*s3]) rotate([-45,asin(1/s3),0]) translate([0,0,100-3/2]) cube([200,200,3], true);
        *color("#ada") translate([0,0,(58.5-100)*s3]) rotate([-45,asin(1/s3),0]) translate([-100+3/2,-100+3/2,100-3/2]) cube([3,3,3], true);
        *color("#ada") translate([0,0,(58.5-100)*s3]) rotate([-45,asin(1/s3),0]) translate([100-3/2,-100+3/2,100-3/2]) cube([3,3,3], true);
        *color("#ada6") rotate([0,0,120]) translate([0,0,(58.5-100)*s3]) rotate([45,asin(1/s3),0]) translate([-100,-100,-100]) cube([3,s3+1,s3+1]);

        // sqrt(2^2 + X^2 + Y^2) = sqrt(2^2 + (s3+1)^2 + (s3+1)^2)
        // X = Y/sqrt(3)
        // (2^2 + X^2 + Y^2) = (2^2 + (s3+1)^2 + (s3+1)^2)
        // (X^2 + Y^2) = ((s3+1)^2 + (s3+1)^2)
        // X^2 = (Y/sqrt(3))^2 = Y^2/3
        // X^2 + Y^2 = Y^2/3 + Y^2 = 4/3 Y^2
        // 4/3 Y^2 = 2*(s3+1)^2
        // Y^2 = 2*(3/4) * (s3+1)^2 = 3/2 * (s3+1)^2

        *color("#ada6") rotate([0,0,120]) translate([0,0,(58.5-100)*s3]) translate([-165,-00,-100/s3]) rotate([0,0,-30]) cube([10,10,3]);
        color("#ada6") rotate([0,0,120]) translate([0,0,(58.5-100)*s3]) rotate([45,asin(1/s3),0]) translate([-100,-100,-100]) cube([3,5,15]);
        color("#ada6") rotate([0,0,120]) translate([0,0,(58.5-100)*s3]) rotate([45,asin(1/s3),0]) translate([-100,-100,-100]) rotate([0,0,-90]) translate([-3,0,0]) cube([3,5,15]);
    }

    *if (1) {
        // Cut one way
        color("#ccc3") render(convexity=8) {receptacle_model();}
        *color("#ccc8") intersection() {
            render(convexity=8) {receptacle_model();}
            translate([200,0,-130]) cylinder(180,200,200,$fn=6);
        }
        *color("#ccc8") rotate([0,0,30]) translate([50,-40,-130]) cube([210,250,2], true);
    } else {

        // Cut the other way
        intersection() {
            receptacle_model();
            translate([-200,0,-130]) cylinder(180,200,200,$fn=6);
        }
        *color("#ccc8") rotate([0,0,-30]) translate([-50,-40,-130]) cube([210,250,2], true);
    }
    *color("#ae8") difference() {
        tetsz = 170;
        tety = tetsz/sqrt(2);
        tetx = tety*2/sqrt(3);
        tetz = tetsz/sqrt(3);
        translate([0,0,-tetsz/sqrt(3)/4-4*sqrt(3)]) 
        polyhedron(
            points=[[0,0,tetz],[tetx,0,0],[-tetx/2,-tety,0],[-tetx/2,tety,0]],
            faces=[[0,1,2],[0,3,1],[0,2,3],[1,3,2]]
            );
        translate([0,0,-20]) cylinder(200, 60, 60, $fn=6);
    }
}

module topplatetop(cp=48)
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;
    pcof = 30+tetof; // 131

    inr = 20;
    plr = 32;

    condia = 7;

    thi2 = 11;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    px = plr/2;
    py = px*sqrt(3);

    poy = 5;
    pox = poy*sqrt(3);

    translate([0,0,tetof-pcof]) 
    difference() {
        union() {
            translate([0,0,-thi]) cylinder(thi, inr, inr, $fn=cp);
            for (an=[0,120,240]) rotate([0,0,an]) {
                translate([15,0,-thi-10]) cylinder(10, 4-0.2, 4-0.2, $fn=cp);
            }
        }
        translate([0,0,-thi-0.01]) cylinder(thi+0.02, condia/2, condia/2, $fn=cp);
        for (an=[0,120,240]) rotate([0,0,an]) {
            translate([15,0,-thi-10.01]) cylinder(10.01, 1.2,1.2, $fn=cp);
        }
    }
}

module topplatebot(cp=48)
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;
    pcof = 30+tetof; // 131

    inr = 20;
    plr = 32;

    holed = 15/2;
    thi2 = 12;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    px = plr/2;
    py = px*sqrt(3);

    poy = 5;
    pox = poy*sqrt(3);

    cndp = 1.8;
    cnwid = 8.6;
    cnlen = 20;

    translate([0,0,tetof-pcof]) 
    difference() {
        union() {
            translate([0,0,-thi-thi2]) linear_extrude(height=thi2) polygon([
                [-px*2,-poy*2],[-px*2,poy*2],
                [px-pox,py+poy],[px+pox,py-poy],
                [px+pox,-py+poy],[px-pox,-py-poy],
            ]);
        }
        for (an=[0,120,240]) rotate([0,0,an]) {
            translate([-px*2,0,-thi-holed]) rotate([0,90,0])
                translate([0,0,-0.01]) cylinder(22.01, 1.2, 1.2, $fn=cp);
        }
        for (an=[0,120,240]) rotate([0,0,an]) {
            translate([15,0,-thi-10]) cylinder(10.01, 4, 4, $fn=cp);
        }
        for (an=[0,120,240]) rotate([0,0,an]) {
            translate([15,0,-thi-thi2-0.01]) cylinder(thi2-10+0.02, 1.5, 1.5, $fn=cp);
        }
        translate([0,0,-thi-thi2/2]) cube([cnwid, 12, thi2+0.02], true);
        translate([0,0,-thi-cndp/2+0.01]) cube([cnwid, cnlen, cndp+0.02], true);
    }
}

module magnetic_connector(cp=48)
{
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;
    pcof = 30+tetof; // 131

    bthi = 1.2;
    bwid = 8.25;
    blen = 18;
    bof = 4;
    bd = (blen-bof*2)/2;

    translate([0,0,tetof-pcof-thi-0.5]) {
        cylinder(3.5, 6.8/2, 6.8/2, $fn=48);
        san = asin(bwid/(blen-bof*2));
        translate([0,0,-bthi]) linear_extrude(height=bthi) polygon(concat(
            [for (an=[-san:san/cp:san]) [sin(an)*bd, bof+cos(an)*bd]],
            [for (an=[180-san:san/cp:180+san]) [sin(an)*bd, -bof+cos(an)*bd]]
        ));
        *#translate([0,0,-bthi]) cube([bwid,blen,bthi], true);
    }
}

module topplate(cp=48)
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;
    pcof = 30+tetof; // 131

    inr = 20;
    plr = 32;

    holed = 15/2;
    thi2 = 11;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    px = plr/2;
    py = px*sqrt(3);

    poy = 5;
    pox = poy*sqrt(3);

    translate([0,0,tetof-pcof]) 
    difference() {
        union() {
            translate([0,0,-thi]) cylinder(thi, inr, inr, $fn=cp);
            translate([0,0,-thi-thi2]) linear_extrude(height=thi2) polygon([
                [-px*2,-poy*2],[-px*2,poy*2],
                [px-pox,py+poy],[px+pox,py-poy],
                [px+pox,-py+poy],[px-pox,-py-poy],
            ]);
        }
        for (an=[0,120,240]) rotate([0,0,an]) {
            translate([-px*2,0,-thi-holed]) rotate([0,90,0])
                translate([0,0,-0.01]) cylinder(20.01, 1.2, 1.2, $fn=48);
        }
    }
}

module bottomplate()
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;

    btcut = 20;
    btlip = 10;
    btthi = 5;
    btins = 5;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    gap = btcut-2;

    ty = btcut*sqrt(3);
    tyg =2*gap/sqrt(3);
    tx = btcut*2;
    txg = gap;
    difference() {
        translate([0,0,tetof-tetz*2]) linear_extrude(height=btins) {
            polygon([
                [-(tetx-tx-txg),gap/sqrt(3)], [-(tetx-tx-txg),-gap/sqrt(3)],
                [tetx/2-btcut-txg,-(tety-ty-tyg/2)], [tetx/2-btcut,-(tety-ty-tyg)],
                [tetx/2-btcut,(tety-ty-tyg)], [tetx/2-btcut-txg,(tety-ty-tyg/2)],
            ]);
        }
        // Holes for bottom lip
        for (an=[0,120,240], y=[-80,80]) {
            rotate([0,0,an]) translate([tetx/2-btcut-btlip/2, y, tetof-tetz*2]) {
                translate([0,0,-0.01]) cylinder(btthi+0.02, 1.5, 1.5, $fn=24); 
                translate([0,0,-0.01]) cylinder(2+0.01, 3, 3, $fn=24); 
            }
        }
        // Weight cutouts
        translate([0,0,tetof-tetz*2-0.01]) linear_extrude(height=btins-2+0.01) {
            sierpinski(tetx-tx-txg-4);
        }
    }
}

module sierpinski(dia, thi = 0.8)
{
    d2 = dia/2-thi;
    dx = dia/4+thi/2;
    dy = dx*sqrt(3);
    
    if (dia > 2) {
        polygon([[ d2, 0], [-d2/2, d2*sqrt(3)/2], [-d2/2, -d2*sqrt(3)/2]]);
        translate([-dx*2, 0]) sierpinski(d2);
        translate([ dx,  dy]) sierpinski(d2);
        translate([ dx, -dy]) sierpinski(d2);
    } else {
        polygon([[-dia, 0], [ dia/2, dia*sqrt(3)/2], [ dia/2, -dia*sqrt(3)/2]]);
    }
}

module receptacle(cp=48)
{
    cubesz = 130;
    cubethi = 5;
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;

    holeof = 58;
    holedep = 20;

    cubebev = 5*2/sqrt(3);

    pcof = 30+tetof; // 131

    cby = cubesz/sqrt(2);
    cbx = cby*2/sqrt(3);
    cbz = cubesz/sqrt(3);

    cty = (cubesz+cubethi-cubebev)/sqrt(2);
    ctx = cty*2/sqrt(3);
    ctz = (cubesz+cubethi-cubebev)/sqrt(3);
    cto = cubethi*sqrt(3);


    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    tu = thi; // Straight up from bottom
    td = thi*s3; // Straight down from tip: Right angle xy

    tz = thi;
    // TODO: Trial-and-error factor
    ty = thi*(sqrt(3)-0.0591);
    tx = ty/sqrt(3);

    tb2 = thi * 1/sqrt(3);
    // sqrt(3)^2 = tb1^2 + tb2^2
    // 3 = tb1^2 + (1/s3)^2 = tb1^2 + 1/3
    // tb1^2 = 3-1/3
    // tb1 = sqrt(3-1/3);
    tb1 = thi * sqrt(3-1/3);

    inz = pcof+thi;

    cutsz = 50*sqrt(3);
    tol = 1;

    ribthi = 15;
    ribof = 8;

    btcut = 20;
    btlip = 10;
    btthi = 5;
    btins = 5;
    difference() {
        union() {
            pup = [[0,0,btins],[0,0,btthi+btins]];

            // Multiple steps to use previous points in calculation
            pts1 = [
                    // Outside of tetraeder
                    // 0..4
                    [0,0,0],[tetx,0,0-tetz],
                    [tetx/2,tety,0-tetz*2],[tetx/2,-tety,0-tetz*2],
                    [0,0,0-tetz*2],

                    // Inside
                    // 5..9
                    [0,0,0-td], [tetx-tb1,0,0-tetz-tb2],
                    [tetx/2-tx,tety-ty,0-tetz*2+tz], [tetx/2-tx,-(tety-ty),0-tetz*2+tz],
                    [0,0,0-tetz*2+tz],

                    // Inside of cube
                    // 10..12
                    [cbx,0,-cbz],[cbx/2,cby,-cbz*2],[cbx/2,-cby,-cbz*2],
                    // Outside of cube
                    // 13..16
                    [0,0,cto],[ctx,0,-ctz+cto],
                    [ctx/2,cty,-ctz*2+cto],[ctx/2,-cty,-ctz*2+cto],
                ];
            pts = concat(pts1, [
                    // Flat bit, bottom of battery
                    // 17..21
                    [0,0,-inz],
                    interpointz(pts1[5], pts1[7], -inz),
                    interpointz(pts1[5], pts1[8], -inz),
                    interpointz(pts1[6], pts1[7], -inz),
                    interpointz(pts1[6], pts1[8], -inz),

                    // Extra points for bottom cut
                    // 22..25
                    interpointx(pts1[4],pts1[2], tetx/2-btcut-btlip+1),
                    interpointx(pts1[4],pts1[3], tetx/2-btcut-btlip+1),
                    interpointx(pts1[4],pts1[2], tetx/2-btcut-btlip+1)+pup[0],
                    interpointx(pts1[4],pts1[3], tetx/2-btcut-btlip+1)+pup[0],

                    // Lip for bottom plate
                    // 26..33
                    interpointx(pts1[4],pts1[2], tetx/2-btcut-btlip)+pup[0],
                    interpointx(pts1[4],pts1[3], tetx/2-btcut-btlip)+pup[0],
                    interpointx(pts1[4], pts1[2], tetx/2-btcut-btlip)+pup[1],
                    interpointx(pts1[4], pts1[3], tetx/2-btcut-btlip)+pup[1],
                    interpointx(pts1[4], pts1[2], tetx/2-btcut)+pup[1],
                    interpointx(pts1[4], pts1[3], tetx/2-btcut)+pup[1],
                    interpointx(pts1[9], pts1[7], tetx/2-btcut+btthi*2),
                    interpointx(pts1[9], pts1[8], tetx/2-btcut+btthi*2),

                    // Inset from lip
                    // 34..37
                    interpointx(pts1[4],pts1[2], tetx/2-btcut-btlip+1)+[btlip-1,-(btlip-1)/sqrt(3),0],
                    interpointx(pts1[4],pts1[3], tetx/2-btcut-btlip+1)+[btlip-1, (btlip-1)/sqrt(3),0],
                    interpointx(pts1[4],pts1[2], tetx/2-btcut-btlip+1)+[btlip-1,-(btlip-1)/sqrt(3),0]+pup[0],
                    interpointx(pts1[4],pts1[3], tetx/2-btcut-btlip+1)+[btlip-1, (btlip-1)/sqrt(3),0]+pup[0],

                    // Tweak for bottom thickness
                    // 38..39
                    pts1[7]+[1.34,-0.77,0], pts1[8]+[1.34,0.77,0],
                ]);

            fcs = [
                    [10,11,2],[10,2,1],[12,10,1],[12,1,3],
                    [1,2,3],

                    [2,22,34,35,23,3],
                    [18,20,38],[18,38,7],
                    [21,19,39],[19,8,39],
                    [20,39,38],[20,21,39],
                    [38,39,8],[38,8,7],

                    [7,8,33,32],
                    [17,18,5],[19,17,5],
                    [2,11,0,5,18,7],

                    [34,36,37,35],
                    [22,24,36,34],[25,23,35,37],
                    [24,25,37,36],

                    [22,2,7],[22,7,32],[22,32,24],
                    [23,8,3],[23,33,8],[23,25,33],
                    // Bottom lip
                    [26,28,29,27],[28,26,24,30],[27,29,31,25],
                    [30,31,29,28],[26,27,25,24],
                    [30,24,32],[25,31,33],
                    [32,33,31,30],

                    [0,12,3,8,19,5],

                    [13,15,14],[13,14,16],
                    [10,14,15],[10,15,11],[14,10,12],[14,12,16],
                    [0,11,15],[0,15,13],[12,0,13],[12,13,16],
                    [19,21,20],[19,20,18],[19,18,17],
                ];

            color("#ab8") translate([0,0,tetof])
            polyhedron(convexity=6,
                points=pts,
                //faces=[for (i=[0:len(fcs)-1]) if (i>=0 && i <= 12) fcs[i]]
                faces=fcs
                );

            /*
            *#translate([0,0,tetof-tetsz*sqrt(3)/2])
            rotate([-45,asin(1/s3),0])
            translate([-tetsz/2, -tetsz/2, -tetsz/2])
            rotate([0,0,0]) 
            cube([tetsz,tetsz,tetsz]);
            */

            translate([tetx/2,-tety,tetof-tetz*2])
            rotate([90-asin(1/s3),0,30]) rotate([0,90,0]) union() {
                linear_extrude(height=thi) polygon([
                    [0,thi],[10,thi+10/sqrt(2)],[10,tetsz],[0,tetsz]
                ]);
                for (n=[20,100]) translate([5-2/2,n,0]) rotate([0,90,0])
                    linear_extrude(height=2) polygon([
                        [0,-thi],[thi,0],[0,thi]
                    ]);
            }

            mirror([0,1,0])
            translate([tetx/2,-tety,tetof-tetz*2])
            rotate([90-asin(1/s3),0,30]) rotate([0,90,0]) difference() {
                linear_extrude(height=thi) polygon([
                    [0,thi],[10,thi+10/sqrt(2)],[10,tetsz],[0,tetsz]
                ]);
                for (n=[20,100]) translate([5-2.2/2,n,0]) rotate([0,90,0])
                    linear_extrude(height=2.2) polygon([
                        [0.01,-thi-0.01-0.2],[-thi-0.2,0],[0.01,thi+0.01+0.2]
                    ]);
            }

            translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),0]) {
                cylinder(holedep,20+thi,20+thi,$fn=cp);
                socketholder(holedep, thi, cp=cp);
            }

            // Ribs for top plane
            rotate([0,0, 30]) translate([0,-35,tetof-pcof-thi])
                rotate([-90,0,0]) linear_extrude(height=thi) difference() {
                    polygon([
                    [-ribof,1],[-ribof+1,0],[58,0],[60,ribthi],[-ribof+ribthi/2,ribthi],[-ribof,ribthi/2]
                    ]);
                    translate([0,ribthi/2]) circle(1.5, $fn=24);
                }
            rotate([0,0,-30]) translate([0, 35,tetof-pcof-thi])
                rotate([-90,0,0]) linear_extrude(height=thi) difference() {
                    polygon([
                    [-ribof,1],[-ribof+1,0],[58,0],[60,ribthi],[-ribof+ribthi/2,ribthi],[-ribof,ribthi/2]
                    ]);
                    translate([0,ribthi/2]) circle(1.5, $fn=24);
                }
            // Rib for center
            translate([tetx/2,0,tetof-tetz*2]) rotate([90,-90+asin(1/s3),0]) translate([0,thi,-thi/2])
                linear_extrude(height=thi) polygon([
                    [-thi*s3,7],[0,0],[51-thi,0],[51-thi,20],[-thi*s3,20]
                ]);
        }
        translate([0,0,tetof-pcof]) {
            linear_extrude(height=200, convexity=6) polygon(
                concat(
                    [for (an=[30:60:150]) each
                        [[(cutsz+tol*sqrt(3))*sin(an) + (10+tol*sqrt(3))*sin(an-120) ,
                          (cutsz+tol*sqrt(3))*cos(an) + (10+tol*sqrt(3))*cos(an-120) ],
                         [(cutsz            )*sin(an) + (10+tol*sqrt(3))*sin(an-60) ,
                          (cutsz            )*cos(an) + (10+tol*sqrt(3))*cos(an-60) ],
                         [(cutsz            )*sin(an) + (10+tol*sqrt(3))*sin(an) ,
                          (cutsz            )*cos(an) + (10+tol*sqrt(3))*cos(an) ],
                         [(cutsz            )*sin(an) + (10+tol*sqrt(3))*sin(an+60) ,
                          (cutsz            )*cos(an) + (10+tol*sqrt(3))*cos(an+60) ],
                         [(cutsz+tol*sqrt(3))*sin(an) + (10+tol*sqrt(3))*sin(an+120) ,
                          (cutsz+tol*sqrt(3))*cos(an) + (10+tol*sqrt(3))*cos(an+120) ]]
                    ],
                    [[-10,0]]
                )
            );
        }
        translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),00]) {
            translate([0,0,-0.01]) cylinder(holedep + 0.02,20,20,$fn=cp);
            translate([0,0,holedep-0.01]) cylinder(15,20,0,$fn=cp);
        }
        // Holes for bottom lip
        for (y=[-80,80]) {
            translate([tetx/2-btcut-btlip/2, y, tetof-tetz*2+btins]) {
                translate([-3/2,0,btthi/2]) cube([5.5+3,5.5,2.6], true);
                translate([0,0,-0.01]) cylinder(btthi+0.02, 1.5, 1.5, $fn=24); 
            }
        }
        // Hole in middle of top
        translate([0,0,tetof-pcof-thi-0.01]) cylinder(thi+0.02, 20, 20, $fn=cp);

        // texture
        for (n=[0:1/40:1]) {
            translate([tetx/2+(tetx/2)*n, tety*(1-n), tetof-tetz*2+tetz*n]) {
                rotate([0,-asin(1/s3),60]) {
                    translate([0,0,-1.4]) cylinder(100, 0.4, 0.4, $fn=4);
                    translate([0,0,100-1.4]) cylinder(0.4, 0.4, 0.0, $fn=4);
                }
            }
            mirror([0,1,0])
            translate([tetx/2+(tetx/2)*n, tety*(1-n), tetof-tetz*2+tetz*n]) {
                rotate([0,-asin(1/s3),60]) {
                    translate([0,0,-1.4]) cylinder(100, 0.4, 0.4, $fn=4);
                    translate([0,0,100-1.4]) cylinder(0.4, 0.4, 0.0, $fn=4);
                }
            }
            translate([tetx/2+(tetx/2)*n, tety*(1-n), tetof-tetz*2+tetz*n]) {
                rotate([90,asin(1/s3),0]) {
                    translate([0,0,-0.4]) cylinder(200*sqrt(2)*(1-n)+0.8, 0.4, 0.4, $fn=4);
                }
            }
        }
    }
    *#translate([0,0,-30]) union() {
        cylinder(200, cutsz+tol*s3, cutsz+tol*s3, $fn=6);
        for (an=[0:60:360-60]) rotate([0,0,an]) translate([50*sqrt(3),0,0])
            cylinder(200, 10+tol*s3, 10+tol*s3, $fn=6);
    }
}

// Return point where the line from pt1 to pt2 intersects plane z=z
// Intersect line from point p1 to point p2 with plane z=-inz
// zf (0 at point p1, 1 at point p2), x = p1.x*zf + p2.x*(1-zf)
// zf = (z-p1.z)/(p2.z-p1.z)
function interpointz(pt1, pt2, z) =
    let (zf = (z-pt1.z)/(pt2.z-pt1.z)) [
     pt1.x + (pt2.x-pt1.x)*zf,
     pt1.y + (pt2.y-pt1.y)*zf,
     z
    ];

function interpointx(pt1, pt2, x) =
    let (xf = (x-pt1.x)/(pt2.x-pt1.x)) [
     x,
     pt1.y + (pt2.y-pt1.y)*xf,
     pt1.z + (pt2.z-pt1.z)*xf,
    ];


module socketholder(holedep, thi, cp=48, tol=0.2)
{
    len1 = 24.8;
    len2 = 34;
    lend = 15.5;
    nlen = 2.5;
    bwid = 30.6;
    nwid = 30.6;
    twid = 41.3;
    hei = 19;
    dia = 10;
    leni = 6.3;
    len3 = len1-1.5-leni;
    iwid = 33.5;
    ihei = 1.6;

    w = twid/2 - dia/2;
    h = hei/2 - dia/2;
    wh = w-h;
    r = dia/2+tol;
    orx = 20+thi;
    ory = 20+thi;

    can = 360/cp;

    // Open front
    *linear_extrude(height=len1+holedep, convexity=5) polygon(concat(
        [for (an=[180:-can: 0]) [ 0+sin(an)*orx, 0+cos(an)*ory ]],
        [for (an=[  0:can: 45]) [ 0+sin(an)*r,   w+cos(an)*r ]],
        [[ hei/2-2, bwid/2],[ hei/2, bwid/2],[ hei/2,-bwid/2],[ hei/2-2,-bwid/2]],
        [for (an=[135:can:180]) [ 0+sin(an)*r,  -w+cos(an)*r ]],
        []
    ));
    // Open side
    san = asin((hei/2+tol)/(20+thi));
    isan = ceil(san/can)*can;
    difference() {
        bwidof = 20+thi - bwid/2;
        union() {
            linear_extrude(height=len2+holedep+0.2, convexity=5) polygon(concat(
                [[ 0+sin(360-san)*orx, 0+cos(360-san)*ory ]],
                [for (an=[360-isan:-can: isan]) [ 0+sin(an)*orx, 0+cos(an)*ory ]],
                [[ 0+sin(san)*orx, 0+cos(san)*ory ]],
                [[ hei/2+tol,-bwid/2-tol], [ hei/2-2+tol,-bwid/2-tol]],
                [for (an=[135:can:225]) [ 0+sin(an)*r,  -w+cos(an)*r] ],
                [[-hei/2+2-tol,-bwid/2-tol],[-hei/2-tol,-bwid/2-tol]],
                //[for (an=[  0:can: 45]) [ 0+sin(an)*r,   w+cos(an)*r ]],
                //[[ hei/2-2, bwid/2],[ hei/2, bwid/2],[ hei/2,-bwid/2],[ hei/2-2,-bwid/2]],
                //[for (an=[135:can:180]) [ 0+sin(an)*r,  -w+cos(an)*r ]],
                []
            ));
            translate([0,0,len2+holedep+0.2]) cylinder(20, 20+thi, 20+thi, $fn=cp);
            if (1) {
                translate([-(hei/2+thi+tol), iwid/2+2, 0]) cube([thi, orx-(iwid/2+2), len2+holedep+10]);
                translate([ (hei/2+tol), iwid/2+2, 0]) cube([thi, orx-(iwid/2+2), len2+holedep+10]);
                translate([-(hei/2+thi/2+tol), iwid/2+2, len2+holedep+tol]) cube([hei+thi, orx-(iwid/2+2), 20]);
                translate([-(hei/2+thi/2+tol), iwid/2+2, 0]) cube([hei+thi, orx-(iwid/2+2), holedep]);
            } else {
                translate([-(hei/2+thi+tol), iwid/2+2.4, len3+leni/2+holedep])
                    rotate([0,90,0]) cylinder(thi, 5, 5, $fn=4);
                translate([ hei/2+thi+tol, iwid/2+2.4, len3+leni/2+holedep])
                    rotate([0,-90,0]) cylinder(thi, 5, 5, $fn=4);
            }

            translate([-hei/2, -twid/2-tol, len1+holedep+0.2]) cube([hei,(twid-bwid)/2, len2-len1+0.2]);

            // Cubes for in socket cutouts
            *#translate([ihei/2+tol,-(twid/2+tol),len3+holedep]) cube([(hei-ihei)/2-1, (twid-iwid)/2, leni]);
            skx = (hei-ihei)/2-3;
            sky = (twid-iwid)/2+1;
            skz = leni;
            translate([ihei/2+tol,-(twid/2+tol+1),len3+holedep]) polyhedron(convexity=3,
                points=[
                    [0,0,0],[skx,0,0],[0,sky,sky],[skx,sky,0],
                    [0,0,skz],[skx,0,skz],[0,sky,skz],[skx,sky,skz]
                ], faces=[
                    [0,1,3],[0,3,2],[1,0,4],[1,4,5],[3,1,5],[3,5,7],
                    [2,3,7],[2,7,6],[0,2,6],[0,6,4],[6,7,5],[6,5,4]
                ]);
            mirror([1,0,0])
            translate([ihei/2+tol,-(twid/2+tol+1),len3+holedep]) polyhedron(convexity=3,
                points=[
                    [0,0,0],[skx,0,0],[0,sky,sky],[skx,sky,0],
                    [0,0,skz],[skx,0,skz],[0,sky,skz],[skx,sky,skz]
                ], faces=[
                    [0,1,3],[0,3,2],[1,0,4],[1,4,5],[3,1,5],[3,5,7],
                    [2,3,7],[2,7,6],[0,2,6],[0,6,4],[6,7,5],[6,5,4]
                ]);
            *translate([ihei/2+tol,-(twid/2+tol),len3+holedep]) cube([(hei-ihei)/2-1, (twid-iwid)/2, leni]);
        }
        translate([0, 20+thi+0.01,len2+holedep+tol]) rotate([90,0,0])
            linear_extrude(height=bwid+bwidof+tol+0.01) polygon([
                [-hei/2-tol,-0.01],[0,hei/2+tol],[hei/2+tol,-0.01]
            ]);
        translate([0, 20+thi+0.01, holedep]) rotate([90,0,0])
            linear_extrude(height=2*(20+thi)+0.02) polygon([
                [-20-thi-0.01, thi-0.01],[-hei/2-thi-tol, thi+(20-hei/2)],
                [-hei/2-thi-tol,len2+thi/sqrt(2)],
                [-thi+10,len2+thi/sqrt(2)+hei/2+10],
                [-thi,len2+30],[-20-thi-0.01,len2+30]
            ]);
        translate([-(hei/2+thi+tol+0.01), iwid/2+2.4, len3+leni/2+holedep]) rotate([0,90,0]) cylinder(thi+0.02, 1.5, 1.5, $fn=24);
        translate([ hei/2+thi+tol+2.01, iwid/2+2.4, len3+leni/2+holedep]) rotate([0,-90,0]) cylinder(thi+2.02, 1.5, 1.5, $fn=24);
        *translate([-(hei-4)/2,-(twid/2+tol),len3+holedep]) cube([hei-4, (twid-iwid)/2, leni]);
        *translate([0, 0, len3+holedep+leni-0.01]) linear_extrude(height=0.21) polygon([
            [-(hei/2+tol-2),-(bwid/2+tol)],[ (hei/2+tol-2),-(bwid/2+tol)],
            [2, -twid/2-tol], [-2, -twid/2-tol]
        ]);
    }
}

module socketclipplace()
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    holeof = 58;
    holedep = 20;

    translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),0]) {
        translate([0,0,holedep]) socketclip(thi, cp=120);
    }
}

module socketclip(thi=3, cp=120, tol=0.2)
{
    len1 = 24.8;
    len2 = 34;
    lend = 15.5;
    nlen = 2.5;
    bwid = 30.6;
    nwid = 30.6;
    twid = 41.3;
    hei = 19;
    dia = 10;
    leni = 6.3;
    len3 = len1-1.5-leni;
    iwid = 33.5;
    ihei = 1.6;

    w = twid/2 - dia/2;
    h = hei/2 - dia/2;
    wh = w-h;
    r = dia/2+tol;
    orx = 20+thi;
    ory = 20+thi;

    can = 360/cp;

    difference() {
        union() {
            san = asin((hei/2)/(20+thi));
            isan = ceil(san/can)*can;
            translate([0,0,tol])
            linear_extrude(height=len1+tol, convexity=5) polygon(concat(
                [[ (hei/2), ory ]],
                [[-(hei/2), ory ]],
                [[-(hei/2), bwid/2+tol], [-(hei/2-2+tol), bwid/2+tol]],
                [for (an=[-45:can:45]) [ 0+sin(an)*r,   w+tol+cos(an)*r] ],
                [[ (hei/2-2+tol), bwid/2+tol],[ (hei/2), bwid/2+tol]],
                []
            ));
            bhei = ory-bwid/2-tol;
            rotate([ 0,-90,90]) translate([0,0,-ory]) linear_extrude(height=bhei, convexity=5)
                polygon([
                    [len1+tol,-hei/2],[len2-tol,-hei/2],[len2-tol+hei/4,-hei/4],
                    [len2,0],[len2-tol+hei/4,hei/4],[len2-tol,hei/2],[len1+tol,hei/2]
                ]);
            translate([ihei/2+tol,iwid/2+tol,len3]) cube([(hei-ihei)/2-1, (twid-iwid)/2, leni]);
            mirror([1,0,0])
            translate([ihei/2+tol,iwid/2+tol,len3]) cube([(hei-ihei)/2-1, (twid-iwid)/2, leni]);
        }
        translate([hei/2+0.01, iwid/2+2.4, len3+leni/2]) rotate([0,-90,0]) cylinder(hei/2, 1.2, 1.2, $fn=24);
        translate([-hei/2-0.01, iwid/2+2.4, len3+leni/2]) rotate([0,90,0]) cylinder(hei/2, 1.2, 1.2, $fn=24);
        translate([0,0,tol-0.01]) cylinder(15, 20, 0, $fn=cp);
    }
}

module socket(cp=48)
{
    len1 = 24.8;
    len2 = 34;
    lend = 15.5;
    nlen = 2.5;
    bwid = 30.6;
    nwid = 30.6;
    twid = 41.3;
    hei = 19;
    thi = 1.8;
    dia = 10;

    leni = 6.3;
    len3 = len1-1.5-leni;
    iwid = 33.5;
    ihei = 1.6;

    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);
    holeof = 58;
    holedep = 20;

    tcp = cp+6;

    translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),00]) {
        translate([0,0,holedep]) difference() {
            union() {
                polyhedron(convexity = 6,
                    points = concat(
                        socket_outline(len2, twid, hei, dia, cp),
                        socket_outline(   0, twid, hei, dia, cp),
                        socket_outline(   0, twid-thi*2, hei-thi*2, dia-thi*2, cp),
                        socket_outline(lend, twid-thi*2, hei-thi*2, dia-thi*2, cp),
                        []
                    ), faces = concat(
                        [[for (p=[0:tcp-1]) p]],
                        [for (l=[0:2]) each nquads(tcp*l, tcp, tcp)],
                        [[for (p=[tcp-1:-1:0]) p+3*tcp]],
                        []
                    )
                );
                // Notchy bits
                linear_extrude(height=len1) polygon([
                    [-hei/2,-bwid/2],[-hei/2,-bwid/2+dia/2],[-hei/2+dia/3,-bwid/2]
                ]);
                mirror([1,0,0]) linear_extrude(height=len1) polygon([
                    [-hei/2,-bwid/2],[-hei/2,-bwid/2+dia/2],[-hei/2+dia/3,-bwid/2]
                ]);
                mirror([0,1,0]) {
                    linear_extrude(height=len1) polygon([
                        [-hei/2,-bwid/2],[-hei/2,-bwid/2+dia/2],[-hei/2+dia/3,-bwid/2]
                    ]);
                    mirror([1,0,0]) linear_extrude(height=len1) polygon([
                        [-hei/2,-bwid/2],[-hei/2,-bwid/2+dia/2],[-hei/2+dia/3,-bwid/2]
                    ]);
                }
            }

            // Backside
            translate([-hei/2-0.01,bwid/2,len1]) cube([hei+0.02, (twid-bwid)/2+0.01, len2-len1+0.01]);
            mirror([0,1,0])
            translate([-hei/2-0.01,bwid/2,len1]) cube([hei+0.02, (twid-bwid)/2+0.01, len2-len1+0.01]);

            // plug holes
            translate([0, 9,lend-0.01]) cylinder(len2-lend+0.02, 4.5/2, 4.5/2, $fn=30);
            translate([0,-9,lend-0.01]) cylinder(len2-lend+0.02, 4.5/2, 4.5/2, $fn=30);

            // Cutouts
            translate([ihei/2,iwid/2,len3]) cube([(hei-ihei)/2+0.01, (twid-iwid)/2+0.01, leni]);
            mirror([0,1,0])
            translate([ihei/2,iwid/2,len3]) cube([(hei-ihei)/2+0.01, (twid-iwid)/2+0.01, leni]);
            mirror([1,0,0]) {
                translate([ihei/2,iwid/2,len3]) cube([(hei-ihei)/2+0.01, (twid-iwid)/2+0.01, leni]);
                mirror([0,1,0])
                translate([ihei/2,iwid/2,len3]) cube([(hei-ihei)/2+0.01, (twid-iwid)/2+0.01, leni]);
            }
        }
    }
}

// Elongated hexagon with rounded corners
function socket_outline(z, wid, hei, dia, cp) =
    let (w = wid/2-dia/2,
         h = hei/2-dia/2,
         wh = w-h,
         r = dia/2)
    concat(
        [for (an=[ 90:360/cp:135]) [ h+sin(an)*r,-wh+cos(an)*r, z]],
        [for (an=[135:360/cp:225]) [ 0+sin(an)*r, -w+cos(an)*r, z]],
        [for (an=[225:360/cp:270]) [-h+sin(an)*r,-wh+cos(an)*r, z]],
        [for (an=[270:360/cp:315]) [-h+sin(an)*r, wh+cos(an)*r, z]],
        [for (an=[315:360/cp:405]) [ 0+sin(an)*r,  w+cos(an)*r, z]],
        [for (an=[405:360/cp:450]) [ h+sin(an)*r, wh+cos(an)*r, z]]
    );

function nquads(s, n, o, es=0) = [for (i=[0:n-1-es]) each [
    [s+(i+1)%n,s+i,s+(i+1)%n+o],
    [s+(i+1)%n+o,s+i,s+i+o]
]];

module receptacle_model()
{
    difference() {
        cubesz = 130;
        tetsz = 200;
        tety = tetsz/sqrt(2);
        tetx = tety*2/sqrt(3);
        tetz = tetsz/sqrt(3);
        union() {
            // tetz - translate.z
            // tetsz/s3 - tetsz/s3/4 - 4*s3
            // tetsz/s3/3
            //color("#ab8") translate([0,0,-tetsz/sqrt(3)/4-4*sqrt(3)]) 
            color("#ab8") translate([0,0,58.5*sqrt(3) - tetz]) 
            polyhedron(
                points=[
                    [0,0,tetz],[tetx,0,0],[-tetx/2,-tety,0],[-tetx/2,tety,0],
                    [0,0,-tetz*2],[-tetx,0,-tetz],[tetx/2,tety,-tetz],[tetx/2,-tety,-tetz],
                    []
                ],
                faces=[
                    //[0,1,2],[0,3,1],[0,2,3],
                    //[1,3,2],
                    //[4,6,5],[4,5,7],[4,7,6],
                    //[5,6,7],
                    [0,1,7,2],[0,3,6,1],[0,2,5,3],
                    [3,5,6],[1,6,7],[2,7,5],
                    [5,7,6],
                    []
                ]
                );
            color("#bca") 
                rotate([45,asin(1/s3),0]) cube(cubesz, true);
        }
        cutsz = 50*sqrt(3);
        excutsz = 10.5;
        tol = 1;
        translate([0,0,-30]) {
            cylinder(200, cutsz+tol*sqrt(3), cutsz+tol*sqrt(3), $fn=6);
            for (an=[0:60:360-60]) rotate([0,0,an]) translate([50*sqrt(3),0,0])
                cylinder(200, 10+tol, 10+tol, $fn=6);
        }
        *translate([0,0,35]) rotate([45,asin(1/s3),0]) cube(cubesz, true);
        *for (an=[0:120:360-1]) rotate([0,0,an]) translate([50*sqrt(3),0,40.7])
            rotate([45,asin(1/s3),0]) cube(16, true);
        // TODO
        *for (an=[60:120:360-1]) rotate([0,0,an]) translate([50*sqrt(3)+5,0,-19])
            rotate([45,-asin(1/s3),0]) cube(12.4, true);
        *for (an=[00:120:360-1]) rotate([0,0,an]) translate([110,20,-30])
            rotate([0,90,60]) cylinder(80,20,20,$fn=cp);
        holeof = 28;
        holedep = 40;
        for (an=[00:120:360-1]) rotate([0,0,an]) translate([tetx-holeof/sqrt(2),0,58.5*sqrt(3)-tetz- holeof])
            rotate([0,-90+asin(1/s3),00])
            translate([0,0,-0.01]) cylinder(holedep + 0.01,20,20,$fn=cp);
    }
}

module plugclipplace()
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    thi = 3;

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    holeof = 58;
    holedep = 20;

    translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),0]) {
        translate([0,0,holedep]) plugclipt(thi, cp=120);
        translate([0,0,holedep]) plugclipb(thi, cp=120);
    }
}

module plugclipt(thi=3, cp=48, tol=0.2)
{
    union() {
        intersection() {
            plugclip(thi, cp, tol);
            translate([0,-30,0]) cube([10, 60, 40]);
        }
        translate([ 0.01,-17, 7]) rotate([0,-90,0]) cylinder(2.01, 2, 1.8, $fn=cp);
        translate([ 0.01,-12,20]) rotate([0,-90,0]) cylinder(2.01, 2, 1.8, $fn=cp);
        translate([ 0.01, 17, 7]) rotate([0,-90,0]) cylinder(2.01, 2, 1.8, $fn=cp);
        translate([ 0.01, 15,20]) rotate([0,-90,0]) cylinder(2.01, 2, 1.8, $fn=cp);
    }
}

module plugclipb(thi=3, cp=48, tol=0.2)
{
    difference() {
        intersection() {
            plugclip(thi, cp, tol);
            translate([-10,-30,0]) cube([10, 60, 40]);
        }
        translate([ 0.01,-17, 7]) rotate([0,-90,0]) cylinder(2.01, 2.1, 2.1, $fn=cp);
        translate([ 0.01,-12,20]) rotate([0,-90,0]) cylinder(2.01, 2.1, 2.1, $fn=cp);
        translate([ 0.01, 17, 7]) rotate([0,-90,0]) cylinder(2.01, 2.1, 2.1, $fn=cp);
        translate([ 0.01, 15,20]) rotate([0,-90,0]) cylinder(2.01, 2.1, 2.1, $fn=cp);
    }
}

module plugclip(thi, cp=48, tol=0.2)
{
    len1 = 24.8;
    len2 = 34;
    lend = 15.5;
    nlen = 2.5;
    bwid = 30.6;
    nwid = 30.6;
    twid = 41.3;
    hei = 19;
    dia = 10;
    leni = 6.3;
    len3 = len1-1.5-leni;
    iwid = 33.5;
    ihei = 1.6;

    w = twid/2 - dia/2;
    h = hei/2 - dia/2;
    wh = w-h;
    r = dia/2+tol;
    orx = 20+thi;
    ory = 20+thi;

    can = 360/cp;

    difference() {
        union() {
            san = asin((hei/2)/(20+thi));
            isan = ceil(san/can)*can;
            translate([0,0,tol])
            linear_extrude(height=len1-tol, convexity=5) polygon(concat(
                [[ (hei/2), ory ]],
                [[-(hei/2), ory ]],
                [[-(hei/2), -bwid/2+tol], [-(hei/2-2+tol), -bwid/2+tol]],
                [for (an=[-45:can:45]) [ 0+sin(an)*r, -w+tol-cos(an)*r] ],
                [[ (hei/2-2+tol), -bwid/2+tol],[ (hei/2), -bwid/2+tol]],
                []
            ));
            bhei = ory-bwid/2-tol;
            rotate([ 0,-90,90]) translate([0,0,-ory]) linear_extrude(height=bhei, convexity=5)
                polygon([
                    [len1-tol,-hei/2],[len2-tol,-hei/2],[len2-tol+hei/4,-hei/4],
                    [len2,0],[len2-tol+hei/4,hei/4],[len2-tol,hei/2],[len1-tol,hei/2]
                ]);
        }
        translate([ihei/2+tol,-twid/2-tol,len3-tol/2]) cube([(hei-ihei)/2-2, (twid-iwid)/2+tol*3, leni+tol]);
        mirror([1,0,0])
        translate([ihei/2+tol,-twid/2-tol,len3-tol/2]) cube([(hei-ihei)/2-2, (twid-iwid)/2+tol*3, leni+tol]);
        translate([hei/2+0.01, iwid/2+2.4, len3+leni/2]) rotate([0,-90,0]) cylinder(hei+0.02, 1.2, 1.2, $fn=24);
        translate([0,0,tol-0.01]) cylinder(15, 20, 0, $fn=cp);

        translate([0,2,0.01]) {
            minkowski() {
                cylinder(len1+0.02, 12.5/2+tol, 12.5/2+tol, $fn=cp);
                cube([0.001, 8, 0.001], true);
            }
            translate([0,0,11+4.2/2]) cube([15+tol,35+tol,4.2+tol], true);
        }
    }
}

module tubeendplace()
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder

    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);

    holeof = 58;
    holedep = 20;

    translate([tetx-holeof/sqrt(2),0,tetof-tetz- holeof]) rotate([0,-90+asin(1/s3),0]) {
        translate([0,0,0]) tubeend(cp=120);
    }
}

module tubeend(cp=48)
{
    holedep = 20;
    holedia = 40;
    tubedia = 31;
    tubethi = 1;
    tol = 0.6;
    enddia1 = holedia - tol*2;
    enddia2 = tubedia + tubethi*2;

    exdia = 36;
    exins = 6;

    thi = 6;
    inthi = 1.2;

    ccen = (enddia1+enddia2)/4;
    cdia = (enddia1-enddia2)/4;

    bev = 0.4;
    outie = 10;

    union() {
        rotate_extrude(convexity = 5, $fn=cp) {
            polygon([
                [ enddia1/2, 0], [ enddia2/2,0],
                [ enddia2/2, holedep-thi ], [tubedia/2, holedep-thi],
                [ tubedia/2, -outie+bev], [ tubedia/2-bev, -outie],
                [ tubedia/2-inthi+0.2, -outie], [ tubedia/2-inthi, -outie+0.2],
                [ tubedia/2-inthi, holedep-exins],
                [ exdia/2, holedep], [enddia1/2-bev, holedep],
                [ enddia1/2, holedep-bev]
            ]);
        }
        for (an=[0:30:360-30]) rotate([0,0,an]) {
            difference() {
                intersection() {
                    translate([enddia2/2-7.3, 0, -outie]) rotate([0,30,0]) cylinder(40, 4, 4, $fn=cp);
                    translate([0,0,-outie]) cylinder(outie+0.01, enddia1/2, enddia1/2, $fn=cp);
                }
                translate([0,0,-outie-0.01]) cylinder(outie+0.03, enddia2/2+0.4, enddia2/2, $fn=cp);
            }
        }
    }
}

module powerplug_f()
{
    tetsz = 200;
    tetof = 58.5*sqrt(3); // Top point of tetraeder
    tety = tetsz/sqrt(2);
    tetx = tety*2/sqrt(3);
    tetz = tetsz/sqrt(3);
    holeof = 58;
    holedep = 20;
    translate([tetx-holeof/sqrt(2),0,tetof-tetz-holeof]) rotate([0,asin(1/s3)-90,0])
        translate([0,2,holedep+11]) rotate([0,0,90]) {
        color("#543") difference() {
            translate([0,0,4.2/2]) cube([35, 15, 4.2], true);
            translate([ 14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
            translate([-14, 0, -0.01]) cylinder(4.22, 1.5, 1.5, $fn=24);
        }
        color("#543") translate([0,0,-0.9]) {
            minkowski() {
                cylinder(14.6, 12.5/2, 12.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
        }
        color("#cce") translate([ 4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);
        color("#cce") translate([-4.2, 2.7, 17.7]) cube([3.3, 0.7, 8], true);

        pluglen = 32.5;
        *color("#975") translate([0, 0, -pluglen]) {
            minkowski() {
                cylinder(pluglen, 10.5/2, 10.5/2, $fn=48);
                cube([8, 0.001, 0.001], true);
            }
            *translate([0, -4, 7.5]) rotate([90,0,0]) cylinder(20, 7.5, 5, $fn=48);
        }
    }
}

