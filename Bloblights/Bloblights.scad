dopow=0;
doback=0;
docover=3;

interlace = false;

overlap = 0;

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
    connectorholder();
    *intersection() {
        ledholder();
        translate([0,-250,10]) cube([80,50,40],true);
    }
} else if (dopow) {
    if (dopow == 1) {
        rotate([90,0,-35]) powerblock_back();
    } else if (dopow == 2) {
        powerblock_left();
    } else if (dopow == 3) {
        powerblock_right();
    } else {
        *color("lightblue") translate([-20,0,28]) cube([200,58,40],true);
        powerblock_back();
        powerblock_left();
        translate([0,0,0]) powerblock_right();
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
        translate([0,-0.1,0]) blobcover(0);
        
        /*
        gshi = 21.5 - 0.8 - 1.25;
        #translate([-bwidth/2,partlength,-gshi]) rotate([0, 90,0]) coverconnect();
        #translate([ bwidth/2,partlength,-gshi]) rotate([0,-90,0]) coverconnect();
        */
    } else {
        blobcover(docover);
    }
}

module powerblock_left()
{
    side_off = 50;
    box_len = 268-side_off;
    box_wid = 66;
    box_hei = 50;
    thick = 1.2;
    tol=0.1;
    
    difference() {
        union() {
            translate([-side_off/2-thick/2-tol/2,
                    -(box_wid/2+thick/2+tol),box_hei/2+thick/2])
                cube([box_len+thick+tol,thick,box_hei+thick],true);
            translate([-side_off/2-thick/2-tol/2,
                    +(box_wid/2+thick/2+tol),box_hei/2+thick/2])
                cube([box_len+thick+tol,thick,box_hei+thick],true);
            translate([-side_off/2-(box_len/2+thick/2+tol),0,box_hei/2])
                cube([thick,box_wid+thick*2+tol*2,box_hei],true);
            translate([-side_off/2-thick/2-tol/2,0,box_hei+thick/2])
                cube([box_len+thick+tol,box_wid+thick*2+tol*2,thick],true);
            
            // Connecting bridge to keep it on the pins
            translate([-side_off/2+box_len/2-0.6,0,10])
                cube([1.2,box_wid+thick,3], true);
            translate([-side_off/2+box_len/2-0.6,-box_wid/2+0.5,box_hei/2+5])
                cube([1.2,2.5,box_hei-8], true);
            translate([-side_off/2+box_len/2-0.6,box_wid/2-0.5,box_hei/2+5])
                cube([1.2,2.5,box_hei-8], true);
            translate([-side_off/2+box_len/2-0.6,0,box_hei-0.5])
                cube([1.2,box_wid+thick,2], true);
        }
        translate([-side_off/2-box_len/2,-box_wid/2,-0.01])
            linear_extrude(height=box_hei+thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]
            ]);
        mirror([0,1,0])
        translate([-side_off/2-box_len/2,-box_wid/2,-0.01])
            linear_extrude(height=box_hei+thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]
            ]);
        translate([-side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei])
            rotate([0,90,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        mirror([0,1,0])
        translate([-side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei])
            rotate([0,90,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        translate([-side_off/2-box_len/2,-box_wid/2-thick-0.01,box_hei])
            rotate([-90,0,0]) linear_extrude(height=box_wid+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        // Ventilation holes down
        for (x=[-21:13],z=[2:4]) if ((x+z)%2) {
            translate([x*5,-box_wid/2-thick-tol-0.01,z*5]) rotate([-90,0,0])
                cylinder(thick+0.02, 2, 2, false, $fn=30);
        }
        // Ventilation holes up
        for (x=[-21:13],z=[2:8]) if ((x+z)%2) {
            translate([x*5,box_wid/2+tol-0.01,z*5]) rotate([-90,0,0])
                cylinder(thick+0.02, 2, 2, false, $fn=30);
        }
        
        // Screw holes
        for (x=[-115,75]) {
            translate([x,-box_wid/2-tol-thick/2,4.5]) rotate([-90,0,0])
                cylinder(thick+5.02, 1.5, 1.5, true, $fn=30);
        }
        // Pin holes
        for (x=[-115,75]) {
            translate([x,box_wid/2+tol-thick/2,5.3]) rotate([-90,0,0])
                cylinder(thick+5.02, 1.6, 1.6, true, $fn=30);
        }
        // Power cord hole
        translate([-side_off/2-box_len/2-thick-tol-0.01,15,thick+3]) rotate([0,90,0]) {
            cylinder(thick+0.02,5,5,false,$fn=30);
            translate([5,0,thick/2+0.01]) cube([10,10,thick+0.02], true);
        }
    }
    
    
}

module powerblock_right()
{
    side_off = 218.1;
    box_len = 268-side_off;
    box_wid = 66;
    box_hei = 60;
    thick = 1.2;
    tol=0.1;
    schn = 10;
    
    difference() {
        union() {
            translate([side_off/2+thick/2+tol/2,
                    -(box_wid/2+thick/2+tol),box_hei/2+thick/2])
                cube([box_len+thick+tol,thick,box_hei+thick],true);
            translate([side_off/2+thick/2+tol/2,
                    +(box_wid/2+thick/2+tol),box_hei/2+thick/2])
                cube([box_len+thick+tol,thick,box_hei+thick],true);
            translate([side_off/2+(box_len/2+thick/2+tol),0,box_hei/2])
                cube([thick,box_wid+thick*2+tol*2,box_hei],true);
            translate([side_off/2+thick/2+tol/2,0,box_hei+thick/2])
                cube([box_len+thick+tol,box_wid+thick*2+tol*2,thick],true);
            
            translate([side_off/2-box_len/2,-box_wid/2-thick-0.01,
                box_hei])
                rotate([-90,0,0]) linear_extrude(height=box_wid+2*thick+0.02) 
                    polygon([
                        [0,0],
                        [0,schn+2.9],[schn+1,0]
                    ]);
            
            // Edge against bottom
            translate([side_off/2+thick/2+tol/2+10,+(box_wid/2),9])
                cube([30,thick*2,1.8],true);
            translate([side_off/2+thick/2+tol/2+10,-(box_wid/2),9])
                cube([30,thick*2,1.8],true);
            
            // Lip edges
            translate([side_off/2-box_len/2,-box_wid/2-thick-0.01,8.1])
                linear_extrude(height=45) 
                    polygon([
                        [0,0],
                        [0,4.4],[1,4.4],[5.4,0]
                    ]);
            mirror([0,1,0])
            translate([side_off/2-box_len/2,-box_wid/2-thick-0.01,8.1])
                linear_extrude(height=45) 
                    polygon([
                        [0,0],
                        [0,4.4],[1,4.4],[5.4,0]
                    ]);

            // Lips    
            translate([side_off/2-box_len/2-2,0,47.7])
                cube([4,box_wid-4,1.2],true);
            translate([side_off/2-box_len/2,-box_wid/2+3.2,0])
                rotate([90,0,0]) linear_extrude(height=1.2) polygon([
                    [-5,12],[-10,17],[-10,43.3],[-5,48.3],
                    [0,48.3],[0,12]
                ]);
                //cube([10,1.2,36.3],true);
            translate([side_off/2-box_len/2,box_wid/2-2,0])
                rotate([90,0,0]) linear_extrude(height=1.2) polygon([
                    [-5,12],[-10,17],[-10,43.3],[-5,48.3],
                    [0,48.3],[0,12]
                ]);
        }
        translate([side_off/2+box_len/2,-box_wid/2,-0.01])
            linear_extrude(height=box_hei+thick+0.02) polygon([
                [+thick+tol+1,-thick-tol-1],
                [+thick+tol+1,-tol+1],[+tol-1,-thick-tol-1]
            ]);
        mirror([0,1,0])
        translate([side_off/2+box_len/2,-box_wid/2,-0.01])
            linear_extrude(height=box_hei+thick+0.02) polygon([
                [+thick+tol+1,-thick-tol-1],
                [+thick+tol+1,-tol+1],[+tol-1,-thick-tol-1]
            ]);
        translate([side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei])
            rotate([0,90,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        mirror([0,1,0])
        translate([side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei])
            rotate([0,90,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        translate([side_off/2+box_len/2,-box_wid/2-thick-0.01,box_hei])
            rotate([-90,0,0]) linear_extrude(height=box_wid+2*thick+0.02) polygon([
                [+thick+tol+1,-thick-tol-1],
                [+thick+tol+1,-tol+1],[+tol-1,-thick-tol-1]

            ]);
        translate([side_off/2-box_len/2,-box_wid/2-thick*2-0.01,box_hei+thick])
            rotate([-90,0,0]) linear_extrude(height=box_wid+2*thick*2+0.02) polygon([
                [-1,-1],
                [-1,schn+1],[schn+1,-1]

            ]);
        translate([side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei-schn-1.7])
            rotate([0,45,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
        mirror([0,1,0])
        translate([side_off/2-box_len/2-thick-0.01,-box_wid/2,box_hei-schn-1.7])
            rotate([0,45,0]) linear_extrude(height=box_len+2*thick+0.02) polygon([
                [-thick-tol-1,-thick-tol-1],
                [-thick-tol-1,-tol+1],[-tol+1,-thick-tol-1]

            ]);
            
        // Screw hole
        translate([side_off/2+box_len/2+thick+tol+0.01,0,4.5]) rotate([0,-90,0])
            cylinder(thick+0.02, 1.5, 1.5, false, $fn=30);

        // Power cord holes
        translate([side_off/2+box_len/2+tol-0.01,15,thick+3]) rotate([0,90,0]) {
            cylinder(thick+0.02,5,5,false,$fn=30);
            translate([5,0,thick/2+0.01]) cube([10,10,thick+0.02], true);
        }
        translate([side_off/2+box_len/2+tol-0.01,-15,thick+3]) rotate([0,90,0]) {
            cylinder(thick+0.02,5,5,false,$fn=30);
            translate([5,0,thick/2+0.01]) cube([10,10,thick+0.02], true);
        }

        // Ventilation holes down
        for (x=[21:25],z=[3:5]) if ((x+z)%2) {
            translate([x*5+2,-box_wid/2-thick-tol-0.01,z*5-3]) rotate([-90,0,0])
                cylinder(thick+0.02, 2, 2, false, $fn=30);
        }
        // Ventilation holes up
        for (x=[21:25],z=[3:11]) if ((x+z)%2) {
            translate([x*5+2,box_wid/2+tol-0.01,z*5-3]) rotate([-90,0,0])
                cylinder(thick+0.02, 2, 2, false, $fn=30);
        }
    }
}

module powerblock_back()
{
    thick = 2;
    sidethick = 8;
    sidewid = 1.2;
    
    nutthick = 2.6;
    nutwall = 1.4;
    nutbot = 2;
    nutsz = 5.4;
    
    pb_len = 200;
    pb_wid = 58;
    pb_hei = 40;
    
    marg_left = 10;
    marg_right = 30;
    
    mod_len = 30;
    mod_wid = 62;
    mod_hei = 55;
    
    box_len = 268; // 200+marg_left+marg_right+mod_len;
    box_wid = 66;
    box_hei = 55;
    
    holex = 190;
    holey = 40;
    holed = 3;
    
    shx = 220;
    shy = 45;
    sho = -15;
    shd = 4;
    
    ribthick = thick+nutthick+nutwall+nutbot;
    pb_off = (marg_left - marg_right);
    
    modhh = 19+thick;
    modrh = 24+thick;
    modrt = 4;
    modho = 2.54*15;
    modhs = 3;
    modstemd = 3;
    modsteml = 5;
    
    modof = box_len/2-mod_len;
    
    difference() {
        union() {
            // Bottom
            translate([0,0,thick/2]) cube([box_len, box_wid, thick], true);
            // Sides
            translate([0,+(box_wid/2-sidewid/2),sidethick/2])
                cube([box_len, sidewid, sidethick], true);
            translate([0,-(box_wid/2-sidewid/2),sidethick/2])
                cube([box_len, sidewid, sidethick], true);
            translate([+(box_len/2-sidewid/2),0,sidethick/2])
                cube([sidewid, box_wid, sidethick], true);
            translate([-(box_len/2-sidewid/2),0,sidethick/2])
                cube([sidewid, box_wid, sidethick], true);
            
            // Print supports for "upper" side
            translate([-box_len/2,+box_wid/2-sidewid,0])
                rotate([0,90,0]) linear_extrude(height=box_len)
                polygon([
                [-sidethick,0],[0,-sidethick+2],[0,0]
            ]);
            
            // Ribs for psu
            translate([pb_off-holex/2,0,ribthick/2])
                cube([nutsz+4, box_wid, ribthick], true);
            translate([pb_off+holex/2,0,ribthick/2])
                cube([nutsz+4, box_wid, ribthick], true);
            
            // Rib for module
            translate([modof-modrt/2, 0, modrh/2])
                cube([modrt, box_wid, modrh], true);
            
            // Stems for holding module
            intersection() {
                union() {
                    translate([modof-0.001, -modho/2, modhh]) rotate([0,90,0])
                        cylinder(modsteml, modstemd+modsteml, modstemd, false, $fn=30);
                    translate([modof-0.001, +modho/2, modhh]) rotate([0,90,0])
                        cylinder(modsteml, modstemd+modsteml, modstemd, false, $fn=30);
                }
                translate([modof+5.8/2, 0, modrh/2])
                    cube([6, box_wid, modrh], true);
            }
            // Offset feet screws
            for (x=[sho-shx/2,sho+shx/2], y=[-shy/2,shy/2]) {
                translate([x,y,0.001]) rotate([180,0,0])
                    cylinder(2, shd/2+4,shd/2+2, false, $fn=30);
            }
            // End cap nut
            translate([box_len/2,0,0]) rotate([0,-90,0])
                linear_extrude(height=nutthick+2.4) polygon([
                [8,-2],[8,2],[1,9],[1,-9]
            ]);
            
            // Power cord hole
            translate([-box_len/2,15,thick+3.5]) rotate([0,90,0]) {
                cylinder(sidewid,5,5,false,$fn=30);
            }

            // Led lead holes
            for (y = [-15,15]) {
                translate([box_len/2,y,thick+3.5]) rotate([0,-90,0])
                    cylinder(sidewid,5,5,false,$fn=30);
            }

        }
        // Holes for nuts psu
        translate([pb_off-holex/2,+holey/2,ribthick-nutwall-nutthick/2])
            cube([nutsz+4.1, nutsz+0.2, nutthick], true);
        translate([pb_off-holex/2,+holey/2,1])
            cylinder(8, holed/2+0.2, holed/2+0.2, false, $fn=60);
        
        translate([pb_off+holex/2,-holey/2,ribthick-nutwall-nutthick/2])
            cube([nutsz+4.1, nutsz+0.2, nutthick], true);
        translate([pb_off+holex/2,-holey/2,1])
            cylinder(8, holed/2+0.2, holed/2+0.2, false, $fn=60);
        
        // Holes for nuts module
        translate([modof-modrt-0.1, -modho/2, modhh]) rotate([0,90,0])
            cylinder(modrt+modsteml+0.2, modhs/2, modhs/2, false, $fn=60);
        translate([modof-modrt-0.1, -modho/2, modhh]) rotate([0,90,0])
            cylinder(5, nutsz/s2+0.2, nutsz/s2+0.2, false, $fn=4);

        translate([modof-modrt-0.1, +modho/2, modhh]) rotate([0,90,0])
            cylinder(modrt+modsteml+0.2, modhs/2, modhs/2, false, $fn=60);
        translate([modof-modrt-0.1, +modho/2, modhh]) rotate([0,90,0])
            cylinder(5, nutsz/s2+0.2, nutsz/s2+0.2, false, $fn=4);
            
        // Holes for screws
        for (x=[sho-shx/2,sho+shx/2], y=[-shy/2,shy/2]) {
            translate([x,y,thick+0.1]) rotate([180,0,0])
                cylinder(thick+2.2, shd/2,shd/2, false, $fn=60);
        }
        
        // Holes for cover mount nuts
        translate([pb_off+holex/2,-box_wid/2+1+nutthick/2,ribthick-nutwall-nutthick/2])
            cube([nutsz+0.2, nutthick, nutsz+2.1], true);
        translate([pb_off+holex/2,-box_wid/2-0.001,4.5]) rotate([-90,0,0])
            cylinder(8, holed/2+0.2, holed/2+0.2, false, $fn=30);

        translate([pb_off-holex/2,-box_wid/2+1+nutthick/2,ribthick-nutwall-nutthick/2])
            cube([nutsz+0.2, nutthick, nutsz+2.1], true);
        translate([pb_off-holex/2,-box_wid/2-0.001,4.5]) rotate([-90,0,0])
            cylinder(8, holed/2+0.2, holed/2+0.2, false, $fn=30);
        
        // End cap nut
        translate([box_len/2+0.1,0,4.5]) rotate([0,-90,0])
            cylinder(10, holed/2, holed/2, false, $fn=30);
        translate([box_len/2-(nutthick+2.4)/2,0,4.5])
            cube([nutthick, nutsz+0.2, nutsz+2.1], true);

        // Power cord hole
        translate([-box_len/2-0.01,15,thick+3.5]) rotate([0,90,0]) {
            cylinder(10,3.5,3.5,false,$fn=30);
            // translate([-3.5,0,3.5]) cube([7,7,7], true);
        }
        // Led lead holes
        for (y = [-15,15]) {
            translate([box_len/2+0.01,y,thick+3.5]) rotate([0,-90,0])
                cylinder(10,3.5,3.5,false,$fn=30);
        }
        
        // Ventilation holes
        for (x = [-17:17], y = [-5:5]) if ((x+y)%2) {
            translate([x*5+pb_off,y*5,-0.01])
                cylinder(sidethick+0.2, 2, 2, false, $fn=20);
        }
        // Ventilation holes II
        for (x = [26:29], y = [-5:5]) if ((x+y)%2) {
            translate([x*5+pb_off,y*5,-0.01])
                cylinder(sidethick+0.2, 2, 2, false, $fn=20);
        }
    }
    // Sacrifical bridge layer for cover mount nut holes
    #translate([pb_off+holex/2, -box_wid/2+3+nutthick/2+0.1, ribthick-nutwall-nutthick/2])
        cube([nutsz+0.2, 0.2, nutsz-0.1], true);
    #translate([pb_off-holex/2, -box_wid/2+3+nutthick/2+0.1, ribthick-nutwall-nutthick/2])
        cube([nutsz+0.2, 0.2, nutsz-0.1], true);
    /*
    *#translate([-box_len/2+sidewid/2,15,sidethick-0.4])
        cube([sidewid,7.001,0.8], true);
    */
    
    // Pins for cover holes
    translate([pb_off+holex/2,+box_wid/2,ribthick-nutwall-nutthick/2])
        rotate([-90,0,0]) cylinder(3, holed/2, holed/2, false, $fn=60);
    translate([pb_off+holex/2,+box_wid/2+3,ribthick-nutwall-nutthick/2])
        rotate([-90,0,0]) cylinder(1, holed/2, holed/4, false, $fn=60);
    translate([pb_off-holex/2,+box_wid/2,ribthick-nutwall-nutthick/2])
        rotate([-90,0,0]) cylinder(3, holed/2, holed/2, false, $fn=60);
    translate([pb_off-holex/2,+box_wid/2+3,ribthick-nutwall-nutthick/2])
        rotate([-90,0,0]) cylinder(1, holed/2, holed/4, false, $fn=60);
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
    f = 2.2;
    tr = 9;
    th = 11;
    tmh = 15;
    b2 = 20/2;
    b3 = b2+8;

    bh = bwidth/2-sthick-7;
    bhr = 4/2;
    
    hoff = 50/6+25;
    difference() {
        union() {
          rotate([90,0,0]) linear_extrude(height=l, convexity=5) polygon([
            [-b1, s],[-b1,-f],[-b3,-f],[-b2,tr],
            [b2,tr],[b3,-f],[b1,-f],[b1,s],
            [b1-t,s],[b1-t,0],[b3,0],[b2,th],[0,tmh],
            [-(b2),th],[-b3,0],[-(b1-t),0],[-(b1-t), s]
          ]);
          translate([0,10-l,0]) rotate([90,0,0]) linear_extrude(height=10, convexity=5) polygon([
            [-b3,-f],[-b2,tr+0.1],[-b2,tr-4]
          ]);
          translate([0,10-l,0]) rotate([90,0,0]) linear_extrude(height=10, convexity=5) polygon([
            [ b3,-f],[ b2,tr+0.1],[ b2,tr-4]
          ]);
        }

        for (h = [-hoff:-l+hoff*2:-l+hoff]) {
            translate([ bh,h,-f-0.5]) cylinder(f+1, bhr, bhr, false, $fn=20);
            translate([-bh,h,-f-0.5]) cylinder(f+1, bhr, bhr, false, $fn=20);
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
        translate([-8,-l+7-2/2,tr-4.8/2]) cube([50,2.2,4.8-0.001], true);
        translate([0,-l+7-2/2,tr-6/2]) cube([23,2.2,6-0.001], true);
        // #translate([0,-l+7-2/2,tr-4.8/2]) cube([22,2.2,4.8-0.001], true);
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
            [-b2,tr-8.4],[b2,tr-8.4],
            [b2,-f],[b3,-f],
            [b2+0.01,tr+0.01],[-b2-0.01,tr+0.01]
        ]);
        for (x=[-2:2]) {
            translate([x*3.96,-l+11-0.5,tr-6]) cube([1.2,1.2,1.2],true);
        }
    }
    *#translate([0,-l+7,4.4]) rotate([90,0,0]) connectorholder();
}

module connectorholder()
{
    lw1 = 11.45;
    lw2 = 14.8;
    lh = 4.6;
    lw3 = 11.5;
    // Connector lip holder
    
    linear_extrude(height=2, convexity=5) polygon([
        //[-7,lh-1.5],
        [-8.5,lh],
        [-lw1,lh], [-lw2,0],
        [-lw3-0.5,0], [-lw3,1], [-10,1.8],
        [-5,1.2], [-5,0.8], [-10,0.8], [-lw3+0.1,0],
        [-lw3+0.1,-0.8], [-10,0],

        [ 10,0], [ lw3-0.1,-0.8],
        [ lw3-0.1,0], [ 10,0.8], [ 5,0.8], [ 5,1.2],
        [ 10,1.7], [ lw3,0.8], [ lw3+0.5,0],
        [ lw2,0], [ lw1,lh],
        [ 8.5,lh]//, [ 7,lh-1.5]

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
    doend = ((covernumber == 1) ? 1 : ((covernumber == numparts) ? -1 : 0));
    
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
        for (x=[-1,1], y=[-10,-14,-18]) {
          translate([x*(bwidth/2-sthick/2),-cof+0.01,y]) rotate([90,45,0])
            cylinder(thick+0.02,sthick/2-0.1,sthick/2-0.3, $fn=4);
        }
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
        for (x=[-1,1], y=[-10,-14,-18]) {
          translate([x*(bwidth/2-sthick/2),length+cof-0.01,y])
            rotate([-90,45,0])
            cylinder(thick+0.02,sthick/2-0.1,sthick/2-0.3, $fn=4);
        }
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
        } else if (!doend && overlap) {
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
        
        /*
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
        */
      }
      if (doend == 1) {
        for (x=[-1,1], y=[-10,-14,-18]) {
          translate([x*(bwidth/2-sthick/2),-cof,y]) rotate([90,45,0])
            cylinder(thick,sthick/2-0.2,sthick/2-0.4, $fn=4);
        }
      }
      if (doend == -1) {
        for (x=[-1,1], y=[-10,-14,-18]) {
          translate([x*(bwidth/2-sthick/2),length+cof,y]) rotate([-90,45,0])
            cylinder(thick,sthick/2-0.2,sthick/2-0.4, $fn=4);
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