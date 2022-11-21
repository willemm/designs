doitem = "";

hexdia = 64.4;
hexside = 8.2;
labelw = 110;
labelside = 0.8;

hexin = 2;

thick = 5.6;
slit = 0.8;

sawwid = 1.2;

inlay = 0.2;

//magnetsize = [1.8, 9.8, 4.8];
magnetsize = [5, 5, 5];

//magnetoff = magnetsize.x/2+sawwid;
magnetoff = magnetsize.x/2+sawwid;

if (doitem == "labeltop") { hexlabeltop(); }
if (doitem == "labelbot") { hexlabelbot(); }

if (doitem == "") {
    translate([hexdia/2, 0, 0]) {
        hexlabelbot();
        *color("#6af") translate([0,0,thick+0.1]) rotate([180,0,0]) hexlabeltop();

        /*
        translate([labelw+hexdia+1,hexdia*sqrt(3)/3+1,thick]) rotate([0,180,0]) {
            hexlabelbot();
            color("#6af") translate([0,0,thick+0.1]) rotate([180,0,0]) hexlabeltop();
        }
        translate([0,2*(hexdia*sqrt(3)/3+1), 0]) {
            hexlabelbot();
            color("#6af") translate([0,0,thick+0.1]) rotate([180,0,0]) hexlabeltop();
        }
        */

        *translate([-(hexdia/2-magnetoff), 0, thick/2]) magnet();
        //*translate([ (hexdia/2-magnetoff), 0, thick/2]) magnet();
        *translate([ (hexdia/2+labelw+hexside-magnetoff), 0, thick/2]) magnet();
    }
}

module hexlabelbot()
{
    sof = hexdia/sqrt(3)/2-1;
    st = thick/2-1;
    sof2 = labelw-2;
    difference() {
        union() {
            hexlabel();
            // Left side
            for (an=[0,60,120]) rotate([0,0,an])
            translate([-(hexdia/2),0,thick/2]) rotate([0,90,0])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof],[st+0.1,-sof]],
                    [for (y=[-3,-2,2,3]) [(y%2 == 0) ? -st : st , y*sof/3]]
                ));

            translate([hexdia/2+1,sof+1,thick/2]) rotate([0,90,-90])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof2],[st+0.1, 0]],
                    [for (y=[0,1,19,20]) [(y%2 == 0) ? st : -st , y*sof2/20]]
                ));
            translate([hexdia/2+1,-sof-1+sawwid,thick/2]) rotate([0,90,-90])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof2],[st+0.1, 0]],
                    [for (y=[0,1,19,20]) [(y%2 == 0) ? st : -st , y*sof2/20]]
                ));
        }
        for (an=[0,60,120]) rotate([0,0,an])
        translate([-(hexdia/2)-0.01,0,thick/2-0.1]) rotate([0,90,0])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.2, sof*2/3],[-st-0.2,-sof*2/3]],
                [for (y=[-2:2]) [(y%2 == 0) ? -st : st , y*sof/3]]
            ));
        translate([hexdia/2+1,sof+1+0.01,thick/2-0.1]) rotate([0,90,-90])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.2, sof2*19/20],[-st-0.2, sof2*1/20]],
                [for (y=[1:19]) [(y%2 == 0) ? st : -st , y*sof2/20]]
            ));
        translate([hexdia/2+1,-sof-1+sawwid+0.01,thick/2-0.1]) rotate([0,90,-90])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.2, sof2*19/20],[-st-0.2, sof2*1/20]],
                [for (y=[1:19]) [(y%2 == 0) ? st : -st , y*sof2/20]]
            ));
        logo();
    }
}

module hexlabeltop()
{
    sof = hexdia/sqrt(3)/2-1;
    st = thick/2-1;
    sof2 = labelw-2;
    difference() {
        union() {
            mirror([0,1,0]) hexlabel();
            // Left side
            for (an=[0,-60,-120]) rotate([0,0,an])
            translate([-(hexdia/2),0,thick/2]) rotate([0,90,0])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof],[st+0.1,-sof]],
                    [for (y=[-2,-1,1,2]) [(y%2 != 0) ? -st : st , y*sof/3]]
                ));

            translate([hexdia/2+1,sof+1,thick/2]) rotate([0,90,-90])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof2],[st+0.1, 0]],
                    [for (y=[1,2,18,19]) [(y%2 != 0) ? st : -st , y*sof2/20]]
                ));
            translate([hexdia/2+1,-sof-1+sawwid,thick/2]) rotate([0,90,-90])
                linear_extrude(height=sawwid, convexity=5) polygon(concat(
                    [[st+0.1, sof2],[st+0.1, 0]],
                    [for (y=[1,2,18,19]) [(y%2 != 0) ? st : -st , y*sof2/20]]
                ));
        }
        for (an=[0,-60,-120]) rotate([0,0,an])
        translate([-(hexdia/2)-0.01,0,thick/2-0.1]) rotate([0,90,0])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.1, sof*2/3],[-st-0.1,-sof*2/3]],
                [for (y=[-3:3]) [(y%2 != 0) ? -st : st , y*sof/3]]
            ));
        translate([hexdia/2+1,sof+1+0.01,thick/2-0.1]) rotate([0,90,-90])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.1, sof2*19/20],[-st-0.1, sof2*1/20]],
                [for (y=[0:20]) [(y%2 != 0) ? st : -st , y*sof2/20]]
            ));
        translate([hexdia/2+1,-sof-1+sawwid+0.01,thick/2-0.1]) rotate([0,90,-90])
            linear_extrude(height=sawwid+0.02, convexity=5) polygon(concat(
                [[-st-0.1, sof2*19/20],[-st-0.1, sof2*1/20]],
                [for (y=[0:20]) [(y%2 != 0) ? st : -st , y*sof2/20]]
            ));
        logo();
    }
}

module logo()
{
    translate([hexdia/2+labelw+2, 0, -0.01]) mirror([0,1,0]) rotate([0,0,-90])
        linear_extrude(height=inlay+0.01, convexity=4) {
            text("ACME", font="ethnocentric", size=4, halign="center");
        }
    sz = 10;
    stp = sz/15;
    translate([hexdia+labelw-6, 0, -0.01]) linear_extrude(height=inlay+0.01, convexity=4) {
        for (y=[sz-stp:-stp*2:0]) polygon([
            [-y*sqrt(3),y],[-(y+stp)*sqrt(3),y+stp],
            [-(y+stp)*sqrt(3),-(y+stp)],[-y*sqrt(3),-y],
            ]);
    }
}

module hexlabel()
{
    hxr = hexdia/sqrt(3);
    hxir = (hexdia-hexside*2)/sqrt(3);
    hin = hexside-hexin;
    hxsr = (hexdia-hin*2)/sqrt(3);
    difference() {
        linear_extrude(height=thick/2, convexity=5) difference() {
            polygon(points=concat(
                [for (an=[30:60:360-30]) [cos(an)*hxr, sin(an)*hxr]],
                [[cos(360-30)*hxr+labelw, sin(360-30)*hxr]
                ,[hexdia+labelw, 0]
                ,[cos(30)*hxr+labelw, sin(30)*hxr]],
                [for (an=[30:60:360-30]) [cos(an)*hxir, sin(an)*hxir]],
                [[cos(360-30)*hxr+labelside, sin(360-30)*hxr+hexside]
                ,[cos(360-30)*hxr+labelw, sin(360-30)*hxr+hexside]
                ,[cos(30)*hxr+labelw, sin(30)*hxr-hexside]
                ,[cos(30)*hxr+labelside, sin(30)*hxr-hexside]]
            ), paths=[
                range(0,9),
                range(9,6),
                range(15,4)]);
        }
        translate([-(hexdia/2-magnetoff), 0, thick/2]) magnethole();
        translate([ (hexdia/2-magnetoff), 0, thick/2]) magnethole();
        //translate([ (hexdia/2-magnetoff), 0, thick/2]) magnethole();
        //translate([ (hexdia/2+labelw+hexside-magnetoff), 0, thick/2]) magnethole();
        translate([ (hexdia/2+labelw-magnetsize.y/2), (sin(30)*hxr-magnetoff), thick/2])
            rotate([0,0,90]) magnethole();
        translate([ (hexdia/2+labelw-magnetsize.y/2),-(sin(30)*hxr-magnetoff), thick/2])
            rotate([0,0,90]) magnethole();
        translate([0, 0, thick/2-slit/2]) linear_extrude(height=slit/2+0.01, convexity=5)
            polygon(concat(
                [for (an=[30:60:150]) [cos(an)*hxsr, sin(an)*hxsr+2*hin]],
                [for (an=[210:60:360-30]) [cos(an)*hxsr, sin(an)*hxsr]]
                ));
        translate([0, 0, thick/2-slit/2]) linear_extrude(height=slit/2+0.01, convexity=5)
            polygon(
                [[cos(360-30)*hxr+labelside-hexin, sin(360-30)*hxr+hin]
                ,[cos(360-30)*hxr+labelw+hexdia, sin(360-30)*hxr+hin]
                ,[cos(30)*hxr+labelw+hexdia, sin(30)*hxr-hin]
                ,[cos(30)*hxr+labelside-hexin, sin(30)*hxr-hin]]
                );
        llen = (hxr+hxir)/2;
        translate([0,0,-0.01]) linear_extrude(height=inlay+0.01, convexity=4) {
            for (an=[30:60:330]) rotate(an) translate([(hxr+hxir)/2, 0]) {
                rotate(30) {
                    cline(llen, (an+30)/60);
                }
            }
        }
        stp = labelw/10;
        swd = 1.8;
        translate([hexdia/2, sin(30)*hxr-hexside/2, -0.01]) linear_extrude(height=inlay+0.01, convexity=4) {
            for (x=[stp/4:stp:labelw-stp]) {
                polygon([
                    [x+stp*0.3-swd,  swd], [x+stp*0.3+swd, -swd],
                    [x+stp*0.8+swd, -swd], [x+stp*0.8-swd,  swd]
                ]);
            }
        }
        translate([hexdia/2, -sin(30)*hxr+hexside/2, -0.01]) linear_extrude(height=inlay+0.01, convexity=4) {
            for (x=[stp/4:stp:labelw-stp]) {
                polygon([
                    [x+stp*0.3-swd,  swd], [x+stp*0.3+swd, -swd],
                    [x+stp*0.8+swd, -swd], [x+stp*0.8-swd,  swd]
                ]);
            }
        }
    }
}

module cline(len, tp=1, wid=1, dot=2, cir=2.8, cp=60)
{
    circle(cir/2, $fn=cp);
    as = 360/cp;
    if (tp == 2) {
        p1 = len*0.10;
        p2 = len*0.25;
        p3 = len*0.40;
        p4 = len*0.60;
        p5 = len*0.75;
        p6 = len*0.90;
        p7 = len*0.20;
        p8 = len*0.45;
        p9 = len*0.55;
        p10= len*0.80;
        of = wid*1;
        translate([-wid/2, 0]) square([wid,p1]);
        wspline([0,p1], [0, p1+2], [of, p2-2], [of, p2]);
        translate([of-wid/2, p2]) square([wid,p3-p2]);
        wspline([of,p3], [of, p3+4], [-of, p4-4], [-of, p4]);
        translate([-of-wid/2, p4]) square([wid,p5-p4]);
        wspline([-of,p5], [-of, p5+2], [0, p6-2], [0, p6]);
        translate([-wid/2, p6]) square([wid,len-p6]);

        wspline([-of+0.2,p7], [-of,p7+1], [-of, p8-1], [-of+0.4, p8]);
        wspline([ of-0.4,p9], [ of,p9+1], [ of, p10-1], [ of-0.2, p10]);
    }
    if (tp == 1) {
        r2 = dot*3/4+wid/2;
        w2 = wid/2;
        san = 72;
        translate([-wid/2, 0]) square([wid,len/2]);
        translate([0, len/2]) {
            circle(dot/2, $fn=cp);
            warc(-san, as, san, r2, w2);
        }
        translate([-wid/2, len/2+dot]) square([wid,len/2-dot]);
    }
    if (tp == 3) {
        r2 = dot*3/4+wid/2;
        w2 = wid/2;
        p1 = len*0.28;
        p2 = len*0.68;
        san = 72;
        translate([-wid/2, 0]) square([wid,p1]);
        translate([0, p1]) {
            circle(dot/2, $fn=cp);
            warc(-san, as, san, r2, w2);
            for (an=[-50:25:50]) {
                rotate(an) translate([0,dot+1.4]) circle(wid/2, $fn=cp);
            }
        }
        translate([0, p2]) {
            circle(dot/2, $fn=cp);
            warc(-san, as, san, r2, w2);
            for (an=[-50:50:50]) {
                rotate(an) translate([0,-dot]) circle(wid/2, $fn=cp);
            }
        }
        translate([-wid/2, p2+dot]) square([wid,len-p2-dot]);

        /*
        p1 = len*0.15;
        p2 = len*0.40;
        p3 = len*0.80;
        p4 = len*0.70;
        l1 = len*0.1;
        of = -wid*1.5;
        translate([-wid/2, 0]) square([wid,p1]);
        wspline([0,p1], [0,p1+l1], [-wid*1.5,p2-l1], [-wid*1.5,p2]);
        translate([of-wid/2, p2]) square([wid,p3-p2]);
        translate([of, p3]) circle(wid/2, $fn=cp);
        translate([-wid/2, p4]) square([wid,len-p4]);
        translate([0, p4]) circle(wid/2, $fn=cp);
        */
    }
    if (tp == 4) {
        stp = len/10;
        s1 = stp*1.5;
        s2 = len-stp*1.5;
        of = wid*1.5;
        translate([-wid/2, 0]) square([wid, s1]);
        wspline([0, s1], [0, s1+of], [of, (stp*2+stp)-of], [of,(stp*2+stp)]);
        translate([of, stp*3]) circle(wid/2, $fn=cp);
        for (s=[stp*2:stp:len-stp*4]) {
            translate([-of, s]) circle(wid/2, $fn=cp);
            wspline([-of, s], [-of, s+of], [of, (s+stp*2)-of], [of,(s+stp*2)]);
            translate([ of, s+stp*2]) circle(wid/2, $fn=cp);
        }
        translate([-of, len-stp*3]) circle(wid/2, $fn=cp);
        wspline([0, s2], [0, s2-of], [-of, len-(stp*2+stp-of)], [-of,len-(stp*2+stp)]);
        translate([-wid/2, s2]) square([wid, len-s2]);
    }
    if (tp == 6) {
        p1 = len*0.15;
        p2 = len*0.30;
        p3 = len*0.70;
        p4 = len*0.85;
        p5 = len*0.33;
        p6 = len*0.67;
        of1 = 3.6;
        of2 = -2.9;
        translate([-wid/2, 0]) square([wid, p1]);
        wspline([0, p1], [0, p1+2], [of1, p2-2], [of1, p2]);
        translate([of1-wid/2, p2]) square([wid, p3-p2]);
        translate([of1, p3]) circle(wid/2, $fn=cp);
        translate([of2-wid/2, p2]) square([wid, p3-p2]);
        translate([of2, p2]) circle(wid/2, $fn=cp);
        wspline([of2, p3], [of2, p3+2], [0, p4-2], [0, p4]);
        translate([-wid/2, p4]) square([wid, len-p4]);

        translate([(of1+of2)/2, p5]) circle(cir/2, $fn=cp);
        //translate([-wid/2, p5]) square([wid, p6-p5]);
        translate([(of1+of2)/2, p6]) circle(cir/2, $fn=cp);
    }
    if (tp == 5) {
        r2 = dot*3/4+wid/2;
        w2 = wid/2;
        san = 72;
        p1 = len/3;
        p2 = len*2/3;
        translate([-wid/2, 0]) square([wid,p1]);
        translate([0, p1]) {
            circle(dot/2, $fn=cp);
            warc(-san, as, san, r2, w2);
        }
        translate([-wid/2, p1+dot]) square([wid,p2-p1-dot*2]);
        translate([0, p2]) {
            circle(dot/2, $fn=cp);
            warc(180-san, as, 180+san, r2, w2);
        }
        translate([-wid/2, p2]) square([wid,len-p2]);
    }
}

module warc(san, as, ean, r2, w2)
{
    r1 = r2-w2;
    r3 = r2+w2;
    polygon(concat(
        [for (an=[san: as: ean]) [sin(an)*r1, cos(an)*r1]],
        [for (an=[ean+180+as:-as:ean-as]) [sin(ean)*r2+sin(an)*w2, cos(ean)*r2+cos(an)*w2]],
        [for (an=[ean:-as:san]) [sin(an)*r3, cos(an)*r3]],
        [for (an=[san+as:-as:san-180-as]) [sin(san)*r2+sin(an)*w2, cos(san)*r2+cos(an)*w2]],
        []
    ));
}

module wspline(p1, p2, p3, p4, wid=1, cp=20)
{
    of = [0.001,0];
    minkowski() {
        polygon(concat(
            spline(p1+of,p2+of,p3+of,p4+of,cp),
            spline(p4-of,p3-of,p2-of,p1-of,cp)
        ));
        circle(wid/2, $fn=60);
    }
}

function spline(p1, p2, p3, p4, cp=10) = [for (t=[0:1/cp:1])
    let(
        p12 = t*p1+(1-t)*p2,
        p23 = t*p2+(1-t)*p3,
        p34 = t*p3+(1-t)*p4,
        p13 = t*p12+(1-t)*p23,
        p24 = t*p23+(1-t)*p34) (t*p13+(1-t)*p24)
];

function range(f, t) = [for (i = [f:(f+t-1)]) i];

module magnethole()
{
    cube(magnetsize, true);
}

module magnet()
{
    cube(magnetsize, true);
}
