$ErrorAction = 'Stop'

$settings = @{
    'nagi'      = 18, 40, '#cde', '#353', 'nagi.png',      -30, -26, 64
    'burns'     = 18, 40, '#cde', '#353', 'burns.png',     -43, -28, 88
    'sparks'    = 18, 40, '#cde', '#353', 'sparks.png',    -30, -27, 60
    'sparkle'   = 16, 40, '#cde', '#353', 'sparkle.jpg',   -23, -28.5, 46

    'sigma'     = 18, 40, '#db3', '#435', 'sigma.jpg',     -27, -28, 56
    'clipboard' = 14, 41, '#db3', '#435', 'clipboard.jpg', -35, -30, 70
    'strix'     = 18, 40, '#db3', '#435', 'strix.jpg',     -28, -28, 56
    'odin'      = 18, 40, '#db3', '#435', 'odin.jpg',      -23, -28, 48
    'seraphim'  = 14, 41, '#db3', '#435', 'seraphim.jpg',  -27, -28.5, 57
}

foreach ($itm in $settings.keys) {
    $callsign = $itm.ToUpper()

    ($textsz, $texty, $textfg, $textbg, $image, $imagex, $imagey, $imagew) = $settings[$itm]

    $content = Get-Content -Raw "label.svg"

    $content = [regex]::Replace($content, '{{\s*(.*?)\s*}}', {
        param($m)
        (Get-Variable -Name $m.Groups[1]).Value
    })
    $content | Out-File -Encoding utf8 "labels/$itm.svg"
}
