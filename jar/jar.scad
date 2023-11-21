doitem = "";

outer_dia = 188;
def_cp = 60;

choff = 1.5;
hmof = 10.4;
holeof = 2.2;

baseholes = [39,42,81,99];
capholes = [33,44,86,87];
cappins = [10,19,78,95];

// Facet holes.
// outled, jack, spinner, button, rocker, rotaryswitch, stopbutton, usbc, usbc, usbc, pot
holetypesmid = [6,6,6,11,2,2,2,7,2,2,2,11];

humidang = 20;

postthi = 3;
prad = 16;
jackout = 2;
jackhi = 35;

if (doitem == "inner_base") { inner_base(cp=240); } 
if (doitem == "inner_cap") { rotate([180,0,45]) inner_cap(cp=240); } 
if (doitem == "inner_post") { inner_post(cp=240); } 
if (doitem == "outer_led_cover") { outer_led_cover(cp=240); } 
if (doitem == "outer_base_n") { outer_base(side=0, cp=240); } 
if (doitem == "outer_base_e") { outer_base(side=1, cp=240); } 
if (doitem == "outer_base_s") { outer_base(side=2, cp=240); } 
if (doitem == "outer_base_w") { outer_base(side=3, cp=240); } 
if (doitem == "inner_base_ring") { inner_base_ring(cp=240); }
if (doitem == "inner_base_foot") { inner_base_foot(); }
if (doitem == "spanner25") { rotate([180,0,0]) pipespanner(size=25); }
if (doitem == "spanner14") { rotate([180,0,0]) pipespanner(size=14); }
if (doitem == "testring_out") { testring_out(); }
if (doitem == "testring_in") { testring_in(); }
if (doitem == "") {
    //translate([-15,-1,300]) rotate([70,0,0]) rotate([0,90,0]) brainL();
    *color("#c46") translate([0,0,160]) rotate([45,90,0]) rotate([0,0,-15]) brainL();
    *color("#c46") translate([0,0,160]) rotate([-45,-90,0]) rotate([0,0,15]) brainR();

    *color("#86c") inner_post(cp=60);
    *color("#86c") render(convexity=10) inner_post(cp=60);

    *color("#68c") inner_base(cp=60, solid=false);
    *color("#97c") inner_base_foot();
    *color("#97c") inner_cap(cp=60, solid=false);
    *translate([0,0,20]) inner_base_ring(cp=60);
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
    *color("#cc53") connectors_out(sides=[0,2]);

    *color("#ccd") outer_led_cover_set();

    *color("#7899") render(convexity=10) outer_base(side=0);
    *color("#4a99") rotate([0,0,90]) render(convexity=10) outer_base(side=1);
    *color("#47c9") rotate([0,0,180]) render(convexity=10) outer_base(side=2);
    *color("#4a99") rotate([0,0,270]) render(convexity=10) outer_base(side=3);

    *for (an=[22.5:45:360]) rotate([0,0,an]) {
        color("#987") outer_foot_stem();
        color("#987") outer_foot();
    }

    *color("#789") outer_base(side=0);
    color("#4a9") rotate([0,0,90]) outer_base(side=1);
    *color("#47c") rotate([0,0,180]) outer_base(side=2);
    *color("#4a9") rotate([0,0,270]) outer_base(side=3);

    *color("#789") outer_base();

    *translate([0,0,30]) testring_in();
    *translate([0,0,30]) testring_out();
    *color("#ccc5") render(convexity=5) glassjar();

    // Build plate size indicartion
    *color("#5954") translate([50,60,-26.2]) cube([250,200,2],true);
}

module outer_base(cp=def_cp, side=0)
{
    numedg = 12;
    thick = 30;
    sang = 28.5;
    stp = 32;
    bot = 25;
    bthi = 3;
    parts = 4;

    irad = outer_dia/2;
    orad = irad+thick;

    difference() {
        circles = generate_facet_circles(numedg, stp, orad, -bot, sang, 6);
        ci = numedg*(len(circles)-2);
        cc = numedg*len(circles);

        circlepoints = [for (circ=circles) each circX(circ[0], circ[1], circ[3], numedg) ];
        render(convexity=10) difference() {

            // Points spiral because of the way it's setup.
            // Therefore some complicated trickery is needed to get the partial side
            union() {
                polyhedron(convexity=10
                , points = concat(circlepoints, [[0, 0, 35], [0,0,-bot]])
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
                         [ci+l, ci+l+numedg, cc],
                         [ci+(l+1)%numedg, cc, ci+l+numedg]
                         ]]
                )
                );
                // Slats to help gluing together
                translate([irad+18,15,47]) rotate([0,-90,0]) linear_extrude(height=4) polygon([
                    [0,0],[17.5,20],[35,0]
                ]);
                translate([irad+18,15,-10]) rotate([0,-90,0]) linear_extrude(height=4) polygon([
                    [0,0],[17.5,20],[35,0]
                ]);
            }
            // Chamfered facet edges
            // I think this will look ugly...
            /*
            *for (l=[1:len(circles)-2], an=[-circles[l][3]:numedg/parts-circles[l][3]-1]) {
                chamferedge([
                    circlepoints[(l+1)*numedg+an],
                    circlepoints[l*numedg+an],
                    circlepoints[(l-1)*numedg+an+1],
                    circlepoints[l*numedg+an+1]
                    ]);
            }
            */
            // Slats to help gluing together
            rotate([0,0,90]) {
                tol = 0.1;
                itol = 0.4;
                translate([irad+18+tol,15,47]) rotate([0,-90,0]) linear_extrude(height=4+tol*2) polygon([
                    [0,-itol],[17.5,20],[35,-itol]
                ]);
                translate([irad+18+tol,15,-10]) rotate([0,-90,0]) linear_extrude(height=4+tol*2) polygon([
                    [0,-itol],[17.5,20],[35,-itol]
                ]);
            }
            // Jar cutout
            translate([0,0,-bthi]) cylinder(circles[len(circles)-1][0]+0.01+bthi, irad+0.5, irad+0.5, $fn=cp);
            // *translate([0,0,-bot+2]) cylinder(bot-bthi-1.9, irad-20, irad-20, $fn=8);
            // Bottom cutout, around feet
            translate([0,0,-bot+2]) linear_extrude(height=bot-bthi-1.9, convexity=10) polygon([
                [-0.1,-0.1],
                [irad-27,-0.1], [irad-42, 35],
                [irad-20,57], [57, irad-20],
                [35, irad-42], [-0.1, irad-27]
            ]);
            // Feet holes
            for (an=[22.5,67.5]) {
                rotate([0,0,an]) translate([irad-20,0,0]) rotate([0,0,0]) {
                    // *rotate([0,0,45]) translate([-10,-10,-bot+2]) cube([20,20, bot-bthi-1.9]);
                    // *translate([-5,-5,-bot-0.1]) cube([10,10, 2.2]);
                    translate([0,0,-bot+2]) rotate([0,0,45]) cylinder(bot-bthi-1.9, 7*sqrt(2), 10*sqrt(2), $fn=4);
                    translate([0,0,-bot-0.1]) cylinder(2.2, 1.8, 1.8, $fn=cp/3);
                }
            }
        }
        holetypes = [
            (side == 2 ? [0, 9, 0] : [ 0, 0, 0 ]),
            (side == 2 ? [0, 8, 0] : [ 0, 0, 0 ]),
            [for (i=[side*3:side*3+2]) holetypesmid[i]],
            [ 1, 1, 1 ],
            [],
        ];
        for (c=[0,2,3]) {
            circ = circles[c];
            for (a=[0:numedg/parts-1]) {
                an = (circ[3]-floor(circ[3]))*(360/numedg)+a*360/numedg;
                rotate ([0,0,an+(360/numedg/2)]) translate([circ[1]*cos(360/numedg/2), 0, circ[0]])
                    rotate([0,270+circ[2],0]) {
                        if (holetypes[c][a] == 0) {
                            // nothing
                        }
                        if (holetypes[c][a] == 1) {
                            // Outward rgb led
                            translate([0,0,-0.01]) cylinder(28.02,11,3.6,$fn=cp/3);
                            translate([0,0,28]) cylinder(8,6,6,$fn=cp/3);
                        }
                        if (holetypes[c][a] == 2) {
                            // Jack socket
                            capped_hole(6, 2, 0.1, cp=cp/3);
                            //translate([0,0,-0.01]) cylinder(2,3,3,$fn=cp/3);
                            translate([0,0,1.5]) rotate([0,0,180/8]) cylinder(33,6,6,$fn=8);
                            translate([-8,-3,1.5]) cube([8, 6, 20]);
                            translate([0,0,10]) rotate([0,0,180/8]) cylinder(31, 14, 14, $fn=8);
                            translate([12,-10.72/2,30]) rotate([0,-circ[2],0]) cube([0.5,10.72,10]);
                        }
                        if (holetypes[c][a] == 3) {
                            // Rotary encoder
                            capped_hole(7.2, 3, cp=cp/3);
                            //translate([0,0,-0.01]) cylinder(3.02,3.6,3.6,$fn=cp/3);
                            translate([-16/2,-13.2/2,3]) cube([16, 13.2, 6.01]);
                            translate([0,0,9]) rotate([0,0,180/8]) cylinder(32, 14, 14, $fn=8);
                            translate([12,-10.72/2,30]) rotate([0,-circ[2],0]) cube([0.5,10.72,10]);
                        }
                        if (holetypes[c][a] == 11) {
                            // potentiometer
                            // translate([0,0,-0.01]) cylinder(3.02,3.6,3.6,$fn=cp/3);
                            capped_hole(7.2, 3, 0.2, cp=cp/3);
                            translate([0,0,3]) cylinder(6.01, 18/2, 18/2, $fn=cp/3);
                            translate([0, -17/2, 3]) cube([18,17,30]);
                            translate([0,0,9]) rotate([0,0,180/8]) cylinder(32, 14, 14, $fn=8);
                            translate([12,-10.72/2,30]) rotate([0,-circ[2],0]) cube([0.5,10.72,10]);
                        }
                        if (holetypes[c][a] == 4) {
                            // Big pushbutton
                            translate([0,0,-0.01]) cylinder(3.02,8,8,$fn=cp/3);
                            translate([0,0,3]) rotate([0,0,180/8]) cylinder(38, 14, 14, $fn=8);
                        }
                        if (holetypes[c][a] == 5) {
                            // Rocker switch
                            translate([0,0,-0.01]) cylinder(10.02,10,10,$fn=cp/3);
                            translate([0,0,10]) rotate([0,0,180/8]) cylinder(32, 14, 14, $fn=8);
                            translate([10,2.2,0]) rotate([90,0,0])
                                linear_extrude(height=4.4) polygon([
                                    [-1, -0.01], [0, -0.01], [1.5, 4], [1.5, 10.01], [-1, 10.01]
                                ]);
                            rotate([0,0,180]) translate([10,2.2,0]) rotate([90,0,0])
                                linear_extrude(height=4.4) polygon([
                                    [-1, -0.01], [0, -0.01], [1.5, 4], [1.5, 10.01], [-1, 10.01]
                                ]);
                            translate([0, 9, -0.01]) linear_extrude(height=10.02) 
                                polygon([[-1.1, 0], [-1.1, 2.1], [1.1, 2.1], [3.0, 0]]);
                        }
                        if (holetypes[c][a] == 6) {
                            // 22mm rotary switch
                            // #translate([0,0,-0.01]) cylinder(3.02,11,11,$fn=cp/3);
                            capped_hole(22, 3, cp=cp/3);
                            translate([0,0,3]) rotate([0,0,180/8]) cylinder(38, 18, 18, $fn=8);
                        }
                        if (holetypes[c][a] == 7) {
                            // 22mm emergency stop
                            capped_hole(22, 3, cp=cp/3);
                            translate([0,0,3]) rotate([0,0,180/8]) cylinder(38, 18, 18, $fn=8);
                        }
                        if (holetypes[c][a] == 8) {
                            // 22mm usb-c connector
                            capped_hole(22, 3, cp=cp/3);
                            translate([0,0,3]) rotate([0,0,180/8]) cylinder(42, 18, 18, $fn=8);
                        }
                        if (holetypes[c][a] == 9) {
                            // 11mm usb-c connector
                            translate([15,0,-0.01]) {
                                intersection() {
                                    //*cylinder(3.02,5.5,5.5,$fn=cp/3);
                                    capped_hole(11, cp=cp/3);
                                    translate([-9.6/2, -11/2, -1]) cube([10, 11, 5]);
                                }
                            }
                            translate([15,0,3]) rotate([0,0,180/8]) cylinder(42, 12.9, 12.9, $fn=8);
                        }
                        if (holetypes[c][a] == 10) {
                            // oblong usb-c connector
                            translate([15,0,-0.01]) {
                                translate([-3.5,-10,0]) cube([7,20,5.01]);
                                translate([-5,-5,0]) cube([10,10,5.01]);
                            }
                            translate([15,0,5-0.01]) {
                                translate([-5,-5,0]) cube([10,10,30]);
                                translate([0, 17.5/2,0]) cylinder(20, 1.3, 1.3, $fn=cp/6);
                                translate([0,-17.5/2,0]) cylinder(20, 1.3, 1.3, $fn=cp/6);
                            }
                        }
                    }
            }
        }
        // Led cable slot
        // Rolled into rgb strip slot
        // *translate([0,0,49]) cylinder(10, irad+3, irad+3, $fn=cp);
        // *translate([0,0,58.99]) cylinder(3, irad+3, irad, $fn=cp);
        // Cable slot
        rotate([0,0,45]) {
            translate([irad-5, 12, 0]) rotate([90,0,0])
                linear_extrude(height=24) polygon([
                    [0,-bthi-20], [4,-bthi-20], [30,10], [30,43], [0,75.5]
                ]);
            translate([irad-5, 12, 0]) rotate([90,0,0])
                linear_extrude(height=4) polygon([
                    [0,72], [20,52], [20,62], [0,82]
                ]);

            translate([irad+2, 0, 1.5]) rotate([-45,0,15]) rotate([0,0,45]) cube([8.5, 8.5, 52]);
            translate([irad+2, 0, 1.5]) rotate([ 45,0,-15]) rotate([0,0,-135]) cube([8.5, 8.5, 52]);
        }
        // Ledstrip slot (strip is 8x2mm)
        // echo ("Circumference of led strip", 2*(irad+4.2)*PI);
        //translate([0,0,65]) cylinder(8, irad+3, irad+3, $fn=cp);
        //translate([0,0,72.99]) cylinder(3, irad+3, irad, $fn=cp);
        // RGB-Ledstrip slot (strip is 9.5x2mm)
        // Together with led cable slot
        est = ceil(18/(360/cp));
        nst = cp/4+est;
        profile = [[0.4, 10+3.8], [4.2, 10], [4.2, 0], [3.7, 0], [3.7, 1],
                   [1.8, 1], [1.8, -4.3], [3.5, -6], [3.5, -16], [0.4, -16]];
        translate([0,0,65]) polyhedron(convexity=10,
            points = [for (an=[-est*360/cp:360/cp:90]) each
                [ for (p=profile) [sin(an)*(irad+p[0]), cos(an)*(irad+p[0]), p[1]] ] ],
            faces = concat(
                nbot(0, len(profile)),
                [for (c=[0:nst-1]) each nquad(c, len(profile))],
                ntop(nst, len(profile))
            ));
        // On the north side, there is some collapsing overhand because of the large cutout
        // So cut a bit more
        if (side==0) {
            rotate([0,0,6]) translate([irad,0,0]) {
                rotate([90,0,0]) linear_extrude(height=10, convexity=10) polygon([
                    [9.25,25.25],[-0.75,35.35],[0,25]
                ]);
            }
        }
    }
}

module chamferedge(corners, tol=0.5)
{
    offset = let(vect = cross(corners[1]-corners[0], corners[2]-corners[1])) tol*vect/norm(vect);
    inset = [for (c=[0:len(corners)-1]) let(vect=corners[(c+2)%len(corners)]-corners[c])
            tol*vect/norm(vect)];
    lc = len(corners);
    polyhedron(points = concat(
            [for (c=[0:lc-1]) corners[c]-offset+inset[c]*2],
            [for (c=[0:lc-1]) corners[c]+offset+inset[c]*0.18],
            [for (c=[0:lc-1]) corners[c]-offset*2-inset[c]]
        ),
        faces = concat(
            nbot(0,4), nquad(0,4), nquad(1,4), ntop(2,4)
        ));
}

module capped_hole(dia, thi=3, cap=0.3, ang=40, off=0.1, cp=def_cp)
{
    rd = dia/2;
    // stp <= 360/cp
    // (360-2*ang) / stp = integer
    stp = (360-2*ang)/ceil((360-2*ang)/(360/cp));
    capy = cap + (1-cos(ang))*rd;
    capx = capy / tan(ang);
    translate([0,0,-off]) linear_extrude(height=thi+off*2, convexity=10) polygon(
        concat(
            [for (an=[ang:stp:360-ang]) [cos(an)*rd, sin(an)*rd]],
            [[cos(ang)*rd+capy, -sin(ang)*rd+capx],
             [cos(ang)*rd+capy, sin(ang)*rd-capx]]
        ));
}

module outer_foot_stem(cp=def_cp)
{
    bot = 25;
    bthi = 3;

    irad = outer_dia/2;
    translate([irad-20,0,0]) difference() {
        translate([0,0,-bot+2.2]) rotate([0,0,45]) cylinder(bot-bthi-2.2-0.3, 6.8*sqrt(2), 9.6*sqrt(2), $fn=4);
        translate([0,0,-bot+1.9]) cylinder(21, 1.3, 1.3, $fn=cp/3);
    }
}

module outer_foot(cp=def_cp)
{
    bot = 25;
    bthi = 3;
    fthi = 5;

    irad = outer_dia/2;
    translate([irad-20,0,0]) difference() {
        translate([0,0,-bot-fthi-0.1]) cylinder(fthi, 10, 14, $fn=cp);
        translate([0,0,-bot-fthi-0.11]) cylinder(fthi+0.12, 1.6, 1.6, $fn=cp/3);
        translate([0,0,-bot-fthi-0.11]) cylinder(fthi-1+0.01, 5, 4, $fn=cp/3);
    }
}

module outer_led_cover_set(cp=def_cp)
{
    numedg = 12;
    thick = 30;
    sang = 28.5;
    stp = 32;
    orad = outer_dia/2+thick;
    bot = 25;
    circles = generate_facet_circles(numedg, stp, orad, -bot, sang, 6);

    for (c=[3]) {
        circ = circles[c];
        echo(circ);
        for (a=[0:11]) {
            an = (circ[3]-floor(circ[3])+a)*(360/numedg);
            rotate ([0,0,an+(360/numedg/2)]) {
                translate([circ[1]*cos(360/numedg/2), 0, circ[0]]) rotate([0,circ[2]-90,0]) {
                    outer_led_cover(cp);
                }
            }
        }
    }
}

module outer_led_cover(cp=def_cp)
{
    translate([0,0,-0.5]) difference() {
        intersection() {
            translate([0,0,-0.01]) cylinder(28.02,11.1,3.7,$fn=cp/3);
            translate([0,0,0]) cylinder(15, 10.2, 25.2, $fn=cp/3);
        }
        translate([0,0,0.5]) cylinder(28.02,10.0,2.5,$fn=cp/3);
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
            translate([0,0,2]) rotate([0,0,45]) {  // Rotate 45 just to get facets aligned at low poly
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
                            [for (an=[-90:360/cp: 90]) [0, sin(an)*6.5, cos(an)*6.5]],
                            [for (an=[ 90:360/cp:270]) [0, sin(an)*5, cos(an)*5-8]],
                            [for (an=[-90:360/cp: 90]) [jackout+1.5, sin(an)*6.5, cos(an)*6.5]],
                            [for (an=[ 90:360/cp:270]) [jackout+1.5, sin(an)*4.5, cos(an)*4-6]]
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
        // Extra bits to hold center post in place
        angs = concat([for (an=[0:360/cp:12]) an], [12.5]);
        translate([0,0,bhei-8]) linear_extrude(height=5.6, convexity=20) {
            for (pa=[45:90:360-45]) {
                polygon(concat(
                    [for (a=[-len(angs)+1:len(angs)-1]) let(an=sign(a)*angs[abs(a)]+pa)
                        [sin(an)*(crad+0.2), cos(an)*(crad+0.2)]],
                    [for (a=[len(angs)-1:-1:-len(angs)+1]) let(an=sign(a)*angs[abs(a)]+pa)
                        [sin(an)*(crad-3.2), cos(an)*(crad-3.2)]]
                ));
            }
        }
        //translate([-30,-30,69]) cube([60,60,100]);
    }
}

module connectors_out(sides=[0,1,2,3])
{
    numedg = 12;
    thick = 30;
    sang = 28.5;
    stp = 32;
    orad = outer_dia/2+thick;
    bot = 25;
    circles = generate_facet_circles(numedg, stp, orad, -bot, sang, 6);
    for (c=[2]) {
        circ = circles[c];
        for (s=sides, a=[s*3:s*3+2]) {
            an = (circ[3]-floor(circ[3])+a)*(360/numedg);
            rotate ([0,0,an+(360/numedg/2)]) {
                translate([circ[1]*cos(360/numedg/2), 0, circ[0]]) rotate([0,circ[2],0]) {
                    if (holetypesmid[a] == 2) {
                        jackplug();
                    }
                    if (holetypesmid[a] == 3) {
                        spinner();
                    }
                    if (holetypesmid[a] == 11) {
                        potentiometer();
                    }
                    if (holetypesmid[a] == 6) {
                        rotary_switch();
                    }
                    if (holetypesmid[a] == 7) {
                        stop_button();
                    }
                }
            }
        }
    }
    for (c=[0]) {
        circ = circles[c];
        for (s=sides, a=[s*3:s*3+2]) {
            if (a == 7) {
                an = (circ[3]-floor(circ[3])+a)*(360/numedg);
                rotate ([0,0,an+(360/numedg/2)]) {
                    translate([circ[1]*cos(360/numedg/2), 0, circ[0]]) rotate([0,circ[2],0]) {
                        usbc_11mm();
                    }
                }
            }
        }
    }
}

module usbc_11mm()
{
    translate([0,0,15]) render(convexity=10) rotate([0,-90,0]) {
        intersection() {
            translate([0,0,0]) cylinder(16.5, 11/2, 11/2, $fn=30);
            translate([-9.25/2, -11/2, -1]) cube([9.25, 11, 18]);
        }
        translate([0,0,-2.2]) cylinder(2.2, 7, 7, $fn=30);
        translate([-2.5/2, -8/2, 16.5]) cube([2.5, 8, 15]);
        translate([0,0,3]) cylinder(3, 14/sqrt(3), 14/sqrt(3), $fn=6);

    }
    #translate([0,0,15]) rotate([0,-90,0]) translate([0,0,4]) pipespanner(14);
}

module jackplug()
{
    render(convexity=10) rotate([0,-90,0]) {
        translate([0,0,-2]) difference() {
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

module spinner() {
    render(convexity=10) rotate([0,-90,0]) {
        translate([0,0,-10]) cylinder(15, 3, 3, $fn=30);
        translate([-15/2,-13/2,3]) cube([15, 13, 6.1]);
        translate([0,0,-2.5]) cylinder(2, 10/sqrt(3), 10/sqrt(3), $fn=6);
        translate([0,0,-0.5]) cylinder(0.4, 6, 6, $fn=30);
    }
}

module potentiometer() {
    render(convexity=10) rotate([0,-90,0]) {
        translate([0,0,-10]) cylinder(15, 3, 3, $fn=30);
        translate([0,0,3]) cylinder(9.2, 17/2, 17/2, $fn=30);
        translate([0,-16/2,3]) cube([12.5, 16, 4]);
        translate([12.5,-5-1/2,6]) cube([4, 1, 1]);
        translate([12.5, 0-1/2,6]) cube([4, 1, 1]);
        translate([12.5, 5-1/2,6]) cube([4, 1, 1]);
        translate([0,0,-2.5]) cylinder(2, 10/sqrt(3), 10/sqrt(3), $fn=6);
        translate([0,0,-0.5]) cylinder(0.4, 6, 6, $fn=30);
    }
}

module rotary_switch() {
    render(convexity=10) rotate([0,-90,0]) {
        translate([0,0,0]) cylinder(38.5, 7, 7, $fn=30);
        translate([0,0,0]) cylinder(20, 11, 11, $fn=30);
        translate([0,0,-2]) cylinder(2, 15, 15, $fn=30);
        translate([0,0,3]) cylinder(2, 25/sqrt(3), 25/sqrt(3), $fn=6);

    }
    #rotate([0,-90,0]) translate([0,0,3.5]) pipespanner(25);
}

module pipespanner(size=25, cp=def_cp)
{
    thick = 1.6;
    ord = size/sqrt(3)+thick;
    hrd = ord+2;
    ext = 1;
    render(convexity=10) {
        linear_extrude(height=60) difference() {
            circle(ord, $fn=cp);
            circle(size/sqrt(3), $fn=6);
        }
        translate([0,0,60-10]) linear_extrude(height=10) difference() {
            polygon(
                [for (an=[0:6:360]) [sin(an)*(hrd+sin(an*12)*ext), cos(an)*(hrd+sin(an*12)*ext)]]
            );
            circle(size/sqrt(3), $fn=6);
        }
    }
}

module stop_button() {
    render(convexity=10) rotate([0,-90,0]) {
        translate([0,0,0]) cylinder(31, 7, 7, $fn=30);
        translate([0,0,-2]) cylinder(17, 11, 11, $fn=30);
        translate([0,0,-14]) cylinder(12, 14, 14, $fn=30);
        translate([0,0,3]) cylinder(2, 25/sqrt(3), 25/sqrt(3), $fn=6);

    }
    #rotate([0,-90,0]) translate([0,0,4]) pipespanner(25);
}

module jackplugs_in()
{
    bhei = 50;
    for (an=[0:3]) rotate([0,0,an*90]) translate([0,0,bhei+jackhi]) {
        translate([prad+1.5+jackout,0,0]) jackplug();
    }
}

// Hole for screws that act as adjustable feet
// Will glue into one of the vertical square(ish) at the bottom
module inner_base_foot()
{
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 50;
    wad = 47.5;

    hst = 5.8;

    drhei = 2;

    holes = innerholes(crad-holeof, irad, hst, choff);
    hole = holes[72];
    d = hole[0];
    an = hole[1];
    by = hole[2]-0.1;
    bx1 = hole[3]-0.1;
    bx2 = hole[4]-0.1;
    rotate([0, 0, an]) translate([d,0,0]) linear_extrude(height=10,convexity=10) difference() {
        polygon([
            [-by, -bx1], [ by, -bx2],
            [ by,  bx2], [-by,  bx1]
        ]);
        circle(1.3, $fn=30);
    }
}

function innerholes(srad, erad, hst, choff, offs=0) =
    [for (d=[srad+hst: hst: erad-hst/2])
        let(nstp = floor(d/(hst/1.5)),
            stp = (90-choff)/nstp,
            vst = d*PI/nstp/2,
            fstp = floor(nstp/2)*offs,
            by = hst*0.5-0.25,
            bx1 = vst*0.5-0.5,
            bx2 = vst*0.5-0.1)
        for (an=[stp/2-choff*offs+choff/2-fstp*stp:stp:90-stp/2-45*offs])
            [d, an+offs*(an > 0 ? choff : 0), by, bx1, bx2]
    ];

module inner_base(cp=def_cp, solid=false)
{
    jthi = 10;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 50;
    wad = 47.5;

    hst = 5.8;

    drhei = 2;

    holes = innerholes(crad-holeof, irad, hst, choff);
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
            // Botton screw hole (foot)
            d = holes[72][0];
            an = holes[72][1];
            by = holes[72][2]+0.1;
            bx1 = holes[72][3]+0.1;
            bx2 = holes[72][4]+0.1;
            rotate([0,0,an]) translate([d,0,0]) linear_extrude(height=15,convexity=10) difference() {
                polygon([
                    [-by, -bx1], [ by, -bx2],
                    [ by,  bx2], [-by,  bx1]
                ]);
                circle(1.3, $fn=30);
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
        rotate([0,0,28]) translate([crad-1,0,hei]) rotate([0,90,3]) {
            rotate([0,0,30]) cylinder(irad-crad-17.5, 3, 3, $fn=6);
        }
    }
}

module inner_cap(cp=def_cp, solid=false)
{
    bhei = 50;
    jthi = 10;
    jout = 4;
    irad = outer_dia/2 - jthi;
    crad = 36;
    hei = 2;
    wad = 50;

    hst = 5.8;

    caphi = 22-3;

    holes = innerholes(crad-holeof, irad, hst, choff, 1);

    translate([0,0,50.1]) difference() {
        union() {
            difference() {
                // Quarter circle plate
                union() {
                    linear_extrude(height=hei, convexity=20) {
                        polygon(concat(
                            [for (an=[45:360/cp:135]) [sin(an)*(irad+jout), cos(an)*(irad+jout)]],
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
                    // Extra bits to hold center post in place
                    angs = concat([for (an=[0:360/cp:11.9]) an], [12]);
                    translate([0,0,-7.5]) linear_extrude(height=hei+7.5, convexity=20) {
                        polygon(concat(
                            [for (a=[0:len(angs)-1]) let(an=angs[a]+45)
                                [sin(an)*(crad-0.2), cos(an)*(crad-0.2)]],
                            [for (a=[len(angs)-1:-1:0]) let(an=angs[a]+45)
                                [sin(an)*(crad-3), cos(an)*(crad-3)]]
                        ));
                        polygon(concat(
                            [for (a=[0:len(angs)-1]) let(an=135-angs[a])
                                [sin(an)*(crad-0.2), cos(an)*(crad-0.2)]],
                            [for (a=[len(angs)-1:-1:0]) let(an=135-angs[a])
                                [sin(an)*(crad-3), cos(an)*(crad-3)]]
                        ));
                    }
                }
                if (!solid) {
                // Water holes
                for (h=[0:len(holes)-1]) {
                    if (len(search(h, capholes)) == 0) {
                        d = holes[h][0];
                        an = holes[h][1];
                        rotate([0,0,an]) translate([d,0,-0.01]) cylinder(hei+0.02, 1, 2.9, $fn=cp/6);
                    }
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
        rotate([0,0,28]) translate([crad-1,0,hei-5]) rotate([0,90,3]) {
            rotate([0,0,30]) translate([0,0,-3]) cylinder(5, 3, 3, $fn=6);
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

module inner_base_ring(cp=def_cp)
{
    jthi = 10;
    jout = 4;
    ir = outer_dia/2 - jthi+0.4;
    ir2 = ir+1.2;
    or = outer_dia/2 - jthi + jout;
    ost = ceil(cp*(12/360));
    nstp = 4;
    hlf = floor(cp/(nstp*2))*(360/cp);
    linear_extrude(height=30) difference() {
        polygon([for (stp=[0:nstp-1]) each
            let(a1=stp*(360/nstp),
                a2=a1+ost*360/cp,
                a3=a1+hlf,
                a4=a3+ost*360/cp,
                a5=(stp+1)*(360/nstp))
            concat(
                [for (an=[a1:360/cp:a2]) [sin(an)*or, cos(an)*or]],
                [for (an=[a2:360/cp:a3]) [sin(an)*ir2, cos(an)*ir2]],
                [for (an=[a3:360/cp:a4]) [sin(an)*or, cos(an)*or]],
                [for (an=[a4:360/cp:a5]) [sin(an)*ir2, cos(an)*ir2]]
            )]);
        /*polygon([for (an=[360/cp:360/cp:360]) let (r=(an%90 < 10) ? or : ir2)
            [sin(an)*r, cos(an)*r]
        ]);*/
        circle(ir, $fn=cp);
    }

}

module testring_out()
{
    or = outer_dia/2;
    linear_extrude(height=20) difference() {
        circle(or+1.6, $fn=240);
        circle(or, $fn=240);
    }
}

module testring_in()
{
    jthi = 10;
    ir = outer_dia/2 - jthi;
    linear_extrude(height=20) difference() {
        circle(ir, $fn=240);
        circle(ir-1.2, $fn=240);
    }
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

function nquad(l, cp=def_cp, md=99999) = [for (an=[0:cp-1]) each [
    [l*cp + an, l*cp + (an+1)%cp, (l+1)%md*cp + an],
    [(l+1)%md*cp + an, l*cp + (an+1)%cp, (l+1)%md*cp + (an+1)%cp]
]];

function ntop(l,cp=def_cp) = [[for (an=[0:cp-1]) l*cp+an]];
    
function nbot(l,cp=def_cp) = [[for (an=[cp-1:-1:0]) l*cp+an]];
