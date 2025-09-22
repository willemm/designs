original_path = "N:/Dungeon Blocks/Majestic Highlands/MH-001-Grass.stl";
echo(original_path);

gridded(original_path);

module gridded(path) {
    difference() {
        original(original_path);
        cutout(-0.5);
        cutout( 0.5);
        rotate([0,0,90]) cutout(-0.5);
        rotate([0,0,90]) cutout( 0.5);
    }
}

module cutout(off = 0, len = 3) {
    tile = 35;
    pts = [[0,0],[4.6,5.4],[4.6,8.7],[5.6,10], [5.5,11]];
    arr = [ pts[0], pts[1], pts[2], pts[3], pts[4],
        mir(pts[4]), mir(pts[3]), mir(pts[2]), mir(pts[1]) ];
    rotate([-90,0,0]) translate([off*tile,-10,-tile*len/2-1]) linear_extrude(height=tile*len+2, convexity=5) polygon(arr);

}

function mir(pt) = [-pt.x, pt.y];

module original(path) {
    import(path, convexity=10);
}
