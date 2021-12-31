
var board = []
var size = 4
var solutions = []

make_cube_board()
var endpoints = [
    [0,0], [7,2], // red
    [0,1], [5,2], // green
    [4,0], [5,5]  // blue
]
set_board_endpoints(endpoints)

function make_cube_board()
{
  var ds = size * 2
  for (var y = 0; y < ds; y++) {
    for (var x = 0; x < ds; x++) {
      // Skip upper right fields because that is the fold
      if (x >= size) {
        if (y < size) { continue }
      }
      var idx = y * ds + x
      var ri = y * ds + x + 1
      if ((x == size-1) && (y < size)) {
        // Right edge folds to top of lower right quadrant
        ri = (ds-1-x) * ds + (ds-1-y)
      }
      if (x == ds-1) {
        // 0 as sentinel because cell 0 can never be right or down
        ri = 0
      }
      var di = (y + 1) * ds + x
      if (y == ds-1) {
        // 0 as sentinel because cell 0 can never be right or down
        di = 0
      }
      var id
      if (y < size) {
        id = 't'+y+x
      } else if (x < size) {
        id = 'f'+(y-size)+x
      } else {
        id = 'r'+(y-size)+(x-size)
      }
      board[idx] = {
        id: id,
        right: ri,
        down: di,
        conns: [0,0],
        numconns: 0
      }
    }
  }
}

function set_board_endpoints(pts)
{
  for (var i = 0; i < pts.length; i++) {
    var pt = pts[i]
    idx = pt[0]*size*2 + pt[1]
    var color = Math.floor(i/2)+1
    board[idx].conns[0] = -color
    board[idx].numconns = 1
  }
}

function draw_board(brd)
{
  $('#view .button').removeClass('endpoint')
  $('#view .button').removeAttr('data-color')
  $('#view .connector').removeClass('on')
  $('#view .connector').removeAttr('data-color')
  var endpoints = []
  for (var i = 0; i < brd.length; i++) {
    var cell = brd[i]
    if (cell) {
      for (var nb = 0; nb < cell.numconns; nb++) {
        if (cell.conns[nb] < 0) {
          endpoints.push(i)
        } else {
          nextcell = brd[cell.conns[nb]]
          con = $('#view .connector.'+cell.id+'.'+nextcell.id)
          con.addClass('on')
        }
      }
    }
  }
  for (var i = 0; i < endpoints.length; i++) {
    traverse_line_color(brd, endpoints[i])
  }
}

// Assumes connections are two way consistent
function traverse_line_color(brd, idx)
{
  var cell = brd[idx]
  if (cell.conns[0] >= 0) return
  var color = -cell.conns[0]
  var prv = cell.conns[0]
  var stp = 0
  while (stp < 1000) {
    stp = stp + 1
    $('#'+cell.id).attr('data-color', color)
    var n = cell.numconns
    while (n-- > 0) {
      if (cell.conns[n] != prv) { break }
    }
    prv = idx
    if (n < 0) { break }
    idx = cell.conns[n]
    if (idx <= 0) { break }
    // logline('traverse', prv, idx, next)
    var nextcell = brd[idx]
    con = $('#view .connector.'+cell.id+'.'+nextcell.id)
    con.attr('data-color', color)

    cell = nextcell
  }
}

function testconns()
{
  board[0].numconns = 2
  board[0].conns[1] = 8
  board[8].numconns = 2
  board[8].conns[0] = 0
  board[8].conns[1] = 9
  board[9].numconns = 2
  board[9].conns[1] = 8
  board[9].conns[0] = 17
  board[17].numconns = 1
  board[17].conns[0] = 9
}

function solve_board_anim(animate = true)
{
  var diagonals = []
  var ds = size*2
  // Follow diagonals
  for (var r = 0; r < size*4-1; r++) {
    for (var y = 0; y <= r; y++) {
      var x = r-y
      if ((y < size) && (x >= size)) { continue }
      if ((y >= ds) || (x >= ds)) { continue }
      var idx = size*2*y + x
      diagonals.push(idx)
    }
  }
  solutions = []
  var didx = 0
  var reverse = false
  var anim_interval = 0
  var anim = function() {
    try {
    var idx = diagonals[didx]
    var cell = board[idx]
    if (animate) { logline("Step on idx", didx, idx, JSON.stringify(cell)) }
    var cright = cell.right ? board[cell.right] : null
    var cdown  = cell.down  ? board[cell.down ] : null
    if (!reverse) {
      reverse = false
      if (cell.numconns == 0) {
        if (cright && cdown && (cright.numconns < 2) && (cdown.numconns < 2)) {
          cell.numconns = 2
          cell.conns[0] = cell.right
          cell.conns[1] = cell.down
          cright.conns[cright.numconns++] = idx
          cdown.conns[cdown.numconns++] = idx
        }
      } else if (cell.numconns == 1) {
        if (cright && cright.numconns < 2) {
          cell.numconns = 2
          cell.conns[1] = cell.right
          cright.conns[cright.numconns++] = idx
        } else if (cdown && cdown.numconns < 2) {
          cell.numconns = 2
          cell.conns[1] = cell.down
          cdown.conns[cdown.numconns++] = idx
        } else {
          reverse = true
        }
      } else {
        // Nothing
      }
    } else {
      reverse = false
      if (cell.numconns == 1) {
        logline(JSON.stringify(board))
        throw("One cell connected on reverse, should not happen: "+idx)
      }
      if (cell.numconns == 2) {
        if ((cell.conns[0] == cell.right) && (cell.conns[1] == cell.down)) {
          cell.numconns = 0
          // Remove assertions when this is slow but working
          if (cright.numconns == 0) {
            throw("Disconnect but not connected r1: "+cell.right +" - "+ idx)
          }
          if (cdown.numconns == 0) {
            throw("Disconnect but not connected d1: "+cell.down +" - "+ idx)
          }
          if (cright.conns[--cright.numconns] != idx) {
            throw("Disconnect from wrong cell r1: "+ cell.right +" - "+ idx)
          }
          if (cdown.conns[--cdown.numconns] != idx) {
            throw("Disconnect from wrong cell d1: "+ cell.down +" - "+ idx)
          }
        } else if (cell.conns[1] == cell.right) {
          if (cright.numconns == 0) {
            throw("Disconnect but not connected r2: "+cell.right +" - "+ idx)
          }
          if (cright.conns[--cright.numconns] != idx) {
            throw("Disconnect from wrong cell r2: "+ cell.right +" - "+ idx)
          }
          if (cdown && cdown.numconns < 2) {
            cell.conns[1] = cell.down
            cdown.conns[cdown.numconns++] = idx
          } else {
            cell.numconns--
            reverse = true
          }
        } else if (cell.conns[1] == cell.down) {
          cell.numconns = 1
          if (cdown.numconns == 0) {
            throw("Disconnect but not connected d1: "+cell.down +" - "+ idx)
          }
          if (cdown.conns[--cdown.numconns] != idx) {
            throw("Disconnect from wrong cell d2: "+ cell.down +" - "+ idx)
          }
          reverse = true
        } else {
          reverse = true
        }
      } else {
        reverse = true
      }
    }
    if (reverse) {
      didx = didx - 1
    } else {
      if (check_partial_solution(idx)) {
        if (didx == diagonals.length-1) {
          reverse = true
          didx = didx - 1
          check_solution(solutions)
        } else {
          didx = didx + 1
        }
      } else {
        reverse = true
      }
    }
    if (animate) {
      logline("Step on idx done", didx, idx, JSON.stringify(cell))
      draw_board(board)
    }
    if (didx < 0) {
      logline("Finished")
      clearInterval(anim_interval)
      return false
    }
    return true
    } catch(e) {
      logline("Error happened", e)
      clearInterval(anim_interval)
      return false
    }
  }
  if (animate) {
    anim_interval = setInterval(anim, 100)
  } else {
    while (anim()) { }
  }
}

function check_solution(solutions)
{
  var colors = []
  for (var i = 0; i < board.length; i++) {
    var cell = board[i]
    if (cell && cell.numconns && cell.conns[0] < 0) {
      var idx = i
      var color = cell.conns[0]
      var prv = cell.conns[0]
      logline("Check color from endpoint", color, idx)
      var stp = 0
      while (stp < 1000) {
        stp = stp + 1
        cell = board[idx]
        var n = cell.numconns
        while (n-- > 0) {
          if (cell.conns[n] != prv) { break }
        }
        logline("Check step", stp, prv, idx, n)
        prv = idx
        if (n >= 0) {
          idx = cell.conns[n]
          if (idx < 0) {
            if (idx != color) {
              logline("Color clash")
              return  // Solution failed
            }
            break
          }
        } else {
          logline("Not connected")
          return  // Solution failed
        }
      }
      if (stp >= 1000) {
        throw("Ran out of steps")
      }
    }
  }
  var sol = JSON.stringify(board)
  solutions.push(sol)
  logline('solution', sol)
}

// Assume the rest of the board was OK, just check the cell at idx 
function check_partial_solution(sidx)
{
  var line = {}
  var touchline = {}
  var color = 0
  line[sidx] = true
  var queue = [sidx]
  while (queue.length > 0) {
    var idx = queue.shift()
    if (touchline[idx]) {
      // Line is touching itself
      return false
    }
    var cell = board[idx]
    var c = {}
    for (var nb = 0; nb < cell.numconns; nb++) {
      var next = cell.conns[nb]
      c[next] = true
      if (next < 0) {
        if (!color) {
          color = -cell.conns[nb]
        } else if (color != -cell.conns[nb]) {
          // Color clash
          return false
        }
      } else {
        if (!line[next]) {
          line[next] = true
          queue.push(next)
        }
      }
    }
    if (cell.right && !c[cell.right]) {
      if (line[cell.right]) {
        // Line is touching itself
        return 
      }
      touchline[cell.right] = true
    }
    if (cell.down && !c[cell.down]) {
      if (line[cell.down]) {
        // Line is touching itself
        return 
      }
      touchline[cell.down] = true
    }
  }
  return true
}

function logline()
{
  var html = ['<p>']
  for (var i = 0; i < arguments.length; i++) {
    html.push(htmlize(arguments[i].toString()))
  }
  html.push('</p>')
  var lg = $('#logging')
  lg.append(html.join(' '))
  var lge = lg.get(0)
  lge.scrollTop = lge.scrollHeight
}

function htmlize(text)
{
    if (!text) return ''
    return text.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('"','&quot;')
}

