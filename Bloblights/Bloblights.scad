doback=1;
docover=1;

numparts = 14;
length = 2500;

partlength = length / numparts;

seed = 2;


pend = partlength * docover;
pstart = pend - partlength;

offs = partlength/20;
width = 55;
bwidth= 60;

blobmin = 16;
blobmax = 23;

ywob = 6;
zwob = 8;

holeoff = 500/10;
holerad = 3;

strip = 12;

thick = 1.2;

s2 = sqrt(2);

numbl = ceil(length/offs)+0;

if (doback) {
    translate([0,250,-20]) ledstrip();
} else {
    blobcover();
}

module ledstrip()
{
    b1 = bwidth/2-thick-0.1;
    t = 2;
    s = strip;
    f = 2;
    tr = 6;
    th = 8;
    b2 = 20/2;
    b3 = b2+th;

    difference() {
        rotate([90,0,0]) linear_extrude(height=250, convexity=3) polygon([
            [-b1, s],[-b1,-f],[-b3,-f],[-b2,tr],
            [b2,tr],[b3,-f],[b1,-f],[b1,s],
            [b1-t,s],[b1-t,0],[b3,0],[b3-th,th],[0,s],
            [-(b3-th),th],[-b3,0],[-(b1-t),0],[-(b1-t), s]
        ]);
        bh = bwidth/2-thick-7;
        bhr = 4/2;
        for (h = [-16:-218:-234]) {
            translate([ bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
            translate([-bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
        }
    }
    for (h = [-holeoff/2:-holeoff:-250]) {
        translate([-b1,h,holerad+1]) rotate([0,-90,0])
            cylinder(thick+0.2, holerad, holerad-thick, false, $fn=4);
        translate([ b1,h,holerad+1]) rotate([0, 90,0])
            cylinder(thick+0.2, holerad, holerad-thick, false, $fn=4);
    }
    taboff = 50;
    stripholder(-2, b1-t, s, 4);
    mirror([1,0,0]) stripholder(-2, b1-t, s, 4);
    for (b = [-taboff:-taboff:-250+taboff]) {
        stripholder(b, b1-t, s, 4);
        mirror([1,0,0]) stripholder(b, b1-t, s, 4);
    }
}

module stripholder(b, be, s, h) {
    lt = 2;
    st = 0.5;
    translate([0,b+h/2,0]) rotate([90,0,0])
      linear_extrude(height=h, convexity=3) polygon([
        [-(be+0.1),s],[-(be-2),s],[-(be-4),s-2],[-(be-4),-1],
        [-(be-st),-1],[-(be-st),0],[-(be-lt),2],
        [-(be-lt),8],[-(be-st),10],[-(be+0.1),10]
    ]);
}

module blobcover()
{
    xpts  = rands( 0,       width/2, numbl, seed);
    ypts  = rands(-ywob,    ywob,    numbl, seed+1);
    zpts  = rands( 0,       zwob,    numbl, seed+2);
    sizes = rands(blobmin,  blobmax, numbl, seed+3);
    
    rots  = rands(0, 360, numbl*3, seed+4);
    fns   = rands(10, 15, numbl, seed+5);
    
    docap = ((docover == 0) ? 1 : ((docover == numparts+1) ? -1 : 0));
    doend = (docover == 1 || docover == numparts);
    
    ps = max(0, floor(numbl*pstart/length)-4+4*(docover%2)+docap*4);
    pe = min(numbl-1, floor(numbl*pend/length)-1+4*(docover%2)+docap*4);
    
    ps3 = max(-1, ps-1);
    ps2 = max(0, ps-4);
    pe3 = min(numbl-1, pe+4);
    pe2 = min(numbl, pe+1);
    
    blength = pend-pstart;
    
    hs = floor(pstart/holeoff)*holeoff+holeoff/2;
    he = ceil(pend/holeoff)*holeoff-holeoff/2;
 
    if (docap == 1) {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,-thick-0.5,-21.5])
                    cube([bwidth, thick, 25.9]);
            }
            translate([-bwidth,-40-0.5,-22]) cube([bwidth*2, 40, 60]);
        }
        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
      }
    } else if (docap == -1) {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,length+0.5,-21.5])
                    cube([bwidth, thick, 25.9]);
            }
            translate([-bwidth,length+0.5,-22]) cube([bwidth*2, 40, 60]);
        }
        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
      }
    } else {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,pstart-(pstart == 0 ? thick+0.5 : 0),-21.5])
                    cube([bwidth, blength+(pend==length ? thick+0.5 : 0)+(pstart== 0 ? thick+0.5 : 0), 25.9]);
            }
            translate([-bwidth,pstart-(doend?0.5:30)*(docover%2),-22]) cube([bwidth*2, blength+(doend?0.5:30), 60]);
        }

        if (docover%2) {
            blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps2, ps3, -thick);

        } else {
            blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, pe2, pe3);

        }

        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
        translate([-bwidth/2+1,pstart-40,-22])
            cube([bwidth-2, blength+80, 25]);
        
        b1 = bwidth/2-thick-0.1;
        for (h = [hs:holeoff:he]) {
            translate([-b1,h,holerad-19]) rotate([0,-90,0])
                cylinder(thick+0.2, holerad+0.1, holerad-thick+0.1, false, $fn=4);
            translate([ b1,h,holerad-19]) rotate([0, 90,0])
                cylinder(thick+0.2, holerad+0.1, holerad-thick+0.1, false, $fn=4);
        }
      }
    }
}

module blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, step, ps, pe, so=0)
{
    if (ps <= pe) {
        for (i = [ps:pe]) {
            translate([((width/2+5) - (xpts[i] * xpts[i] / width)) *(((i+2)%4)-1.5)/2, i*step+ypts[i], zpts[i]])
            scale([1,1.5,0.8]) rotate([rots[i*3],rots[i*3+1],rots[i*3+2]])
            sphere(sizes[i]+so, $fn=fns[i]);
        }
    }
}