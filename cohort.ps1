param([switch]$html)

$circleinner = 368
$planetoffset = 20
$planetradius = 60
$sunradius = 40
$edge = 3
$script:sunY = 0
$inangle = 10
$outangle = 15
$numrays = 3

$suncol = "#fff"

function planet($offset = $planetoffset, $radius = $planetradius)
{
    "M -$radius $offset"
    "a $radius $radius 0 0 1  $($radius*2) 0"
    "a $radius $radius 0 0 1 -$($radius*2) 0"
    "Z"
}

function sun($radius=$sunradius, $edgeradius=$planetradius+$edge, $intersectX=$sunradius-5)
{
    # Get intersectY from intersectX
    $intersectY = -[math]::sqrt($edgeradius*$edgeradius - $intersectX*$intersectX) + $planetoffset
    # Calculate center of sun from intersectX and sun radius (sunX = 0)
    $script:sunY = [math]::sqrt($radius*$radius - $intersectX*$intersectX) + $intersectY

    "M -{0:0.0} {1:0.0}" -f ($intersectX, $intersectY)
    "A {0} {0} 0 0 1  {1:0.0} {2:0.0}" -f ($radius, $intersectX, $intersectY)
    "A {0} {0} 0 0 0 -{1:0.0} {2:0.0}" -f ($edgeradius, $intersectX, $intersectY)
    "Z"
}

function crown($step=0, $angle=10, $outangle=10, $inradius=$sunradius+$edge, $radius=$circleinner-$edge, $sunoffset = $script:sunY)
{
    $ian1 = ($angle*($step-0.5))*[math]::PI/180
    $ian2 = ($angle*($step+0.5))*[math]::PI/180
    $oan1 = ($outangle*($step-0.5))*[math]::PI/180
    $oan2 = ($outangle*($step+0.5))*[math]::PI/180
    "M {0:0.0} {1:0.0}" -f (($inradius * [math]::sin($ian1)), -($inradius * [math]::cos($ian1) - $sunoffset))
    "A {0} {0} 0 0 1  {1:0.0} {2:0.0}" -f ($inradius, ([math]::sin($ian2)*$inradius), -([math]::cos($ian2)*$inradius - $sunoffset))
    "L {0:0.0} {1:0.0}" -f (([math]::sin($oan2)*$radius), -([math]::cos($oan2)*$radius))
    "A {0} {0} 0 0 0  {1:0.0} {2:0.0}" -f ($radius, ([math]::sin($oan1)*$radius), -([math]::cos($oan1)*$radius))
    "Z"
}

function crowns($angle=$inangle, $outangle=$outangle, $num=$numrays, $color=$suncol)
{
  $cnt = 1
  @(
  foreach ($st in (-$num .. $num)) {
      '  <path id="crown{0}" fill="{1}" d="' -f ($cnt,$color)
      '    '+((crown -step ($st*2) -angle $angle -outangle $outangle) -join "`r`n    ")
      '  " />'
      ''
    $cnt += 1
  }
  ) -join "`r`n"
}

function star($x, $y, $rado=20, $radi=10, $pts=4)
{
    $cmd = "M"
    foreach ($st in (0 .. ($pts-1))) {
        $an1 = $st * 2*[math]::pi/$pts
        $an2 = ($st+0.5) * 2*[math]::pi/$pts
        "{0} {1:0.0} {2:0.0}" -f ($cmd, ($x + [math]::sin($an1)*$rado), ($y - [math]::cos($an1)*$rado))
        $cmd = "L"
        "{0} {1:0.0} {2:0.0}" -f ($cmd, ($x + [math]::sin($an2)*$radi), ($y - [math]::cos($an2)*$radi))
    }
    "Z"
}

function stars($color = "#fff")
{
    $starposr = @(
        90, 90,
        60, 120,
        200, 150,
        -150, 180,
        -130, 200,
        -200, 120,
        50, 250,
        -30, 270,
        -80, 280,
        20, 180,
        -70, 100,
        80, 105
    )
    $starpos = @(
        -270, 100,
        -210, 80,
        -150, 50,
        -220, 130,
        -140, 120,
        -130, 180,

        -80, 250,
        -20, 200,

        150, 110,
        220, 60,
        140, 200,
        200, 140
    )
    $ns = $starpos.count/2
    @(
    foreach ($st in (0 .. ($starpos.count/2-1))) {
        '  <path id="star{0}" fill="{1}" d="' -f ($st,$color)
        '    '+((star $starpos[$st*2] $starpos[$st*2+1]) -join "`r`n    ")
        '  " />'
        ''
    }
    ) -join "`r`n"
}

if ($html) {
@"
<!DOCTYPE html>
<html>
<head>
    <title>Cohort</title>
    <meta charset="utf-8">
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width">
</head>
<body>
"@
}
@"
<svg $(if ($html) { ' width="800" height="800"' }) xmlns="http://www.w3.org/2000/svg" viewBox="-450 -450 900 900" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <path id="circleCW" fill="black" stroke="#bcd" style="stroke-width:15" d="
      M 0  377
      a 377 377 0 0 1  0 -754
      a 377 377 0 0 1  0  754
      Z
    " />
    <path id="circleCCW" fill="black" stroke="#bcd" style="stroke-width:15" d="
      M 0 -438 
      a 438 438 0 0 0  0  876
      a 438 438 0 0 0  0 -876
      Z
    " />
  </defs>
  <circle cs="0" cy="0" r="450" fill="black" />
  <path fill="#bcd" d="
    M -368 0
    a 368 368 0 0 1  736 0
    a 368 368 0 0 1 -736 0
    Z
    M -450 0
    a 450 450 0 0 0  900 0
    a 450 450 0 0 0 -900 0
    Z
  " />
  <text fill="#345" font-size="84" style="font-family: arial;" font-weight="bold" letter-spacing="4" word-spacing="30">
    <textPath xlink:href="#circleCW" text-anchor="middle" startOffset="50%">
      ONGSTRAY ALONAY
    </textPath>
  </text>
  <text fill="#345" font-size="84" style="font-family: arial;" font-weight="bold" letter-spacing="10" word-spacing="20">
    <textPath xlink:href="#circleCCW" text-anchor="middle" startOffset="50%">
      ERSTRONGAY OGETHERTAY
    </textPath>
  </text>

  <path id="planet" fill="#46f" d="
    $((planet) -join "`r`n    ")
  " />

  <path id="sun" fill="$suncol" d="
    $((sun) -join "`r`n    ")
  " />

  $(crowns)

  $(stars)

</svg>
"@
if ($html) {
@"
</body>
"@
}
