$(load)

function facehtml(face)
{
    var html = []
    html.push('<div class="nothing"></div>')
    for (var x = 0; x < 4; x++) {
        if (face != 't') {
            var c1 = face+'0'+x
            var c2
            if (face == 'f') { c2 = 't3'+x }
            if (face == 'r') { c2 = 't'+(3-x)+'3' }
            html.push('<div class="connector vertical ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
        } else {
            html.push('<div class="nothing"></div>')
        }
        html.push('<div class="nothing"></div>')
    }
    for (var y = 0; y <= 4; y++) {
        if (y > 0 && y < 4) {
            for (var x = 0; x < 4; x++) {
                var c1 = face+(y-1)+x
                var c2 = face+y+x
                html.push('<div class="nothing"></div>')
                html.push('<div class="connector vertical ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            }
            html.push('<div class="nothing"></div>')
        }
        if (y < 4) {
            if (face == 'r') {
                var c1 = face+y+'0'
                var c2 = 'f'+y+'3'
                html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            } else {
                html.push('<div class="nothing"></div>')
            }
            for (var x = 0; x < 4; x++) {
                var c1 = face+y+(x-1)
                var c2 = face+y+x
                if (x > 0) html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
                html.push('<div class="button" id="',face,y,x,'"',face,y,x,'"></div>')
            }
            if (face != 'r') {
                var c1 = face+y+'3'
                var c2
                if (face == 't') { c2 = 'r0'+(3-y) }
                if (face == 'f') { c2 = 'r'+y+'0' }
                html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            } else {
                html.push('<div class="nothing"></div>')
            }
        }
    }
    html.push('<div class="nothing"></div>')
    for (var x = 0; x < 4; x++) {
        if (face == 't') {
            var c1 = face+'3'+x
            var c2 = 'f0'+x
            html.push('<div class="connector vertical ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
        } else {
            html.push('<div class="nothing"></div>')
        }
        html.push('<div class="nothing"></div>')
    }
    return html.join('')
}

function load()
{
    $('#top').html(facehtml('t'))
    $('#front').html(facehtml('f'))
    $('#right').html(facehtml('r'))
    // $('#view').on('mousemove', set_perspective)
    $('.button#t10,.button#f32').addClass('endpoint').attr('data-color', '1')
    $('.button#t01,.button#f12').addClass('endpoint').attr('data-color', '2')
    $('.button#f00,.button#r11').addClass('endpoint').attr('data-color', '3')
    $('#view').on('click', '.button', push_button)
}

function set_perspective(ev)
{
    var el = $(this)
    var pos = el.position()
    var elx = ev.pageX-pos.left
    var ely = ev.pageY-pos.top
    el.css({'perspective-origin': elx+'px '+ely+'px'})
}

function push_button()
{
    var tgt = $(this)
    var src = $('.button.selected')
    if (!src.length) {
        tgt.addClass('selected')
        return
    }
    src.removeClass('selected')
    var sid = src.attr('id')
    var tid = tgt.attr('id')
    if (tid == sid) return
    // Find connecting bit between selected buttons
    var connectors = $('.connector.'+sid+'.'+tid)
    if (connectors.length) {
        if (connectors.hasClass('on')) {
            // Special case: the target is not connected to anything else
            var others = $('.connector.on.'+tid)
            if (others.length > 1) connectors.removeClass('on full')
        } else {
            var scol = src.attr('data-color')
            var tcol = tgt.attr('data-color')
            if (tcol && scol && tcol != scol) {
                $('.connector.'+tid).removeClass('on full')
            }
            connectors.addClass('on')
            check_connections(tid)
        }
        fill_connections(sid)
        fill_connections(tid)
    }
    tgt.addClass('selected')
}

function check_connections(fid)
{
    $('.connector.'+fid+':not(.on)').each(function() {
        var tid = $(this).attr('data-c1')
        if (tid == fid) tid = $(this).attr('data-c2')
        fill_connections(tid)
    })
}

function fill_connections(fid)
{
    var done = {}
    done[fid] = true
    var queue = [fid]
    var going = true
    var idx = 0
    while (idx < queue.length) {
        var sid = queue[idx]
        idx++
        $('.connector.'+sid+'.on').each(function() {
            var tid = $(this).attr('data-c1')
            if (tid == sid) tid = $(this).attr('data-c2')
            if (!done[tid]) {
                queue.push(tid)
                done[tid] = true
            }
        })
    }
    var buttons = $($.map( queue, function(i) { return document.getElementById(i) }))
    var colors = buttons.filter('.endpoint').map(function() { return $(this).attr('data-color') }).get()
    var others = buttons.filter(':not(.endpoint)')
    var connectors = $('.connector.on').filter(function() { return done[$(this).attr('data-c1')] && done[$(this).attr('data-c2')] })
    others.removeClass('full')
    connectors.removeClass('full')
    if (colors.length == 0) {
        others.attr('data-color', '')
        connectors.attr('data-color', '')
        return
    }
    var color = colors[0]
    if (colors.length > 1) {
        var clash = false
        for (var i = 1; i < colors.length; i++) {
            if (colors[i] != color) clash = true
        }
        if (clash) {
            others.attr('data-color', '')
            connectors.attr('data-color', '')
            return
        }
    }
    if (colors.length > 1) {
        others.addClass('full')
        connectors.addClass('full')
    }
    others.attr('data-color', color)
    connectors.attr('data-color', color)
}
