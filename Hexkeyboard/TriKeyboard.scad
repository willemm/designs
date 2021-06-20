use <Keyboard.scad>;

tside=2;
s3 = sqrt(3);
off = 22;

boltoff = 5.5;
ribthick = 2;
coverhi = 7;
mpthick = 1;

textra = 62;
  
cdia = 36;
kdia = off*(tside*2)+textra-cdia*2;

kext = 0;


screendia = 33;
speakerdia = 50;

tkeycaps();
color("lightblue") tkeycover();
color("green") translate([0,0,-1.1]) tkeyplane();
roundscreen();
rotate([0,0,120]) speaker();
rotate([0,0,240]) speaker();

module speaker()
{
    srd = speakerdia/2;
    color("blue") translate([0,kdia,coverhi-0.5]) cylinder(2, srd, srd, true);
}

module roundscreen()
{
    srd = screendia/2;
    color("green") translate([0,kdia,coverhi-0.5]) cylinder(2, srd, srd, true);
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
    dpt=20;
    
    tothi = hi+dpt+thick;
    bevel = 8;
    translate([0,0,hi]) difference() {
        translate([-kext/2,0,0]) union() {
            translate([0,0,-dpt-hi]) tkeycover_box();
        }
        
        // Main hex keys
        for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
            translate([off*row, off*col*s3/2, -hi-0.1])
                linear_extrude(height=thick+hi+0.2)
                polygon([for (a=[60:60:360]) [sin(a)*dia/s3, cos(a)*dia/s3]]);
        }
    }
}

module tkeycover_box()
{
    thick = 2;
    ythick = 1;
    dia=off+1;
    hi=coverhi-mpthick;
    dpt=20;
    
    tothi = hi+dpt+thick;
    bevel = 6;
    hbev = 1;
    ibev = 4;
    o1 = thick*2;
    o2 = thick*2 + thick;
    o3 = thick*2 + thick + ibev;
    
    ang = 10;
    nsd = 360/ang + 3;
    polyhedron(
        points=concat(
            rounded_poly(kdia, dpt+hi       , cdia-o3, ang),
            rounded_poly(kdia, dpt+hi-ibev, cdia-o2, ang),
            rounded_poly(kdia, dpt, cdia-o2,ang),
            rounded_poly(kdia, dpt, cdia-o1,ang),
            rounded_poly(kdia, 0  , cdia-o1,ang),
            rounded_poly(kdia, 0, cdia,ang),
            rounded_poly(kdia, hi+dpt+thick/2-bevel,cdia,ang),
            rounded_poly(kdia,hi+dpt+thick/2,cdia-bevel,ang)
        ),
        faces=topnquadbot(nsd, 8),
        convexity=4
    );
}

module tkeyplane()
{
    thick = 2;
    kthick = 1.4;
    rh = 6;
    skthick = 1.6;
    translate([0,0,-thick/2]) difference() {
        union() {
            translate([0,0,-thick/2]) tkeyplane_box();
        }
        
        // Normal hex keys
        for (col = [-tside:tside], row = [-(tside-abs(col)/2):(tside-abs(col)/2)]) {
            translate([off*row, off*col*s3/2, 0]) cube([14, 14, thick+0.1], true);
            translate([off*row, off*col*s3/2, -kthick]) cube([16,16,thick+0.1], true);
        }
        
    }
    // horizontal ribs
    for (col = [-tside-0.5:tside+0.5]) {
        kwid = kdia + (tside-abs(col))*off + 15;
        translate([0, off*col*s3/2, -rh/2]) cube([kwid, ribthick, rh], true);
        for (row = [-tside-1+abs(col)/2:tside-abs(col)/2]) {
            translate([off*row+off*1.28-(abs(col)%2)*off/2, off*col*s3/2, -rh-2]) wireclip_y();
        }
    }
    
    // Vertical ribs
    for (col = [-tside:tside], row = [-(tside-abs(col)/2)-0.5:(tside-abs(col)/2)+0.5]) {
        translate([off*row, off*col*s3/2, -rh/2]) cube([ribthick, off*s3/2, rh], true);
        translate([off*row, off*col*s3/2-2.1-(3.3*((col+tside+1)%2)), -rh]) wireclip_x();
    }
}

module tkeyplane_box()
{
    thick = 2;
    kthick = 1.4;
    rh = 6;
    skthick = 1.6;

    ang = 10;
    nsd = 360/ang + 3;
    polyhedron(
        points=concat(
            rounded_poly(kdia, 0, cdia-thick*2-0.1, ang),
            rounded_poly(kdia, thick, cdia-thick*2-0.1, ang)
        ),
        faces=topnquadbot(nsd, 2),
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
