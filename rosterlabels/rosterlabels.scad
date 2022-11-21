

hexdia = 60;
hexside = 6;
labelw = 110;
labelside = 1;

hexin = 2;

thick = 5.2;
slit = 0.8;

magnetsize = [1.8, 9.8, 4.8];

magnetoff = magnetsize.x/2+1.2;

translate([hexdia/2, 0, 0]) {
    hexlabel();

    *translate([-(hexdia/2-magnetoff), 0, thick/2]) magnet();
    //*translate([ (hexdia/2-magnetoff), 0, thick/2]) magnet();
    *translate([ (hexdia/2+labelw+hexside-magnetoff), 0, thick/2]) magnet();
}

module hexlabel()
{
    hxr = hexdia/sqrt(3);
    hxir = (hexdia-hexside*2)/sqrt(3);
    hin = hexside-hexin;
    hxsr = (hexdia-hin*2)/sqrt(3);
    difference() {
        linear_extrude(height=thick/2, convexity=5) difference() {
            polygon(points=concat(
                [for (an=[30:60:360-30]) [cos(an)*hxr, sin(an)*hxr]],
                [[cos(360-30)*hxr+labelw, sin(360-30)*hxr]
                ,[hexdia+labelw, 0]
                ,[cos(30)*hxr+labelw, sin(30)*hxr]],
                [for (an=[30:60:360-30]) [cos(an)*hxir, sin(an)*hxir]],
                [[cos(360-30)*hxr+labelside, sin(360-30)*hxr+hexside]
                ,[cos(360-30)*hxr+labelw, sin(360-30)*hxr+hexside]
                ,[cos(30)*hxr+labelw, sin(30)*hxr-hexside]
                ,[cos(30)*hxr+labelside, sin(30)*hxr-hexside]]
            ), paths=[
                range(0,9),
                range(9,6),
                range(15,4)]);
        }
        translate([-(hexdia/2-magnetoff), 0, thick/2]) magnethole();
        //translate([ (hexdia/2-magnetoff), 0, thick/2]) magnethole();
        //translate([ (hexdia/2+labelw+hexside-magnetoff), 0, thick/2]) magnethole();
        translate([ (hexdia/2+labelw-magnetsize.y/2), sin(30)*hxr-magnetoff, thick/2])
            rotate([0,0,90]) magnethole();
        translate([0, 0, thick/2-slit/2]) linear_extrude(height=slit/2+0.01, convexity=5)
            polygon(concat(
                [for (an=[30:60:150]) [cos(an)*hxsr, sin(an)*hxsr+2*hin]],
                [for (an=[210:60:360-30]) [cos(an)*hxsr, sin(an)*hxsr]]
                ));
        translate([0, 0, thick/2-slit/2]) linear_extrude(height=slit/2+0.01, convexity=5)
            polygon(
                [[cos(360-30)*hxr+labelside-hexin, sin(360-30)*hxr+hin]
                ,[cos(360-30)*hxr+labelw+hexdia, sin(360-30)*hxr+hin]
                ,[cos(30)*hxr+labelw+hexdia, sin(30)*hxr-hin]
                ,[cos(30)*hxr+labelside-hexin, sin(30)*hxr-hin]]
                );
    }
}

function range(f, t) = [for (i = [f:(f+t-1)]) i];

module magnethole()
{
    cube(magnetsize, true);
}

module magnet()
{
    cube(magnetsize, true);
}
