deg2rad = PI/180;
translate([0,0,0]) gear(30);
translate([-50,0,0]) rotate([0,0,0/40]) gear(20);
translate([42,0,0]) rotate([0,0,0/24]) gear(12);
translate([0,46,0]) rotate([0,0,0]) rotate([0,0,360/32]) gear(16);
translate([0,-70,0]) rotate([0,0,0]) rotate([0,0,360/80]) gear(40, height=4);

module gear(teeth, modl = 1, thick = 2, height=3, res = 10, cres = 10, pressure=20)
{    
    linear_extrude(height=thick) difference() {
        polygon(gearpoints(modl*teeth, teeth, pressure, height, res, cres));
        circle(2, $fn=60);
    }
    /*
    color("lightgreen") translate([0,0,-1]) circle(modl*teeth*cos(20), $fn=60);
    color("green") translate([0,0,-2]) circle(modl*teeth, $fn=60);
    color("red") translate([0,0,-3]) circle(modl*teeth*cos(20)+height, $fn=60);
    */
}

function gearpoints(radius, teeth, pressure, height, res, cres) =
    [for (t = [0:teeth-1]) let(
        rad = radius*cos(pressure),
        tang = sqrt(height*height + 2*height*rad)/rad/deg2rad,
        steps = res,
        extra = sqrt(radius*radius - rad*rad) - pressure*deg2rad*rad
    ) each concat(
        toothpoints_l(rad, (t-0.25)*(360/teeth), tang/steps, steps, extra),
        toothpoints_r(rad, (t+0.25)*(360/teeth), tang/steps, steps, extra),
        toothinset(radius, teeth, rad, (t+0.5)*(360/teeth), extra, cres)
    )];

function toothpoints_l(rad, ang, tang, steps, extra) =
    [for (inv = [0:steps]) let (ia = inv * tang) [
        rad*sin(ang+ia)-(ia*deg2rad*rad+extra)*cos(ang+ia),
        rad*cos(ang+ia)+(ia*deg2rad*rad+extra)*sin(ang+ia)
    ]];

function toothpoints_r(rad, ang, tang, steps, extra) =
    [for (inv = [steps:-1:0]) let (ia = inv * tang) [
        rad*sin(ang-ia)+(ia*deg2rad*rad+extra)*cos(ang-ia),
        rad*cos(ang-ia)-(ia*deg2rad*rad+extra)*sin(ang-ia)
    ]];

function toothinset(radius, teeth, rad, ang, extra, cres) = 
    [for (st = [cres:-1:-cres]) let (a = ang + (st * 90/cres)) [
        rad*sin(ang) - (((PI/2)*rad/teeth-extra) * sin(a)),
        rad*cos(ang) - (((PI/2)*rad/teeth-extra) * cos(a))
    ]];
