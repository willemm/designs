$ErrorAction = 'Stop'

$settings = @{
    'clipboard' = 14, 41, '#db3', '#435', '129.jpg', -35, -30, 72
    'strix'     = 18, 40, '#db3', '#435', '346.jpg', -27, -27, 54
    'sigma'     = 18, 40, '#db3', '#435', '145.jpg', -27, -28, 56
    'barzha'    = 18, 40, '#db3', '#435', '142.jpg', -23, -28, 48
    'seraphim'  = 14, 41, '#db3', '#435', '136.jpg', -27, -28.5, 57
    'joy'       = 18, 40, '#db3', '#435',  '82.jpg', -34, -30, 68
    'witch'     = 18, 40, '#db3', '#435',  '90.jpg', -30, -26, 65

    'nagi'      = 18, 40, '#cde', '#353', '381.png', -30, -26, 64
    'burns'     = 18, 40, '#cde', '#353', '359.png', -43, -28, 88
    'sparks'    = 18, 40, '#cde', '#353', '433.png', -30, -27, 60
    'sparkle'   = 16, 40, '#cde', '#353', '197.jpg', -23, -28.5, 46
    'glitter'   = 18, 40, '#cde', '#353', '113.jpg', -27, -30, 54

    'octavia'   = 14, 41, '#cde', '#353',  '38.jpg', -28, -28, 56
    #'maati'     = 18, 40, '#cde', '#353',   '1.jpg', -35, -27, 70
    #'keanu'     = 18, 40, '#cde', '#353', '121.jpg', -27, -33, 52
    'Aelia Devin'               = 10, 42, '#cde', '#353', '187.png', -32, -28, 63
    'Darius Anatexis Al Jalmud' = 5, 42, '#cde', '#353', '385.png', -27, -26, 54
    'Tuloy Mabuhay Panatag'     = 6, 42, '#cde', '#353', '132.jpg', -29, -29, 62

    #'orlov'     = 18, 40, '#db3', '#435', '168.jpg', -32, -29, 64

    'Aleksei Volkov'       = 6, 42, '#000', '#fff', '125.jpg', -28, -28, 54, 'ethnocentric'
    'Armond Vincere'       = 6, 42, '#000', '#fff', '106.jpg', -34, -27, 68, 'ethnocentric'
    'Curo Salai Corian'    = 6, 42, '#000', '#fff',  '56.jpg', -33, -28, 66, 'ethnocentric'
    'Medea Flavius'        = 6, 42, '#000', '#fff', '233.png', -36, -24, 74, 'ethnocentric'
    'Nimuel Agati Iskandu' = 6, 42, '#000', '#fff',  '42.jpg', -28, -28, 54, 'ethnocentric'
    'Tiberius Quartus'     = 6, 42, '#000', '#fff',  '46.jpg', -35, -28, 70, 'ethnocentric'
    'Vladimir Karkin'      = 6, 42, '#000', '#fff', '183.jpg', -18, -25, 38, 'ethnocentric'
}

$svgcontent = @{}

foreach ($itm in $settings.keys) {
    $callsign = $itm
    if ($callsign -notmatch ' ') {
        $callsign = $itm.ToUpper()
    }

    ($textsz, $texty, $textfg, $textbg, $image, $imagex, $imagey, $imagew, $textfont) = $settings[$itm]

    if (-not $textfont) { $textfont = 'varino' }

    $content = Get-Content -Raw "label.svg"

    $content = [regex]::Replace($content, '{{\s*(.*?)\s*}}', {
        param($m)
        (Get-Variable -Name $m.Groups[1]).Value
    })
    $svgcontent[$itm] = $content
    #$content | Out-File -Encoding utf8 "labels/$itm.svg"
}

$svgs = foreach ($itm in $settings.keys | Sort-Object) {
    $itmid = $itm -replace ' ','_'
    $svgcontent[$itm] -replace "id=`"", "id=`"$($itmid)_" -replace "href=`"#","href=`"#$($itmid)_" -replace "url\(#","url(#$($itmid)_"
}

$html = "<html><body>`n$($svgs -join "`n")`n</body></html>`n"

$html | Out-File -Encoding utf8 "labels/index.html"
