$(load)
var size = 5

function facehtml(face)
{
    var html = []
    html.push('<div class="nothing"></div>')
    for (var x = 0; x < size; x++) {
        if (face != 't') {
            var c1 = face+'0'+x
            var c2
            if (face == 'f') { c2 = 't'+(size-1)+x }
            if (face == 'r') { c2 = 't'+(size-1-x)+(size-1) }
            html.push('<div class="connector vertical ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
        } else {
            html.push('<div class="nothing"></div>')
        }
        html.push('<div class="nothing"></div>')
    }
    for (var y = 0; y <= size; y++) {
        if (y > 0 && y < size) {
            for (var x = 0; x < size; x++) {
                var c1 = face+(y-1)+x
                var c2 = face+y+x
                html.push('<div class="nothing"></div>')
                html.push('<div class="connector vertical ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            }
            html.push('<div class="nothing"></div>')
        }
        if (y < size) {
            if (face == 'r') {
                var c1 = face+y+'0'
                var c2 = 'f'+y+(size-1)
                html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            } else {
                html.push('<div class="nothing"></div>')
            }
            for (var x = 0; x < size; x++) {
                var c1 = face+y+(x-1)
                var c2 = face+y+x
                if (x > 0) html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
                html.push('<div class="button" id="',face,y,x,'"',face,y,x,'"></div>')
            }
            if (face != 'r') {
                var c1 = face+y+(size-1)
                var c2
                if (face == 't') { c2 = 'r0'+(size-1-y) }
                if (face == 'f') { c2 = 'r'+y+'0' }
                html.push('<div class="connector horizontal ',c1,' ',c2,'" data-c1="',c1,'" data-c2="',c2,'"></div>')
            } else {
                html.push('<div class="nothing"></div>')
            }
        }
    }
    html.push('<div class="nothing"></div>')
    for (var x = 0; x < size; x++) {
        if (face == 't') {
            var c1 = face+(size-1)+x
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
    // $('.button#t00,.button#f32').addClass('endpoint').attr('data-color', '1')
    // $('.button#t01,.button#f12').addClass('endpoint').attr('data-color', '2')
    // $('.button#f00,.button#r11').addClass('endpoint').attr('data-color', '3')
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

/* Folded out cube coords
 *
 * top  right
 * TTTTRRRR
 * TTTTRRRR
 * TTTTRRRR
 * TTTTRRRR
 * FFFF....
 * FFFF....
 * FFFF....
 * FFFF....
 * front
 *
 * Index: y*w*2+x
 *
 */

var points = []

/*
var endpoints = [
    [0,0], [7,2], // red
    [0,1], [5,2], // green
    [4,0], [2,5]  // blue
]
*/

function mkpoint(x, y, w)
{
    // neighbour points
    var ngb = []
    if (x > 0) { ngb.push([x-1,y]) }
    if (y > 0) { ngb.push([x,y-1]) }
    if (y < w-1) {
        ngb.push([x,y+1])
        if (x < w*2-1) { ngb.push([x+1,y]) }
    } else if (y < w) {
        if (x < w) { ngb.push([x,y+1]) }
        else { ngb.push([y,x]) } // Edge between R and F
        if (x < w*2-1) { ngb.push([x+1,y]) }
    } else {
        if (y < w*2-1) { ngb.push([x,y+1]) }
        if (x < w-1) { ngb.push([x+1,y]) }
        else { ngb.push([y,x]) } // Edge between R and F
    }
    epdir = []
    var isep = -1
    for (var c = 0; c < endpoints.length; c++) {
        ept = endpoints[c]
        ex = ept[0]
        ey = ept[1]
        if (x == ex && y == ey) {
            epdir[c] = -1
            isep = c
            continue
        }
        if (x >= w && ey >= w) {
            // across front edge, rotate endpoint coord to empty quad: anticlockwise
            ex = ept[1]
            ey = 2*w-1-ept[0]
        }
        if (y >= w && ex >= w) {
            // across front edge, rotate endpoint coord to empty quad: clockwise
            ex = 2*w-1-ept[1]
            ey = ept[0]
        }
        var dx = ex - x
        var dy = ey - y
        var dirx = dx > 0 ? 1 : -1
        var diry = dy > 0 ? 1 : -1
        if (dx*dirx > dy*diry) {
            epp = [x+dirx,y]
        } else {
            epp = [x,y+diry]
        }
        eppx = epp[0]
        eppy = epp[1]
        if (eppx >= w && eppy >= w) {
            // Empty quadrant, rotate back
            if (x >= w) {
                // clockwise
                eppx = 2*w-1-epp[1]
                eppy = epp[0]
            } else {
                // anticlockwise
                eppx = epp[1]
                eppy = 2*w-1-epp[0]
            }
        }
        var nidx = 0
        for (; nidx < ngb.length; nidx++) {
            if (ngb[nidx][0] == eppx && ngb[nidx][1] == eppy) { break }
        }
        epdir[c] = nidx
    }
    if (isep >= 0) {
        for (var c = 0; c < endpoints.length; c++) {
            if (c != (isep ^ 1)) {
                epdir[c] = -1
            }
        }
    }
    return {
        neighbours: ngb,
        endpoints: epdir,
        colour: isep
    }
}

function initpoints()
{
    var w = size

    points = []
    for (var x = 0; x < w*2; x++) {
        var ye = x<w ? w*2 : w
        points[x] = []
        for (var y = 0; y < ye; y++) {
            points[x][y] = mkpoint(x, y, w)
        }
    }
    return points
}

// Try a step from x,y to neighbour n
// x,y will be conected to an endpoint
function trystep(x, y, x2, y2)
{
    var c = points[x][y].colour
    var pt = points[x2][y2]
    // Set new point colour
    pt.colour = c
    // Disconnect and reflow neighbours of other colours
    var ngb = pt.neighbours
    for (var n = 0; n < ngb.length; n++) {
        var pt2 = points[ngb[n][0]][ngb[n][1]]
        var rvn = size-1-n // ????
        for (var c = 0; c < endpoints.length; c++) {
            if (pt2.endpoints[c] == rvn) {
                reflow(ngb[n][0], ngb[n][1])
            }
        }
    }
}
