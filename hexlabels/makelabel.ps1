$ErrorAction = 'Stop'

$settings = @{
    'nagi'      = 18, 40, '#cde', '#353', 'nagi.png',      -30, -28, 64
    'sigma'     = 18, 40, '#db3', '#335', 'sigma.jpg',     -27, -28, 56
    'clipboard' = 14, 41, '#db3', '#335', 'clipboard.jpg', -35, -30, 70
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
