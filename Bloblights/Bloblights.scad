doback=1;
docover=2;

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

numbl = ceil(length/offs)+1;

if (doback) {
    translate([0,250,-20]) ledholder();
    if (doback >= 2) {
        color("lightblue") translate([0,250,-19.9]) {
            ledstrip();
            mirror([1,0,0]) ledstrip();
        }
    }
    if (doback >= 3) {
        blobcover();
    }
} else {
    blobcover();
}

module ledstrip(l = 250, h=strip-2)
{
    bo = -bwidth/2+thick+1.8;
    translate([bo,-l,0]) cube([0.2,l,h]);
    loff = 50/3;
    for (ld = [loff/2:loff:l]) {
        translate([bo,-ld-2.5,2.5]) cube([1.7,4.7,5]);
    }
}

module ledholder(l = 250)
{
    b1 = bwidth/2-thick-0.1;
    t = 1.6;
    s = strip;
    f = 2;
    tr = 6;
    th = 8;
    b2 = 20/2;
    b3 = b2+th;

    bh = bwidth/2-thick-7;
    bhr = 4/2;
    
    hoff = 50/6+25;
    difference() {
        rotate([90,0,0]) linear_extrude(height=l, convexity=5) polygon([
            [-b1, s],[-b1,-f],[-b3,-f],[-b2,tr],
            [b2,tr],[b3,-f],[b1,-f],[b1,s],
            [b1-t,s],[b1-t,0],[b3,0],[b3-th,th],[0,s],
            [-(b3-th),th],[-b3,0],[-(b1-t),0],[-(b1-t), s]
        ]);

        for (h = [-hoff:-l+hoff*2:-l+hoff]) {
            translate([ bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
            translate([-bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
        }
        
        // Holes for connecting led strip
        translate([  b3-1 ,-l+3,0]) rotate([0, 45,0]) cylinder(4,2,2,true,$fn=4);
        translate([-(b3-1),-l+3,0]) rotate([0,-45,0]) cylinder(4,2,2,true,$fn=4);
        
        // Mating hole top near (glue)
        translate([ 4,-l-0.1,8.2]) rotate([-90,0,0])
            cylinder(2.2, 2.2, 0, false, $fn=4);
        
        // Mating holes sides near (glue)
        translate([-bh-1,-l,-f-0.1]) cylinder(f+0.2,2,2,false,$fn=4);
        translate([ b1-t/2,-l,6]) rotate([0,-90,0])
            cylinder(t/2+0.1,5,5,false,$fn=4);
        
        // Mating hole top far
        translate([ 4,0.1,8.2]) rotate([90,0,0])
            cylinder(2.2, 2.2, 0, false, $fn=4);
        
        // Mating holes sides far
        translate([-bh+1,0,-f-0.1]) cylinder(f+0.2,2,2,false,$fn=4);
        translate([ b1+0.1,0,6]) rotate([0,-90,0]) cylinder(t+0.2,2,2,false,$fn=4);
    }
    for (h = [-holeoff/2:-holeoff:-l]) {
        translate([-b1,h,holerad+1]) rotate([0,-90,0])
            cylinder(thick+0.2, holerad, holerad-thick, false, $fn=4);
        translate([ b1,h,holerad+1]) rotate([0, 90,0])
            cylinder(thick+0.2, holerad, holerad-thick, false, $fn=4);
    }
    taboff = 50;
    
    stripholder(-2, b1-t, s, 4);

    mirror([1,0,0]) stripholder(-2, b1-t, s, 4);
    
    stripholder(-taboff/3, b1-t, s, 4);
    mirror([1,0,0]) stripholder(-taboff/3, b1-t, s, 4);

    stripholder(-l+taboff/3, b1-t, s, 4);
    mirror([1,0,0]) stripholder(-l+taboff/3, b1-t, s, 4);

    for (b = [-taboff:-taboff:-l+taboff]) {
        stripholder(b, b1-t, s, 4);
        mirror([1,0,0]) stripholder(b, b1-t, s, 4);
    }
    
    // Mating pin top near (glue)
    translate([-4,-l,8.2]) rotate([90,0,0]) cylinder(2, 2, 0, false, $fn=4);
    
    // Mating pins sides near (glue)
    translate([ bh+1,-l,-f]) cylinder(f,2,2,false,$fn=4);
    translate([-b1+t/2,-l,6]) rotate([0,90,0])
        cylinder(t/2,4.9,4.9,false,$fn=4);

    // Mating pin top far
    translate([-4,0,8.2]) rotate([-90,0,0]) cylinder(2, 2, 0, false, $fn=4);
    
    // Mating pins sides far
    translate([ bh-1,0,-f]) cylinder(f,2,2,false,$fn=4);
    translate([-b1,0,6]) rotate([0,90,0]) cylinder(t,2,2,false,$fn=4);

}

module stripholder(b, be, s, h) {
    lt = 2;
    st = 0.5;
    t = 1.6;
    translate([0,b+h/2,0]) rotate([90,0,0])
      linear_extrude(height=h, convexity=3) polygon([
        [-(be+0.1),s],[-(be-1),s],[-(be-2-t),s-t-2],[-(be-2-t),-1],
        [-(be-st),-1],[-(be-st),0],[-(be-lt),2],
        [-(be-lt),8.2],[-(be-st),10.2],[-(be+0.1),10.2]
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
    
    cof = 2.5;
 
    if (docap == 1) {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,-thick-cof,-21.5])
                    cube([bwidth, thick, 25.9]);
            }
            translate([-bwidth,-40-cof,-22]) cube([bwidth*2, 40, 60]);
        }
        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
      }
    } else if (docap == -1) {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,length+cof,-21.5])
                    cube([bwidth, thick, 25.9]);
            }
            translate([-bwidth,length+cof,-22]) cube([bwidth*2, 40, 60]);
        }
        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
      }
    } else {
      difference() {
        intersection() {
            union() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe);

                color("red") translate([-bwidth/2,pstart-(pstart == 0 ? thick+cof : 0),-21.5])
                    cube([bwidth, blength+(pend==length ? thick+cof : 0)+(pstart== 0 ? thick+cof : 0), 25.9]);
            }
            translate([-bwidth,pstart-(doend?cof:30)*(docover%2),-22])
                cube([bwidth*2, blength+(doend?cof:30), 60]);
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