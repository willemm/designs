#include "settings.h"

// Status of playing field
int selected; // currently selected endpoint

unsigned long lastpress = 0;
int lastkey = 0; // Last key pressed
int curkey = 0; // Key currently being held down

static_assert(sizeof(fieldcell_t) == 16, "Size of fieldcell_t is bigger than 16");
/*
static_assert(offsetof(fieldcell_t, up   ) == offsetof(fieldcell_t, neighbour)+0, "Neighbour doesn't match up");
static_assert(offsetof(fieldcell_t, left ) == offsetof(fieldcell_t, neighbour)+1, "Neighbour doesn't match left");
static_assert(offsetof(fieldcell_t, down ) == offsetof(fieldcell_t, neighbour)+2, "Neighbour doesn't match down");
static_assert(offsetof(fieldcell_t, right) == offsetof(fieldcell_t, neighbour)+3, "Neighbour doesn't match right");
*/

#define FIELD_ENDPOINT 0x01
#define FIELD_FOLD 0x02

#define FIELD_UP    0
#define FIELD_LEFT  1
#define FIELD_DOWN  2
#define FIELD_RIGHT 3

#define EP_NORMAL    0
#define EP_SELECTED  1
#define EP_CONNECTED 2
#define EP_DELETING  3

#define FSZ 5
#define DSZ (FSZ*2)
#define SSZ (FSZ*FSZ)
#define LEDSZ ((int)(DSZ*DSZ))

#define NUMKEYS (3*FSZ*FSZ)

fieldcell_t field[NUMKEYS];

struct neighbours_t { int8_t neighbour[5]; };

/* Determining field neighbours:
   Up, Left, Down, Right

side = 0, 1, 2

First:
- if side = 0  (right)
  - if idx >= 5
    - nb = idx - 5
  - else (idx < 5)
    - nb = 50 + 24 - (idx * 5)
- if side = 1  (up)
  - if idx >= 25 + 5
    - nb = idx - 5
  - else (idx < 5)
    - nb = 0 + 24 - ((idx - 25) * 5)
- if side = 2  (left)
  - if idx >= 50 + 5
    - nb = idx = 5
  - else (idx < 5)
    - nb = 25 + 24 - ((idx - 50) * 5)

Second:
- if side = 0  (down)
  - if (idx % 5) < 4
    - nb = idx + 1
  - else (idx % 5 = 4)
    - nb = 25 + 4 - (idx / 5) 
- if side = 1  (right)
  - if (idx % 5) < 4
    - nb = idx + 1
  - else (idx % 5 = 4)
    - nb = 50 + 4 - ((idx - 25) / 5) 
- if side = 2  (up)
  - if (idx % 5) < 4
    - nb = idx + 1
  - else (idx % 5 = 4)
    - nb = 0 + 4 - ((idx - 50) / 5) 

Third:
- if side = 0  (left)
  - if idx < 20
    - nb = idx + 5
  - else (idx >= 20)
    - nb = -1 (none)
- if side = 1  (down)
  - if idx < 20 + 25
    - nb = idx + 5
  - else (idx >= 20 + 25)
    - nb = -1 (none)
- if side = 2  (right)
  - if idx < 20 + 50
    - nb = idx + 5
  - else (idx >= 20 + 50)
    - nb = -1 (none)

Fourth:
- if side = 0  (up)
  - if idx % 5 > 0
    - nb = idx - 1
  - else (idx % 5 = 0)
    - nb = -1 (none)
- if side = 1  (left)
  - if idx % 5 > 0
    - nb = idx - 1
  - else (idx % 5 = 0)
    - nb = -1 (none)
- if side = 2  (down)
  - if idx % 5 > 0
    - nb = idx - 1
  - else (idx % 5 = 0)
    - nb = -1 (none)

First, simplified:
- sidx = idx % 25
- if sidx >= 5
  - nb = idx - 5
- else
  - nb = (24 - (idx * 5))
         + ((((idx / 25) + 2) % 3) * 25)  // 0 => 50, 1 => 0, 2 => 25

Second, simplified:
- if (idx % 5) < 4
  - nb = idx + 1
- else
  - nb = 4 - ((idx % 25) / 5)
         + ((((idx / 25) + 1) % 3) * 25)  // 0 => 25, 1 => 50, 2 => 0

Third, simplified:
- if (idx % 25) < 20
  - nb = idx + 5
- else
  - nb = -1  // none

Fourth, simplified
- if (idx % 5) > 0
  - nb = idx - 1
- else
  - nb = -1  // none

*/

static int8_t field_neighbour(int idx, int nd)
{
    switch (nd) {
      case 0:
        if ((idx % FSZ) > 0) { // Up (on side 0) is index minus one
            return idx - 1;
        } else {
            return -1;
        }
      case 1:
        if ((idx % SSZ) < (SSZ-FSZ)) { // Left (on side 0) is index plus one row
            return idx + FSZ;
        } else {
            return -1;
        }
      case 2:
        if ((idx % FSZ) < (FSZ-1)) { // Down (on side 0) is index plus one
            return idx + 1;
        } else {
            return 4 - (idx / FSZ) +  ((((idx / SSZ) + 1) % 3) * SSZ);
        }
      case 3:
        if ((idx % SSZ) >= FSZ) { // Right (on side 0) is index minus one row
            return idx - FSZ;
        } else {
            return (SSZ - ((idx % SSZ) * FSZ)) + ((((idx / SSZ) + 2) % 3) * SSZ);
        }
      default:
        return -1;
    }
}

static neighbours_t field_neighbours(int idx)
{
    neighbours_t nb;

    int sidx = idx % SSZ;  // Index on side
    int side = idx / SSZ;  // Side (0,1,2)
    int ridx = idx % FSZ;  // Row number
    int cidx = idx / FSZ;  // Column number

    if (ridx > 0) { // Up (on side 0) is index minus one
        nb.neighbour[0] = idx - 1;
    } else {
        nb.neighbour[0] = -1;
    }
    if (sidx < (SSZ-FSZ)) { // Left (on side 0) is index plus one row
        nb.neighbour[1] = idx + FSZ;
    } else {
        nb.neighbour[1] = -1;
    }
    if (ridx < (FSZ-1)) { // Down (on side 0) is index plus one
        nb.neighbour[2] = idx + 1;
    } else {
        nb.neighbour[2] = 4 - cidx +  (((side + 1) % 3) * SSZ);
    }
    if (sidx >= FSZ) { // Right (on side 0) is index minus one row
        nb.neighbour[3] = idx - FSZ;
    } else {
        nb.neighbour[3] = (SSZ - (sidx * FSZ)) + (((side + 2) % 3) * SSZ);
    }
    nb.neighbour[4] = -1;
    return nb;
}

// Translate from 6 directions to four, depending on cube side
// This way a straight line across a fold always has the same direction number
static const uint8_t step_dirs[3][6] = {
    { 2, 3, 4, 0, 1, 4 },
    { 2, 4, 3, 0, 4, 1 },
    { 4, 2, 3, 4, 0, 1 }
};

static inline uint8_t step_nb(fieldcell_t field, int dir)
{
    return step_dirs[field.side][dir%6];
}

// Find the field index in the given (one of six) direction
static inline int step_dir(neighbours_t neighbours, fieldcell_t field, int dir)
{
    return neighbours.neighbour[step_nb(field, dir)];
}

// Find the index of the led in the given (one of six) direction
static inline int pixel_dir(fieldcell_t field, int dir)
{
    uint8_t sdir = step_dirs[field.side][dir];
    if (sdir >= 4) {
        debugE("ERROR CANTHAPPEN: Wants to get direction %d on side %d", dir, field.side);
    }
    return ((int)field.side)*LEDSZ + (int)field.pixel[sdir%4];
}


/*
   Field layout:
  
   +-----+      
   |     |      
   | top |      
   | +0  |      
   +-----+-----+
   |     |     |
   |front|right|
   | +25 | +50 |
   +-----+-----+

   +-----------+
   |20 ..  5 0 |
   |21     6 1 |
   |22     7 2 |
   |23     8 3 |
   |24 ..  9 4 |
   +-----------+-----------+
   | 0 1 2 3 4 | 4 9 ..  24|
   | 5 6 7 8 9 | 3 8     23|
   |10         | 2 7     22|
   |15         | 1 6     21|
   |20 ..    24| 0 5 ..  20|
   +-----------+-----------+
 */

static inline int field_idx(int y, int x)
{
    if (y < FSZ) {
        // top
        return (FSZ-1-x)*FSZ + y;
        //return (FSZ-1)*FSZ - x*FSZ + y;
    } else if (x < FSZ) {
        // front
        return FSZ*FSZ + (y-FSZ)*FSZ + x;
        //return y*FSZ + x;
    } else {
        // right
        return FSZ*FSZ*2 + (x-FSZ)*FSZ + (FSZ-1-(y-FSZ));
        //return FSZ*FSZ + 2*FSZ - 1 + x*FSZ - y;
    }
}

void field_init()
{
    for (int y = 0; y < DSZ; y++) {
        // Upper right quadrant is not used
        int xsz = ((y >= FSZ) ? DSZ : FSZ);
        for (int x = 0; x < xsz; x++) {
            int idx = field_idx(y,x);
            ledset_t cell = leds_keyidx(idx);
            /*
            int cellrot = (idx/(FSZ*FSZ)); // Rotate by 1 or 2 steps depending on face
            field[idx].side = cell.side;
            field[idx].pixel[(cellrot+0)%4] = cell.left;   // up
            field[idx].pixel[(cellrot+1)%4] = cell.down;   // right
            field[idx].pixel[(cellrot+2)%4] = cell.left^1; // down
            field[idx].pixel[(cellrot+3)%4] = cell.down^1; // left
            field[idx].none = -1;
            field[idx].up = -1;
            field[idx].left = -1;
            field[idx].prev = 4;
            field[idx].next = 4;
            */
            field[idx].side = cell.side;
            field[idx].pixel[0] = cell.left;   // up
            field[idx].pixel[1] = cell.down;   // right
            field[idx].pixel[2] = cell.left^1; // down
            field[idx].pixel[3] = cell.down^1; // left
            field[idx].prev = 4;
            field[idx].next = 4;
            field[idx].is_endpoint = 0;
            /*
            if ((x == FSZ-1) && (y < FSZ)) {
                // Right edge of upper left folds to top of lower right
                field[idx].right = field_idx(DSZ-1-x, DSZ-1-y);
            } else if (x == DSZ-1) {
                // Sentinel value for no right neighbour
                field[idx].right = -1;
            } else {
                field[idx].right = field_idx(y,x+1);
            }
            // Down never folds
            if (y == DSZ-1) {
                field[idx].down = -1;
            } else {
                field[idx].down = field_idx(y+1,x);
            }
            */
        }
    }
    /*
    for (int idx = 0; idx < NUMKEYS; idx++) {
        for (int n = 0; n < 3; n++) {
            int nb = step_dir(field[idx], n);
            if (nb >= 0) {
                field[nb].neighbour[step_nb(field[nb], n+3)] = idx;
            }
        }
    }
    */
}

int8_t endpoint_coords[] = {
    3,1, 5,5,
    1,2, 7,2,
    6,5, 5,6,
    5,9, 9,9,
    1,1, 6,6,
    -1
};

struct endpoint_t {
    uint32_t color;
    long animstart;
    int8_t idx;
    int8_t status;
};

static endpoint_t * make_endpoints(int8_t coords[])
{
    int cnt = 0;
    while (coords[cnt*2] >= 0) { cnt++; }
    endpoint_t *endpoints = new endpoint_t[cnt+1];

    for (cnt = 0; coords[cnt*2] >= 0; cnt++) {
        endpoints[cnt].idx = field_idx(coords[cnt*2], coords[cnt*2+1]);
        endpoints[cnt].status = 0;
        endpoints[cnt].color = colors[cnt/2];
    }
    endpoints[cnt].idx = -1;
    return endpoints;
}

endpoint_t *field_endpoints;

static void set_endpoints(endpoint_t *endpoints)
{
    for (int c = 0; endpoints[c].idx >= 0; c++) {
        debugD("Set endpoint %d: (%d)", c, endpoints[c].idx);
        field[endpoints[c].idx].line = c;
        field[endpoints[c].idx].is_endpoint = 1;
    }
}

static inline uint32_t colorscale(uint32_t color, uint32_t brightness)
{
    uint32_t r = (color >> 16) & 0xff;
    r = (r * brightness) / 1000;
    if (r > 255) r = 255;
    uint32_t g = (color >> 8) & 0xff;
    g = (g * brightness) / 1000;
    if (g > 255) g = 255;
    uint32_t b = (color >> 0) & 0xff;
    b = (b * brightness) / 1000;
    if (b > 255) b = 255;
    return (uint32_t)((r << 16) | (g << 8) | (b << 0));
}

#define ANIM_STEP 200
struct anim_t {
    uint32_t timeoff, brightness;
};
static const anim_t anim_selected[] = {
  {    0,  700 },
  {  400,  200 },
  {  700, 4000 },
  { 1000,  200 },
  { 1400,  700 },
  { 1940,  700 },
  { 0, 0 }
};

static const anim_t anim_connected[] = {
  {    0,  700 },
  {  200,  200 },
  {  500, 4000 },
  {  800,  200 },
  { 1000,  700 },
  { 1030,  700 },
  { 0, 0 }
};

static uint32_t anim_color(uint32_t color, int32_t phs, const anim_t anim[], int cnt)
{
    if (phs <= 0) {
        return colorscale(color, anim[0].brightness);
    }
    uint32_t of = phs % anim[cnt-1].timeoff;
    int ani;
    for (ani = 0; ani < (cnt-1); ani++) {
        if (anim[ani].timeoff > of) break;
    }
    uint32_t di = anim[ani].timeoff - anim[ani-1].timeoff;
    of = of - anim[ani-1].timeoff;
    uint32_t brightness = (of * anim[ani].brightness + (di-of) * anim[ani-1].brightness) / di;
    return colorscale(color, brightness);
}

static void draw_line_anim(endpoint_t *ep, long now, bool debug, const anim_t anim[])
{
    int anim_cnt;
    for (anim_cnt = 1; anim[anim_cnt].timeoff > 0; anim_cnt++) { /* Nothing */ }
    uint32_t color = ep->color;
    int32_t phs = (int32_t)(now - ep->animstart);
    int idx = ep->idx;
    for (int pi = 0; pi < 4; pi++) {
        pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[pi], color);
    }
    while (idx >= 0) {
        phs -= ANIM_STEP;
        int8_t pd = field[idx].prev;
        if (pd < 4) {
            uint32_t colorval = anim_color(color, phs, anim, anim_cnt);
            pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[pd], colorval);
        }
        phs -= ANIM_STEP;
        int8_t nd = field[idx].next;
        if (nd < 4) {
            uint32_t colorval = anim_color(color, phs, anim, anim_cnt);
            pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[nd], colorval);
        }
        // idx = field[idx].neighbour[nd];
        idx = field_neighbour(idx, nd);
    }
}

static void draw_line_default(endpoint_t *ep, long now, bool debug)
{
    uint32_t color = ep->color;
    int idx = ep->idx;
    for (int pi = 0; pi < 4; pi++) {
        pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[pi], color);
    }
    while (idx >= 0) {
        int8_t pd = field[idx].prev;
        if (pd < 4) {
            pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[pd], color);
        }
        int8_t nd = field[idx].next;
        if (nd < 4) {
            pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[nd], color);
        }
        // idx = field[idx].neighbour[nd];
        idx = field_neighbour(idx, nd);
    }
}

static void draw_line(endpoint_t *ep, long now, bool debug)
{
    switch (ep->status) {
      case EP_SELECTED:
        return draw_line_anim(ep, now, debug, anim_selected);
      case EP_CONNECTED:
        return draw_line_anim(ep, now, debug, anim_connected);
      default:
        return draw_line_default(ep, now, debug);
    }
}

static void draw_field(bool debug=false)
{
    long now = millis();
    pixels.clear();
    for (int c = 0; field_endpoints[c].idx >= 0; c++) {
        draw_line(&field_endpoints[c], now, debug);
    }
    // Light up pressed key
    if (curkey > 0) {
        int idx = curkey - 1;
        int side = ((int)field[idx].side)*LEDSZ;
        uint32_t colorval = pixels.Color(255,255,255);
        for (int i = 0; i < 4; i++) {
            pixels.setPixelColor(side+field[idx].pixel[i], colorval);
        }
    }
    pixels.show();
}

/*
static void draw_field_old(bool debug=false)
{
    pixels.clear();
    for (int idx = 0; idx < NUMKEYS; idx++) {
        int side = ((int)field[idx].side)*LEDSZ;
        int color = field[idx].color;
        if (color >= 0) {
            uint32_t colorval = colors[color/2];
            if (debug) debugV("color = %d, idx=%d, colorval = 0x%06x", color, color/2, colorval);
            // if (color == selected) colorval = colorval*2; // brighten (TODO: do this better)
            if (field[idx].is_endpoint) {
                for (int i = 0; i < 4; i++) {
                    pixels.setPixelColor(side+field[idx].pixel[i], colorval);
                }
            }

            for (int i = 0; i < 3; i++) {
                int dir = step_dir(field[idx], i);
                if ((dir >= 0) && (field[dir].color == color)) {
                    pixels.setPixelColor(pixel_dir(field[idx], i), colorval);
                    pixels.setPixelColor(pixel_dir(field[dir], i+3), colorval);
                    if (debug) debugV("Set pixels between %2d and %2d: (%3d,%3d) = 0x%06x",
                        idx, dir,
                        pixel_dir(field[idx], i), pixel_dir(field[dir], i+3),
                        colorval);
                    }
            }
        }
        if (idx == (curkey-1)) {
            uint32_t colorval = pixels.Color(255,255,255);
            for (int i = 0; i < 4; i++) {
                pixels.setPixelColor(side+field[idx].pixel[i], colorval);
            }
        }
    }
    if (selected >= 0) {
        long now = millis();
        int idx = field_idx(field_endpoints[selected*2], field_endpoints[selected*2+1]);
        int len = 0;
        int nxt = idx;
        while (nxt >= 0) {
            len++;
            nxt = field[nxt].neighbour[field[nxt].next];
        }
        int32_t anpos = (now % 2000);
        anpos = anpos * (len+3) / 2 - 2000;
        nxt = idx;
        if (debug) debugV("position %d", anpos);
        while (nxt >= 0) {
            uint32_t colorval = colors[selected/2];
            int32_t aps = anpos;
            if (aps < 0) aps = -aps;
            if (aps <= 2000) {
                if (aps <= 1000) {
                    if (debug) debugV("key %d, brighten", nxt);
                    colorval = colorscale(colorval, 500+(3*(1000-aps)/2));
                } else {
                    if (debug) debugV("key %d, dim", nxt);
                    colorval = colorscale(colorval, aps/2);
                }
            }
            int8_t pd = field[nxt].prev;
            if (pd < 4) {
                if (debug) debugV("Set key %d prev color to 0x%06x", nxt, colorval);
                pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[pd], colorval);
            } else {
                if (debug) debugV("Set key %d start color to 0x%06x", nxt, colorval);
                for (int pi = 0; pi < 4; pi++) {
                    pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[pi], colorval);
                }
            }
            int8_t nd = field[nxt].next;
            if (nd < 4) {
                if (debug) debugV("Set key %d next color to 0x%06x", nxt, colorval);
                pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[nd], colorval);
            }
            nxt = field[nxt].neighbour[nd];
            anpos -= 1000;
        }
    }
    pixels.show();
}
*/

void field_clear()
{
    debugI("Clearing game field");
    selected = -1;
    for (int idx = 0; idx < NUMKEYS; idx++) {
        field[idx].line = -1;
        field[idx].prev = 4;
        field[idx].next = 4;
        field[idx].is_endpoint = 0;
        field[idx].dist = 0;
    } 
    delete field_endpoints;
    field_endpoints = make_endpoints(endpoint_coords);
    set_endpoints(field_endpoints);
    // draw_field(true);
    debugI("Inited game field");
    debug_update();
}

static const int field_test_lines[5][8] = {
    { 1,2,3,8,9,28,33,32 },
    { 0,5,6,7,12,13,14,27 },
    { 15,20,21,22,23,24,25,30 },
    { 18,19,26,31,36,37,38,43 },
    { 40,45,46,47,48,49,44,39 }
};

static void testdelay(int dly)
{
    for (int d = 0; d < dly; d += 100) {
        delay(100);
        keys_scan();
    }
}

/*
void field_test()
{
    for (int idx = 0; idx < NUMKEYS; idx++) {
        field[idx].line = -1;
        field[idx].is_endpoint = 0;
    }
    debugI("Init field test (field size = %d)", sizeof(fieldcell_t));
    draw_field();
    for (int ln = 0; ln < 5; ln++) {
        testdelay(500);
        debugD("Field test line %d, color 0x%06x, from %2d to %2d (%d,%d)",
            ln, colors[ln+1], field_test_lines[ln][0], field_test_lines[ln][7],
            (ln+1)*2, (ln+1)*2+1);
        selected = ln*2;
        field[field_test_lines[ln][0]].line = ln*2;
        field[field_test_lines[ln][0]].is_endpoint = 1;
        field[field_test_lines[ln][7]].line = ln*2+1;
        field[field_test_lines[ln][7]].is_endpoint = 1;
        draw_field();
        for (int p = 1; p < 7; p++) {
            testdelay(500);
            field[field_test_lines[ln][p]].line = ln*2;
            draw_field();
        }
        testdelay(500);
        field[field_test_lines[ln][7]].line = ln*2;
        draw_field();
    }
    selected = -1;
    testdelay(500);
    draw_field(true);

    testdelay(2000);
}
*/

static void disconnect_chain(int idx)
{
    int nxt = idx;
    // Disconnect last link
    field[idx].prev = 4;
    // First reverse, see if his leads to an endpoint
    while (nxt >= 0) {
        debugD("Reverse %d->%d->%d", field[nxt].prev, nxt, field[nxt].next);
        int nn = field[nxt].next;
        field[nxt].next = field[nxt].prev;
        field[nxt].prev = nn;
        field[nxt].line = field[nxt].line ^ 1;
        if (field[nxt].is_endpoint) {
            // Found an endpoint, so don't turn off
            // Only turn off the first one
            // Fix the distances
            int dist = 0;
            while (nxt >= 0) {
                field[nxt].dist = dist++;
                // nxt = field[nxt].neighbour[field[nxt].next];
                nxt = field_neighbour(nxt, field[nxt].next);
            }
        }
        // nxt = field[nxt].neighbour[nn];
        nxt = field_neighbour(nxt, nn);
    }
    // There was no endpoint so turn the chain off
    nxt = idx;
    while (nxt >= 0) {
        debugD("Disconnect %d->%d->%d", field[nxt].prev, nxt, field[nxt].next);
        int nn = field[nxt].prev;
        field[nxt].next = 4;
        field[nxt].prev = 4;
        field[nxt].line = -1;
        // nxt = field[nxt].neighbour[nn];
        nxt = field_neighbour(nxt, nn);
    }
}

static void press_key(int key)
{
    long now = millis();
    int line = field[key].line;
    if (selected >= 0) {
        debugI("Press key %d, check for neighbour with selected line %d", key, selected);
        int fnd = -1;
        int mindist = 1000;
        neighbours_t neighbours = field_neighbours(key);
        for (int n = 0; n < 6; n++) {
            int nb = step_dir(neighbours, field[key], n);
            if (nb >= 0) {
                debugD("Check field #%d = %d, line %d, dist %d", n, nb, field[nb].line, field[nb].dist);
            }
            if ((nb >= 0) && (field[nb].line == selected) && (field[nb].dist < mindist)) {
                debugD("Got field #%d = %d, line %d, dist %d < %d", n, nb, field[nb].line, field[nb].dist, mindist);
                fnd = n;
                mindist = field[nb].dist;
            }
        }
        if (fnd < 0) {
            // Pressed key was not next to selected chain, so deselect
            // TODO: Some kind of distance/straight line stuff maybe?
            debugI("Press key %d, different chain, deselect", key);
            selected = -1;
            // Fall through to no line selected code
        } else {
            if (line == selected) {
                debugI("Press key %d, same line %d, do nothing", key, line);
                // Nothing, maybe deselect further bit of chain?
            } else if (line == (selected ^ 1)) {
                debugI("Press key %d, matching line %d, connect", key, line);
                // Disconnect pressed chain end
                // int nxt = field[key].neighbour[field[key].next];
                int nxt = field_neighbour(key, field[key].next);
                debugD("Connect to chain at %d, disconnect %d", key, nxt);
                disconnect_chain(nxt);
                int idx = step_dir(neighbours, field[key], fnd);
                // Connect pressed chain
                field[key].next = step_nb(field[key], fnd);
                field[idx].next = step_nb(field[idx], fnd+3);
                debugD("Connect %d to %d and %d to %d", key, field[key].next, idx, field[idx].next);
                // Reverse other chain to beginning
                nxt = key;
                int dist = field[idx].dist;
                while (nxt >= 0) {
                    debugD("Reverse %d<-%d<-%d", field[nxt].prev, nxt, field[nxt].next);
                    field[nxt].line = selected;
                    field[nxt].dist = ++dist;

                    int nn = field[nxt].prev;
                    field[nxt].prev = field[nxt].next;
                    field[nxt].next = nn;
                    // nxt = field[nxt].neighbour[nn];
                    nxt = field_neighbour(nxt, nn);
                }
                field_endpoints[selected].status = EP_CONNECTED;
                field_endpoints[line].status = EP_CONNECTED;
                selected = -1;
            } else if (line >= 0) {
                if (field[key].is_endpoint) {
                    // Endpoints cannot be pushed through
                    selected = -1;
                } else {
                    debugI("Press key %d, different line %d, push through, todo", key, line);
                    // TODO: Overwrite chain
                }
            } else {
                // Extend chain
                debugI("Press key %d, no line %d, extend chain", key, line);
                int idx = step_dir(neighbours, field[key], fnd);
                // int nxt = field[idx].neighbour[field[idx].next];
                int nxt = field_neighbour(idx, field[idx].next);
                debugD("Connect to chain at %d, disconnect %d", idx, nxt);
                // Disconnect other chain
                disconnect_chain(nxt);
                field[key].line = field[idx].line;
                field[key].dist = field[idx].dist + 1;
                field[key].prev = step_nb(field[key], fnd);
                field[idx].next = step_nb(field[idx], fnd+3);
            }
        }
    }
    // Don't use else to enable above block to deselect and then fall into this block
    if (selected < 0) {
        if (line >= 0) {
            // Select this line
            selected = line;
            debugI("Press %d selects %d", key, selected);
        } else {
            debugI("Press %d does nothing (todo)", key);
            /*
            int line = 0;
            int cnt = 0;
            for (int n = 0; n < 4; n++) {
                int nb = field[key].neighbour[n];
                if ((nb >= 0) && (field[nb].line)) {
                    cnt++;
                    line = field[nb].line;
                }
            }
            if (cnt == 1) {
                field[key].line = line;
                selected = line;
                debugI("Press %d selects neighbouring %d", key, selected);
            }
            */
            // TODO: Connect two lines ?
        }
    }
    // Unset mode of selected line
    for (int ep = 0; field_endpoints[ep].idx >= 0; ep++) {
        if (ep == selected) {
            if (field_endpoints[ep].status != EP_SELECTED) {
                // TODO: Set animation start phase, stuff like that
                field_endpoints[ep].status = EP_SELECTED;
                field_endpoints[ep].animstart = now;
            }
        } else {
            if (field_endpoints[ep].status == EP_SELECTED) {
                // TODO: Maybe deselect animation ?
                field_endpoints[ep].status = EP_NORMAL;
            }
        }
    }
    draw_field(true);
}

unsigned long lasttick = 0;

void field_update()
{
    int key = keys_scan();
    if (key < 0) {
        debugE("ERROR: Key scan error");
        delay(100);
        return;
    }
    unsigned long tick = millis();
    if (key != curkey) {
        debugD("Field scan, key=%d, curkey=%d, lastkey=%d, tick=%ld", key, curkey, lastkey, tick);
        curkey = key;
        if (key > 0) {
            if ((key != lastkey) || (lastpress+50 < tick)) {
                lastkey = key;
                press_key(key-1);
            }
        }
        lasttick = 0;
    }
    if (lasttick < tick) {
        lasttick = tick + 20; // Draw 50 times per second
        draw_field();
    }
}
