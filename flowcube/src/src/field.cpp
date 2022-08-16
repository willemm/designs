#include "settings.h"

// Status of playing field
int selected; // currently selected endpoint

unsigned long lastpress = 0;
int lastkey = 0; // Last key pressed
int curkey = 0; // Key currently being held down

struct fieldcell_t {
    long animstart;
    uint8_t animtype;
    uint8_t dist;
    int8_t line;
    unsigned next:3, prev:3;
    unsigned is_endpoint:1;
};

static_assert(sizeof(fieldcell_t) == 8, "Size of fieldcell_t is bigger than 8");

#define FIELD_ENDPOINT 0x01
#define FIELD_FOLD 0x02

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

// Because dividing by 25 is expensive, shift the indices to multiples of 32
// For this we need a special function to translate back to multiples of 25
// to actually index the field, so we don't get gaps.

#define ESSZ 32  // First power of two above SSZ  (which is 25)

#define GET_FIELD(idx) (field[(idx) - (ESSZ-SSZ) * ((idx)/ESSZ)])
#define FIELD_SIDE(idx) ((idx)/ESSZ)

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

// Calculate step to go across a cube edge, downward
// 24 19 14  9  4  (plus side index * 32)
// --------------
//  0  1  2  3  4  (plus side index * 32, note this is widdershins, so side index +1 (mod3))
//
// Take index mod32 to remove side number
// Reverse order from 24  to go 24,19,14,9,4 => 0,5,10,15,20
// Integer divide by FSZ (5) and add 32 to go widdershins
#define NEIGHBOUR_WRAP_DOWN(idx) (((SSZ-1 - ((idx) % ESSZ)) / FSZ) + (((idx)/ESSZ + 1)%3)*ESSZ)

// Calculate step to across a cube edge, rightward
// Note, this is opposite downward because directions rotate across the cube
// Therefore, caulculation is reverse of downward
//
// Take index mod32 to remove side number
// Multiply by FSZ (5),
// Reverse order from 24 to go 0,5,10,15,20/24,19,14,9,4 and add 32 twice to go sunwise
#define NEIGHBOUR_WRAP_RIGHT(idx) ((SSZ-1 - (((idx) % ESSZ) * FSZ)) + (((idx)/ESSZ + 2)%3)*ESSZ)

// Four directions.  (Up is as seen on the first side in the diagram above)
#define NEIGHBOUR_UP(idx)    (((((idx) % ESSZ) % FSZ) > 0) ? ((idx) - 1) : -1)
#define NEIGHBOUR_LEFT(idx)  ((((idx) % ESSZ) < (SSZ-FSZ)) ? ((idx) + FSZ) : -1)
#define NEIGHBOUR_DOWN(idx)  (((((idx) % ESSZ) % FSZ) < (FSZ-1)) ? ((idx) + 1) : NEIGHBOUR_WRAP_DOWN((idx)))
#define NEIGHBOUR_RIGHT(idx) ((((idx) % ESSZ) >= FSZ) ? ((idx) - FSZ) : NEIGHBOUR_WRAP_RIGHT((idx)))

static int8_t field_neighbour(int idx, int nd)
{
    switch(nd) {
        case 0: return NEIGHBOUR_UP(idx);
        case 1: return NEIGHBOUR_LEFT(idx);
        case 2: return NEIGHBOUR_DOWN(idx);
        case 3: return NEIGHBOUR_RIGHT(idx);
        default: return -1;
    }
}

static neighbours_t field_neighbours(int8_t idx)
{
    neighbours_t nb;

    nb.neighbour[0] = NEIGHBOUR_UP(idx);
    nb.neighbour[1] = NEIGHBOUR_LEFT(idx);
    nb.neighbour[2] = NEIGHBOUR_DOWN(idx);
    nb.neighbour[3] = NEIGHBOUR_RIGHT(idx);
    nb.neighbour[4] = -1;
    return nb;
}

// Calculate the inverse of a direction
// Normally this is (direction ^ 2)
// However, across a fold this is different.
// 
// Note that each side thinks it's upper left, rotation-wise,
// so on the cube the four directions are like this:
//
// +---+
// | 0 |
// |1 3|
// | 2 |
// +---+---+
// | 3 | 2 |
// |0 2|3 1|
// | 1 | 0 |
// +---+---+
//
// It becomes apparent that a fold always has 2 and 3 as directions.
// So if the side is the same, the inverse direction is (direction ^ 2)
// but on a fold, the inverse direction is (direction ^ 1)

// Calculate the inverse direction (going from 'from' to 'to' is 'dir')
static inline uint8_t invert_dir(int from, int to, int dir)
{
    // If sides are the same, 0<>2 and 1<>3  (so xor 2)
    // If sides are different, 2<>3  (so xor 1)
    return dir ^ (1 << (from/ESSZ == to/ESSZ));
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
        return ESSZ + (y-FSZ)*FSZ + x;
        //return y*FSZ + x;
    } else {
        // right
        return ESSZ*2 + (x-FSZ)*FSZ + (FSZ-1-(y-FSZ));
        //return FSZ*FSZ + 2*FSZ - 1 + x*FSZ - y;
    }
}

struct ledset_t {
    uint8_t led[4];
};

// Leds are ordered like this:
//  Y   4  3  2  1  0
//
// X    +--+  +--+  in 
//      |  |  |  |  |
// 0 +--O--O--O--5--0-- out
//   |  |  |  |  |  |   
//   |  |  |  |  |  |   
// 1 +--O--O--O--6--1--+
//      |  |  |  |  |  |
//      |  |  |  |  |  |
// 2 +--O--O--O--7--2--+
//   |  |  |  |  |  |
//   |  |  |  |  |  |
// 3 +--O--O--O--8--3--+
//      |  |  |  |  |  |
//      |  |  |  |  |  |
// 4 +--O--O--O--9--4--+
//   |  |  |  |  |  |
//   +--+  +--+  +--+
//
//
//  We only calculate left and down because right and up will be that cell xor 1
//
// Recalculate x and y from index (we can't re-use x and y because sides are rotated)
//       
// 
//  Number of steps:
//    
// - divide by 5   = y
// - get remainder = x
//
//  x = 0..4
//  y = 0..4
//
// - Check y even/odd to calc direction
// - multiply x by 2        0,2,4,6,8
// - subtract 4            -4,-2,0,2,4
// - multiply by direction -4,-2,0,2,4  but maybe reversed
// - add 1 if y is odd     -4,-2,0,2,4 or 5,3,1,-1,-3
// - add 4                  0,2,4,6,8 or 9,7,5,3,1
// - multiply y by 10       0,10,20,30,40
// - add to result          0 .. 49
// - = left pixel.  Right pixel is left xor 1
//
// ALT
// - Check y even/odd to calc direction
// - multiply x by 2                0,2,4,6,8
// - subtract from 9 if y is odd    0,2,4,6,8 or 9,7,5,3,1
// - multiply y by 10               0,10,20,30,40
// - add to result                  0 .. 49
//
// - Check x even/odd to calc direction
// - multiply y by 2                0,2,4,6,8
// - subtract 4                    -4,-2,0,2,4
// - multiply by direction         -4,-2,0,2,4 or 4,2,0,-2,-4
// - add 1 if x is odd             -4,-2,0,2,4 or 5,3,1,-1,-3
// - add 4                          0,2,4,6,8 or 9,7,5,3,1
// - multiply x by 10               10,20,30,40,50
// - add to result                  0 .. 49
// - subtract the whole shebang from 99   99 .. 50
//
// ALT
// - Check x even/odd to calc direction
// - same calc as ALT for left, but swap x and y
// - Subtract from 99
//
//
// Fast division by 5 for a number between 0 and 24
//
// get bits 0+1 in r, 2+3+4 in d
// o = (d > r) + (d > 5)
// div5 = r - o - (d > r)
// mod5 = r + d - (d > r)
//
// 00000  = 0   0 - (0 > 0)    0 = 0 - 0 + 5*(0 > 0)
// 00001  = 0   0 - (0 > 1)    1 = 1 - 0 + 5*(0 > 1)
// 00010  = 0   0 - (0 > 2)    2 = 2 - 0 + 5*(0 > 2)
// 00011  = 0   0 - (0 > 3)    3 = 3 - 0 + 5*(0 > 3)
// 00100  = 0   1 - (1 > 0)!   4 = 0 - 1 + 5*(1 > 0)!
// 00101  = 1   1 - (1 > 1)    0 = 1 - 1 + 5*(1 > 1)
// 00110  = 1   1 - (1 > 2)    1 = 2 - 1 + 5*(1 > 2)
// 00111  = 1   1 - (1 > 3)    2 = 3 - 1 + 5*(1 > 3)
// 01000  = 1   2 - (2 > 0)!   3 = 0 - 2 + 5*(2 > 0)!
// 01001  = 1   2 - (2 > 1)!   4 = 1 - 2 + 5*(2 > 1)!
// 01010  = 2   2 - (2 > 2)    0 = 2 - 2 + 5*(2 > 2)
// 01011  = 2   2 - (2 > 3)    1 = 3 - 2 + 5*(2 > 3)
// 01100  = 2   3 - (3 > 0)!   2 = 0 - 3 + 5*(3 > 0)!
// 01101  = 2   3 - (3 > 1)!   3 = 1 - 3 + 5*(3 > 1)!
// 01110  = 2   3 - (3 > 2)!   4 = 2 - 3 + 5*(3 > 2)!
// 01111  = 3   3 - (3 > 3)    0 = 3 - 3 + 5*(3 > 3)
// 10000  = 3   4 - (4 > 0)!   1 = 0 - 4 + 5*(0 > 0)
// 10001  = 3   4 - (4 > 1)!   2 = 1 - 4 + 5*(0 > 1)
// 10010  = 3   4 - (4 > 2)!   3 = 2 - 4 + 5*(0 > 2)
// 10011  = 3   4 - (4 > 3)!   4 = 3 - 4 + 5*(0 > 3)
// 10100  = 4   5 - (5 > 0)!   0 = 0 - 5 + 5*(1 > 0)!
// 10101  = 4   5 - (5 > 1)!   1 = 1 - 5 + 5*(1 > 1)
// 10110  = 4   5 - (5 > 2)!   2 = 2 - 5 + 5*(1 > 2)
// 10111  = 4   5 - (5 > 3)!   3 = 3 - 5 + 5*(1 > 3)
// 11000  = 4   6 - (6 > 0)!   4 = 0 - 6 + 5*(2 > 0)  !!!!!
//
// 24 needs an extra +1 or -1, so add (d > 5) to o
// 
static inline ledset_t leds_keyidx(uint8_t idx)
{
    ledset_t leds;
    // Calculate x and y
    // Bitshifting calculation of div5 and mod5, see above
    unsigned int d5r = ((idx % ESSZ) & 3);
    unsigned int d5d = ((idx % ESSZ) >> 2);
    unsigned int d5o = (d5d > d5r) + (d5d > 5);
    unsigned int x = d5r + d5o*5 - d5d;  // idx % 5
    unsigned int y = d5d - d5o;          // idx / 5

    // unsigned int y = ((idx % ESSZ) / FSZ);
    // unsigned int x = ((idx % ESSZ) % FSZ);
    // unsigned int x = ((idx % ESSZ) - (FSZ * y));
    unsigned int left = x*2;
    if (y%2) left = (FSZ*2-1)-left;
    left += y*(FSZ*2);
    leds.led[1] = left;
    leds.led[3] = left^1;

    unsigned int down = y*2;
    if (x%2) down = (FSZ*2-1)-down;
    down += x*(FSZ*2);
    down = (4*SSZ-1) - down;
    leds.led[2] = down;
    leds.led[0] = down^1;

    return leds;
}

void field_init()
{
    for (int y = 0; y < DSZ; y++) {
        // Upper right quadrant is not used
        int xsz = ((y >= FSZ) ? DSZ : FSZ);
        for (int x = 0; x < xsz; x++) {
            int idx = field_idx(y, x);
            GET_FIELD(idx).prev = 4;
            GET_FIELD(idx).next = 4;
            GET_FIELD(idx).is_endpoint = 0;
        }
    }
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
        GET_FIELD(endpoints[c].idx).line = c;
        GET_FIELD(endpoints[c].idx).is_endpoint = 1;
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
    ledset_t leds = leds_keyidx(idx);
    for (int pi = 0; pi < 4; pi++) {
        pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[pi], color);
    }
    while (idx >= 0) {
        phs -= ANIM_STEP;
        int pd = GET_FIELD(idx).prev;
        if (pd < 4) {
            uint32_t colorval = anim_color(color, phs, anim, anim_cnt);
            pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[pd], colorval);
        }
        phs -= ANIM_STEP;
        int nd = GET_FIELD(idx).next;
        if (nd < 4) {
            uint32_t colorval = anim_color(color, phs, anim, anim_cnt);
            pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[nd], colorval);
        }
        idx = field_neighbour(idx, nd);
        if (idx >= 0) { leds = leds_keyidx(idx); }
    }
}

static void draw_line_default(endpoint_t *ep, long now, bool debug)
{
    uint32_t color = ep->color;
    int idx = ep->idx;
    ledset_t leds = leds_keyidx(idx);
    for (int pi = 0; pi < 4; pi++) {
        pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[pi], color);
    }
    while (idx >= 0) {
        int8_t pd = GET_FIELD(idx).prev;
        if (pd < 4) {
            pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[pd], color);
        }
        int8_t nd = GET_FIELD(idx).next;
        if (nd < 4) {
            pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[nd], color);
        }
        idx = field_neighbour(idx, nd);
        if (idx >= 0) { leds = leds_keyidx(idx); }
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
    if (curkey >= 0) {
        int idx = curkey;
        uint32_t colorval = pixels.Color(255,255,255);
        ledset_t leds = leds_keyidx(idx);
        for (int i = 0; i < 4; i++) {
            pixels.setPixelColor(FIELD_SIDE(idx)*LEDSZ + leds.led[i], colorval);
        }
    }
    pixels.show();
}

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

/*
static void testdelay(int dly)
{
    for (int d = 0; d < dly; d += 100) {
        delay(100);
        keys_scan();
    }
}

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
    if (idx < 0) return;
    int nxt = idx;
    // Disconnect last link
    GET_FIELD(idx).prev = 4;
    // First reverse, see if his leads to an endpoint
    while (nxt >= 0) {
        debugD("Reverse %d->%d->%d", GET_FIELD(nxt).prev, nxt, GET_FIELD(nxt).next);
        int nn = GET_FIELD(nxt).next;
        GET_FIELD(nxt).next = GET_FIELD(nxt).prev;
        GET_FIELD(nxt).prev = nn;
        GET_FIELD(nxt).line = GET_FIELD(nxt).line ^ 1;
        if (GET_FIELD(nxt).is_endpoint) {
            // Found an endpoint, so don't turn off
            // Only turn off the first one
            // Fix the distances
            int dist = 0;
            while (nxt >= 0) {
                GET_FIELD(nxt).dist = dist++;
                nxt = field_neighbour(nxt, GET_FIELD(nxt).next);
            }
        }
        nxt = field_neighbour(nxt, nn);
    }
    // There was no endpoint so turn the chain off
    nxt = idx;
    while (nxt >= 0) {
        debugD("Disconnect %d->%d->%d", GET_FIELD(nxt).prev, nxt, GET_FIELD(nxt).next);
        int nn = GET_FIELD(nxt).prev;
        GET_FIELD(nxt).next = 4;
        GET_FIELD(nxt).prev = 4;
        GET_FIELD(nxt).line = -1;
        nxt = field_neighbour(nxt, nn);
    }
}

static void press_key(int key)
{
    long now = millis();
    int line = GET_FIELD(key).line;
    if (selected >= 0) {
        debugI("Press key %d, check for neighbour with selected line %d", key, selected);
        int fnd = -1;
        int mindist = 1000;
        neighbours_t neighbours = field_neighbours(key);
        for (int n = 0; n < 4; n++) {
            int nb = neighbours.neighbour[n];
            if (nb >= 0) {
                debugD("Check field #%d = %d, line %d, dist %d", n, nb, GET_FIELD(nb).line, GET_FIELD(nb).dist);
            }
            if ((nb >= 0) && (GET_FIELD(nb).line == selected) && (GET_FIELD(nb).dist < mindist)) {
                debugD("Got field #%d = %d, line %d, dist %d < %d", n, nb, GET_FIELD(nb).line, GET_FIELD(nb).dist, mindist);
                fnd = n;
                mindist = GET_FIELD(nb).dist;
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
                int nxt = neighbours.neighbour[GET_FIELD(key).next];
                debugD("Connect to chain at %d, disconnect %d", key, nxt);
                disconnect_chain(nxt);
                int idx = neighbours.neighbour[fnd];
                // Connect pressed chain to other chain (use next because we invert later)
                GET_FIELD(key).next = fnd;
                GET_FIELD(idx).next = invert_dir(key, idx, fnd);
                debugD("Connect %d to %d and %d to %d", key, GET_FIELD(key).next, idx, GET_FIELD(idx).next);
                // Reverse other chain to beginning
                nxt = key;
                int dist = GET_FIELD(idx).dist;
                while (nxt >= 0) {
                    debugD("Reverse %d<-%d<-%d", GET_FIELD(nxt).prev, nxt, GET_FIELD(nxt).next);
                    GET_FIELD(nxt).line = selected;
                    GET_FIELD(nxt).dist = ++dist;

                    int nn = GET_FIELD(nxt).prev;
                    GET_FIELD(nxt).prev = GET_FIELD(nxt).next;
                    GET_FIELD(nxt).next = nn;
                    nxt = field_neighbour(nxt, nn);
                }
                field_endpoints[selected].status = EP_CONNECTED;
                field_endpoints[line].status = EP_CONNECTED;
                selected = -1;
            } else if (line >= 0) {
                if (GET_FIELD(key).is_endpoint) {
                    // Endpoints cannot be pushed through
                    selected = -1;
                } else {
                    debugI("Press key %d, different line %d, push through, todo", key, line);
                    // Disconnect pushed-through chain
                    //  disconnect next-direction
                    int nxt = neighbours.neighbour[GET_FIELD(key).next];
                    while (nxt >= 0) {
                        int dist = 0;
                        // Find end of chain
                        if (GET_FIELD(nxt).is_endpoint) {
                            // Reverse chain
                            dist = 0;
                            int dline = line ^ 1;
                            while (nxt != key) {
                                debugD("Reverse %d<-%d<-%d", GET_FIELD(nxt).prev, nxt, GET_FIELD(nxt).next);
                                GET_FIELD(nxt).line = dline;
                                GET_FIELD(nxt).dist = ++dist;

                                int nn = GET_FIELD(nxt).prev;
                                GET_FIELD(nxt).prev = GET_FIELD(nxt).next;
                                GET_FIELD(nxt).next = nn;
                                nxt = field_neighbour(nxt, nn);
                                if (nxt < 0) {
                                    debugE("While reversing, reached end of chain at %d", nn);
                                    return;
                                }
                                if (dist > 150) {
                                    debugE("While reversing, got endless loop");
                                    return;
                                }
                            }
                            break;
                        }
                        if (dist++ > 125) {
                            debugE("While scanning, got endless loop");
                            return;
                        }
                        nxt = field_neighbour(nxt, GET_FIELD(nxt).next);
                    }
                    if (nxt < 0) {
                        // No endpoint, kill chain
                        nxt = neighbours.neighbour[GET_FIELD(key).next];
                        debugD("Disconnect chain %d", nxt);
                        disconnect_chain(nxt);
                    } else {
                        nxt = neighbours.neighbour[GET_FIELD(key).next];
                        debugD("Disconnect second end %d", nxt);
                        GET_FIELD(nxt).next = 4;
                        GET_FIELD(key).next = 4;
                    }
                    int prv = neighbours.neighbour[GET_FIELD(key).prev];
                    debugD("Disconnect end %d", prv);
                    GET_FIELD(prv).next = 4;
                    // GET_FIELD(ket).prev = 4    // Will be set below
                    field_endpoints[line].status = EP_NORMAL;

                    // Extend chain
                    debugI("Press key %d, no line %d, extend chain", key, line);
                    int idx = neighbours.neighbour[fnd];
                    nxt = field_neighbour(idx, GET_FIELD(idx).next);
                    debugD("Connect to chain at %d, disconnect %d", idx, nxt);
                    // Disconnect other chain
                    disconnect_chain(nxt);
                    GET_FIELD(key).line = GET_FIELD(idx).line;
                    GET_FIELD(key).dist = GET_FIELD(idx).dist + 1;
                    GET_FIELD(key).prev = fnd;
                    GET_FIELD(idx).next = invert_dir(key, idx, fnd);
                }
            } else {
                // Extend chain
                debugI("Press key %d, no line %d, extend chain", key, line);
                int idx = neighbours.neighbour[fnd];
                int nxt = field_neighbour(idx, GET_FIELD(idx).next);
                debugD("Connect to chain at %d, disconnect %d", idx, nxt);
                // Disconnect other chain
                disconnect_chain(nxt);
                GET_FIELD(key).line = GET_FIELD(idx).line;
                GET_FIELD(key).dist = GET_FIELD(idx).dist + 1;
                GET_FIELD(key).prev = fnd;
                GET_FIELD(idx).next = invert_dir(key, idx, fnd);
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
    // Translate to 32-offset index
    key = (key-1) + (ESSZ-SSZ)*((key-1)/25);
    unsigned long tick = millis();
    if (key != curkey) {
        debugD("Field scan, key=%d, curkey=%d, lastkey=%d, tick=%ld", key, curkey, lastkey, tick);
        curkey = key;
        if (key >= 0) {
            if ((key != lastkey) || (lastpress+50 < tick)) {
                lastkey = key;
                press_key(key);
            }
        }
        lasttick = 0;
    }
    if (lasttick < tick) {
        lasttick = tick + 20; // Draw 50 times per second
        draw_field();
    }
}

void field_debug_dump()
{
    for (int y = 0; y < DSZ; y++) {
        int xsz = ((y >= FSZ) ? DSZ : FSZ);
        for (int x = 0; x < xsz; x++) {
            Debug.printf("%2d  ", field_idx(y, x));
        }
        Debug.printf("\r\n");
    }
    for (int fidx = 0; fidx < NUMKEYS; fidx++) {
        int idx = fidx + (ESSZ-SSZ)*(fidx/SSZ);
        neighbours_t neighbours = field_neighbours(idx);
        ledset_t leds = leds_keyidx(idx);
        Debug.printf("%2d : neighbour = (%2d, %2d, %2d, %2d) pixel = (%2d, %2d, %2d, %2d) side = %d\r\n",
            idx,
            neighbours.neighbour[0], neighbours.neighbour[1],
            neighbours.neighbour[2], neighbours.neighbour[3],
            leds.led[0], leds.led[1], leds.led[2], leds.led[3],
            FIELD_SIDE(idx));
        Debug.printf("   : chain = (%d, %d) dist = %2d line = %2d endpoint = %d\r\n",
            GET_FIELD(idx).prev, GET_FIELD(idx).next, GET_FIELD(idx).dist,
            GET_FIELD(idx).line, GET_FIELD(idx).is_endpoint);
    }
    for (int line = 0; field_endpoints[line].idx >= 0; line++) {
        int idx = field_endpoints[line].idx;
        Debug.printf("Line %d : %d", line, idx);
        while (idx >= 0) {
            int8_t nd = GET_FIELD(idx).next;
            idx = field_neighbour(idx, nd);
            if (idx >= 0) {
                Debug.printf(" -%c> %d", "uldr "[nd], idx);
            }
        }
        Debug.printf("\r\n");
    }
}

