doback=1;
docover=1;

interlace = false;

overlap = 2;

numparts = 14;
length = 2500;

partlength = length / numparts;

seed = 2;

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
sthick = 2;

s2 = sqrt(2);

numbl = ceil(length/offs)+1;

if (false) {
    *coverconnect();
    *connectorholder();
    *intersection() {
        ledholder();
        translate([0,-250,10]) cube([80,50,40],true);
    }
} else if (doback) {
    translate([0,250,-20]) ledholder();
    if (doback >= 2) {
        color("lightblue") translate([0,250,-19.9]) {
            ledstrip();
            mirror([1,0,0]) ledstrip();
        }
    }
    if (doback >= 3) {
        blobcover(docover);
    }
} else  {
    if (docover == 100) {
        blobcover(1);
        translate([0,0,0]) blobcover(2);
        
        gshi = 21.5 - 0.8 - 1.25;
        #translate([-bwidth/2,partlength,-gshi]) rotate([0, 90,0]) coverconnect();
        #translate([ bwidth/2,partlength,-gshi]) rotate([0,-90,0]) coverconnect();
    } else {
        blobcover(docover);
    }
}

module coverconnect()
{
    gsw = 2.5-0.2;
    gsl = 10;

    translate([0,0,thick/4]) cube([gsw,gsl*2,thick/2], true);
    translate([0,-gsl,0]) cylinder(thick,gsw/2,gsw/2,false,$fn=4);
    translate([0, gsl,0]) cylinder(thick,gsw/2,gsw/2,false,$fn=4);
}

module ledstrip(l = 250, h=strip-2)
{
    bo = -bwidth/2+sthick+1.8;
    translate([bo,-l,0]) cube([0.2,l,h]);
    loff = 50/3;
    for (ld = [loff/2:loff:l]) {
        translate([bo,-ld-2.5,2.5]) cube([1.7,4.7,5]);
    }
}

module ledholder(l = 250)
{
    b1 = bwidth/2-sthick-0.1;
    t = 1.6;
    s = strip;
    f = 2;
    tr = 9;
    th = 11;
    tmh = 15;
    b2 = 20/2;
    b3 = b2+8;

    bh = bwidth/2-sthick-7;
    bhr = 4/2;
    
    hoff = 50/6+25;
    difference() {
        rotate([90,0,0]) linear_extrude(height=l, convexity=5) polygon([
            [-b1, s],[-b1,-f],[-b3,-f],[-b2,tr],
            [b2,tr],[b3,-f],[b1,-f],[b1,s],
            [b1-t,s],[b1-t,0],[b3,0],[b2,th],[0,tmh],
            [-(b2),th],[-b3,0],[-(b1-t),0],[-(b1-t), s]
        ]);

        for (h = [-hoff:-l+hoff*2:-l+hoff]) {
            translate([ bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
            translate([-bh,h,-t-0.5]) cylinder(t+1, bhr, bhr, false, $fn=20);
        }
        
        // Holes for connecting led strip
        translate([  b3-1 ,-l+3,0]) rotate([0, 45,0]) cylinder(4,2,2,true,$fn=4);
        translate([-(b3-1),-l+3,0]) rotate([0,-45,0]) cylinder(4,2,2,true,$fn=4);
        
        // Mating hole top near (glue)
        translate([ 4,-l-0.1,tmh-3.8]) rotate([-90,0,0])
            cylinder(2.2, 2.2, 0, false, $fn=4);
        
        // Mating holes sides near (glue)
        translate([-bh-1,-l,-f-0.1]) cylinder(f+0.2,2,2,false,$fn=4);
        translate([ b1-t/2,-l,6]) rotate([0,-90,0])
            cylinder(t/2+0.1,5,5,false,$fn=4);
        
        // Mating hole top far
        translate([ 4,0.1,tmh-3.8]) rotate([90,0,0])
            cylinder(2.2, 2.2, 0, false, $fn=4);
        
        // Mating holes sides far
        translate([-bh+1,0,-f-0.1]) cylinder(f+0.2,2,2,false,$fn=4);
        translate([ b1+0.1,0,6]) rotate([0,-90,0]) cylinder(t+0.2,2,2,false,$fn=4);
        
        // Connector holder slot
        translate([0,-l+7-2/2,tr-4.6/2]) cube([32,2,4.6-0.001], true);
    }
    // Cover holding pins
    for (h = [-holeoff/2:-holeoff:-l]) {
        translate([-b1,h,holerad+1]) rotate([0,-90,0])
            cylinder(sthick+0.2, holerad, holerad-sthick, false, $fn=4);
        translate([ b1,h,holerad+1]) rotate([0, 90,0])
            cylinder(sthick+0.2, holerad, holerad-sthick, false, $fn=4);
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
    translate([-4,-l,tmh-3.8]) rotate([90,0,0]) cylinder(2, 2, 0, false, $fn=4);
    
    // Mating pins sides near (glue)
    translate([ bh+1,-l,-f]) cylinder(f,2,2,false,$fn=4);
    translate([-b1+t/2,-l,6]) rotate([0,90,0])
        cylinder(t/2,4.9,4.9,false,$fn=4);

    // Mating pin top far
    translate([-4,0,tmh-3.8]) rotate([-90,0,0]) cylinder(2, 2, 0, false, $fn=4);
    
    // Mating pins sides far
    translate([ bh-1,0,-f]) cylinder(f,2,2,false,$fn=4);
    translate([-b1,0,6]) rotate([0,90,0]) cylinder(t,2,2,false,$fn=4);
    
    // Connector holder
    difference() {
        translate([0,-l+11,0]) rotate([90,0,0])
          linear_extrude(height=1, convexity=5) polygon([
            [-b3,-f],[-b2,-f],
            [-b2,tr-8],[b2,tr-8],
            [b2,-f],[b3,-f],
            [b2+0.01,tr+0.01],[-b2-0.01,tr+0.01]
        ]);
        for (x=[-2:2]) {
            translate([x*3.96,-l+11+0.1,tr-5.5]) rotate([90,45,0]) cylinder(1.2,s2/2,s2/2,$fn=4);
        }
    }
    *translate([0,-l+7,4.4]) rotate([90,0,0]) connectorholder();
}

module connectorholder()
{
    lw1 = 11.45;
    lw2 = 14.8;
    lh = 4.6;
    // Connector lip holder
    
    linear_extrude(height=2, convexity=5) polygon([
        [-7,lh-1.5], [-8.5,lh],
        [-lw1,lh], [-lw2,0],
        [-lw2+1.3,0], [-lw2+1.45,0.8], [-lw2+2.5,1.7],
        [-5,1.2], [-5,0.8], [-lw2+2.5,0.8], [-lw2+1.5,0],
        [-lw2+1.5,-0.8], [-10,0],

        [ 10,0], [ lw2-1.5,-0.8],
        [ lw2-1.5,0], [ lw2-2.5,0.8], [ 5,0.8], [ 5,1.2],
        [ lw2-2.5,1.7], [ lw2-1.45,0.8], [ lw2-1.3,0],
        [ lw2,0], [ lw1,lh],
        [ 8.5,lh], [ 7,lh-1.5]

    ]);

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

module blobcover(covernumber)
{
    pend = partlength * covernumber;
    pstart = pend - partlength;
    
    xpts  = rands( 0,       width/2, numbl, seed);
    ypts  = rands(-ywob,    ywob,    numbl, seed+1);
    zpts  = rands( 0,       zwob,    numbl, seed+2);
    sizes = rands(blobmin,  blobmax, numbl, seed+3);
    
    rots  = rands(0, 360, numbl*3, seed+4);
    fns   = rands(10, 15, numbl, seed+5);
    
    docap = ((covernumber == 0) ? 1 : ((covernumber == numparts+1) ? -1 : 0));
    doend = (covernumber == 1 || covernumber == numparts);
    
    ps = max(0, floor(numbl*pstart/length)-4+4*(covernumber%2)+docap*4-(interlace?0:4));
    pe = min(numbl-1, floor(numbl*pend/length)-1+4*(covernumber%2)+docap*4+(interlace?0:4));
    
    ps3 = max(-1, ps-1+(interlace?0:8));
    ps2 = max(0, ps-4);
    pe3 = min(numbl-1, pe+4);
    pe2 = min(numbl, pe+1-(interlace?0:8));
    
    ilof = interlace ? 30 : overlap/2;
    
    blength = pend-pstart;
    
    hs = floor(pstart/holeoff)*holeoff+holeoff/2;
    he = ceil(pend/holeoff)*holeoff-holeoff/2;
    
    cof = 2.5;
 
    if (docap == 1) {
      // Butt end, with different side for gluing endcap on
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
      // Butt end, with different side for gluing endcap on
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
            // Cut the blobs to size
            translate([-bwidth,pstart-(doend?cof:ilof)*(covernumber%2),-22])
                cube([bwidth*2, blength+(doend?cof:ilof), 60]);
        }

        if (interlace) {
          // Overhanging pieces of blobs, cut with the blobs from the next piece
          if (covernumber%2) {
            blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps2, ps3, -thick);

          } else {
            blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, pe2, pe3);
          }
        } else if (!doend) {
          // Straight cut but with a small lip
          if (covernumber%2) {
            // Lip is on the outside, so cut out the inside
            intersection() {
                blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps2, ps3, -thick/2);
                translate([-bwidth,pstart-overlap*1.5,-22])
                    cube([bwidth*2, overlap*2, 60]);
            }
          } else {
            // Lip is on the outside, so cut out the inside
            // of the outside to use to cut off the outside
            intersection() {
                difference() {
                    blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, pe2, pe3, 0.1);
                    blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, pe2, pe3, -thick/2);
                }
                translate([-bwidth,pend-overlap*0.5,-22])
                    cube([bwidth*2, overlap*2, 60]);
            }
            // Also cut the sides a bit
            translate([-bwidth/2-0.001,pend-overlap*0.5,-22])
                cube([bwidth+0.002, overlap*2, 25]);
          }
        }

        // Hollow out the inside
        blobset(xpts, ypts, zpts, sizes, numbl, rots, fns, offs, ps, pe, -thick);
        translate([-bwidth/2+sthick,pstart-40,-22])
            cube([bwidth-sthick*2, blength+80, 25]);
        
        b1 = bwidth/2-sthick-0.1;
        for (h = [hs:holeoff:he]) {
            translate([-b1,h,holerad-19]) rotate([0,-90,0])
                cylinder(sthick+0.2, holerad+0.1, holerad-sthick+0.1, false, $fn=4);
            translate([ b1,h,holerad-19]) rotate([0, 90,0])
                cylinder(sthick+0.2, holerad+0.1, holerad-sthick+0.1, false, $fn=4);
        }
        
        gshi = 21.5 - 0.8;
        gsw = 2.5;
        gsl = 10;
        // Room for glue strip, with holes
        if (covernumber%2) {
            translate([-bwidth/2-0.001,pend-gsl,-gshi])
                cube([sthick/2+0.001, 20.001, gsw]);
            translate([-b1,pend-gsl,-gshi+gsw/2]) rotate([0,-90,0])
                cylinder(sthick+0.2, gsw/2,gsw/2, false, $fn=4);
            
            translate([bwidth/2-sthick/2,pend-gsl,-gshi])
                cube([sthick/2+0.001, 20.001, gsw]);
            translate([ b1,pend-gsl,-gshi+gsw/2]) rotate([0, 90,0])
                cylinder(sthick+0.2, gsw/2,gsw/2, false, $fn=4);
        } else {
            translate([-bwidth/2-0.001,pstart-0.001,-gshi])
                cube([sthick/2+0.001, gsl+0.001, gsw]);
            translate([-b1,pstart+gsl,-gshi+gsw/2]) rotate([0,-90,0])
                cylinder(sthick+0.2, gsw/2,gsw/2, false, $fn=4);

            translate([bwidth/2-sthick/2,pstart-0.001,-gshi])
                cube([sthick/2+0.001, gsl+0.001, gsw]);
            translate([ b1,pstart+gsl,-gshi+gsw/2]) rotate([0, 90,0])
                cylinder(sthick+0.2, gsw/2,gsw/2, false, $fn=4);
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