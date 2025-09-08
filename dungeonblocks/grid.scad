
// Total height
height = 13.75365;
// Inside bevel
inset = 2;

// Outside and inside size of a single square
size = 35;
isize = 27; 

// Dimensions of connectors
clen = 12.6;
cwid = 1.7;
coff = 1.3;
ctol = 0.3;

cells_x = 6;
cells_y = 6;

cell_jmp = 3;

*color("#aaa") {
    *import("DB to XL Grid Adaptor.stl", 10);
    *#translate([1.5*size, 1.5*size, 0]) import("XL Lock Grid.stl", 10);
    translate([4.5*size, 1.5*size, 0]) import("XL Lock Grid.stl", 10);
    translate([4.5*size, -1.5*size, 0]) import("XL Lock Grid.stl", 10);
    *import("Grid 3x3.stl", 10);
    *import("grid 6x6.stl", 10);
}

render(convexity=10)
grid(cells_x, cells_y);

module grid(cx, cy)
{
    owid = (size-isize)/2;
    rotate([0,0,  0]) translate([-size*cx/2, -size*cy/2, 0]) obeam(cy, owid);
    rotate([0,0, 90]) translate([-size*cy/2, -size*cx/2, 0]) obeam(cx, owid);
    rotate([0,0,180]) translate([-size*cx/2, -size*cy/2, 0]) obeam(cy, owid);
    rotate([0,0,270]) translate([-size*cy/2, -size*cx/2, 0]) obeam(cx, owid);
    for (x=[1:cx-1]) {
        if (x % cell_jmp == 0) {
            translate([(x-cx/2)*size,-size*cy/2,0]) ibeam(cy, owid);
        } else {
            for (y=[0:cell_jmp:cy-1]) {
                translate([(x-cx/2)*size, size*(-cy/2+y),0]) ifoot();
                translate([(x-cx/2)*size, size*(-cy/2+y+cell_jmp),0]) mirror([0,1,0]) ifoot();
            }
        }
    }
    for (y=[1:cy-1]) {
        rotate([0,0, 90]) if (y % cell_jmp == 0) {
            translate([(y-cy/2)*size,-size*cx/2,0]) ibeam(cx, owid);
        } else {
            for (x=[0:cell_jmp:cx-1]) {
                translate([(y-cy/2)*size, size*(-cx/2+x),0]) ifoot();
                translate([(y-cy/2)*size, size*(-cx/2+x+cell_jmp),0]) mirror([0,1,0]) ifoot();
            }
        }
    }
}

module ifoot(len=8, wid=10.28, hei=5.33, wst=4.3, hst=0.95)
{
    rotate([0,-90,0]) translate([0, 0, -len/2]) linear_extrude(height=len, convexity=6) polygon([
        [0, wst-hst], [0, wid], [hst, wid], [hei, wst], [hei, wst-hst]
    ]);
}

module obeam(cells, wid)
{
    len = cells*size;
    difference() {
        rotate([90,0,0]) translate([0,0,-len]) linear_extrude(height=len, convexity=6) polygon([
            [0, 0], [wid, 0], [wid, height-inset], [wid-inset, height], [0, height]
        ]);
        for (y=[2.5*size:3*size:len]) {
            translate([0, y, -0.01]) mirror([1,0,0]) slot(clen+ctol*5, cwid+ctol, coff+ctol, height+0.02);
        }
    }
    for (y=[0.5*size:3*size:len]) {
        translate([0, y, 0]) slot(clen, cwid, coff, height);
    }
}

module slot(len, wid, off, hi)
{
        linear_extrude(height=hi, convexity=6) polygon([
            [-wid, -len/2], [-wid, len/2], [0.01, len/2-off], [0.01, -(len/2-off)]
        ]);
}

module ibeam(cells, wid)
{
    len = cells*size;
    rotate([90,0,0]) translate([0,0,-len]) linear_extrude(height=len, convexity=6) polygon([
        [-wid, 0], [wid, 0], [wid, height-inset], [wid-inset, height], [inset-wid, height], [-wid, height-inset]
    ]);
}
