var cols = 32
var tapelen = 32

var slots = []

$(init)

function init()
{
    for (var c = 0; c < cols; c++) {
        slots.push({
            card: 0,
            conns: new Set(),
            tape: null,
            newtape: null
        })
    }
    var html = [[],[],[]]
    for (var s = 0; s < slots.length; s++) {
        html[0].push('<td><div></div></td>')
        html[1].push('<td><div class="slot" myslotidx="'+s+'"><div></div></div></td>')
        html[2].push('<td><div class="socket" myslotidx="'+s+'"></div></td>')
    }
    $('#positions').html(html[0].join(''))
    $('#slots').html(html[1].join(''))
    $('#connectors').html(html[2].join(''))
    html = []
    for (var t = 0; t < tapelen; t++) {
        html.push('<div class="cell"></div>')
    }
    $('#tape').html(html.join(''))

    $('#stepone').click(clickstepone)
    $('#insert').click(clickinsert)

    $('#slots').on('click', 'div.slot', clickslot)

    $('#connectors').on('click', 'div.socket', clicksocket)
    $('#connectors').on('click', 'div.connection', clickconnection)
}

function clicksocket(e)
{
    var tgt = $(this)
    var src = $('#connectors div.socket.clicksource')
    if (src.length > 0) {
        src.removeClass('clicksource')
        var sidx = parseInt(src.attr('myslotidx'))
        var tidx = parseInt(tgt.attr('myslotidx'))
        if (sidx != tidx) {
            addconn(sidx, tidx)
        }
    } else {
        tgt.addClass('clicksource')
    }
}

function clickconnection(e)
{
    var conn = $(this)
    var s1 = parseInt(conn.attr('mysrc'))
    var s2 = parseInt(conn.attr('mytgt'))
    slots[s1].conns.delete(s2)
    slots[s2].conns.delete(s1)
    conn.remove()
    e.stopPropagation()
    return false
}

function setupprog()
{
    slots[3].card = 3
    slots[5].card = 5
    slots[6].card = 6
    slots[7].card = 7
    slots[8].card = 1
    slots[9].card = 4
    showslot(3)
    showslot(5)
    showslot(6)
    showslot(7)
    showslot(8)
    showslot(9)
    addconn(5,8)
    addconn(9,4)
    addconn(6,4)
    addconn(7,10)
}

function clickslot(e)
{
    var slotidx = parseInt($(this).attr('myslotidx'))
    var slot = slots[slotidx]
    slot.card = (slot.card + 1) % 8
    this.className = "slot card_"+slot.card
}

function showslot(s)
{
    $('#slots td:nth-child('+(s+1)+') div.slot').addClass("card_"+slots[s].card)
}

function clickstepone(e)
{
    stepone()
    e.stopPropagation()
    return false
}

function clickinsert(e)
{
    newtape()
    e.stopPropagation()
    return false
}

function newtape()
{
    var tape = {
        content: [1,2,1,2,1],
        show: true
    }
    slots[0].newtape = tape
}

function stepone()
{
    for (var s = 0; s < slots.length; s++) {
        var slot = slots[s]
        if (slot.tape != null) {
            if (slot.tape.error) {
                console.log("Eating error tape")
                continue
            }
            var tape = slot.tape
            var tgts = [s+1]
            if (slot.card < 4) {
                // Write color
                if (slot.card > 0) {
                    if (tape.content.length < 32) {
                        tape.content.push(slot.card)
                    } else {
                        console.log("Tape overflow")
                    }
                }
            } else {
                var dobranch = true
                if (slot.card > 4) {
                    // Read color
                    var color = tape.content[0]
                    if (color == (slot.card-4)) {
                        tape.content.shift()
                    } else {
                        dobranch = false
                    }
                }
                if (dobranch) {
                    tgts = slot.conns
                }
            }
            tgts.forEach(ns => {
                if (ns < slots.length) {
                    if (slots[ns].newtape != null) {
                        console.log("Tape clash")
                        slots[ns].newtape.error = "clash"
                    } else {
                        slots[ns].newtape = tape
                    }
                } else {
                    tapecheck(tape)
                }
            })
        }
    }
    var poss = $('#positions td')
    for (var s = 0; s < slots.length; s++) {
        var slot = slots[s]
        if (slot.newtape) {
            slot.tape = slot.newtape
            if (slot.tape.show) {
                showtape(slot.tape)
                poss[s].className = "tape show"
            } else {
                poss[s].className = "tape"
            }
        } else {
            slot.tape = null
            poss[s].className = ""
        }
        slot.newtape = null
    }
}

function addconn(s1, s2)
{
    if (s1 > s2) {
        var s = s1
        s1 = s2
        s2 = s
    }
    if (slots[s1].conns.has(s2)) {
        return
    }
    slots[s1].conns.add(s2)
    slots[s2].conns.add(s1)
    var td1 = $('#connectors td:nth-child('+(s1+1)+')')
    var td2 = $('#connectors td:nth-child('+(s2+1)+')')
    var dist = td2.position().left - td1.position().left
    var conn = $('<div class="connection" mysrc="'+s1+'" mytgt="'+s2+'"></div>').appendTo(td1)
    conn.width(dist)
    conn.height(dist/3)
}

function tapecheck(tape)
{
    console.log("TODO check", tape)
}

function showtape(tape)
{
    var tapecells = $('#tape div.cell')
    for (t = 0; t < tapecells.length; t++) {
        if (tape.content[t]) {
            tapecells[t].className = "cell cell_"+tape.content[t]
        } else {
            tapecells[t].className = "cell"
        }
    }
}
