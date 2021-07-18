use <Keyboard.scad>;

tside=2;
s3 = sqrt(3);
s2 = sqrt(2);
off = 22;

boxdepth = 22;

rnd = 120;

boltoff = 6.5;
boltspa = 45;
ampboltspa = 28;
espboltspa = 25;

ribthick = 2;
coverhi = 7;
mpthick = 1;

textra = 58;
  
cdia = 34;
kdia = off*(tside*2)+textra-cdia*2;

kext = 0;
sholes = 0; // Turn on speaker holes

screendia = 35.6;
screentab1 = 14.5;
screentab2 = 17.5;
screentabh = 4.5;
screentabo = 3;

speakerdia = 48.5;

esp32xoff = -14.8*s3;
esp32yoff = -2.1-12.8;
esp32zoff = 3;

*translate([0,0,0]) tkeycaps();
*color("lightblue") tkeycover();
color("green") translate([0,0,-1.1]) tkeyplane();
*color("lightgreen") translate([0,0,-1.05]) tkeyholder();
color("lightblue") tbottom();


color("pink") translate([0,kdia,coverhi-0.5]) roundscreen();
rotate([0,0,120]) speaker();
rotate([0,0,240]) speaker();
color("teal") translate([20.9*s3,kdia+cdia-2.1 -31, -1.5-1.6-2.4])
    rotate([180,0,-60]) ampboard();
color("teal") translate([esp32xoff,kdia+cdia+esp32yoff, -1.5-1.6-3])
    rotate([180,0,-30]) esp32();
color("teal") translate([0,-kdia/2-cdia+3.4,-1.5-1.6-3.9]) sdboard();
    

module sdboard()
{
    swi = 18;
    shi = 18;
    sth = 1.6;
    translate([-swi/2, 0, 0]) {
        cube([swi,shi,sth], false);
        translate([2.2, -2.6, sth]) cube([13.7, 11.8, 2.2], false);
        translate([2, 15.3, -12]) cube([15, 2.5, 12], false);
    }
}

module esp32()
{
    ewi = 31.5;
    ehi = 39;
    eth = 0.9;
    ebz = 2.7;
    ehh = 6;
    ehw = 2.7;
    
    linear_extrude(height=eth) polygon([
        [0,ebz],[ebz,0],[ewi-ebz,0],[ewi,ebz],
        [ewi,ehi-ehh],[ewi-ehw,ehi-ehh],[ewi-ehw,ehi],
        [0,ehi]
    ]);
    translate([6.6, 0.4, eth]) cube([18.1, 25.5, 0.9], false);
    translate([7.8, 7.3, eth+0.9]) cube([15.7, 17.7, 2.4], false);
    translate([11.7, 34.1, eth]) cube([7.7, 5.5, 2.6], false);
    translate([25.8, 33.7, eth]) cube([3.5, 4.8, 2.0], false);
}

module ampboard()
{
    translate([0,29.9/2,1.6/2]) cube([30.2, 29.9, 1.6], true);
    translate([-6, 4.5, 3]) cylinder(2, 8, 8, false, $fn=32);
    translate([-6, 4.5, 1.6]) cylinder(1.5, 5, 5, false, $fn=32);
    translate([9.9,25.7,11.6/2]) cube([10, 7.8, 11.6], true);
    translate([-0.6,25.7,11.6/2]) cube([10, 7.8, 11.6], true);
    translate([-13.6, 20.7, 5]) cube([2.5, 18, 10], true);
    translate([-2.8, 17.5, 0]) cylinder(13.7, 2.6, 2.6, $fn=32);
}

module speaker()
{
    srd = speakerdia/2;
    color("blue") translate([0,kdia,coverhi-1]) mirror([0,0,1]) {
        difference() {
            union() {
                cylinder(2, srd, srd, false);
                translate([0,0,2]) cylinder(2, 25, 24.5, false);
                translate([0,0,4]) cylinder(9.1, 45/2, 41/2, false);
                translate([0,0,13]) cylinder(6, 9, 9, false);
            }
            translate([0,0,-0.01]) cylinder(2.01, srd-1.5, srd-1.5, false);
        }
    }
}

module roundscreen()
{
    srd = screendia/2;
    srd2 = 37.4/2;
    tb1 = screentab1/2;
    tb2 = screentab2/2;
    th1 = -srd-screentabo;
    th2 = th1 + screentabh;
    pinl = 2.4;
    pind = 3.5;
    pinx = (30-pind)/2;
    piny = (22.1-pind)/2;

    translate([0,0,-2]) cylinder(2, srd, srd, false, $fn=rnd);
    translate([0,0,-2-1.6]) cylinder(1.6, srd2, srd2, false, $fn=rnd);
    translate([0,0,-2-1.6])
        linear_extrude(height=1.6) polygon([
            [-tb1,th1],[tb1,th1],[tb2,th2],[-tb2,th2]
        ]);
    translate([0,0,-2])
        linear_extrude(height=2) polygon([
            [-tb1+0.2,th1+0.4],[tb1-0.2,th1+0.4],
            [tb2,th2+0.9],[-tb2,th2+0.9]
        ]);
    for (x=[-1,1], y=[-1,1]) {
        translate([x*pinx, y*piny, -2-1.6-pinl])
            cylinder(pinl+0.01, pind/2, pind/2, false, $fn=16);
    }
    translate([0,srd-12,-2-1.6-5.8/2]) cube([20, 8, 5.8], true);
}

module tkeycaps()
{
    // Normal hex keys
    for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
        translate([off*row, off*col*s3/2, 0]) {
            color("brown") cherryswitch();
            // color("orange") rgbmodule();
            color("white") translate([0,0,5.1]) keycap();
        }
    }
}

module tkeycover()
{
    thick = 2;
    ythick = 1;
    dia=off+1;
    hi=coverhi-mpthick;
    dpt=boxdepth;
    srd = (screendia+0.4)/2;

    
    tothi = hi+dpt+thick;
    bevel = 8;
    translate([0,0,hi]) difference() {
        translate([-kext/2,0,0]) union() {
            translate([0,0,-dpt-hi]) tkeycover_box(dpt);
            // Screen
            translate([0,kdia,ythick-2.4]) cylinder(1.5, srd+1, srd+2, false, $fn=rnd);
            // Speakers
            for (a=[120,240]) rotate([0,0,a]) {
                translate([0,kdia, -2])
                    cylinder(2, 26, 27, false, $fn=rnd);
            }

            // Bolt hole cubes
            // Backside
            for (x=[-boltspa,boltspa]) translate([x, -kdia/2-cdia+thick+6.99, -hi/2+0.01]) tbolt_cube(10,10.02,hi+0.02,4);
            // Side with amp
            rotate([0,0,120]) for (x=[-boltspa,ampboltspa])
                translate([x, -kdia/2-cdia+thick+6.99, -hi/2+0.01]) tbolt_cube(10,10.01,hi+0.01,4);
            // Side with esp32
            rotate([0,0,240]) for (x=[-espboltspa,boltspa])
                translate([x, -kdia/2-cdia+thick+6.99, -hi/2+0.01]) tbolt_cube(10,10.01,hi+0.01,4);
        }
        
        // Bolt holes
        // Backside
        for (x=[-boltspa,boltspa]) {
            translate([x, -kdia/2-cdia+thick+boltoff, -6.01]) cylinder(hi, 2.1, 2.1, $fn=32);
            translate([x, -kdia/2-cdia+thick+boltoff+0.5, -3]) cube([6, 10, 2.5], true);
        }
        // Side with amp
        rotate([0,0,120]) for (x=[-boltspa,ampboltspa]) {
            translate([x, -kdia/2-cdia+thick+boltoff, -6.01]) cylinder(hi, 2.1, 2.1, $fn=32);
            translate([x, -kdia/2-cdia+thick+boltoff+0.5, -3]) cube([6, 10, 2.5], true);
        }
        // Side with esp32
        rotate([0,0,240]) for (x=[-espboltspa,boltspa]) {
            translate([x, -kdia/2-cdia+thick+boltoff, -6.01]) cylinder(hi, 2.1, 2.1, $fn=32);
            translate([x, -kdia/2-cdia+thick+boltoff+0.5, -3]) cube([6, 10, 2.5], true);
        }
        // Main hex keys
        for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
            translate([off*row, off*col*s3/2, -hi-0.1])
                linear_extrude(height=thick+hi+0.2)
                polygon([for (a=[60:60:360]) [sin(a)*dia/s3, cos(a)*dia/s3]]);
        }
        // Screen cutout
        translate([0,kdia,ythick-3]) cylinder(3+0.01, srd, srd, false, $fn=rnd);
        tb1 = screentab1/2;
        tb2 = screentab2/2+0.2;
        th1 = -srd-screentabo+0.4;
        th2 = th1 + screentabh+0.6;
        translate([0,kdia,ythick-2.5]) linear_extrude(height=2.1) polygon([
            [-tb1,th1],[tb1,th1],[tb2,th2],[-tb2,th2]
        ]);
        
        
        // Speakers cutout
        if (sholes) for (a=[120,240]) rotate([0,0,a]) {
            translate([0,kdia, -3.01]) {
                cylinder(3.01, 24.5, 24.5, false);
            }
            translate([0, kdia, -0.01])
                cylinder(1.02, 1, 1, false, $fn=24);

            for (d=[1:6], an=[360/(d*6)+30:360/(d*6):360+30]) {
                translate([sin(an)*d*3, kdia+cos(an)*d*3, -0.01])
                cylinder(1.02, 1, 1, false, $fn=24);
            }
        }
        
        // Amp cutout
        translate([20.9*s3,kdia+cdia-2.1 -31, -1.5-1.6-2.4-hi]) rotate([180,0,-60]) {
            translate([-6, 4.5, 2.5]) cylinder(3, 9, 9, false, $fn=32);
            translate([-6, 4.5, 1.5]) cylinder(1.01, 6, 6, false, $fn=32);
        }

        // sd card cutout
        translate([-7, -kdia/2-cdia-0.01, -1.5-1.6-2.4-hi]) cube([14, 2.02, 2.4], false);
        
    }

    // Sacrificial layer for bolt holes
    for (x=[-boltspa,boltspa]) {
        translate([x, -kdia/2-cdia+thick+boltoff+0.5, hi-4.35]) #cube([8,8,0.2], true);
    }
    // Side with amp
    rotate([0,0,120]) for (x=[-boltspa,ampboltspa]) {
        translate([x, -kdia/2-cdia+thick+boltoff+0.5, hi-4.35]) #cube([8,8,0.2], true);
    }
    // Side with esp32
    rotate([0,0,240]) for (x=[-espboltspa,boltspa]) {
        translate([x, -kdia/2-cdia+thick+boltoff+0.5, hi-4.35]) #cube([8,8,0.2], true);
    }
}

module tkeycover_box(dpt=20)
{
    thick = 2;
    ythick = 1;
    dia=off+1;
    hi=coverhi-mpthick;
    
    // tothi = hi+dpt+thick;
    bevel = 6;
    hbev = 1;
    ibev = 4;
    o1 = thick;
    o2 = thick + thick;
    o3 = thick + thick + ibev;
    
    ang = 360/rnd;
    nsd = 360/ang + 3;
    polyhedron(
        points=concat(
            rounded_poly(kdia, dpt+hi       , cdia-o3, ang),
            rounded_poly(kdia, dpt+hi-ibev, cdia-o2, ang),
            rounded_poly(kdia, dpt, cdia-o2,ang),
            rounded_poly(kdia, dpt, cdia-o1,ang),
            rounded_poly(kdia, 0  , cdia-o1,ang),
            rounded_poly(kdia, 0, cdia,ang),
            rounded_poly(kdia, hi+dpt+ythick-bevel,cdia,ang),
            rounded_poly(kdia,hi+dpt+ythick,cdia-bevel,ang)
        ),
        faces=topnquadbot(nsd, 8),
        convexity=4
    );
}

module tbolt_cube(x, y, z, b)
{
    rotate([0,90,0]) translate([0,0,-y/2]) linear_extrude(height=y) polygon([
        [z/2,x/2],[z/2,-x/2],[-z/2+b,-x/2],[-z/2,-x/2+b],[-z/2,x/2]
    ]);
}

module tkeyplane()
{
    thick = 2;
    kthick = 1.4;
    rh = 6;
    skthick = 1.6;
    
    // Screen pins
    pind = 3.5;
    pinl = 2.4;
    pinx = (30-pind)/2;
    piny = (22.1-pind)/2;
    
    difference() {
        union() {
            translate([0,0,-thick]) tkeyplane_box(thick, thick);
                
            // horizontal ribs
            for (col = [-tside-0.5:tside+0.5]) {
                kwid = kdia + (tside-abs(col))*off + 15;
                translate([0, off*col*s3/2, -rh/2]) cube([kwid, ribthick, rh], true);
                for (row = [-tside-1+abs(col)/2:tside-abs(col)/2-(abs(col)<1 ? 1 : 0)]) {
                    // translate([off*row+off*1.28-(abs(col)%2)*off/2, off*col*s3/2, -rh-2]) wireclip_y();
                    if (col > 0) translate([off*row+off*1.28, off*col*s3/2, -rh-2]) wireclip_d(an=-30);
                    else if (col < -1) translate([off*row+off*0.78, off*col*s3/2, -rh-2]) wireclip_d(an=30);
                    else translate([off*row+off*0.81, off*col*s3/2, -rh-2]) wireclip_d(an=0);
                }
            }
            // extra horizontal wireclips
            translate([off*(tside-1)+off*0.88, off*(-0.5)*s3/2, -rh-2]) wireclip_d(an=0);
            translate([off*(tside-1)+off*0.88, off*(0.5)*s3/2, -rh-2]) wireclip_d(an=0);
            translate([off*(tside-1)+off*0.82, off*(-1.5)*s3/2, -rh-2]) wireclip_d(an=0);
            translate([off*(tside-1)+off*1.18, off*(-0.5)*s3/2, -rh-2]) wireclip_d(an=0);
            translate([off*(tside-1)+off*1.18, off*(0.5)*s3/2, -rh-2]) wireclip_d(an=0);
            translate([off*(tside-1)+off*1.06, off*(-1.5)*s3/2, -rh-2]) wireclip_d(an=0);
            
            // Vertical ribs
            for (col = [-tside:tside], row = [-(tside-abs(col)/2)-0.5:(tside-abs(col)/2)+0.5]) {
                pinof = col >= 0 ? 3.3 : 0;
                translate([off*row, off*col*s3/2, -rh/2]) cube([ribthick, off*s3/2, rh], true);
                translate([off*row, off*col*s3/2-2.1-pinof, -rh]) wireclip_x();
            }

            // Amp holder
            translate([20.9*s3,kdia+cdia-2.1 -31, -2]) rotate([180,0,-60]) {
                // Right side
                translate([-30.2/2-2/2, 19/2, 6/2]) cube([2, 19, 6], true);
                translate([-30.2/2, 19/2, 2.3/2]) cube([1, 19, 2.3], true);

                // Left side
                translate([30.2/2+2/2, 30/2, 6/2]) cube([2, 30, 6], true);
                translate([30.2/2, 30/2, 2.3/2]) cube([4, 30, 2.3], true);

                // Back
                translate([0.16,30+2/2,6/2]) cube([33, 2, 6], true);
                translate([2.5,30,2.3/2]) cube([29, 4, 2.3], true);

                // Bottom
                translate([0, 4+6/2, 2.3/2]) cube([3, 6, 2.3], true);
            }
            
            // esp32 holder
            translate([esp32xoff, kdia+cdia+esp32yoff, -2]) rotate([180,0,-30]) {
                ewi = 31.5;
                ehi = 39;
                // bottom side
                translate([0.5,-2,0]) cube([13.5, 2, esp32zoff+3], false);
                translate([0.5,-2,0]) cube([13.5, 4, esp32zoff], false);
                
                // top side
                translate([0, ehi, 0]) cube([11, 2, esp32zoff+3], false);
                translate([20, ehi, 0]) cube([ewi-22, 2, esp32zoff+3], false);
                translate([0, ehi-2, 0]) cube([ewi-2, 4, esp32zoff], false);
                
                // right side
                translate([ewi, 2.655, 0]) cube([2, ehi-10+0.345, esp32zoff+3], false);
                translate([ewi-2, 2.655, 0]) cube([4, 3.345, esp32zoff], false);
                translate([ewi-0.5, 2.655, 0]) cube([2.5, ehi-10+0.345, esp32zoff], false);
                
                // Middle
                translate([ewi/2, ehi/2, 0]) cylinder(esp32zoff, 5, 5, false, $fn=32);
            }

            // sd module holder
            translate([0,-kdia/2-cdia+2.1,-2]) {
                // left side
                translate([-11.1,0,-4]) cube([2,23,4], false);
                translate([-11.1,4,-2.3]) cube([4,12,2.3], false);
                translate([-11.1,0,-4]) cube([4, 1.2, 4], false);

                // right side
                translate([9.1,0,-4]) cube([2,23,4], false);
                translate([7.1,4,-2.3]) cube([4,12,2.3], false);
                translate([7.1,0,-4]) cube([4, 1.2, 4], false);

                // bottom
                translate([-11.1,19.4,-4]) cube([22.2,3,4], false);
            }

        }
        
        // Normal hex keys
        for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
            translate([off*row, off*col*s3/2, -thick/2]) cube([14, 14, thick+0.1], true);
            translate([off*row, off*col*s3/2, -kthick-thick/2]) cube([16,16,thick+0.1], true);
        }
        // Screen connector
        translate([0,kdia+10,-thick/2-3]) cube([21, 18, 8.1], true);
        // Screen pins
        for (x=[-1,1], y=[-1,1]) {
            translate([x*pinx, y*piny+kdia, -1.1-thick/2])
                cylinder(4, 1.25, 1.25, false, $fn=32);
            translate([x*pinx, y*piny+kdia, -12])
                cylinder(10, 2.75, 2.75, false, $fn=32);
        }
        
        // Speakers
        for (a=[120,240]) rotate([0,0,a]) {
            translate([0, kdia, -8.01]) {
                cylinder(8.02, 22.5, 22.5, false, $fn=rnd);
                rotate([0,0,90-a*1.5]) translate([0, 21, 6])
                    cube([23, 7, 8], true);
            }
        }

        // Bolt holes
        // Backside
        for (x=[-boltspa,boltspa]) translate([x, -kdia/2-cdia+thick+boltoff, -2.01]) cylinder(2.02, 2.1, 2.1, $fn=32);
        // Side with amp
        rotate([0,0,120]) for (x=[-boltspa,ampboltspa])
            translate([x, -kdia/2-cdia+thick+boltoff, -2.01]) cylinder(2.02, 2.1, 2.1, $fn=32);
        // Side with esp32
        rotate([0,0,240]) for (x=[-espboltspa,boltspa])
            translate([x, -kdia/2-cdia+thick+boltoff, -2.01]) cylinder(2.02, 2.1, 2.1, $fn=32);
    }
}

module wireclip_d(an=-30, wid=ribthick, dia=0.8, thick=0.8, hei=1.5)
{
    r = dia/2;
    t = thick*1.4;
    op = 0.2;
    difference() {
        translate([0,0,hei/2]) cube([dia+2*t,wid,hei+3], true);
        translate([0,0,-r]) rotate([90,0,an]) cylinder(1.5*wid+0.2, r, r, true, $fn=20);
        translate([0,0,-r]) rotate([90,0,an]) cylinder(1.5*wid+0.2, r+0.3, 0, true, $fn=20);
        translate([0,0,-r]) rotate([90,0,an]) cylinder(1.5*wid+0.2, 0, r+0.3, true, $fn=20);
    }
}


module tkeyholder(off=off, thick=mpthick, kthick=1, rh=6, skthick=1.6)
{
    tkthick = 3.8;
    lcl = 7;
    lch = 5;
    lct = 1.2;

    // Screen pins
    pind = 3.5;
    pinl = 2.4;
    pinx = (30-pind)/2;
    piny = (22.1-pind)/2;
    
    translate([0,0,0]) difference() {
        union() {
            translate([0,0,0]) tkeyplane_box(thick, 2);
            // Screen pins
            for (x=[-1,1], y=[-1,1]) {
                translate([x*pinx, y*piny+kdia, thick-0.2])
                    cylinder(5-pinl, 2.8, 2.5, false, $fn=32);
            }

            // Normal hex keys
            for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
                translate([off*row, off*col*s3/2, 1]) {
                    cube([18,18,2], true);
                    translate([0,7+lct,0]) rotate([90,0,0])
                      linear_extrude(height=lct) polygon([
                        [-5,0],[-3,lch],[3,lch],[5,0]
                      ]);
                    // translate([0,(14+lct)/2,lch/2]) cube([lcl,lct,lch], true);
                }
            }

            // Speakers
            for (a=[120,240]) rotate([0,0,a]) {
                translate([0,kdia, 0])
                    cylinder(2.9, 26, 25, false, $fn=rnd);
            }
        }
        
        // Normal hex keys
        for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
            translate([off*row, off*col*s3/2, thick/2-0.01/2])
                cube([16,16,thick+0.01], true);
            translate([off*row, off*col*s3/2 ,0.999])
                rotate([0,0,45]) cylinder(1.002,16/s2,(16-2)/s2, $fn=4);

        }

        // Screen connector
        translate([0,kdia+10,thick/2]) cube([21, 18, 1.01], true);
        // Screen pins
        for (x=[-1,1], y=[-1,1]) {
            translate([x*pinx, y*piny+kdia, -0.01])
                cylinder(1.52, 1.25, 1.25, false, $fn=32);
            translate([x*pinx, y*piny+kdia, 1.5])
                cylinder(2, 1.8, 1.8, false, $fn=32);
        }
        // Speakers
        for (a=[120,240]) rotate([0,0,a]) {
            translate([0, kdia, -0.01]) {
                cylinder(3.01, 23, 23, false, $fn=rnd);
                rotate([0,0,90-a*1.5]) translate([0, 21, 1.5])
                    cube([23, 7, 3.01], true);
                rotate([0,0,90-a*1.5]) translate([0, 21, 2.11])
                    cube([23, 10, 2.2], true);
            }
        }
        // Bolt holes
        // Backside
        for (x=[-boltspa,boltspa]) translate([x, -kdia/2-cdia+2+boltoff, -0.01]) cylinder(1.02, 2.1, 2.1, $fn=32);
        // Side with amp
        rotate([0,0,120]) for (x=[-boltspa,ampboltspa])
            translate([x, -kdia/2-cdia+2+boltoff, -0.01]) cylinder(1.02, 2.1, 2.1, $fn=32);
        // Side with esp32
        rotate([0,0,240]) for (x=[-espboltspa,boltspa])
            translate([x, -kdia/2-cdia+2+boltoff, -0.01]) cylinder(1.02, 2.1, 2.1, $fn=32);
    }

}

module tkeyplane_box(thick=2, off=2)
{
    ang = 360/rnd;
    nsd = 360/ang + 3;
    polyhedron(
        points=concat(
            rounded_poly(kdia, 0, cdia-off-0.1, ang),
            rounded_poly(kdia, thick, cdia-off-0.1, ang)
        ),
        faces=topnquadbot(nsd, 2),
        convexity=4
    );
}

module tbottom(dpt = boxdepth)
{
    thick = 2;
    translate([0,0,-dpt]) difference() {
        union() {
            tbottom_box(dpt);

            // sd card
            translate([8, -kdia/2-cdia+4.1, 0]) rotate([0,-90,0]) {
                linear_extrude(height=16) polygon([
                    [0,0],[0,3],[dpt-7.2,10],[dpt-7.1,9.9],[dpt-7.1,0.1],[dpt-7.2,0]
                ]);
            }

        }

        // sd card
        translate([-12, -kdia/2-cdia+2.09, dpt-7.2]) cube([24, 2.02, 4.01], false);

        // Amp cutout
        translate([20.9*s3,kdia+cdia-2.1 -31, dpt-3.11]) rotate([180,0,-60]) {
            translate([-17.5,-0.15,0]) cube([35,2.1,9.01], false);
        }

    }
    // Amp board

    translate([20.9*s3,kdia+cdia-2.1 -31, -2-dpt]) rotate([180,0,-60]) {
        translate([-11, 14, 5.2-dpt]) cube([4,15,dpt-7.2], false);
        difference() {
            translate([2.5, -0.1, 5.2-dpt]) cube([2.5,8,dpt-7.2], false);
            translate([-6, 4.5, 5.15-dpt]) cylinder(5, 9.5, 9.5, $fn=rnd);
        }
    }

    // esp32

    translate([esp32xoff,kdia+cdia+esp32yoff, 0]) rotate([180,0,-30]) {
        x = 15.7;
        y = 17.7;
        z = dpt-10.4;
        translate([7.8, 7.3, 10.4]) polyhedron(
            points = [
                [4,4,0],[x-4,4,0],[x-4,y-4,0],[4,y-4,0],
                [0,0,z],[x,0,z],[x,y,z],[0,y,z] ],
            faces = [
                [0,1,2,3],[7,6,5,4],
                [4,5,1,0],[5,6,2,1],[6,7,3,2],[7,4,0,3]
            ]);

        // cube([15.7, 17.7, dpt-10.4], false);
    }
}

module tbottom_box(dpt = boxdepth)
{
    thick = 2;
    ythick = 1;
    ang = 360/rnd;
    nsd = 360/ang + 3;
    hi = dpt-coverhi+3.8;
    polyhedron(
        points=concat(
            rounded_poly(kdia, 0, cdia-thick-0.1, ang),
            rounded_poly(kdia, hi, cdia-thick-0.1, ang),
            rounded_poly(kdia, hi, cdia-thick*2-0.1, ang),
            rounded_poly(kdia, ythick, cdia-thick*2-0.1, ang)
        ),
        faces=topnquadbot(nsd, 4),
        convexity=4
    );
}

function rounded_poly(d,z,b,s,n=3) = concat(
    [for (sd = [360/n:360/n:360]) each
        [for (an = [sd-180/n:s:sd+180/n]) [d*sin(sd)+b*sin(an),d*cos(sd)+b*cos(an),z]] ]
);

function topnquadbot(nsides, nlayers) = concat(
    topface(nsides, 0),
    [for (fc = [0:nlayers-2]) each nquads(nsides, nsides*fc)],
    botface(nsides, nsides*(nlayers-1)) );

function brect(w,h,z,b) = [
    [ w/2,-h/2+b,z], [ w/2-b,-h/2,z],
    [-w/2+b,-h/2,z], [-w/2,-h/2+b,z],
    [-w/2, h/2-b,z], [-w/2+b, h/2,z],
    [ w/2-b, h/2,z], [ w/2, h/2-b,z]
    ];
