
acryl_thick = 3;  // acrylic wall thickness
tape_thick = 0.5;

conn_thick = 3;    // Connector thickness
conn_width = 50;  // Connector width
conn_depth = 23;  // Connector depth

color("#8a5") edgeconnector_outside();
color("#58a") edgeconnector_inside();

module edgeconnector_inside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick)
{
    linear_extrude(height=cw, convexity=5) {
        polygon(concat(
            edgecon_in_poly(cd, ct, at, tt), mirxy(edgecon_in_poly(cd, ct, at, tt))
        ));
    }
}

module edgeconnector_outside(at = acryl_thick, ct = conn_thick, cw = conn_width,
        cd = conn_depth, tt = tape_thick)
{
    linear_extrude(height=cw, convexity=5) {
        polygon(concat(
            edgecon_out_poly(cd, ct, at, tt), mirxy(edgecon_out_poly(cd, ct, at, tt))
        ));
    }
}

function edgecon_in_poly(cd, ct, at, tt, tol=0.1) = (
    let (s2 = sqrt(2)
        ,yi = 0
        ,ym = at
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xo-2, yi-ct], [xo, yi-ct+2], [xo, yi], [xi+tol+2, yi], [xi+tol+2, yi+tt], [xi+tol+1, yi+tt]
    , [xi+tol+1, yi+at+tt-tol], [xi+tol-1, yi+at+tt-tol], [xi+tol-1, yi+1] // [xi+tol, yi]
    , [xi+ct*2, yi-ct*2+tol], [xi+ct*3-tol, yi-ct], [xo-ct*s2-2, yi-ct] ]
);

function edgecon_out_poly(cd, ct, at, tt, tol=0.1) = (
    let (s2 = sqrt(2)
        ,yi = 0
        ,ym = at+tt
        ,yo = ym+ct
        ,xi = ct/s2
        ,xo = cd
        )
    [ [xi+ct*3+ct/s2, yi-ct-ct/s2], [xi+ct*3+ct/s2, yi-ct-tol], [xi+ct*3-tol, yi-ct-tol], [xi+ct*2, yi-ct*2]
    , [xi-1, yi+1], [xi-1, ym], [xo, ym], [xo, yo], [0, yo] ]
);

function mirxy(ar) = [for (i=[len(ar)-1:-1:0]) [-ar[i].y, -ar[i].x]];
