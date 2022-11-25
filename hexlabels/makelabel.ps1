$ErrorAction = 'Stop'

$settings = @{
    'nagi'      = 18, 40, '#cde', '#353', '381.png', -30, -26, 64
    'burns'     = 18, 40, '#cde', '#353', '359.png', -43, -28, 88
    'sparks'    = 18, 40, '#cde', '#353', '433.png', -30, -27, 60
    'sparkle'   = 16, 40, '#cde', '#353', '197.jpg', -23, -28.5, 46

    'clipboard' = 14, 41, '#db3', '#435', '129.jpg', -35, -30, 70
    'strix'     = 18, 40, '#db3', '#435', '346.jpg', -27, -27, 54
    'sigma'     = 18, 40, '#db3', '#435', '145.jpg', -27, -28, 56
    'odin'      = 18, 40, '#db3', '#435', '142.jpg', -23, -28, 48
    'seraphim'  = 14, 41, '#db3', '#435', '136.jpg', -27, -28.5, 57

    'orlov'     = 18, 40, '#db3', '#435', '168.jpg', -32, -29, 64
    'kat'       = 18, 40, '#db3', '#435',  '90.jpg', -30, -26, 65
    'tilia'     = 18, 40, '#db3', '#435',  '82.jpg', -34, -30, 68

    'najat'     = 18, 40, '#cde', '#353', '113.jpg', -27, -30, 54
    'octavia'   = 14, 41, '#cde', '#435',  '38.jpg', -28, -28, 56
}

$svgcontent = @{}

foreach ($itm in $settings.keys) {
    $callsign = $itm.ToUpper()

    ($textsz, $texty, $textfg, $textbg, $image, $imagex, $imagey, $imagew) = $settings[$itm]

    $content = Get-Content -Raw "label.svg"

    $content = [regex]::Replace($content, '{{\s*(.*?)\s*}}', {
        param($m)
        (Get-Variable -Name $m.Groups[1]).Value
    })
    $svgcontent[$itm] = $content
    $content | Out-File -Encoding utf8 "labels/$itm.svg"
}

$svgs = foreach ($itm in $settings.keys | Sort-Object) {
    $svgcontent[$itm] -replace "id=`"", "id=`"$($itm)_" -replace "href=`"#","href=`"#$($itm)_" -replace "url\(#","url(#$($itm)_"
}

$html = "<html><body>`n$($svgs -join "`n")`n</body></html>`n"

$html | Out-File -Encoding utf8 "labels/index.html"
