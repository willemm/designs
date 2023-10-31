doitem = "";

outer_dia = 188;
def_cp = 60;

choff = 1.5;
hmof = 10.4;
holeof = 2.2;

baseholes = [39,42,81,99];
capholes = [33,44,86,87];
cappins = [10,19,78,95];

humidang = 20;

postthi = 3;
prad = 16;
jackout = 2;
jackhi = 25;

if (doitem == "inner_base") { inner_base(cp=240); } 
if (doitem == "inner_cap") { rotate([180,0,45]) inner_cap(cp=240); } 
if (doitem == "inner_post") { inner_post(cp=240); } 
if (doitem == "outer_base") { outer_base(cp=240); } 
if (doitem == "") {
    //translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
    *color("#c46") translate([0,0,160]) rotate([0,90,0]) rotate([0,0,-15]) brainL();
    *color("#c46") translate([0,0,160]) rotate([0,-90,0]) rotate([0,0,15]) brainR();

    *color("#86c") inner_post(cp=60);

    *color("#68c") inner_base(cp=60, solid=true);
    *color("#97c") inner_cap(cp=60);
    *translate([0,0,0])  {
        color("#68c") render(convexity=10) inner_base(cp=60);
        color("#86c") render(convexity=10) inner_cap(cp=60);
        rotate([0,0,90]) {
            color("#68c2") render(convexity=10) inner_base(cp=60);
            color("#86c2") render(convexity=10) inner_cap(cp=60);
        }
        rotate([0,0,180]) {
            color("#68c") render(convexity=10) inner_base(cp=60);
            color("#86c") render(convexity=10) inner_cap(cp=60);
        }
        rotate([0,0,270]) {
            color("#68c2") render(convexity=10) inner_base(cp=60);
            color("#86c2") render(convexity=10) inner_cap(cp=60);
        }
    }

    *color("#cc53") jackplugs_in();
    *color("#ccc5") render(convexity=5) glassjar();
    *color("#cc53") jackplugs_out();

    color("#789") render(convexity=10) outer_base();
    *color("#4a93") rotate([0,0,90]) render(convexity=10) outer_base();
    *color("#47c3") rotate([0,0,180]) render(convexity=10) outer_base();
    *color("#4a93") rotate([0,0,270]) render(convexity=10) outer_base();

    *color("#789") outer_base();
    *color("#789") outer_base_section();


    *color("#5954") translate([00,00,-26.2]) cube([250,200,2],true);
}

module outer_base(cp=def_cp)
{
    thick = 20;
    numedg = 12;
    stp = 32;
    bot = 25;
    bthi = 3;
    parts = 4;

    irad = outer_dia/2;
    orad = irad+thick;

    difference() {
        circles = generate_facet_circles(numedg, stp, orad, -bot, 30, 6);
        ci = numedg*(len(circles)-2);
        cc = numedg*len(circles);

        // Points spiral because of the way it's setup.
        // Therefore some complicated trickery is needed to get the partial side
        polyhedron(convexity=10
            , points = concat([for (circ=circles) each circX(circ[0], circ[1], circ[3], numedg) ],
                [[0, 0, 35], [0,0,-bot]])
            , faces = concat(
                [concat(cc+1, [for (an=[numedg/parts-circles[0][3]:-1:-circles[0][3]]) an])],
                [for (l=[0:len(circles)-2], an=[-circles[l][3]:numedg/parts-circles[l][3]-1])
                    [l*numedg+an,l*numedg+an+1,(l+1)*numedg+an]],
                [for (l=[0:len(circles)-3], an=[-circles[l+1][3]+1:numedg/parts-circles[l+1][3]])
                    [l*numedg+an,(l+1)*numedg+an,(l+1)*numedg+an-1]],
                [[-circles[0][3], cc, cc+1], [numedg/parts-circles[0][3], cc+1, cc]],
                [for (l=[0:len(circles)-3])
                    [l*numedg-circles[l][3], (l+1)*numedg-circles[l+1][3], cc]],
                [for (l=[0:len(circles)-3])
                    [numedg/parts+(l+1)*numedg-circles[l+1][3], numedg/parts+l*numedg-circles[l][3], cc]],
                [for (l=[-circles[len(circles)-2][3]:numedg/parts-circles[len(circles)-2][3]-1]) each [
                     [ci+l, ci+(l+1)%numedg, ci+l+numedg],
                     [ci+l, ci+l+numedg, cc],
                     [ci+(l+1)%numedg, cc, ci+l+numedg]
                     ]]
            )
        );
        // Jar cutout
        translate([0,0,-bthi]) cylinder(circles[len(circles)-1][0]+0.01+bthi, irad, irad, $fn=cp);
        // *translate([0,0,-bot+2]) cylinder(bot-bthi-1.9, irad-20, irad-20, $fn=8);
        // Bottom cutout
        translate([0,0,-bot+2]) linear_extrude(height=bot-bthi-1.9, convexity=10) polygon([
            [-0.1,-0.1],
            [irad-22,-0.1], [irad-22, 13], [irad-42, 21],
            [irad-32, 44], [irad-20,57],
            [57, irad-20], [44, irad-32],
            [21, irad-42], [13, irad-22], [-0.1, irad-22],
        ]);
        // Feet holes
        for (an=[22.5,67.5]) {
            rotate([0,0,an]) translate([irad-20,0,0]) rotate([0,0,0]) {
                // *rotate([0,0,45]) translate([-10,-10,-bot+2]) cube([20,20, bot-bthi-1.9]);
                // *translate([-5,-5,-bot-0.1]) cube([10,10, 2.2]);
                translate([0,0,-bot+2]) cylinder(bot-bthi-1.9, 7*sqrt(2), 10*sqrt(2), $fn=4);
                translate([0,0,-bot-0.1]) cylinder(2.2, 3, 3, $fn=cp/3);
            }
        }
        // Facet holes.
        holetypes = [
            [],
            [],
            [ 0, 1, 0 ],
            [ 0, 0, 0 ],
            [],
        ];
        // Todo: actually make them fit whatever comes in them (leds, connectors, switches)
        for (c=[2,3]) {
            circ = circles[c];
            for (a=[0:numedg/parts-1]) {
                an = (circ[3]-floor(circ[3]))*(360/numedg)+a*360/numedg;
                rotate ([0,0,an+(360/numedg/2)]) translate([circ[1]*cos(360/numedg/2), 0, circ[0]])
                    rotate([0,270+circ[2],0]) {
                        if (holetypes[c][a] == 0) {
                            // todo
                            translate([0,0,-0.01]) cylinder(33,5,5,$fn=cp/3);
                        }
                        if (holetypes[c][a] == 1) {
                            // Jack socket
                            translate([0,0,-0.01]) cylinder(2,3,3,$fn=cp/3);
                            translate([0,0,1.5]) cylinder(33,5,5,$fn=cp/3);
                            translate([-8,-3,1.5]) cube([8, 6, 20]);
                        }
                    }
            }
        }
        // Cable slot
        rotate([0,0,45]) {
            translate([irad-5, 12, 0]) rotate([90,0,0])
                linear_extrude(height=24) polygon([
                    [0,-bthi-20], [4,-bthi-20], [30,10], [30,60], [0,77]
                ]);
        }
        // Ledstrip slot (strip is 8x2mm)
        translate([0,0,65]) cylinder(8, irad+3, irad+3, $fn=cp);
        translate([0,0,72.99]) cylinder(3, irad+3, irad, $fn=cp);
    }
}

module inner_post(cp=def_cp)
{
    jthi = 20;
    irad = outer_dia/2 - jthi;
    crad = 35.6;
    bhei = 50;
    hei = 150;

    brad = crad/sqrt(2);
    bext = irad-brad;
    difference() {
        union() {
            /*
            // Post
            cylinder(hei, prad, prad, $fn=cp);
            // Inside base
            cylinder(bhei, crad, crad, $fn=cp);
            // Bottom flange
            rotate([0,0,45]) linear_extrude(height=postthi) polygon(concat(
                [for (an=[-15:360/cp:180+15]) [sin(an)*brad+bext, cos(an)*brad]],
                [[0,-6]],
                [for (an=[180-15:360/cp:360+15]) [sin(an)*brad-bext, cos(an)*brad]],
                [[0, 6]]
            ));
            */
            translate([0,0,2]) {
                // Post
                cylinder(hei-2, prad, prad, $fn=cp);
                // Inside base
                cylinder(bhei-4.5, crad, crad, $fn=cp);
            }
            // Outsets for connectors
            if (jackout > 0) {
                for (an=[0:3]) rotate([0,0,an*90]) {
                    *translate([prad-2, 0, bhei+jackhi]) rotate([0,90,0])
                        cylinder(jackout+1.5, 7, 4, $fn=cp/3);
                    translate([prad-2, 0, bhei+jackhi]) polyhedron(convexity=10,
                        points=concat(
                            [for (an=[-90:360/cp: 90]) [0, sin(an)*6, cos(an)*6]],
                            [for (an=[ 90:360/cp:270]) [0, sin(an)*6, cos(an)*6-8]],
                            [for (an=[-90:360/cp: 90]) [jackout+1.5, sin(an)*4, cos(an)*4]],
                            [for (an=[ 90:360/cp:270]) [jackout+1.5, sin(an)*4, cos(an)*4-6]]
                        ), faces = concat(
                            nbot(0, cp+2),
                            nquad(0, cp+2),
                            ntop(1, cp+2)
                        )
                    );
                }
            }
        }
        corad = crad-3;
        cirad = prad;
        // Cutout base
        translate([0,0,3]) for (xa=[90:90:360]) {
            linear_extrude(height=bhei-2.9, convexity=10) polygon(concat(
                [for (an=[ 3: 360/cp:90-3]) [sin(an+xa)*corad, cos(an+xa)*corad]],
                [for (an=[90-3:-360/cp: 3]) [sin(an+xa)*cirad, cos(an+xa)*cirad]]
            ));
        }
        // Cutout middle
        translate([0,0,-0.1]) cylinder(hei+0.2, prad-2, prad-2, $fn=cp);

        // Slits and connector holes for humidifier discs
        for (an=[0:3]) rotate([0,0,an*90]) {
            rotate([0,0,45]) translate([prad-3.5,-2.5,bhei-15]) cube([3.6, 5, 25]);
            translate([prad+jackout,0,bhei+jackhi]) {
                translate([-3.5,0,0]) rotate([0,90,0]) cylinder(3.6, 3, 3, $fn=cp/3);
                if (jackout < 1) {
                    translate([-0.5,0,0]) rotate([0,90,0]) cylinder(1.0,4.5,4.5, $fn=cp/3);
                }
                translate([-2.0,0,0]) rotate([0,-90,0]) cylinder(5.0,5,5, $fn=cp/3);
                translate([-2.0-4,-3,-8]) cube([4, 6, 8]);
            }
        }

        // Drainage holes
        translate([0,0,2]) for (an=[90:90:360]) {
            rotate([0,90,an+3]) {
                translate([-3,3,prad-5]) cylinder(crad-prad+12, 3, 3, $fn=4);
                translate([0,3,prad-5])
                    rotate([0,0,45]) cylinder(crad-prad+12, 3*sqrt(2), 3*sqrt(2), $fn=4);
            }
            rotate([0,90,an-3]) {
                translate([-3,-3,prad-5]) cylinder(crad-prad+12, 3, 3, $fn=4);
                translate([0,-3,prad-5])
                    rotate([0,0,45]) cylinder(crad-prad+12, 3*sqrt(2), 3*sqrt(2), $fn=4);
            }
        }
    }
}

module jackplug()
{
    render(convexity=10) rotate([0,-90,0]) {
        difference() {
            union() {
                cylinder(7.5, 2.9, 2.9, $fn=30);
                translate([0,0,0.6]) cylinder(1.4, 4, 4, $fn=30);
                translate([0,0,3.6]) cylinder(3.9, 4.5, 4.5, $fn=30);
                translate([-7,-3,3.8]) cube([7, 6, 12.7]);
            }
            cylinder(15, 1.75, 1.75, $fn=30);
        }
    }
}

module jackplugs_out(num=1)
{
    numedg = 12;
    stp = 32;
    thick = 20;
    orad = outer_dia/2+thick;
    bot = 25;
    circles = generate_facet_circles(numedg, stp, orad, -bot, 30, 6);
    for (c=[2]) {
        circ = circles[c];
        for (an=[(circ[3]-floor(circ[3])+1)*(360/numedg):90:(circ[3]-floor(circ[3])+(numedg*num/4)-1)*(360/numedg)]) {
            rotate ([0,0,an+(360/numedg/2)]) {
                translate([circ[1]*cos(360/numedg/2)+2, 0, circ[0]]) rotate([0,circ[2],0])
                    jackplug();
            }
        }
    }
}

module jackplugs_in()
{
    bhei = 50;
    for (an=[0:3]) rotate([0,0,an*90]) translate([0,0,bhei+jackhi]) {
        translate([prad+1.5+jackout,0,0]) jackplug();
    }
}

module inner_base(cp=def_cp, solid=false)
{
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 50;
    wad = 47.5;

    hst = 5.8;

    drhei = 2;

    holes = [for (d=[crad+hst-holeof: hst: irad-hst/2])
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
                // Quarter circle block
                polygon(concat(
                    [for (an=[0:360/cp:90]) [sin(an)*irad, cos(an)*irad]],
                    [for (an=[90:-360/cp:0]) [sin(an)*crad, cos(an)*crad]]
                ));
                if (!solid) {
                    // Square holes in block
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
            }
            if (!solid) {
            // Upper block for humidifier element
            intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([-12,-11,-14]) cube([26,22,3]);
                }
                linear_extrude(height=hei, convexity=20)
                    polygon(concat(
                        [for (an=[0:360/cp:90]) [sin(an)*(irad-0.1), cos(an)*(irad-0.1)]],
                        [for (an=[90:-360/cp:0]) [sin(an)*(crad+hst*4.5-holeof), cos(an)*(crad+hst*4.5-holeof)]]
                    ));
            }
            // Lower block for cotton wad
            intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([-13,-5,-14-wad]) cube([21, 10, 4]);
                }
                linear_extrude(height=hei, convexity=20)
                    polygon(concat(
                        [for (an=[0:360/cp:90]) [sin(an)*(irad-0.1), cos(an)*(irad-0.1)]],
                        [for (an=[90:-360/cp:0]) [sin(an)*(crad+hst*6.5-holeof), cos(an)*(crad+hst*6.5-holeof)]]
                    ));

            }
            // Screw hole inserts
            for (h=baseholes) {
                cwid = 5.8;
                chei = 6.5;
                d = holes[h][0];
                an = holes[h][1];
                rotate([0,0,an]) translate([d,0,hei-12]) difference() {
                    translate([-cwid/2,-chei/2,0]) cube([cwid,chei,12]);
                    translate([0,0,-0.01]) cylinder(12.02, 1.3, 1.3, $fn=cp/6);
                    translate([0,0,-0.01]) rotate([0,0,45]) cylinder(4, chei/sqrt(2)+0.1, 1.2, $fn=4);
                }
            }
            }
            // Extra edge for under center post
            linear_extrude(height=2, convexity=20) {
                polygon(concat(
                    [for (an=[15:360/cp:75]) [sin(an)*(crad+1), cos(an)*(crad+1)]],
                    [for (an=[72,18]) [sin(an)*(crad-7), cos(an)*(crad-7)]]
                ));

            }
        }
        // Cutouts for humidifier element
        rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
            translate([0,0,-12]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-11]) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 1, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(22, 10, 10, $fn=cp);
            translate([0,0,-12-wad]) cylinder(wad + 0.1, 4, 4, $fn=cp);
        }
        if (!solid) {
        // Holes at bottom for water flow
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

        }
        // Cutout for humidifier cable
        rotate([0,0,29]) translate([crad-1,0,hei]) rotate([0,90,0]) {
            rotate([0,0,30]) cylinder(irad-crad-17.5, 3, 3, $fn=6);
        }
    }
}

module inner_cap(cp=def_cp)
{
    bhei = 50;
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 2;
    wad = 50;

    hst = 5.8;

    caphi = 22-3;

    holes = [for (d=[crad+hst-holeof: hst: irad-hst/2])
        let(nstp = floor(d/(hst/1.5)),
            stp = (90-choff)/nstp,
            vst = d*3.141/nstp/2,
            fstp = floor(nstp/2),
            by = hst*0.5-0.25,
            bx1 = vst*0.5-0.5,
            bx2 = vst*0.5-0.1)
        for (an=[stp/2-choff/2-fstp*stp:stp:45-stp/2])
            [d, an+(an > 0 ? choff : 0), by, bx1, bx2]
    ];

    translate([0,0,50.1]) difference() {
        union() {
            difference() {
                // Quarter circle plate
                union() {
                    linear_extrude(height=hei, convexity=20) {
                        polygon(concat(
                            [for (an=[45:360/cp:135]) [sin(an)*irad, cos(an)*irad]],
                            [for (an=[135:-360/cp:45]) [sin(an)*(crad-1), cos(an)*(crad-1)]]
                        ));
                    }
                    // Edge to hold center post in place
                    translate([0,0,-2.5]) linear_extrude(height=hei+2.5, convexity=20) {
                        polygon(concat(
                            [for (an=[45:360/cp:135]) [sin(an)*(crad-0.2), cos(an)*(crad-0.2)]],
                            [for (an=[135:-360/cp:45]) [sin(an)*(crad-3), cos(an)*(crad-3)]]
                        ));
                    }
                }
                // Water holes
                for (h=[0:len(holes)-1]) {
                    if (len(search(h, capholes)) == 0) {
                        d = holes[h][0];
                        an = holes[h][1];
                        rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1, 2.9, $fn=cp/6);
                    }
                }
            }
            // Extrusion to hold humidifier
            translate([0,0,-hei]) intersection() {
                rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, hei]) rotate([45,0,4]) {
                    translate([0,0,-caphi+10]) cylinder(caphi+10, 10, 10, $fn=cp);
                }
                translate([50,1,2*hei-30]) cube([50, 50, 30]);
            }
            // Extrusions that fit in base holes
            for (h=cappins) {
                d = holes[h][0];
                an = holes[h][1];
                by = holes[h][2]-0.2;
                bx1 = holes[h][3]-0.2;
                bx2 = holes[h][4]-0.2;
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
        // Screw holes
        for (h=capholes) {
            d = holes[h][0];
            an = holes[h][1];
            rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1.6, 1.6, $fn=cp/6);
        }
        // Hole for humidifier
        rotate([0,0,humidang]) translate([(irad+crad)/2+hmof, 0, 0]) rotate([45,0,4]) {
            translate([0,0,-caphi+9.9]) cylinder(caphi+0.1, 7, 7, $fn=cp);
            translate([0,0,-22+10]) cylinder(4, 10.01, 10.01, $fn=cp);
            translate([0,-5,-8]) rotate([90,0,0]) cylinder(5, 4, 4, $fn=cp);
        }
        // Hole for humidifier cable
        rotate([0,0,29]) translate([crad-4,0,hei-5]) rotate([0,90,0]) {
            rotate([0,0,30]) cylinder(5, 3, 3, $fn=6);
        }
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


// Generate diamond facets going up and inward from a cerrain radius
function generate_facet_circles(numedg, stp, rad, hei, an, num) = (num <= 0) ? [] : let(
    rad1 = cos(360/numedg/2)*rad+stp*sin(an),
    hei1 = hei + stp*cos(an),
    an1 = atan((cos(360/numedg/2)*rad1-rad) / (hei1-hei))
) concat(
    [[hei, rad, an, -num/2]],
    generate_facet_circles(numedg, stp, rad1, hei1, an1, num-1)
);

function circX(z, d, of=0, cp=def_cp) = [for (an=[of*(360/cp):360/cp:(cp+of-1)*(360/cp)])
    [sin(an)*d, cos(an)*d, z]
];

function nquad(l, cp=def_cp) = [for (an=[0:cp-1]) each [
    [l*cp + an, l*cp + (an+1)%cp, (l+1)*cp + an],
    [(l+1)*cp + an, l*cp + (an+1)%cp, (l+1)*cp + (an+1)%cp]
]];

function ntop(l,cp=def_cp) = [[for (an=[0:cp-1]) l*cp+an]];
    
function nbot(l,cp=def_cp) = [[for (an=[cp-1:-1:0]) l*cp+an]];
